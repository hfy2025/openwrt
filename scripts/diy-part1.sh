#!/bin/bash

# 设置默认管理IP地址为192.168.6.1
sed -i 's/192\.168\.1\.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 设置主机名
sed -i "s/OpenWrt/MyOpenWrt-Router/g" package/base-files/files/bin/config_generate

# 设置默认主题为argon
sed -i "/set luci.main.mediaurlbase/s#/luci-static/.*#/luci-static/argon#'" package/lean/default-settings/files/zzz-default-settings 2>/dev/null || true

# 网络优化内核参数
echo "net.core.default_qdisc=fq_codel" >> package/base-files/files/etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> package/base-files/files/etc/sysctl.conf
echo "net.netfilter.nf_conntrack_max=65536" >> package/base-files/files/etc/sysctl.conf

# 为OTA功能准备：确保sysupgrade相关配置
# 检查并确保sysupgrade包含必要组件
if [ -f target/linux/x86/image/Makefile ]; then
  sed -i 's/$(eval $(call BuildImage/generic,/$(eval $(call BuildImage/generic-sysupgrade,/g' target/linux/x86/image/Makefile 2>/dev/null || true
fi

echo "第一阶段自定义脚本执行完成。"
