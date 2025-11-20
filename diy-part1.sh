#!/bin/bash
#
# diy-part1.sh
# Description: Update feeds and add custom sources
#

# 1. Add Custom Feeds (User Defined)
src-git packages https://github.com/coolsnowwolf/packages
src-git luci https://github.com/coolsnowwolf/luci
src-git routing https://github.com/coolsnowwolf/routing
src-git telephony https://github.com/openwrt/telephony

# 2. Add AdGuardHome Source (Requirement 10)
echo 'src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome' >>feeds.conf.default

# 3. Update feeds
# ./scripts/feeds update -a
# ./scripts/feeds install -a
