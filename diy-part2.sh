#!/bin/bash

echo "开始添加第三方插件..."

cd openwrt-source

# 添加第三方软件源
cat > feeds.conf << 'EOF'
src-git official https://git.openwrt.org/feed/packages.git^6c1c8e6
src-git luci https://git.openwrt.org/project/luci.git^e6b8b4c
src-git routing https://git.openwrt.org/feed/routing.git^e63b254
src-git telephony https://git.openwrt.org/feed/telephony.git^9e0c7c8

# 第三方插件源
src-git small https://github.com/kenzok8/small-package.git^d5b7bf0
src-git openclash https://github.com/vernesong/OpenClash.git^f9193ff
src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome.git^0b5ae66
src-git dockerman https://github.com/lisaac/luci-app-dockerman.git^d3a9c29
EOF

# 更新并安装 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 为某些插件创建必要的符号链接
mkdir -p package/community
cd package/community

# 克隆一些额外的插件
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git
git clone --depth=1 https://github.com/thinktip/luci-theme-neobird.git

cd ../..

echo "第三方插件添加完成！"
