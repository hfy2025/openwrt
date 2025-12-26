#!/bin/bash

echo "开始添加第三方插件..."

cd openwrt

# 更新 feeds
./scripts/feeds update -a

# 添加第三方软件源
echo "
# 第三方插件源
src-git small https://github.com/kenzok8/small-package
src-git openclash https://github.com/vernesong/OpenClash
src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome
src-git dockerman https://github.com/lisaac/luci-app-dockerman
src-git argon_config https://github.com/jerrykuku/luci-app-argon-config
" >> feeds.conf.default

# 再次更新所有 feeds
./scripts/feeds update -a
./scripts/feeds install -a

echo "第三方插件添加完成！"
