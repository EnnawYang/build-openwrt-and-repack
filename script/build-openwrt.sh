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

update_config_repo () {
    if [ -d $GITHUB_WORKSPACE/$CONFIG_FLODER/.git ]; then
        cd $GITHUB_WORKSPACE/$CONFIG_FLODER
        git reset --hard
        echo -e "$green>>>> update config ... $white"
        git pull
    else
        echo -e "$green>>>> clone config ... $white"
        cd $GITHUB_WORKSPACE
        git clone $CONFIG_REPO -b $CONFIG_BRANCH $CONFIG_FLODER --single-branch
    fi
}

update_source_code () {
    if [ -d $GITHUB_WORKSPACE/$REPO_FLODER/.git ]; then
        cd $GITHUB_WORKSPACE/$REPO_FLODER
        git reset --hard
        distclean
        echo -e "$green>>>> update source code ... $white"
        git pull
        ./scripts/feeds update -a && ./scripts/feeds install -a
    else
        echo -e "$green>>>> clone source code ... $white"
        cd $GITHUB_WORKSPACE
        git clone $REPO_URL -b $REPO_BRANCH $REPO_FLODER --single-branch
        cd $GITHUB_WORKSPACE/$REPO_FLODER
        ./scripts/feeds update -a && ./scripts/feeds install -a
    fi
}

distclean () {
    if [[ $MAKE_DISTCLEAN == true ]]; then
        cd $GITHUB_WORKSPACE/$REPO_FLODER
        make distclean
    fi
}

rm_dl () {
    if [[ $RM_DL == true ]] && [ -d $GITHUB_WORKSPACE/$REPO_FLODER/dl ]; then
        cd $GITHUB_WORKSPACE/$REPO_FLODER
        rm -rf dl
    fi
}

custom_configuration () {
    cd $GITHUB_WORKSPACE/$REPO_FLODER
    echo -e "$green>>>> load custom configuration ... $white"
    chmod +x $GITHUB_WORKSPACE/$CONFIG_FLODER/*.sh
    bash $GITHUB_WORKSPACE/$CONFIG_FLODER/"$TARGET_NAME"-part2.sh
}

copy_config () {
    echo -e "$green>>>> copy .config file ... $white"
    if [ -e $GITHUB_WORKSPACE/$REPO_FLODER/.config ];then
        rm $GITHUB_WORKSPACE/$REPO_FLODER/.config*
    fi
    cp $GITHUB_WORKSPACE/$CONFIG_FLODER/"$TARGET_NAME".config $GITHUB_WORKSPACE/$REPO_FLODER/.config
    cd $GITHUB_WORKSPACE/$REPO_FLODER
    echo -e "\nCONFIG_DEVEL=y\nCONFIG_BUILD_LOG=y\nCONFIG_BUILD_LOG_DIR=\"./logs\"" >> .config
    make defconfig
}

make_download () {
    cd $GITHUB_WORKSPACE/$REPO_FLODER
    echo -e "$green>>>> download packages ... $white"
    dl_starttime=`date +'%Y-%m-%d %H:%M:%S'`
    make download -j8
    find dl -size -1024c -exec ls -l {} \;
    find dl -size -1024c -exec rm -f {} \;
    dl_endtime=`date +'%Y-%m-%d %H:%M:%S'`
}

clean_up () {
    cd $GITHUB_WORKSPACE/$REPO_FLODER
    mv bin/* $GITHUB_WORKSPACE/bin/
    make clean

    if [ -d files ]; then
        rm -rf files
    fi

    if [ -d logs ]; then
        rm -if logs
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
}

make_compile () {
    cd $GITHUB_WORKSPACE/$REPO_FLODER
    echo -e "$green>>>> $(nproc) thread compile ... $white"
    starttime=`date +'%Y-%m-%d %H:%M:%S'`
    make -j$(nproc)
    if [ $? -eq 0 ]; then
        endtime=`date +'%Y-%m-%d %H:%M:%S'`
        start_seconds=$(date --date="$starttime" +%s);
        end_seconds=$(date --date="$endtime" +%s);
        dl_start_seconds=$(date --date="$dl_starttime" +%s);
        dl_end_seconds=$(date --date="$dl_endtime" +%s);
        # clean_up
        echo -e "$green>>>> compile success ... $white"
        echo -e "$green>>>> download with $((dl_end_seconds-dl_start_seconds))s $white"
        echo -e "$green>>>> compile with $((end_seconds-start_seconds))s $white"
    else
        echo -e "$red>>>> $(nproc) thread compile failed ... \n$yellow>>>> logs will be updated later ... $white"
        exit 1
    fi
}

update_config_repo
update_source_code
custom_configuration
copy_config
rm_dl
make_download
make_compile

