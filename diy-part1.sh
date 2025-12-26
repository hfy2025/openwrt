#!/bin/bash

echo "开始应用自定义设置..."

# 设置后台管理 IP
sed -i "s/192\.168\.1\.1/192.168.6.1/g" package/base-files/files/bin/config_generate

# 设置主机名
sed -i "s/OpenWrt/OpenWrt-x86-64/g" package/base-files/files/bin/config_generate

# 设置时区
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate

# 设置语言
sed -i "/uci commit system/i\uci set system.@system[0].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 修改 root 密码为空（首次登录需要自己设置）
sed -i '/root/c\\$1\$V4UetPzk\$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::' package/base-files/files/etc/shadow

# 优化内核参数（千兆/万兆网络）
cat >> package/base-files/files/etc/sysctl.conf << EOF

# 千兆/万兆网络优化
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_rmem=4096 87380 134217728
net.ipv4.tcp_wmem=4096 65536 134217728
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_notsent_lowat=16384
net.core.netdev_max_backlog=300000
net.ipv4.tcp_max_syn_backlog=2048
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_mtu_probing=1

# 提高连接数限制
net.netfilter.nf_conntrack_max=524288
net.nf_conntrack_max=524288
EOF

# 添加性能优化脚本
cat > package/base-files/files/etc/init.d/optimize << 'EOF'
#!/bin/sh /etc/rc.common

START=99

start() {
    # 启用 BBR
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    
    # 应用优化参数
    sysctl -p
    
    # 设置 CPU 调度
    echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null || true
    
    # IRQ 优化（针对多网卡）
    if [ -f /usr/sbin/irqbalance ]; then
        /usr/sbin/irqbalance
    fi
}

stop() {
    echo "停止优化..."
}
EOF

chmod +x package/base-files/files/etc/init.d/optimize

# 修改默认主题为 argon
sed -i '/uci set luci.main.mediaurlbase/d' package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base
cat >> package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base << EOF
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
EOF

echo "自定义设置应用完成！"
