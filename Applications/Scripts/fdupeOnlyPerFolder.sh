#!/bin/bash

cd $1

IFS=$'\n'
baseDir=$(pwd)
for folder in $(find . -type d)
do
    cd "$folder"

    files=$(fdupes .)
    if [[ $? != 0 ]]; then
        pwd
        echo "Command failed."
    elif [[ $files ]]; then
        pwd
        #echo "Duplicates Found:"
        echo "$files"
        echo
        echo
    #else
        #echo "No duplicates found"
    fi
    
    cd "$baseDir"
done
