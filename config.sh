# 自定义配置（如主机名、LAN IP、主题、分区大小等）

#!/bin/bash
# 自定义配置
HOSTNAME="Openwrt-NIT"
LAN_IP="192.168.6.1"
THEME="luci-theme-argon"
SIGNATURE_PREFIX="04543473"
KERNEL_PARTSIZE=32
ROOTFS_PARTSIZE=1024

# 生成个性签名（附加当前日期）
DATE=$(date +%Y%m%d)
SIGNATURE="${SIGNATURE_PREFIX}${DATE}"
