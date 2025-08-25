# 自定义初始化脚本（设置主题、IP等）

#!/bin/sh

# 设置默认主题
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# 其他自定义：如关闭WAN防火墙后提醒
exit 0
