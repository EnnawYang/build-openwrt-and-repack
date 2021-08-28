# 本项目为自用，不保证可用性

## 功能
- 本项目通过打包整个lede项目使用rclone上传到Google Drive，供二次编译直接使用从而达到一定加速效果  
- 二次编译可以跳过编译tools和toolchain进一步加快编译速度，因机型不同，一般可以加快30-50分钟左右  

使用本项目需要以下secrets:  
- RCLONE_CONFIG (rclone配置文件)  
- RCLONE_NAME (rclone配置文件中网盘的名称)  
- SCTKEY (可选，微信通知SCT KEY，用于通知)  
- TG_BOT_TOKEN (可选，telegram bot token，用于通知)  
- TG_CHAT_ID (可选，telegram id，用于通知)  

项目调用 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 作为配置文件库，可以在yml中设置仓库地址  
调用 `机型.config` 和 `机型-part2.sh`  

## 鸣谢
[P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)  
[SuLingGG/OpenWrt-Rpi](https://github.com/SuLingGG/OpenWrt-Rpi)

## 写在最后
没有一定排错能力请不要使用本项目
