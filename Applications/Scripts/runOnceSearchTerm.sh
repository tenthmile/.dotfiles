#!/bin/bash

#this script is like runOnce.sh, however it takes an search argument as it's first parameter and uses that to queue with pgrep instead of the program name. This is e.g. multiload-ng-systray, where the executable is called "multiload-ng-systray" but pgrep only finds it as multiload-ng
searchTerm=$1
shift # this pops the first element of $@ and $*
pgrep $searchTerm > /dev/null || ($@ &)
