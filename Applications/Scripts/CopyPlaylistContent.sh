#!/bin/bash
copyCommand="gio copy"  # cp
copyCommandParameter="-p"
fileExistsCommand="gio info"     # ls
createDirCommand="gio mkdir" # mkdir
createDirCommandParameter="-p"


if [ \( "$#" -ne 3 \) -a \( "$#" -ne 4 \) ]
then
    echo $0 playlistFile fromDirectory toDirectory [excludeFilesThatExistInThisDir]
    exit
fi

playlist="$1"
fromBaseDir="$(realpath $2)"
toBaseDir="$3"
excludeIfExistsIn="$4"

IFS=$'\n'

lastFile=""
cd "$(dirname $playlist)"
for line in $(cat $playlist)
do
    fullpath=$(realpath "$line")
    if [[ "$fullpath" ]]; then
        relativeName="${fullpath#$fromBaseDir/}"
        # escape special characters if for example you copy files with gio.
        relativeNameEscaped=$(sed -e 's/%/%25/g' <<< $relativeName)
        

        if [[ "$excludeIfExistsIn" ]]; then
            existsInOther="$excludeIfExistsIn/$relativeNameEscaped"
            eval $fileExistsCommand \"$existsInOther\" > /dev/null 2> /dev/null
            if [ $? -eq 0 ]; then
                continue
            fi
        fi

        # create folder if necessary
        destDirName=$(dirname $toBaseDir/$relativeNameEscaped)
        eval $fileExistsCommand \"$destDirName\" > /dev/null 2> /dev/null
        if [ $? -ne 0 ]; then
            eval $createDirCommand $createDirCommandParameter \"$destDirName\"
        fi
        # copy files over (if they don't already exist)
        eval $fileExistsCommand \"$toBaseDir/$relativeNameEscaped\" > /dev/null 2> /dev/null
        if [ $? -ne 0 ]; then
            eval $copyCommand $copyCommandParameter \"$fromBaseDir/$relativeName\" \"$toBaseDir/$relativeNameEscaped\"
        fi
        if [ $? -ne 0 ]; then
            echo Failed to copy "$fromBaseDir/$relativeName" to "$toBaseDir/$relativeNameEscaped".
            break
        fi
    fi
done
