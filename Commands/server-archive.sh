#!/bin/bash

# This script creates a tar.gz archive with preserved permissions of the passed in folder

date=$(date +"%d_%m_%y_%Hh%Mm")

tar -zpcf "$1_$date.tar.gz" $betterMineOS"/Servers/"$1

if [ ! -d $betterMineOS"/Archives/"$1  ]; then
    mkdir $betterMineOS"/Archives/"$1
fi

mv "$1_$date.tar.gz" $betterMineOS"/Archives/"$1/
