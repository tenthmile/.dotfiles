#!/bin/bash
# Todo. e.g. multiple VLC instances. Just choose the one with the biggest id (a.k.a. the newest).
# todo improve the queuing of the sound id.
# todo limit volume to <= 100

configFile=~/.paChangeStreamVolume
volumeUpperLimit=100

if [ $# -eq 0 ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
    echo "Usage: $0 [NUMBER] [OPTION]
Looks for specified audio stream to set its volume.
Specified audio streams are program names defined in $configFile.

Examples:
  $0 5 +  # increase volume by 5%
  $0 5 -  # decrease volume by 5%
  $0 60   # set volume to 60%

Mandatory arguments:
  [NUMBER]  any number between 0 and $volumeUpperLimit"
    if [ $# -eq 0 ]; then
        exit 1
    else
        exit 0
    fi
fi

cat $configFile | while read programName
do
    # this var may contain multiple lines (e.g. multiple Chromium instances) or fail if no instance of that program was found
    soundStreamIds=$(pactl list sink-inputs | grep -B 30 "application.name = \"$programName" | grep "Sink Input" | awk 'BEGIN {FS="#"}; {print $2} END {if (NR==0) exit 1}')
    if [ $? -eq 0 ]; then # we found 1 or many instances
        while read -r streamId; do # iterate over many instances so we can change the volume of every stream
            pactl set-sink-input-volume $streamId $2$1%
        done <<< "$soundStreamIds"
        break
    fi
done
