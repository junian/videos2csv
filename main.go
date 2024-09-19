package main

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

// List of common video file extensions
var videoExtensions = []string{
	".mp4", ".m4v", ".mov", ".mkv", ".avi", ".flv", ".webm",
	".ts", ".m2ts", ".vob", ".rm", ".rmvb", ".wmv", ".ogv", ".gifv",
}

func main() {
	// Check if root directory is provided as an argument
	if len(os.Args) != 2 {
		fmt.Println("Usage: <program> <root_directory>")
		return
	}
	rootDir := os.Args[1]

	// Output CSV Header
	fmt.Println("Year,Month,Project Name,Filename,Modified Date")

	// Walk through the directories in the rootDir
	filepath.Walk(rootDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Only process directories
		if info.IsDir() && path != rootDir {
			folderName := filepath.Base(path)

			// Extract year, month, and project name from folder name
			if year, month, projectName, valid := parseFolderName(folderName); valid {
				// Look for files in this directory
				filepath.Walk(path, func(filePath string, fileInfo os.FileInfo, fileErr error) error {
					if fileErr != nil {
						return fileErr
					}
					// Check if the file is a video file
					if !fileInfo.IsDir() && isVideoFile(filePath) {
						// Get the file's modification date
						modifiedDate := fileInfo.ModTime().Format("2006-01-02 15:04:05")
						// Output the CSV line
						fmt.Printf("%d,%02d,%s,%s,%s\n", year, month, projectName, fileInfo.Name(), modifiedDate)
					}
					return nil
				})
			}
		}
		return nil
	})
}

// Function to parse folder names of format "YYMM Project Name"
func parseFolderName(folderName string) (year int, month int, projectName string, valid bool) {
	re := regexp.MustCompile(`^(\d{2})(\d{2})\s+(.+)$`)
	matches := re.FindStringSubmatch(folderName)

	if len(matches) == 4 {
		yy := matches[1]
		mm := matches[2]
		projectName = matches[3]

		// Convert to integers for year and month
		fmt.Sscanf(yy, "%d", &year)
		fmt.Sscanf(mm, "%d", &month)

		// Assuming 20YY for the year
		year += 2000

		// Validate month range (1-12)
		if month >= 1 && month <= 12 {
			valid = true
		}
	}
	return
}

// Function to check if a file is a video file by extension
func isVideoFile(filePath string) bool {
	ext := strings.ToLower(filepath.Ext(filePath))
	for _, videoExt := range videoExtensions {
		if ext == videoExt {
			return true
		}
	}
	return false
}
