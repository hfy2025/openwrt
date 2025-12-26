#!/bin/bash

echo "开始应用自定义设置..."

# 设置后台管理 IP
sed -i "s/192\.168\.1\.1/192.168.6.1/g" package/base-files/files/bin/config_generate

# 设置主机名
sed -i "s/OpenWrt/OpenWrt-x86-64/g" package/base-files/files/bin/config_generate

# 设置时区
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate

# 修改 root 密码为空
sed -i '/root/c\\$1\$V4UetPzk\$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::' package/base-files/files/etc/shadow

# 网络优化配置
cat >> package/base-files/files/etc/sysctl.conf << 'EOF'

# 千兆/万兆网络优化
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_rmem=4096 87380 134217728
net.ipv4.tcp_wmem=4096 65536 134217728
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

# 设置默认主题
sed -i '/uci set luci.main.mediaurlbase/d' package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base
cat >> package/feeds/luci/luci-base/root/etc/uci-defaults/luci-base << 'EOF'
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
EOF

echo "自定义设置应用完成！"
