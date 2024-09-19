#!/bin/bash

readonly APP_VERSION=1.0.1

# Define the root directory
ROOT_DIR=$1

# Output CSV Header with all fields as strings
echo "\"Year\",\"Month\",\"Project Name\",\"Filename\",\"Modified Date\",\"Path\""

# Updated array of common video file extensions based on Wikipedia article
video_extensions=("mp4" "m4v" "mov" "mkv" "avi" "flv" "webm" "ts" "m2ts" "vob" "rm" "rmvb" "wmv" "ogv" "gifv")

# Function to check if a file is a video file
is_video_file() {
    local file=$1
    # Convert filename to lowercase for case-insensitive comparison
    local lower_file=$(echo "$file" | tr '[:upper:]' '[:lower:]')
    for ext in "${video_extensions[@]}"; do
        if [[ "$lower_file" == *".${ext}" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to escape double quotes in CSV fields
escape_csv_field() {
    local field=$1
    # Escape double quotes by doubling them
    field=$(echo "$field" | sed 's/"/""/g')
    # If the field contains commas or double quotes, wrap it in double quotes
    if [[ "$field" == *","* || "$field" == *"\""* ]]; then
        field="\"$field\""
    fi
    echo "$field"
}

# List folders from ROOT_DIR with format YYMM Project Name
find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r folder; do
    folder_name=$(basename "$folder")

    # Extract year, month, and project name from folder name
    if [[ $folder_name =~ ^([0-9]{2})([0-9]{2})\ (.+)$ ]]; then
        year="20${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        project_name="${BASH_REMATCH[3]}"
        
        # Recursively find files in the folder and check if they are video files
        find "$folder" -type f ! -type l | while read -r file; do
            if is_video_file "$file"; then
                # Get file modified date
                modified_date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file")
                # Calculate relative path by stripping ROOT_DIR from the full path
                relative_path="${file#$ROOT_DIR/}"
                # Escape fields to handle special CSV characters
                year=$(escape_csv_field "$year")
                month=$(escape_csv_field "$month")
                project_name=$(escape_csv_field "$project_name")
                filename=$(escape_csv_field "$(basename "$file")")
                modified_date=$(escape_csv_field "$modified_date")
                relative_path=$(escape_csv_field "$relative_path")
                # Output the CSV row
                echo "$year,$month,$project_name,$filename,$modified_date,$relative_path"
            fi
        done
    fi
done
