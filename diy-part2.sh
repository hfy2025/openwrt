#!/bin/bash
#
# diy-part2.sh
# Description: System modifications (IP, Theme, Kernel, etc.)
#

# 1. Modify Default IP (Requirement 2)
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 2. Modify Hostname (Requirement 4)
sed -i 's/OpenWrt/openwrt-NIT/g' package/base-files/files/bin/config_generate

# 3. Clear Password (Set to empty) (Requirement 3)
sed -i 's/^root:[^:]*:/root::/' package/base-files/files/etc/shadow

# 4. Set Kernel Version (Requirement 9)
sed -i 's/^KERNEL_PATCHVER:=.*/KERNEL_PATCHVER:=6.12/' target/linux/x86/Makefile

# 5. Set Default Theme to Argon (Requirement 6)
# Remove default theme setting if exists and set argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 6. Add Custom Signature (Requirement 8)

# Add Custom Signature (Requirement 8)
sed -i "s/%D %V, %C/%D %V, %C - [$(TZ=UTC-8 date "+%Y.%m.%d")]/g" package/base-files/files/etc/banner
sed -i "s/%D %V, %C/%D %V, %C - [$(TZ=UTC-8 date "+%Y.%m.%d")]/g" package/base-files/files/etc/openwrt_release


# 7. OpenClash Setup (Master Branch) (Requirement 7)
# Replace OpenClash with Master Branch (Requirement 7)
rm -rf feeds/luci/applications/luci-app-openclash
git clone -b master --depth 1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash

# 8. User Custom Scripts
git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart
