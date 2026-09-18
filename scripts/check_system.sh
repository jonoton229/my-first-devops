#!/bin/bash
# check_system.sh — проверка состояния системы
# Работает на Linux, macOS и Windows (Git Bash)

# Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}System Health Check${NC}"
echo -e "${YELLOW}========================================${NC}"
echo -e "Date: $(date)"
echo -e "Hostname: $(hostname 2>/dev/null || echo 'unknown')"
echo -e "OS: $(uname -s 2>/dev/null || echo 'unknown')"
echo ""

# UPTIME
echo -e "${YELLOW}[1/5]${NC} Uptime"

if command -v uptime &> /dev/null; then
    # Linux/macOS
    uptime
    echo -e "${GREEN}✓${NC} Uptime retrieved"
elif [ -f /proc/uptime ]; then
    # Fallback через /proc
    UPTIME_SECONDS=$(cut -d. -f1 /proc/uptime)
    UPTIME_HOURS=$((UPTIME_SECONDS / 3600))
    UPTIME_MINUTES=$(((UPTIME_SECONDS % 3600) / 60))
    echo "Up ${UPTIME_HOURS}h ${UPTIME_MINUTES}m"
    echo -e "${GREEN}✓${NC} Uptime retrieved from /proc"
else
    # Windows Git Bash — через systeminfo (медленно) или пропускаем
    echo -e "${YELLOW}⚠${NC} Uptime not available on this system"
fi
echo ""


# CPU
echo -e "${YELLOW}[2/5]${NC} CPU Load"

if [ -f /proc/loadavg ]; then
    cat /proc/loadavg
    echo -e "${GREEN}✓${NC} CPU load retrieved"
elif command -v wmic &> /dev/null; then
    # Windows fallback
    wmic cpu get loadpercentage 2>/dev/null | grep -E '^[0-9]' || echo "N/A"
    echo -e "${GREEN}✓${NC} CPU load retrieved"
else
    echo -e "${YELLOW}⚠${NC} CPU load not available"
fi
echo ""


# RAM
echo -e "${YELLOW}[3/5]${NC} Memory Usage"

if command -v free &> /dev/null; then
    # Linux
    free -h
    echo -e "${GREEN}✓${NC} Memory info retrieved"
elif [ -f /proc/meminfo ]; then
    # Fallback через /proc (работает в Git Bash)
    TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    AVAIL=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    TOTAL_MB=$((TOTAL / 1024))
    AVAIL_MB=$((AVAIL / 1024))
    USED_MB=$((TOTAL_MB - AVAIL_MB))
    echo "Total: ${TOTAL_MB} MB"
    echo "Used:  ${USED_MB} MB"
    echo "Free:  ${AVAIL_MB} MB"
    echo -e "${GREEN}✓${NC} Memory info retrieved from /proc"
else
    echo -e "${YELLOW}⚠${NC} Memory info not available"
fi
echo ""


# DISK
echo -e "${YELLOW}[4/5]${NC} Disk Usage"

if df -h / &> /dev/null; then
    df -h /
    echo -e "${GREEN}✓${NC} Disk info retrieved"
else
    echo -e "${YELLOW}⚠${NC} Disk info not available"
fi
echo ""


# INTERNET
echo -e "${YELLOW}[5/5]${NC} Internet Connection"

# Пробуем несколько способов
if command -v curl &> /dev/null; then
    if curl -s --max-time 3 https://github.com > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Internet is available (via curl)"
    else
        echo -e "${YELLOW}⚠${NC} No internet connection (or blocked)"
    fi
elif command -v ping &> /dev/null; then
    if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
        echo -e "${GREEN}✓${NC} Internet is available (via ping)"
    else
        echo -e "${YELLOW}⚠${NC} No internet connection (or blocked)"
    fi
else
    echo -e "${YELLOW}⚠${NC} No tool available to check internet (curl/ping)"
fi
echo ""

# ИТОГ
echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}Health check completed${NC}"
echo -e "${YELLOW}========================================${NC}"

# Всегда возвращаем 0 — скрипт информационный
exit 0