#!/bin/bash

echo "=== 精简插件添加脚本 ==="
cd $GITHUB_WORKSPACE/build/immortalwrt

# 仅添加核心主题
echo "添加 Argon 主题..."
if [ ! -d "package/luci-theme-argon" ]; then
    git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
fi

# 可选：根据环境变量添加额外插件
if [ "$ADD_EXTRA_PLUGINS" = "true" ]; then
    echo "添加额外插件..."
    
    # Passwall
    if [ ! -d "package/passwall" ]; then
        git clone --depth=1 -b x86 https://github.com/xiaorouji/openwrt-passwall.git package/passwall
    fi
    
    # OpenClash
    if [ ! -d "package/luci-app-openclash" ]; then
        mkdir -p package/luci-app-openclash
        wget -qO- https://github.com/vernesong/OpenClash/archive/master.tar.gz | \
          tar -xz -C package/luci-app-openclash --strip-components=2 --wildcards "*/luci-app-openclash/*"
    fi
fi

echo "=== 插件添加完成 ==="
