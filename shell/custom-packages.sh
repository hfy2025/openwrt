#!/bin/bash

CUSTOM_PACKAGES="luci-app-openclash luci-app-adguardhome luci-app-quickstart luci-app-dockerman luci-app-nikki luci-app-store luci-app-upnp luci-app-lucky luci-theme-argon"
# 添加更多依赖如果需要：CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-ipt-tproxy" 等
# 移除不需要的：CUSTOM_PACKAGES="$CUSTOM_PACKAGES -luci-app-example"
export CUSTOM_PACKAGES
