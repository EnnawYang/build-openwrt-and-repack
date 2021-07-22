#!/bin/bash

green="\033[32m"
white="\033[0m"
yellow="\033[33m"
red="\033[31m"

cd $GITHUB_WORKSPACE

echo -e "$green>>>> workdir: $(pwd) $white \n"

# openwrt源码库
REPO_URL=https://github.com/immortalwrt/immortalwrt
REPO_BRANCH=openwrt-18.06-k5.4
REPO_FLODER=openwrt

# 机型配置文件库
CONFIG_REPO=https://github.com/EnnawYang/Actions-OpenWrt
CONFIG_BRANCH=main
CONFIG_FLODER=Actions-OpenWrt

cd $GITHUB_WORKSPACE/$REPO_FLODER
make clean

if [ -d bin ]; then
  rm -rf bin
fi
	
if [ -d files ]; then
  rm -rf files
fi
	
if [ -d tmp ]; then
  rm -rf tmp
fi
	
if [ -d package/diy ]; then
  rm -rf diy
fi
	
if [ -d dl/go-mod-cache ]; then
  rm -rf dl/go-mod-cache
fi

git reset --hard

cd $GITHUB_WORKSPACE/$CONFIG_FLODER
git reset --hard

