#!/bin/bash

# Тест для check_system.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK_SCRIPT="$PROJECT_ROOT/scripts/check_system.sh"

echo -e "${YELLOW}==================================${NC}"
echo -e "${YELLOW} Testing check_system.sh${NC}"
echo -e "${YELLOW}==================================${NC}"

# Тест 1. Скрипт вообще есть?

echo -e "\n${YELLOW}[Test 1]${NC} Script exists"
TESTS_RUN=$((TESTS_RUN + 1))
if [ -f "$CHECK_SCRIPT" ]; then
    echo -e " ${GREEN} PASS${NC}: check_system.sh exists"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e " ${RED} FAIL${NC}: check_system.sh not found"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Тест 2. Синтаксис корректен
echo -e "\n${YELLOW}[Test 2]${NC} Bash syntax is valid"
TESTS_RUN=$((TESTS_RUN + 1))
if bash -n "$CHECK_SCRIPT" 2>/dev/null; then
    echo -e " ${GREEN} PASS${NC}: No syntax errors"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e " ${RED} FAIL${NC}: Syntax errors found"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Тест 3. Проверка запуска скрипта
echo -e "\n${YELLOW} [Test 3]${NC} Script runs successfully"
TESTS_RUN=$((TESTS_RUN + 1 ))
if "$CHECK_SCRIPT" > /dev/null 2>&1; then
    echo -e " ${GREEN} PASS${NC}: Exit code is 0"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else 
    echo -e " ${RED} FAIL${NC}: Non-zero exit code"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Итоги тестов
echo -e "\n${YELLOW}========================================${NC}"
echo -e "Total:  $TESTS_RUN"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo -e "${YELLOW}========================================${NC}"

if [ "$TESTS_FAILED" -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
