#!/bin/bash

version="1.17.1"

version_url=https://papermc.io/api/v2/projects/paper/versions/$version

min_ram=6G
max_ram=6G

builds_string=$(curl -X GET "$version_url" -H  "accept: application/json")

latest=$(echo $builds_string | rev | cut -d, -f1 | rev | cut -d] -f1)

download_url="$version_url/builds/$latest/downloads/paper-$version-$latest.jar"

echo "Latest version of paper $version: "$latest

if [ "$(ls | grep $latest)" == "paper-$version-$latest.jar" ]; then
    echo You are up to date, starting paper-$version-$latest.jar

    java -Xms$min_ram -Xmx$max_ram -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper-$version-$latest.jar nogui
else
    echo You are out of date, updating...
    curl -OX GET $download_url -H "accept: application/json"

    java -Xms$min_ram -Xmx$max_ram -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper-$version-$latest.jar nogui
fi
