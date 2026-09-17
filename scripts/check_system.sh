#!/bin/bash
# Скрипт проверяет состояние системы
# Показывает CPU, RAM, диск, uptime, инет

set -e 

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# UPTIME

echo -e "${YELLOW}[1/5]${NC} Uptime"
if command -v -uptime &> /dev/null; then
    uptime
    echo -e "${GREEN}${NC} Uptime retrieved"
else
    echo -e "${RED}${NC} Command 'uptime' not found"
fi
echo ""

# CPU

echo -e "${YELLOW}[2/5]${NC} CPU Load"
if [ -f /proc/loadavg ]; then
    cat /proc/loadavg
    echo -e "${GREEN}${NC} CPU CPU load retrived"
else
    echo -e "${YELLOW}${NC} /proc/loadavg not available"
fi
echo ""

# RAM

echo -e "${YELLOW}[3/5]${NC} Memory Usage"
if command -v free &> /dev/null; then
    free -h
    echo -e "${GREEN}${NC} Memory info retrieved"
else
    echo -e "${YELLOW}${NC} Command 'free' not avaible"
fi
echo ""

# DISK

echo -e "${YELLOW}[4/5]${NC} Disk Usage"
df -h / 2>/dev/null || df -h
echo -e "${GREEN}${NC} Disk info retrieved"
echo ""

# INET

echo -e "${YELLOW}[5/5]${NC} Internet Connection"
if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    echo -e "${GREEN}${NC} Internet is available"
else
    echo -e "${RED}${NC} No internet connection"
fi
echo ""

# Итог

echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}Health check completed${NC}"
echo -e "${YELLOW}========================================${NC}"