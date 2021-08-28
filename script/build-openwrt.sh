#!/bin/bash

GREEN="\033[32m"
WHITE="\033[0m"
YELLOW="\033[33m"
RED="\033[31m"

# openwrt源码库
#REPO_URL=
#REPO_BRANCH=
#REPO_FLODER=

# 机型配置文件库
#CONFIG_REPO=
#CONFIG_BRANCH=
#CONFIG_FLODER=

WORKDIR=$(pwd)
echo -e "$GREEN>>>> workdir: $WORKDIR $WHITE \n"

UPDATE_CONFIG_REPO () {
    if [ -d $WORKDIR/$CONFIG_FLODER/.git ]; then
        cd $WORKDIR/$CONFIG_FLODER
        git reset --hard
        echo -e "$GREEN>>>> update config ... $WHITE"
        git pull
    else
        echo -e "$GREEN>>>> clone config ... $WHITE"
        cd $WORKDIR
        git clone $CONFIG_REPO -b $CONFIG_BRANCH $CONFIG_FLODER --single-branch
    fi
}

UPDATE_SOURCE_CODE () {
    if [ -d $WORKDIR/$REPO_FLODER/.git ]; then
        cd $WORKDIR/$REPO_FLODER
        git reset --hard
        echo -e "$GREEN>>>> update source code ... $WHITE"
        git pull
        ./scripts/feeds update -a && ./scripts/feeds install -a
    else
        echo -e "$GREEN>>>> clone source code ... $WHITE"
        cd $WORKDIR
        git clone $REPO_URL -b $REPO_BRANCH $REPO_FLODER --single-branch
        cd $WORKDIR/$REPO_FLODER
        ./scripts/feeds update -a && ./scripts/feeds install -a
    fi
}

RM_DL () {
    if [[ $RM_DL == true ]] && [ -d $WORKDIR/$REPO_FLODER/dl ]; then
        rm -rf $WORKDIR/$REPO_FLODER/dl
    fi
}

CUSTOM_CONFIGURATION () {
    cd $WORKDIR/$REPO_FLODER
    echo -e "$GREEN>>>> load custom configuration ... $WHITE"
    chmod +x $WORKDIR/$CONFIG_FLODER/*.sh
    bash $WORKDIR/$CONFIG_FLODER/"$TARGET_NAME"-part2.sh
}

COPY_CONFIG () {
    echo -e "$GREEN>>>> copy .config file ... $WHITE"
    if [ -e $WORKDIR/$REPO_FLODER/.config ];then
        rm $WORKDIR/$REPO_FLODER/.config*
    fi
    cp $WORKDIR/$CONFIG_FLODER/"$TARGET_NAME".config $WORKDIR/$REPO_FLODER/.config
    cd $WORKDIR/$REPO_FLODER
    echo -e "\nCONFIG_DEVEL=y\nCONFIG_BUILD_LOG=y\nCONFIG_BUILD_LOG_DIR=\"./logs\"" >> .config
    make defconfig
}

MAKE_DOWNLOAD () {
    cd $WORKDIR/$REPO_FLODER
    echo -e "$GREEN>>>> download packages ... $WHITE"
    DL_STARTTIME=`date +'%Y-%m-%d %H:%M:%S'`
    make download -j8
    find dl -size -1024c -exec ls -l {} \;
    find dl -size -1024c -exec rm -f {} \;
    DL_ENDTIME=`date +'%Y-%m-%d %H:%M:%S'`
}

MAKE_COMPILE () {
    cd $WORKDIR/$REPO_FLODER
    echo -e "$GREEN>>>> $(nproc) thread compile ... $WHITE"
    STARTTIME=`date +'%Y-%m-%d %H:%M:%S'`
    [[ $TOOLCHAIN == true ]] && make tools/compile -j$(nproc) && make toolchain/compile -j$(nproc)
    make target/compile -j$(nproc) && \
    make diffconfig && \
    make package/compile -j$(nproc) && \
    make package/index && \
    make package/install -j$(nproc) && \
    make target/install -j$(nproc) && \
    make checksum
    if [ $? -eq 0 ]; then
        ENDTIME=`date +'%Y-%m-%d %H:%M:%S'`
        START_SECONDS=$(date --date="$STARTTIME" +%s);
        END_SECONDS=$(date --date="$ENDTIME" +%s);
        DL_START_SECONDS=$(date --date="$DL_STARTTIME" +%s);
        DL_END_SECONDS=$(date --date="$DL_ENDTIME" +%s);
        echo -e "$GREEN>>>> compile success ... $WHITE"
        echo -e "$GREEN>>>> download with $((DL_END_SECONDS-DL_START_SECONDS))s $WHITE"
        echo -e "$GREEN>>>> compile with $((END_SECONDS-START_SECONDS))s $WHITE"
    else
        echo -e "$RED>>>> $(nproc) thread compile failed ... \n$YELLOW>>>> logs will be uploaded later ... $WHITE"
        exit 1
    fi
}

UPDATE_CONFIG_REPO
UPDATE_SOURCE_CODE
CUSTOM_CONFIGURATION
COPY_CONFIG
RM_DL
MAKE_DOWNLOAD
MAKE_COMPILE

