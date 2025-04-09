#!/bin/bash

#First version if needed for future
#--------------------------------------------
# Get the first matching line number
#start_line_number=$(grep -n '<tr><td>MONAR</td><td>' ./html/groups.html | head -n 1 | cut -d: -f1)
#check how many lines to copy
#line_count=$(wc -l < tocopyhtmlGrupaB.txt)
#to set last line to update
#end_line_number=$((start_line_number+line_count-1))
# Print the result (optional)
#echo "First match is on line: $start_line_number, end line is $end_line_number and line count is $line_count"
#make backup of the file just in case
#cp ./html/groups.html ./html/backup/groups.html.onestepback
#prepare string to input into html file
#new_content=$(cat tocopyhtmlGrupaB.txt | sed ':a;N;$!ba;s/\n/\\\n/g')
#change html file
# sed -i "${start_line_number},${end_line_number}c $new_content" ./html/groups.html
#-------------------------------------------
case "$1" in
    A) file="Grupa A (4)" ;;
    B) file="Grupa B (4)" ;;
    C) file="Grupa C (4)" ;;
    D) file="Grupa D (5)" ;;
    W) file="Grupa W (7)" ;;
    W1) file="Grupa W1 (5)" ;;
    W2) file="Grupa W2 (5)" ;;
   *)
        echo "Usage: $0 {A|B|C|D|W|W1|W2}"
        exit 1
        ;;
esac

name=$(echo "$file" | sed -E 's/[ ()0-9]//g')
#---------------------

# Read each line from the file tocopyhtml${name}.txt
while IFS= read -r line; do
    # Extract the first word inside <td>...</td>, removing numbers, hyphens, and newlines
    word=$(echo "$line" | grep -o '<td>[^<]*</td>' | sed 's/<td>\(.*\)<\/td>/\1/' | sed 's/[0-9]//g' | sed 's/-//g' | tr -d '\n')

    # Find the line number in groups.html where the extracted word appears
    line_number=$(grep -n "$word" ./html/groups.html | head -n 1 | cut -d: -f1)

    # Check if the line number is not empty and if the current line differs from the corresponding line in groups.html
    if [ -n "$line_number" ] && [ "$line" != "$(sed -n "${line_number}p" ./html/groups.html)" ]; then
        # Create a backup of groups.html before making changes
        cp ./html/groups.html ./html/backup/groups.html.onestepback

        # Replace the line in groups.html at the specified line number with the current line
        sed -i "${line_number}c\\$line" ./html/groups.html

        # Print a message indicating the replacement
        echo "Replaced line $line_number in groups.html with: $line"
    fi
done < tocopyhtml${name}.txt