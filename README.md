# 本项目为自用，不保证可用性

Auto build OpenWrt firmware via GitHub Actions  

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/EnnawYang/openwrt-fastbuild/Build%20OpenWrt?label=GITHUB%20ACTIONS&style=for-the-badge)](https://github.com/EnnawYang/openwrt-fastbuild/actions)  

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/EnnawYang/openwrt-fastbuild?style=for-the-badge&label=DOWNLOADS)](https://github.com/EnnawYang/openwrt-fastbuild/releases/latest)  

## 功能
- 通过使用[预编译工具链](https://github.com/EnnawYang/OpenWrt-Toolchain-Cache/releases)从而达到一定加速效果，大约能加速30m-1h  
- 编译失败则打包日志目录上传  

本项目需要以下secrets (非必要):  
- SCTKEY (微信通知SCT KEY，用于通知)  
- TG_BOT_TOKEN (telegram bot token，用于通知)  
- TG_CHAT_ID (telegram id，用于通知)  

项目调用 [EnnawYang/openwrt-config](https://github.com/EnnawYang/openwrt-config) 作为配置文件库，可在env处更换仓库地址  
调用 `设备名.config` 和 `设备名-customize.sh`  
**ccache加速可能会造成一些问题，故未开启**  
**需要配合预编译工具链，否则没有提速效果，工具链源码仓库要与编译固件的源码仓库一致**  

## 使用方法
yml中config_name填写格式示例：  
```  
matrix:
  config_name: [x86_64, Rpi-4B, Newifi-D2]
```  
**注意英文逗号和空格**  
对应 `设备名.config` 和 `设备名-customize.sh`  

# Thanks
[P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)  
[SuLingGG/OpenWrt-Rpi](https://github.com/SuLingGG/OpenWrt-Rpi)  
[SuLingGG/OpenWrt-Cache](https://github.com/SuLingGG/OpenWrt-Cache)  
[klever1988/cachewrtbuild](https://github.com/klever1988/cachewrtbuild)

# 写在最后
没有一定排错能力请不要使用本项目
