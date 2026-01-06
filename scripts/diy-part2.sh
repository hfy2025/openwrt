#!/bin/bash

# 此脚本在更新并安装feeds后执行
# 主要用于添加非官方源的插件或应用补丁

# 进入OpenWrt目录
cd openwrt || exit 1

# 示例：添加一个第三方插件仓库 (以OpenClash为例，如果feeds中没有)
# 注意：feeds.conf.default中已添加kenzo源，通常已包含。
# 如果需要特定版本，可以在此处checkout
if [ -d "package/kenzo/openclash" ]; then
  echo "OpenClash已通过feeds添加。"
  # 切换到特定提交 (可选)
  # cd package/kenzo/openclash && git checkout abc123 && cd ../../..
fi

# 示例：为Dockerman添加依赖 (如果feeds中的版本需要)
# if [ -d "package/kenzo/luci-app-dockerman" ]; then
#   # 确保Docker相关内核模块已选中
#   echo "CONFIG_PACKAGE_kmod-fs-btrfs=y" >> .config
#   echo "CONFIG_PACKAGE_kmod-dm=y" >> .config
#   echo "CONFIG_PACKAGE_kmod-br-netfilter=y" >> .config
# fi

# 应用任何额外的内核补丁 (如果有)
# for patch_file in ../patches/*.patch; do
#   if [ -f "$patch_file" ]; then
#     patch -p1 < "$patch_file"
#   fi
# done

# 重新生成.config以确保所有依赖被正确处理
make defconfig

echo "第二阶段自定义脚本执行完成。"
