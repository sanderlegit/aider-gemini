# Makefile for google-ai project using uv

# --- Configuration ---
# Use a relative path for the virtual environment directory
VENV_DIR := .venv
# Define the Python executable path within the venv
PYTHON := $(VENV_DIR)/bin/python

PROJECT_NAME := google-ai # From pyproject.toml

# Default arguments for aider (can be overridden)
DEFAULT_AIDER_ARGS := --no-attribute-author --no-attribute-committer --dark-mode
AIDER_ARGS ?= $(DEFAULT_AIDER_ARGS) # Allows overriding like: make run-aider AIDER_ARGS="--version"

# --- Targets ---

.PHONY: help install clean run-aider sync install-playwright

help: ## ✨ Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Target to ensure the Python interpreter exists (by creating the venv)
# This is the primary prerequisite for tasks needing the venv.
$(PYTHON): pyproject.toml
	# Creating virtual environment in $(VENV_DIR)
	# Create the venv using the specified Python version. Creates $(PYTHON) file.
	uv venv $(VENV_DIR) --python 3.12

install: $(PYTHON)
	# 📦 Install dependencies from pyproject.toml into the venv
	# Syncing project $(PROJECT_NAME) dependencies into $(VENV_DIR) using $(PYTHON)
	# Use sync to install exactly what's in pyproject.toml into the specified venv
	uv pip sync -p $(PYTHON) pyproject.toml

sync: install ## 🔄 Alias for install, ensures venv exists and syncs dependencies

clean:
	# 🧹 Remove virtual environment, lock file, and build artifacts
	rm -rf $(VENV_DIR)
	rm -f uv.lock
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -exec rm -rf {} +

install-playwright: install ## 🎭 Install Playwright and its dependencies
	# Installing Playwright and its dependencies
	uv pip install -p $(PYTHON) -e .[playwright]
	uv run -p $(PYTHON) playwright install --with-deps chromium

run-aider: install
	# ▶️ Run aider with specified arguments using uv run
	# args: $(AIDER_ARGS) using venv $(VENV_DIR) ---"
	# Use uv run with the specific python interpreter from the venv
	uv run -p $(PYTHON) aider $(AIDER_ARGS)
