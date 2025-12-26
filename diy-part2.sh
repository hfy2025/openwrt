#!/bin/bash

echo "开始添加第三方插件..."

cd ${{ github.workspace }}/openwrt

# 首先更新一次官方 feeds
./scripts/feeds update -a

# 添加第三方软件源到 feeds.conf.default
cat >> feeds.conf.default << 'EOF'

# 第三方插件源
src-git small https://github.com/kenzok8/small-package
src-git openclash https://github.com/vernesong/OpenClash
src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome
src-git dockerman https://github.com/lisaac/luci-app-dockerman
src-git argon_config https://github.com/jerrykuku/luci-app-argon-config
src-git store https://github.com/linkease/istore
EOF

# 再次更新所有 feeds
./scripts/feeds update -a

# 安装所有包
./scripts/feeds install -a

# 特别安装一些必要的包
./scripts/feeds install luci-app-adguardhome
./scripts/feeds install luci-app-openclash
./scripts/feeds install luci-app-dockerman
./scripts/feeds install luci-app-argon-config
./scripts/feeds install luci-app-store
./scripts/feeds install luci-app-turboacc
./scripts/feeds install luci-app-samba4
./scripts/feeds install luci-app-upnp
./scripts/feeds install luci-app-appfilter
./scripts/feeds install luci-app-quickstart

echo "第三方插件添加完成！"
