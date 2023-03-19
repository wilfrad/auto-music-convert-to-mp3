#!/bin/bash
function init_converter() {
    if ! command -v ffmpeg &> /dev/null ; then
        echo "ffmpeg not found. Please install ffmpeg"
        return
    fi
    echo "$( convert $1 $2 )"
}

function convert() {
    input_file=$1
    output_file=$2
    ffmpeg -i "$input_file" -codec:a libmp3lame -qscale:a 2 "$output_file"
    echo "Conversion completed."
}