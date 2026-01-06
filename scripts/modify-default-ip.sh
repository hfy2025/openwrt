#!/bin/bash
# Script to modify iStoreOS default IP to 192.168.6.1
# Usage: ./scripts/modify-default-ip.sh

set -e

echo "🔧 Modifying iStoreOS default IP to 192.168.6.1"

# 检查是否在iStoreOS源码目录
if [ ! -f "package/base-files/files/bin/config_generate" ]; then
    echo "❌ Not in iStoreOS source directory!"
    exit 1
fi

# 备份原始文件
cp package/base-files/files/bin/config_generate package/base-files/files/bin/config_generate.bak

# 修改默认IP地址
sed -i "s/ipaddr='192\.168\.[0-9]*\.[0-9]*'/ipaddr='192.168.6.1'/" package/base-files/files/bin/config_generate

# 修改默认网关（如果需要）
sed -i "s/gateway='192\.168\.[0-9]*\.[0-9]*'/gateway='192.168.6.254'/" package/base-files/files/bin/config_generate

# 验证修改
echo "✅ Modified default IP configuration:"
grep -n "ipaddr=" package/base-files/files/bin/config_generate
grep -n "gateway=" package/base-files/files/bin/config_generate

echo "📝 Changes saved. Original file backed up as config_generate.bak"
