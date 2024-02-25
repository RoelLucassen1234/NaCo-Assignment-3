#!/bin/bash

# Check if two files are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <data_filename> <labels_filename>"
    exit 1
fi

data_filename="$1"
labels_filename="$2"

# Check if the data file exists
if [ ! -f "$data_filename" ]; then
    echo "Data file $data_filename not found."
    exit 1
fi

# Check if the labels file exists
if [ ! -f "$labels_filename" ]; then
    echo "Labels file $labels_filename not found."
    exit 1
fi

# Create the output filenames
data_output_filename="${data_filename}.split"
labels_output_filename="${labels_filename}.split"

# Check if the output files exist and delete them if they do
if [ -f "$data_output_filename" ]; then
    rm "$data_output_filename"
fi

if [ -f "$labels_output_filename" ]; then
    rm "$labels_output_filename"
fi

# Find the length of the shortest line in the data file
#min_length=$(awk '{ if (NR==1 || length < min) min=length } END { print min }' "$data_filename")
min_length=30
# Read both data and labels files simultaneously
exec 3<"$data_filename"
exec 4<"$labels_filename"

while IFS= read -r -u 3 data_line && IFS= read -r -u 4 label_line; do
    # Split the line into multiple lines with maximum length of min_length
    while [ -n "$data_line" ]; do
        # Check if the current portion of the line is shorter than the minimum length
        #if [ ${#data_line} -lt $min_length ]; then
        #    break
        #fi
        
        # Write the current portion of the line to the output files
        echo "${data_line:0:min_length}" >> "$data_output_filename"
        # If the label is 0, replicate it for each split line
        if [ "$label_line" == "0" ]; then
            echo "0" >> "$labels_output_filename"
        else
            echo "$label_line" >> "$labels_output_filename"
        fi
        data_line="${data_line:min_length}"
    done
done

# Close file descriptors
exec 3<&-
exec 4<&-

echo "Output written to $data_output_filename and $labels_output_filename"
