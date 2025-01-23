MAKEFLAGS += --no-print-directory

create-project:
	@echo "Criando projeto..."
	@docker run --rm -v $(pwd)/src:/app -w /app composer create-project --prefer-dist laravel/laravel .
	@echo "Projeto criado com sucesso!"
dev: ## Pipeline de desenvolvimento
	@echo "Iniciando pipeline de desenvolvimento..."
	@docker compose up -d

help: ## Lista comandos disponíveis
	@echo "Uso: make [comando] [PROJECT=nome-do-projeto]"
	@echo ""
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: check-infra infra-start infra-stop start stop clean test dev status help
.DEFAULT_GOAL := help