#!/bin/bash
#deploy.sh - простой скрипт делоя который я спиздил

set -e # Остановить выполнение при любой ошибке

# Цвета для вывода 
# ахуй ещё и цветное
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # без цвета

# переменные
ENVIRONMENT="${1:-staging}"
APP_NAME="my-devops-app"
DEPLOY_DIR="/tmp/deploy/${APP_NAME}"

# Определяем корень проекта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${YELLOW}=================${NC}"
echo -e "${YELLOW}Deploying ${APP_NAME} to ${ENVIRONMENT}${NC}"
echo -e "${YELLOW}=================${NC}"

# 1. Проверка окружения 
echo -e "\n${YELLOW}[1/5]${NC} Checking environment..."
if [ "$ENVIRONMENT" != "staging" ] && [ "$ENVIRONMENT" != "production" ]; then
    echo -e "${RED}Error: environment must be 'staging' or 'production'${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Environment is valid: ${ENVIRONMENT}"

# 2. Создание папки для деплоя
echo -e "\n${YELLOW}[2/5]${NC} Preparing deploy directory..."
mkdir -p "$DEPLOY_DIR"
echo -e "${GREEN}✓${NC} Directory created: ${DEPLOY_DIR}"

# 3. Копирование файлов
echo -e "\n${YELLOW}[3/5]${NC} Copying application files..."
cp "$PROJECT_ROOT/README.md" "$DEPLOY_DIR/"
cp "$PROJECT_ROOT/Makefile" "$DEPLOY_DIR/"
echo -e "${GREEN}✓${NC} Files copied"

# 4. Симуляция перезапуска сервиса 
echo -e "\n${YELLOW}[4/5]${NC} Restarting application service..."
sleep 1
echo -e "${GREEN}✓${NC} Service restarted"

# 5. Проверка 
echo -e "\n${YELLOW}[5/5]${NC} Verifying deployment..."
if [ -f "$DEPLOY_DIR/README.md" ]; then
    echo -e "${GREEN}✓${NC} Verification passed"
else
    echo -e "${RED}✗ Verification failed gg${NC}"
    exit 1
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "App: ${APP_NAME}"
echo -e "Environment: ${ENVIRONMENT}"
echo -e "Location: ${DEPLOY_DIR}"