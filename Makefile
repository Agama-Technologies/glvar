MAKEFILE_ABS_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := help

##@ Help
.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Environment
.PHONY: env
env:
	@echo "Setting up development environment with uv..."
	@test -d .venv || uv venv
	@uv pip install -e '.[test]'
	@echo "✓ Development environment ready"
	@echo "  Activate with: source .venv/bin/activate"

.PHONY: clean
clean: ## Clean up build artifacts
	@echo "Cleaning up..."
	@rm -rf dist
	@rm -rf glvar.egg-info
	@rm -rf .venv/
	@rm -rf .ruff_cache/
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.pyc" -delete
	@find . -name "*.pyo" -delete
	@find . -name "*~" -delete
	@echo "Cleaned up"


##@ Compiling
.PHONY: build
build: ## Build
	@echo "Building..."
	@uv build


##@ Linting / Formatting

.PHONY: format
format: ## Format code with ruff
	@echo "Formatting code..."
	@uv run ruff format glvar/

.PHONY: lint
lint: ## Check code style with ruff
	@echo "Checking code style..."
	@uv run ruff check glvar/

.PHONY: lint-fix
lint-fix: ## Fix code style issues automatically
	@echo "Fixing code style..."
	@uv run ruff check --fix glvar/
