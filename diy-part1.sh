#!/bin/bash

echo "=== 开始应用自定义设置 ==="

# 切换到 openwrt 目录
cd openwrt

# 设置管理 IP 地址
echo "设置管理 IP 为 192.168.6.1"
sed -i "s/192\.168\.1\.1/192.168.6.1/g" package/base-files/files/bin/config_generate
sed -i "s/192\.168\.\$\{ipaddr\}/192.168.6/g" package/base-files/files/bin/config_generate

# 设置主机名
echo "设置主机名为 OpenWrt-x86"
sed -i "s/OpenWrt/OpenWrt-x86/g" package/base-files/files/bin/config_generate

# 设置时区
echo "设置时区为亚洲/上海"
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate

# 修改 root 密码为空（首次登录后需修改）
echo "设置 root 密码为空"
sed -i 's/^root::/root::/g' package/base-files/files/etc/shadow 2>/dev/null || \
sed -i '/root/c\root::0:0:99999:7:::' package/base-files/files/etc/shadow

# 添加网络优化配置
echo "添加网络优化配置"
cat >> package/base-files/files/etc/sysctl.conf << 'EOF'

# 网络优化配置
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_rmem=4096 87380 134217728
net.ipv4.tcp_wmem=4096 65536 134217728
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

# 设置默认主题
echo "设置默认主题为 argon"
if [ -f "package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base" ]; then
  sed -i '/set luci.main.mediaurlbase/d' package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base
  echo "uci set luci.main.mediaurlbase='/luci-static/argon'" >> package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base
  echo "uci commit luci" >> package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base
fi

# 添加 CPU 优化脚本
cat > package/base-files/files/etc/init.d/cpu-optimize << 'EOF'
#!/bin/sh /etc/rc.common

START=99

start() {
    # 设置 CPU 为性能模式
    for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo performance > $gov 2>/dev/null || true
    done
}

stop() {
    echo "停止 CPU 优化"
}
EOF

chmod +x package/base-files/files/etc/init.d/cpu-optimize

echo "=== 自定义设置完成 ==="
