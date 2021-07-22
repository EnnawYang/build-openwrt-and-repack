#!/bin/bash

green="\033[32m"
white="\033[0m"
yellow="\033[33m"
red="\033[31m"

rclone lsf $RCLONE_NAME:openwrt/repack > list.txt
grep "$TARGET_NAME" list.txt > /dev/null
if [ $? -eq 0 ]; then
    rclone copy $RCLONE_NAME:openwrt/repack/$TARGET_NAME-openwrt.tar . --transfers=8 -v
    tar -xvf $TARGET_NAME-openwrt.tar
    rm *-openwrt.tar
    sudo chown -R $USER:$GROUPS openwrt
else
    echo -e "$yellow>>>> skip download ... $white"
    exit 0
fi

