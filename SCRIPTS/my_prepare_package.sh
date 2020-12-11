#!/bin/sh

MY_PATH=$(pwd)

#SSRP
pushd package/lean
rm -fr luci-app-ssr-plus tcping naiveproxy
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/tcping tcping
svn co https://github.com/fw876/helloworld/trunk/naiveproxy naiveproxy
popd
pushd package/lean/luci-app-ssr-plus
# 调整常用端口
sed -i 's/143/143,25,5222/' root/etc/init.d/shadowsocksr
# 替换首页标题及其翻译
sed -i 's/ShadowSocksR Plus+ Settings/Basic Settings/' po/zh-cn/ssr-plus.po
sed -i 's/ShadowSocksR Plus+ 设置/基本设置/' po/zh-cn/ssr-plus.po
# 删除首页不必要的内容
sed -i '/<h3>Support SS/d' po/zh-cn/ssr-plus.po
sed -i '/<h3>支持 SS/d' po/zh-cn/ssr-plus.po
sed -i 's/Map(shadowsocksr, translate("ShadowSocksR Plus+ Settings"),/Map(shadowsocksr, translate("Basic Settings"))/' luasrc/model/cbi/shadowsocksr/client.lua
sed -i '/translate("<h3>Support SS/d' luasrc/model/cbi/shadowsocksr/client.lua
# 全局替换 ShadowSocksR Plus+ 为 SSRPlus
files="$(find 2>"/dev/null")"
for f in ${files}
do
	if [ -f "$f" ]
	then
		# echo "$f"
		sed -i 's/ShadowSocksR Plus+/SSRPlus/gi' "$f"
	fi
done
popd

# OpenClash
rm -fr package/lean/luci-app-openclash
git clone -b master --single-branch https://github.com/vernesong/OpenClash package/lean/luci-app-openclash
## 修改 DashBoard 默认地址和密码
pushd package/lean/luci-app-openclash/luci-app-openclash/root/usr/share/openclash/dashboard/static/js
sed -i 's/n=C(\"externalControllerAddr\",\"127.0.0.1\"),a=C(\"externalControllerPort\",\"9090\"),r=C(\"secret\",\"\")/n=C(\"externalControllerAddr\",\"nanopi-r4s\"),a=C(\"externalControllerPort\",\"9090\"),r=C(\"secret\",\"123456\")/' *js
sed -i 's/hostname:\"127.0.0.1\",port:\"9090\",secret:\"\"/hostname:\"nanopi-r4s\",port:\"9090\",secret:\"123456\"/' *js
popd
# 预置 dev 内核
mkdir -p package/base-files/files/etc/openclash/core
wget https://raw.githubusercontent.com/vernesong/OpenClash/master/core-lateset/dev/clash-linux-armv8.tar.gz
tar -zxvf clash-linux-armv8.tar.gz
chmod +x clash
mv clash package/base-files/files/etc/openclash/core/

# Argon 主题
rm -rf package/lean/luci-theme-argon
git clone -b 18.06 --single-branch https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
## 移除底部文字
pushd package/lean/luci-theme-argon/luasrc/view/themes/argon
sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\">/d' footer.htm
sed -i '/(<%= ver.luciversion %>)<\/a>/d' footer.htm
sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\">/d'  footer.htm
sed -i '/<%= ver.distversion %>/d' footer.htm
popd

# 替换 luci 的 bootstrap 主题依赖
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci/Makefile

# 替换默认设置
pushd package/lean/default-settings/files
rm -f zzz-default-settings
cp ${MY_PATH}/../PATCH/zzz-default-settings ./
popd

# 移除 LuCI 部分页面
pushd feeds/luci/modules/luci-mod-admin-full/luasrc/model/cbi/admin_system
rm -fr backupfiles.lua fstab* ipkg.lua
popd
pushd feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_system
rm -fr applyreboot.htm backupfiles.htm flashops.htm ipkg.htm  packages.htm upgrade.htm
popd
pushd feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin
rm -fr system.lua
cp ${MY_PATH}/../PATCH/system.lua ./
popd

# 删除指向 fstab 页面的超链接
pushd package/lean/luci-app-samba4/luasrc/model/cbi
sed -i '/"system", "fstab"/d' samba4.lua
popd

unset MY_PATH
exit 0
