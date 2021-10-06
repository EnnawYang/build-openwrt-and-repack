# 本项目为自用，不保证可用性

## 功能
- 通过打包整个lede项目使用rclone上传到GoogleDrive，供二次编译从而达到一定加速效果(20min-1hour左右)  
- 二次编译可以跳过编译tools和toolchain进一步加快编译速度(30min-50min左右)  
- 编译失败则打包日志目录上传  

使用本项目需要以下secrets:  
- RCLONE_CONFIG (rclone配置文件，不设置则每次全新编译)  
- RCLONE_NAME (rclone配置文件中网盘的名称，不设置则每次全新编译)  
- SCTKEY (可选，微信通知SCT KEY，用于通知)  
- TG_BOT_TOKEN (可选，telegram bot token，用于通知)  
- TG_CHAT_ID (可选，telegram id，用于通知)  

项目调用 [EnnawYang/Actions-OpenWrt](https://github.com/EnnawYang/Actions-OpenWrt) 作为配置文件库，可以在yml中设置仓库地址  
调用 `机型.config` 和 `机型-customize.sh` ，如果不存在则调用 `.config` 和 `customize.sh`  

## 使用方法
增删target以增加或者减少机型,以下为示例：  
```  
strategy:
  matrix:
    include:
      - targets: "x86_64"
```  
引号内为机型，对应 `机型.config` 和 `机型-customize.sh`


## Thanks
[P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)  
[SuLingGG/OpenWrt-Rpi](https://github.com/SuLingGG/OpenWrt-Rpi)  
[klever1988/cachewrtbuild](https://github.com/klever1988/cachewrtbuild)

## 写在最后
没有一定排错能力请不要使用本项目
