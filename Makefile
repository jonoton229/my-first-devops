# Make file - удобные команды для проекта

# .Phony говорит make, что это не файлы, а команды
.Phony: help deploy deploy-prod test test-deploy test-check shellcheck clean

# Команда по умолчанию
help:
	@echo "Available commands"
	@echo " make help   - show this help "
	@echo " make deploy - run deploy script "
	@echo " make deploy_prod - deploy to production "
	@echo " make test - run tests "
	@echo " make test-deploy - run deploy test only"
	@echo " make test-check - run check_system tests only"
	@echo " make shellcheck - check "
	@echo " make clean - remove temporary files "

deploy:
	@echo "Running deploy.."
	@cd scripts && ./deploy.sh

test:
	@echo "Running tests.."
	@cd tests && ./test_deploy.sh

clean:
	@echo "Cleaning temporary files.."
	@rm -f *.log
	@rm -rf tmp/
	@echo "Succsec"
