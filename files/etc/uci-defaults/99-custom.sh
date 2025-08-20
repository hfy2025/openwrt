#!/bin/sh

# Set hostname
uci set system.@system[0].hostname='MyRouter'  # Modify here
uci set system.@system[0].description='Custom OpenWrt Firmware'
uci commit system

# Set management IP
uci set network.lan.ipaddr='192.168.6.1'  # Modify here
uci set network.lan.netmask='255.255.255.0'
uci commit network

# Set default theme to argon
uci set luci.main.mediaurlbase='/luci-static/argon'  # Modify if needed
uci commit luci

# Custom signature/motd (optional, append to banner)
echo "Custom Signature: Built by Grok on $(date)" >> /etc/banner  # Modify signature here

# Other customizations (e.g., enable services)
exit 0
