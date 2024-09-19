#!/bin/bash

ROOT_DIR=$1
OUTPUT_DIR=$2

progress_bar() {
    if [ $2 = 0 ]; then
        return
    fi

    # Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    # Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

    # 1.2 Build progressbar strings and print the ProgressBar line
    # 1.2.1 Output example:                           
    # 1.2.1.1 Progress : [########################################] 100%
    printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

END=`find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l`
START=0;

find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r folder; do

    #progress_bar ${START} ${END}
    START=$START+1

    mkdir -p "$OUTPUT_DIR"
    
    DIRNAME=`basename "$folder"`
    echo "$DIRNAME"

    ./videos2csv.sh "$folder" "$OUTPUT_DIR/$DIRNAME.csv" "noprogress";

done

#progress_bar ${END} ${END}
