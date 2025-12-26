#!/bin/bash

echo "=== 开始添加第三方插件 ==="

cd openwrt

# 首先更新官方 feeds
echo "更新官方 feeds..."
./scripts/feeds update -a
./scripts/feeds install -a

# 添加第三方软件源到 feeds.conf
echo "添加第三方软件源..."
cat >> feeds.conf.default << 'EOF'

# 第三方插件源
src-git small https://github.com/kenzok8/small-package
src-git openclash https://github.com/vernesong/OpenClash
src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome
EOF

# 重新更新 feeds
echo "重新更新 feeds..."
./scripts/feeds update -a

# 安装插件
echo "安装插件..."
./scripts/feeds install -a

# 特别安装需要的插件
for pkg in \
  luci-app-adguardhome \
  luci-app-openclash \
  luci-app-dockerman \
  luci-app-samba4 \
  luci-app-turboacc \
  luci-app-upnp \
  luci-app-argon-config \
  luci-app-quickstart \
  luci-app-store; do
  ./scripts/feeds install $pkg 2>/dev/null && echo "安装 $pkg 成功" || echo "安装 $pkg 失败"
done

echo "=== 第三方插件添加完成 ==="
