#!/bin/bash

set -e

if [ "$1" = "" ]; then
    echo -e "\n\e[91mMust pass in a server name \e[0m\n"
    exit
fi

if [ -d $BetterMineOS"/Servers/"$1 ]; then
    echo -e "\nStoping server: \e[93m $1 \e[0m\n"
    screen -r $1 -p 0 -X stuff "stop^M"
    exit
else
    echo -e "\n\e[91mServer does not exist!\e[0m\n"
fi
