#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <scoreA> <scoreB> [penalties-optional]"
    exit 1
fi

main_html="./html/index.html"
history_html="./html/history.html"
# Extract the first item from the "Schedule" table
next_match=$(sed -n '/<h2>Schedule/,/<\/table>/p' "$main_html" | grep -o '<tr><td>[^<]*</td>.*</tr>' | head -n 1)
# Extract the current match
current_match=$(sed -n '/<h2>Current Match<\/h2>/,/<\/table>/p' "$main_html" | grep -o '<tr><td>[^<]*</td>.*</tr>' | head -n 1)
# global variable when vs is changed to score
clean_current_match=${current_match//vs/$1<\/td><td>$2}

remove_time=$(echo "$clean_current_match" | grep -o '<td>[^<]*</td>' | sed -n '2p' | sed 's/<td>\(.*\)<\/td>/\1/')
remove_time_t=$(echo "$remove_time" | sed 's/[&/]/\\&/g')

#function which move next match to current match and remove same position from schedule
change_function(){
next_match=$(echo "$next_match"  | sed 's/[&/]/\\&/g')
sed -i "/<h2>Current Match<\/h2>/,/<\/table>/ {
    /<tr>/!b
    s/<tr>.*<\/tr>/$next_match/
}" "$main_html"
sed -i "/<h2>Schedule/,/<\/table>/ {
    /$next_match/d
}" "$main_html"
}


cp ./html/index.html ./html/backup/index.html.onestepback
cp ./html/history.html ./html/backup/history.html.onestepback


if [ -n "$3" ]; then
    case "$3" in
    # Append the current match to the "History" section in history.html when in penalties win Team A
        A)
word=$(echo "$current_match" | grep -o '<td>[^<]*</td>' | sed -n '3p' | sed 's/<td>\(.*\)<\/td>/\1/'  | sed 's/-//g')
current_match=$(echo "$clean_current_match" | sed "s/$word/<b>${word}*<\/b>/g; s/<td>$remove_time_t<\/td>//")
 sed -i "/<\/table>/i $current_match" "$history_html"

change_function
sh ./scripts/upload.sh 
 exit 1
            ;;
            # Append the current match to the "History" section in history.html when in penalties win Team B
        B)
word=$(echo "$current_match" | grep -o '<td>[^<]*</td>' | sed -n '5p' | sed 's/<td>\(.*\)<\/td>/\1/'  | sed 's/-//g')
current_match=$(echo "$clean_current_match" | sed "s/$word/<b>${word}*<\/b>/g; s/<td>$remove_time_t<\/td>//")
 sed -i "/<\/table>/i $current_match" "$history_html"

change_function
sh ./scripts/upload.sh 
 exit 1
            ;;
        *)
            echo "Unknown third parameter: $3"
            exit 1
            ;;
    esac
fi

# Append the current match to the "History" section in history.html
if [ -n "$current_match" ]; then
clean_current_match=$(echo "$clean_current_match" | sed "s/<td>$remove_time_t<\/td>//")
    sed -i "/<\/table>/i $clean_current_match" "$history_html"
    echo "Appended current match to history.html"
else
    echo "No current match found to append to history.html"
fi

change_function
sh ./scripts/upload.sh 