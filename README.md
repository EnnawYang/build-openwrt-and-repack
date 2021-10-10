# 本项目为自用，不保证可用性

## 功能
- 通过打包整个lede项目使用rclone上传到GoogleDrive，供二次编译直接使用从而达到一定加速效果(20min-1hour左右)  
- 二次编译可以跳过编译tools和toolchain进一步加快编译速度(30min-50min左右)  
- 编译失败则打包日志目录上传  

使用本项目需要以下secrets:  
- RCLONE_CONFIG (rclone配置文件，不设置则每次全新编译)  
- RCLONE_NAME (rclone配置文件中网盘的名称，不设置则每次全新编译)  
- SCTKEY (可选，微信通知SCT KEY，用于通知)  
- TG_BOT_TOKEN (可选，telegram bot token，用于通知)  
- TG_CHAT_ID (可选，telegram id，用于通知)  

项目调用 [EnnawYang/openwrt-config](https://github.com/EnnawYang/openwrt-config) 作为配置文件库，可以在触发时设置仓库地址  
带星号的为必填项，填错会导致失败  
调用 `机型.config` 和 `机型-customize.sh` ，如果不存在则调用 `.config` 和 `customize.sh`  

## Thanks
[P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)  
[SuLingGG/OpenWrt-Rpi](https://github.com/SuLingGG/OpenWrt-Rpi)  
[klever1988/cachewrtbuild](https://github.com/klever1988/cachewrtbuild)

## 写在最后
看不懂就不要用了
