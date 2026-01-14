#!/bin/bash

echo "=== 开始添加自定义插件和主题 ==="
cd $GITHUB_WORKSPACE/build/immortalwrt

# 添加 Argon 主题
echo "添加 Argon 主题..."
if [ ! -d "package/luci-theme-argon" ]; then
    git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
fi

# 添加 Argon 主题配置
if [ ! -d "package/luci-app-argon-config" ]; then
    git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
fi

# 添加 Material 主题
echo "添加 Material 主题..."
if [ ! -d "package/luci-theme-material" ]; then
    git clone --depth=1 https://github.com/Lienol/openwrt-package.git lienol-packages
    cp -r lienol-packages/luci-theme-material package/
    rm -rf lienol-packages
fi

# 添加 Passwall (X86 分支)
echo "添加 Passwall..."
if [ ! -d "package/passwall" ]; then
    git clone --depth=1 -b x86 https://github.com/xiaorouji/openwrt-passwall.git package/passwall
fi

# 添加 OpenClash
echo "添加 OpenClash..."
if [ ! -d "package/luci-app-openclash" ]; then
    mkdir -p package/luci-app-openclash
    git clone --depth=1 https://github.com/vernesong/OpenClash.git
    mv OpenClash/luci-app-openclash/* package/luci-app-openclash/
    rm -rf OpenClash
fi

# 添加 AdGuardHome
echo "添加 AdGuardHome..."
if [ ! -d "package/luci-app-adguardhome" ]; then
    git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
fi

# 添加 Dockerman
echo "添加 Dockerman..."
if [ ! -d "package/luci-app-dockerman" ]; then
    git clone --depth=1 https://github.com/lisaac/luci-app-dockerman.git package/luci-app-dockerman
    # 需要对应的 Docker 插件
    git clone --depth=1 https://github.com/lisaac/luci-lib-docker.git package/luci-lib-docker
fi

# 添加自动更新插件
echo "添加自动更新插件..."
if [ ! -d "package/luci-app-autoupdate" ]; then
    git clone --depth=1 https://github.com/sirpdboy/luci-app-autoupdate.git package/luci-app-autoupdate
fi

# 添加 Adbyby Plus
echo "添加 Adbyby Plus..."
if [ ! -d "package/luci-app-adbyby-plus" ]; then
    git clone --depth=1 https://github.com/chenxiccc/luci-app-adbyby-plus.git package/luci-app-adbyby-plus
fi

# 添加 Fail2ban
echo "添加 Fail2ban..."
if [ ! -d "package/luci-app-fail2ban" ]; then
    git clone --depth=1 https://github.com/openwrt/luci.git luci-main
    cp -r luci-main/applications/luci-app-fail2ban package/
    rm -rf luci-main
fi

# 添加 AppFilter
echo "添加 AppFilter..."
if [ ! -d "package/luci-app-appfilter" ]; then
    git clone --depth=1 https://github.com/destan19/OpenAppFilter.git openappfilter
    cp -r openappfilter/luci-app-appfilter package/
    cp -r openappfilter/open-app-filter package/
    rm -rf openappfilter
fi

echo "=== 自定义插件添加完成 ==="

# 更新 feeds 以包含新添加的包
./scripts/feeds update -a
./scripts/feeds install -a

# 列出已添加的包
echo "已添加的自定义包："
ls -la package/ | grep -E "(luci|passwall|argon|material)"
