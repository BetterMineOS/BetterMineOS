#!/bin/bash

# Mission is to be able to backup the server with a single script
# Python will pass the appropriate parameters to the script to make it work
# --no-encryption is always implied
# The user will be able to specify a file to exclude

# $1 aka first argument is the file to be backed up
# $2 aka second argument is the location it is backed up to
#
# Usage:
# Backup.sh [-t timeSinceLastFullBackup] [-e exclude] <server-to-backup> <backup-location>

# TODO: Provide proper error checking if screen doesn't exist

set -e

saved="Saved the game"

exclude=""
timeSinceLastFullBackup=""


while getopts ":e:t:" opt; do
    case ${opt} in
        e )
            exclude=$OPTARG
            ;;
        t )
            timeSinceLastFullBackup=$OPTARG
            ;;
    esac
done

ARG1=${@:$OPTIND:1}
ARG2=${@:$OPTIND+1:1}

screen -S $ARG1 -p 0 -X stuff "save-off^M" 
screen -S $ARG1 -p 0 -X stuff "save-all^M" 
sleep 2

check=$(tail -c 15 $BetterMineOS/servers/$ARG1/logs/latest.log | grep -o "Saved the game")

while [ "$check" != "$saved" ]
do	
	check=$(tail -c 15 $BetterMineOS/servers/$ARG1/logs/latest.log | grep -o "Saved the game")
	sleep 0.25
done


if [ "$exclude" != "" ]
then
    echo exclude argument $exclude
fi

if [ "$timeSinceLastFullBackup" != "" ]
then
    echo timeSinceLastFullBackup argument $timeSinceLastFullBackup
fi

if [ "$timeSinceLastFullBackup" != "" ] && [ "$exclude" != "" ]
then
    # run duplicity with the argument of time since last full backup    
    # and exclude file arguments
    
    duplicity $BetterMineOS/servers/$ARG1 $ARG2 --full-if-older-than $timeSinceLastFullBackup --exclude $exclude --no-encryption --allow-source-mismatch

elif [ "$timeSinceLastFullBackup" != "" ]
then
    # time since last full backup
    duplicity $BetterMineOS/servers/$ARG1 $ARG2 --full-if-older-than $timeSinceLastFullBackup --no-encryption --allow-source-mismatch

elif [ "$exclude" != "" ]
then
    # exclude
    duplicity $BetterMineOS/servers/$ARG1 $ARG2 --exclude $exclude --no-encryption --allow-source-mismatch
else
    duplicity $BetterMineOS/servers/$ARG1 $ARG2 --no-encryption --allow-source-mismatch
fi

screen -S $ARG1 -p 0 -X stuff "save-on^M" 
