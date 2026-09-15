# Make file - удобные команды для проекта

# .Phony говорит make, что это не файлы, а команды
.Phony: help deploy test clean

# Команда по умолчанию
help:
	@echo "Доступные команды"
	@echo " make help   - показать справку "
	@echo " make deploy - запустить скрипт деплоя "
	@echo " make test - запустить тесты "
	@echo " make clean - удалить временные файлы "

deploy:
	@echo "Запуск деплоя.."
	@cd scripts && ./deploy.sh

test:
	@echo "Запуск тестов.."
	@cd tests && ./test_deploy.sh

clean:
	@echo "Очищаю временные файлы.."
	@rm -f *.log
	@rm -rf tmp/
	@echo "Готово"
