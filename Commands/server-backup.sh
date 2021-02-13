#!/bin/bash

# Mission is to be able to backup the server with a single script
# --no-encryption is always implied
# The server is assumed to be running (fails otherwise)
# 
# $1 The server to backup
#
# Usage:
# server-backup.sh <server-to-backup>

# TODO: Provide proper error checking if screen doesn't exist

set -e
ARG1=${@:$OPTIND:1}

# make sure there is a place to put the backup
if [ ! -d $BetterMineOS"/Backups/"$1  ]; then
    mkdir $BetterMineOS"/Backups/"$1
fi

# Setting up the server to be backed up
screen -S $ARG1 -p 0 -X stuff "save-off^M" 
screen -S $ARG1 -p 0 -X stuff "save-all^M" 
sleep 2

saved="Saved the game"
check=$(tail -c 15 $BetterMineOS/Servers/$ARG1/logs/latest.log | grep -o "Saved the game")
while [ "$check" != "$saved" ]
do	
	check=$(tail -c 15 $BetterMineOS/Servers/$ARG1/logs/latest.log | grep -o "Saved the game")
    echo "Stalled"
	sleep 0.25
done

duplicity $BetterMineOS"/Servers/"$1 file://$BetterMineOS/Backups/$1 --no-encryption

screen -S $ARG1 -p 0 -X stuff "save-on^M"
