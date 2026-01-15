#!/bin/bash

# 监控磁盘空间并在需要时清理

monitor_disk() {
    THRESHOLD=85  # 磁盘使用率阈值（%）
    
    while true; do
        USAGE=$(df -h /home/runner | tail -1 | awk '{print $5}' | sed 's/%//')
        
        if [ "$USAGE" -gt "$THRESHOLD" ]; then
            echo "⚠️ 磁盘使用率 ${USAGE}% 超过阈值 ${THRESHOLD}%"
            echo "执行清理..."
            
            # 清理缓存
            sudo apt-get clean
            sudo rm -rf /var/lib/apt/lists/*
            
            # 清理编译临时文件
            find /tmp -type f -atime +1 -delete 2>/dev/null || true
            
            # 清理日志文件
            find /var/log -type f -name "*.log" -size +10M -delete 2>/dev/null || true
            
            echo "清理后使用率:"
            df -h /home/runner | tail -1
        fi
        
        sleep 60  # 每分钟检查一次
    done
}

# 如果作为脚本运行，则执行监控
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    monitor_disk
fi
