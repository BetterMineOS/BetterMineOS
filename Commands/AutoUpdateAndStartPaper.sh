#!/bin/bash

version="1.16.4"

version_url="https://papermc.io/api/v1/paper/"$version
latest_url="https://papermc.io/api/v1/paper/"$version"/latest/download"

min_ram=6G
max_ram=6G

curl -o versions.txt $version_url
latest=$(grep -oe '"latest":[0-9]\+' versions.txt | grep -oe '[0-9]\+')
rm versions.txt

echo "Latest version of paper "$version": "$latest

if [ "$(ls | grep $latest)" == "paper-$latest.jar" ]; then
    echo You are up to date, starting paper-$latest.jar

    java -Xms$min_ram -Xmx$max_ram -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper-$latest.jar nogui
else
    echo You are out of date, updating...
    curl -JLo "paper-$latest.jar" $latest_url

    java -Xms$min_ram -Xmx$max_ram -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper-$latest.jar nogui
fi
