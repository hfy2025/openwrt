# 网络设置
# 设置 LAN 口 IP 为 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# --- 千兆网络优化 (1000M 带宽跑满) ---

# 1. 启用流量分载 (软件/硬件)
# 对于 1000Mbps+ 速度至关重要，可降低 CPU 负载
sed -i 's/option flow_offloading .*/option flow_offloading 1/' package/network/config/firewall/files/firewall.config
sed -i '/option flow_offloading/a \
\toption flow_offloading_hw 1' package/network/config/firewall/files/firewall.config

# 2. 深度系统内核优化 (sysctl.conf)
mkdir -p package/base-files/files/etc/sysctl.d
cat <<EOF >> package/base-files/files/etc/sysctl.d/99-custom.conf
# --- BBR 拥塞控制 ---
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr

# --- 网络缓冲区优化 (针对千兆/万兆) ---
# 增加接收和发送缓冲区大小
net.core.rmem_default=262144
net.core.wmem_default=262144
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216

# --- 连接跟踪与队列优化 ---
net.core.netdev_max_backlog=16384
net.core.somaxconn=8192
net.ipv4.tcp_max_syn_backlog=8192
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_keepalive_time=1200
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_timestamps=1

# --- IPv6 专用优化 ---
net.ipv6.conf.all.disable_ipv6=0
net.ipv6.conf.default.disable_ipv6=0
net.ipv6.conf.all.forwarding=1
net.ipv6.conf.default.forwarding=1
# 允许更多的 IPv6 路由表条目
net.ipv6.route.max_size=4096
# 邻居发现表大小 (防止局域网设备多时 ARP 满)
net.ipv4.neigh.default.gc_thresh1=512
net.ipv4.neigh.default.gc_thresh2=2048
net.ipv4.neigh.default.gc_thresh3=4096
net.ipv6.neigh.default.gc_thresh1=512
net.ipv6.neigh.default.gc_thresh2=2048
net.ipv6.neigh.default.gc_thresh3=4096
EOF

# 3. 在 rc.local 中启用数据包控制 (RPS)
# 将网络中断分配到所有 CPU 核心
sed -i "/exit 0/i \
# 优化：启用数据包控制 (RPS)\n\
for file in /sys/class/net/*/queues/rx-*/rps_cpus; do echo f > \$file; done\n\
" package/base-files/files/etc/rc.local
