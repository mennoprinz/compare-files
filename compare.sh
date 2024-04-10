#!/bin/bash

# This script has been created for migrating ORM packages into Cyclovriend projects

# Define the directories to compare
directory1=
directory2=

output_file=
temp_file_1=
temp_file_2=
set -e

truncate -s 0 "$output_file"

for file1 in "$directory1"/*; do
    file2="${directory2}/${file1##*/}"  # Construct file path in directory2

    if [ -f "$file2" ]; then
        truncate -s 0 "$temp_file_1"
        truncate -s 0 "$temp_file_2"

        # use this for classes
         grep_file_1=$(grep -m 1 -n "class" "$file1" | cut -d: -f1)
         grep_file_2=$(grep -m 1 -n "class" "$file2" | cut -d: -f1)

        #use this for Traits
#        grep_file_2=$(grep -m 1 -n "trait" "$file2" | cut -d: -f1)
#        grep_file_1=$(grep -m 1 -n "trait" "$file1" | cut -d: -f1)

        tail_file_1=$(tail -n +"$grep_file_1" "$file1")
        tail_file_2=$(tail -n +"$grep_file_2" "$file2")

        echo "$tail_file_1" >> "$temp_file_1"
        echo "$tail_file_2" >> "$temp_file_2"

        echo "Differences found in file: ${file1##*/}:" >> "$output_file"
        echo "$(diff "$temp_file_1" "$temp_file_2")" >> "$output_file"
        echo "________________________________________________________" >> "$output_file"
    else
        echo "File ${file1##*/} does not exist in $directory2"
    fi
done

echo "Comparison results written to $output_file"
