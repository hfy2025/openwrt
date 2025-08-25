#!/bin/sh

# 设置主机名
uci set system.@system[0].hostname='NIT'  # 可修改
uci set system.@system[0].description='04543473'
uci commit system

# 设置后台管理 IP
uci set network.lan.ipaddr='192.168.6.1'  # 可修改
uci set network.lan.netmask='255.255.255.0'
uci commit network

# 设置默认主题为 argon
uci set luci.main.mediaurlbase='/luci-static/argon'  # 可修改
uci commit luci

# 自定义签名（附加到 banner）
echo "自定义签名: 由 Grok 构建于 $(date)" >> /etc/banner  # 可修改
exit 0
