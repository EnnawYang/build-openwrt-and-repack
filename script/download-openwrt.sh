#!/bin/bash

GREEN="\033[32m"
WHITE="\033[0m"
YELLOW="\033[33m"
RED="\033[31m"

rclone lsf $RCLONE_NAME:openwrt/repack >list.txt
grep "$TARGET_NAME" list.txt >/dev/null
if [ $? -eq 0 ]; then
    rclone copy $RCLONE_NAME:openwrt/repack/$TARGET_NAME-openwrt.tar . --transfers=8 -v
    tar -xvf $TARGET_NAME-openwrt.tar 2>&1 >/dev/null
    rm *-openwrt.tar
    sudo chown -R $USER:$GROUPS $REPO_FLODER
else
    echo -e "$YELLOW>>>> skip download ... $WHITE"
    exit 0
fi

