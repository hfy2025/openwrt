#!/bin/bash

echo "开始应用自定义设置..."

# 设置构建环境变量
export FORCE_UNSAFE_CONFIGURE=1

# 设置后台管理 IP
sed -i "s/192\.168\.1\.1/192.168.6.1/g" package/base-files/files/bin/config_generate
sed -i "s/192\.168\.\$\{ipaddr\}/192.168.6/g" package/base-files/files/bin/config_generate

# 设置主机名
sed -i "s/OpenWrt/OpenWrt-x86-64/g" package/base-files/files/bin/config_generate
sed -i "s/openwrt/OpenWrt-x86-64/g" package/base-files/files/bin/config_generate

# 设置时区为亚洲/上海
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/system.@system\[0\].timezone=/c\	set system.@system[0].timezone='CST-8'" package/base-files/files/bin/config_generate

# 设置语言
sed -i "/system.@system\[0\].lang=/c\	set system.@system[0].lang='zh_cn'" package/base-files/files/bin/config_generate

# 修改 root 密码为空
sed -i '/^root:/s|^.*$|root::0:0:99999:7:::|' package/base-files/files/etc/shadow

# 添加自定义网络配置
cat > package/base-files/files/etc/config/network << 'EOF'
config interface 'loopback'
	option device 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'
	option ula_prefix 'fd00:ab:cd::/48'

config device
	option name 'br-lan'
	option type 'bridge'
	list ports 'eth0'

config interface 'lan'
	option device 'br-lan'
	option proto 'static'
	option ipaddr '192.168.6.1'
	option netmask '255.255.255.0'
	option ip6assign '60'

config interface 'wan'
	option device 'eth1'
	option proto 'dhcp'

config interface 'wan6'
	option device 'eth1'
	option proto 'dhcpv6'
EOF

# 添加 DHCP 配置
cat > package/base-files/files/etc/config/dhcp << 'EOF'
config dnsmasq
	option domainneeded '1'
	option boguspriv '1'
	option filterwin2k '0'
	option localise_queries '1'
	option rebind_protection '1'
	option rebind_localhost '1'
	option local '/lan/'
	option domain 'lan'
	option expandhosts '1'
	option nonegcache '0'
	option authoritative '1'
	option readethers '1'
	option leasefile '/tmp/dhcp.leases'
	option resolvfile '/tmp/resolv.conf.auto'
	option nonwildcard '1'
	option localservice '1'

config dhcp 'lan'
	option interface 'lan'
	option start '100'
	option limit '150'
	option leasetime '12h'
	option dhcpv4 'server'
	option dhcpv6 'server'
	option ra 'server'
	option ra_management '1'

config dhcp 'wan'
	option interface 'wan'
	option ignore '1'

config odhcpd 'odhcpd'
	option maindhcp '0'
	option leasefile '/tmp/hosts/odhcpd'
	option leasetrigger '/usr/sbin/odhcpd-update'
	option loglevel '4'
EOF

# 优化内核参数（千兆/万兆网络）
cat >> package/base-files/files/etc/sysctl.d/99-custom.conf << 'EOF'
# 千兆/万兆网络优化
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_notsent_lowat = 16384
net.core.netdev_max_backlog = 300000
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_mtu_probing = 1

# 提高连接数限制
net.netfilter.nf_conntrack_max = 524288
net.nf_conntrack_max = 524288
net.netfilter.nf_conntrack_tcp_timeout_established = 1200

# 文件系统优化
fs.file-max = 2097152
fs.nr_open = 2097152

# 内存优化
vm.swappiness = 10
vm.vfs_cache_pressure = 50
EOF

# 添加性能优化启动脚本
cat > package/base-files/files/etc/init.d/network-optimize << 'EOF'
#!/bin/sh /etc/rc.common

START=99
USE_PROCD=1

start_service() {
    procd_open_instance
    procd_set_param command /bin/true
    procd_close_instance
    
    # 等待网络就绪
    sleep 5
    
    # 启用 BBR
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    
    # 应用优化参数
    sysctl -p /etc/sysctl.d/99-custom.conf
    
    # 设置 CPU 调度为性能模式
    echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null || true
    
    # 如果有多个 CPU 核心
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo performance > $cpu 2>/dev/null || true
    done
    
    # IRQ 优化（针对多网卡）
    if [ -x /usr/sbin/irqbalance ]; then
        /usr/sbin/irqbalance --foreground &
    fi
    
    # 优化磁盘 I/O
    if command -v fstrim >/dev/null; then
        fstrim / 2>/dev/null || true
    fi
}

stop_service() {
    echo "停止网络优化..."
}
EOF

chmod +x package/base-files/files/etc/init.d/network-optimize

# 启用网络优化服务
ln -sf ../init.d/network-optimize package/base-files/files/etc/rc.d/S99network-optimize

# 修改默认主题为 argon
sed -i '/set luci.main.mediaurlbase/d' package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base
cat >> package/feeds/luci/luci-base/root/etc/uci-defaults/30_luci-theme << 'EOF'
uci set luci.main.mediaurlbase='/luci-static/argon'
uci set luci.themes.argon=/luci-static/argon
uci commit luci
EOF

# 添加默认软件包
cat >> package/base-files/files/etc/opkg.conf << 'EOF'

# 自定义软件源
src/gz custom https://downloads.openwrt.org/releases/24.10-SNAPSHOT/packages/x86_64/custom
EOF

echo "自定义设置应用完成！"
