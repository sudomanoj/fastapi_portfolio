.PHONY: help install install-dev format lint test security clean pre-commit run

# Default target
help:
	@echo "Available commands:"
	@echo "  install     - Install production dependencies"
	@echo "  install-dev - Install development dependencies"
	@echo "  format      - Format code with black and isort"
	@echo "  lint        - Run linting checks"
	@echo "  test        - Run tests"
	@echo "  security    - Run security checks"
	@echo "  pre-commit  - Run all checks (format, lint, security)"
	@echo "  run         - Run the FastAPI application"
	@echo "  clean       - Clean up temporary files"

# Install production dependencies
install:
	pip install -r requirements.txt

# Install development dependencies
install-dev:
	pip install -r requirements.txt
	pip install black isort flake8 mypy pylint bandit pre-commit pytest

# Install pre-commit hooks
install-hooks:
	pre-commit install

# Format code
format:
	black portfolio_app/
	isort portfolio_app/

# Lint code
lint:
	flake8 portfolio_app/
	mypy portfolio_app/
	pylint portfolio_app/ --disable=all --enable=C0103,C0114,C0115,C0116,R0903,W0613

# Run tests
test:
	pytest

# Security checks
security:
	bandit -r portfolio_app/ -c pyproject.toml

# Run all checks
pre-commit: format lint security

# Run the application
run:
	uvicorn portfolio_app.main:app --reload --host 0.0.0.0 --port 8000

# Run with docker
docker-run:
	docker-compose up --build

# Clean up
clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	rm -rf .mypy_cache
	rm -rf .pytest_cache
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info

# Database commands (add if you have a database)
migrate:
	alembic upgrade head

# Show current status
status:
	@echo "=== Python version ==="
	python --version
	@echo "\n=== Installed packages ==="
	pip list
	@echo "\n=== Git status ==="
	git status