# NanoPi-R4S 的 OpenWrt 固件  
![R4S-OpenWrt-Lean](https://github.com/RikudouPatrickstar/R4S-OpenWrt-Lean/workflows/R4S-OpenWrt-Lean/badge.svg)  

## 一、固件特性  
### 基于 [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede) 并做如下修改：  
1. 插件包含： `OpenClash` `SSRPlus` `Samba4网络共享`  
2. 设置主机名为 `NanoPi-R4S`  
3. 设置 `luci-theme-argon` 为默认主题且删除主题底部文字  
4. 提供 `EXT4FS` 和 `SQUASHFS` 两种类型固件  
5. 重命名 `ShadowSocksR Plus+` 为 `SSRPlus`，不用占两行了，并且微调其设置首页内容  
6. 移除 `luci-app-autoreboot` `luci-app-ramfree` `luci-theme-bootstrap`  
7. 精简 LuCI 界面，移除 `软件包` `挂载点` `备份/升级`  
8. 取消 IPv6 支持  

### 默认 LAN IP、用户、密码：  
1. 默认 LAN IP： `192.168.1.1`  
2. 默认用户、密码： `root` `无`  

## 二、感谢  
   感谢所有提供了上游项目代码和给予了帮助的大佬们  
