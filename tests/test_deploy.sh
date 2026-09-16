#!/bin/bash
# test_deploy.sh - тест для scripts/deploy.sh

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Счётчики
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Путь к скрипту деплоя
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEPLOY_SCRIPT="$PROJECT_ROOT/scripts(govno)/deploy.sh"

# Функция для проверки: печатает PASS/FAIL и увеличивает счётчики
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ "$expected" = "$actual" ]; then
        echo -e "  ${GREEN}✓ PASS${NC}: $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "  ${RED}✗ FAIL${NC}: $message"
        echo -e "    Expected: $expected"
        echo -e "    Actual:   $actual"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Функция для проверки: файл существует
assert_file_exists() {
    local file="$1"
    local message="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓ PASS${NC}: $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "  ${RED}✗ FAIL${NC}: $message"
        echo -e "    File not found: $file"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Running tests for deploy.sh${NC}"
echo -e "${YELLOW}========================================${NC}"

# ТЕСТ 1: Скрипт существует и исполняемый
echo -e "\n${YELLOW}[Test 1]${NC} Deploy script exists"

assert_file_exists "$DEPLOY_SCRIPT" "deploy.sh exists"

# ТЕСТ 2: Синтаксис bash корректен
echo -e "\n${YELLOW}[Test 2]${NC} Bash syntax is valid"

TESTS_RUN=$((TESTS_RUN + 1))
if bash -n "$DEPLOY_SCRIPT" 2>/dev/null; then
    echo -e "  ${GREEN}✓ PASS${NC}: No syntax errors"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "  ${RED}✗ FAIL${NC}: Syntax errors found"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# ТЕСТ 3: Деплой в staging проходит успешно
echo -e "\n${YELLOW}[Test 3]${NC} Deploy to staging succeeds"

# Очищаем перед тестом
rm -rf /tmp/deploy/my-devops-app

"$DEPLOY_SCRIPT" staging > /dev/null 2>&1
EXIT_CODE=$?

assert_equals "0" "$EXIT_CODE" "Exit code is 0 for staging"

# Проверяем, что файлы скопировались
assert_file_exists "/tmp/deploy/my-devops-app/README.md" "README.md copied"
assert_file_exists "/tmp/deploy/my-devops-app/Makefile" "Makefile copied"

# ТЕСТ 4: Деплой в production проходит успешно
echo -e "\n${YELLOW}[Test 4]${NC} Deploy to production succeeds"

rm -rf /tmp/deploy/my-devops-app

"$DEPLOY_SCRIPT" production > /dev/null 2>&1
EXIT_CODE=$?

assert_equals "0" "$EXIT_CODE" "Exit code is 0 for production"

# ТЕСТ 5: Неправильное окружение — ошибка
echo -e "\n${YELLOW}[Test 5]${NC} Invalid environment fails"

"$DEPLOY_SCRIPT" invalid > /dev/null 2>&1
EXIT_CODE=$?

assert_equals "1" "$EXIT_CODE" "Exit code is 1 for invalid environment"

# ТЕСТ 6: Без аргументов — используется staging
echo -e "\n${YELLOW}[Test 6]${NC} No argument defaults to staging"

rm -rf /tmp/deploy/my-devops-app

"$DEPLOY_SCRIPT" > /dev/null 2>&1
EXIT_CODE=$?

assert_equals "0" "$EXIT_CODE" "Exit code is 0 when no argument"

# ИТОГИ
echo -e "\n${YELLOW}========================================${NC}"
echo -e "${YELLOW}Test results${NC}"
echo -e "${YELLOW}========================================${NC}"
echo -e "Total:  $TESTS_RUN"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo -e "${YELLOW}========================================${NC}"

# Возвращаем код: 0 если все тесты прошли, 1 если есть провалы
if [ "$TESTS_FAILED" -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi