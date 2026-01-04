#!/bin/bash
# 清理脚本，可以在工作流中添加

echo "清理工作空间..."

# 删除临时文件
rm -rf /tmp/firmware_output 2>/dev/null || true
rm -rf /tmp/openwrt-firmware 2>/dev/null || true

# 清理 openwrt 目录
if [ -d "openwrt" ]; then
  echo "清理 openwrt 目录..."
  cd openwrt
  make clean 2>/dev/null || true
  rm -rf dl/* 2>/dev/null || true
  rm -rf build_dir/* 2>/dev/null || true
  rm -rf staging_dir/* 2>/dev/null || true
fi

echo "清理完成"
