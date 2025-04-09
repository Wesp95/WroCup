#!/bin/bash
#Script created to export details from excel sheet and prepare html input
#Only used for Wroclaw Cup tournament when used Stolik file
#and webpage base on AWS S3 Bucket and HTML files.

# Check which parameter is provided as base for tab and file name
case "$1" in
    A) group="Grupa A (4)" ;;
    B) group="Grupa B (4)" ;;
    C) group="Grupa C (4)" ;;
    D) group="Grupa D (5)" ;;
    W) group="Grupa W (7)" ;;
    W1) group="Grupa W1 (5)" ;;
    W2) group="Grupa W2 (5)" ;;
    *)
        echo "Usage: $0 {A|B|C|D|W|W1|W2}"
        exit 1
        ;;
esac

#variables for file name and number of teams/rows to be copied into html
name=$(echo "$group" | sed -E 's/[ ()0-9]//g')
numb=$(echo "$group" | sed -E 's/[ ()A-Za-z]//g')
# Check if previous copy file exists
if [ -f tocopyhtml${name}.txt ]; then
    rm ./tocopyhtml${name}.txt
else
    touch "./tocopyhtml${name}.txt"
fi

#generate new csv file from excel
xlsx2csv -n "$group" stolik.xlsx > ${name}.csv 2>/dev/null
#counter is first row from which data is taken
counter=5
max=$((counter+numb-1))
echo "$max"
while [ $counter -le $max ]; do
#taking data from csv and inputing into html string
#then saving it to file based on the input file name
entry=$(awk -v line=$counter -F',' 'NR==line {print "<tr><td>" $2 "</td><td>" $3 "</td><td>" $4 "</td><td>" $5 "</td><td>" $6 "</td><td>" $7 "</td></tr>\n"}'  ${name}.csv)
echo "$entry" >> "tocopyhtml${name}.txt"
counter=$((counter+1))
echo "Export in progress"
echo "$entry"
done
echo "Export Completed"

mv ${name}.csv ./csfiles/${name}.csv.bkp.$(date +%Y%m%d%H%M)
