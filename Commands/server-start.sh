#!/bin/bash

set -e

if [ "$1" = "" ]
then
    echo -e "\n\e[91mMust pass in a server name \e[0m\n"
    exit
fi

if [ -d $BetterMineOS"/Servers/"$1 ]
then
    cd $BetterMineOS"/Servers/"$1
    echo $(pwd)
    echo -e "\nStarting server: \e[93m $1 \e[0m\n"
    screen -dmS $1 ./AutoUpdateAndStartPaper.sh
else
    echo -e "\n\e[91mServer does not exist!\e[0m\n"
fi
