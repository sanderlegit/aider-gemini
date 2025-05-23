# Aider with Google Vertex AI, managed by uv

This project provides a setup to use [Aider](https://aider.chat/), an AI pair programming tool, with Google Cloud's Vertex AI models. It uses [uv](https://github.com/astral-sh/uv) for Python environment and package management.

## Prerequisites

Before you begin, ensure you have the following installed:

1.  **uv:** A fast Python package installer and resolver.
    *   Installation instructions: [https://github.com/astral-sh/uv#installation](https://github.com/astral-sh/uv#installation)
2.  **Google Cloud SDK (gcloud CLI):** For authentication and interaction with Google Cloud.
    *   Installation instructions: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)

## Setup Instructions

Follow these steps to configure your environment:

### 1. Authenticate with Google Cloud

You need to authenticate to Google Cloud to allow Aider to use Vertex AI services. This is done by creating Application Default Credentials (ADC).

Run the following command and follow the prompts to log in with your Google account:
```bash
gcloud auth application-default login
```
This command stores your credentials in a well-known location that Aider and Google client libraries can automatically find. Ensure the account you use has permissions to access Vertex AI services. For more details on this command, see the [official gcloud documentation](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login).

### 2. Configure Vertex AI for Aider

Aider requires specific environment variables to connect to your Vertex AI project and location.

*   `VERTEXAI_PROJECT`: Your Google Cloud Project ID.
*   `VERTEXAI_LOCATION`: The Google Cloud region where your Vertex AI models are available (e.g., `us-central1`).

You can set these environment variables in a few ways. One common method is to create a `.env` file in the root of this project directory. Aider will automatically load variables from this file.

Create a file named `.env` in the project root with the following content:
```env
VERTEXAI_PROJECT="gen-lang-client-0342800361"
VERTEXAI_LOCATION="us-central1"
```
Replace the values if you are using a different project or location.

Alternatively, you can export these variables in your shell session before running Aider:
```bash
export VERTEXAI_PROJECT="gen-lang-client-0342800361"
export VERTEXAI_LOCATION="us-central1"
```

### 3. Install Dependencies

This project uses a `Makefile` to simplify the setup and common tasks. The `make install` command will:
1.  Create a Python virtual environment in `./.venv` using `uv`.
2.  Install all required dependencies (including Aider and Google Cloud libraries like the Vertex AI SDK) specified in `pyproject.toml` into the virtual environment. For more information on the SDK itself, see the [Vertex AI SDK documentation](https://cloud.google.com/vertex-ai/docs/start/install-sdk).

Run the following command:
```bash
make install
```
You can also use `make sync`, which is an alias for `make install`.

## Usage

### Running Aider with Vertex AI

Once the setup is complete, you can run Aider. You'll need to specify a Vertex AI model. Refer to the [Aider documentation for Vertex AI](https://aider.chat/docs/llms/vertex.html) for available model names (e.g., `vertex_ai/gemini-1.5-pro-preview-0514`, `vertex_ai/claude-3-5-sonnet@20240620`).

You can use the `make run-aider` target, passing the model and other Aider arguments via `AIDER_ARGS`:
```bash
make run-aider AIDER_ARGS="--model vertex_ai/gemini-1.5-pro-preview-0514 your_file.py"
```
Or, to start an Aider session with a specific model:
```bash
make run-aider AIDER_ARGS="--model vertex_ai/gemini-1.5-pro-preview-0514"
```

Alternatively, you can activate the virtual environment and run `aider` directly, or use `uv run`:
```bash
# Activate venv (optional, if you prefer)
# source .venv/bin/activate 
# aider --model vertex_ai/gemini-1.5-pro-preview-0514

# Or using uv run directly
uv run -p .venv/bin/python aider --model vertex_ai/gemini-1.5-pro-preview-0514
```

### Shell Alias for Convenience

For easier access, you can create a shell alias. The `Makefile` defines `VENV_DIR := .venv`, so the Python interpreter path within the virtual environment is `.venv/bin/python`.

Here's an example of how you might define an alias in your shell configuration file (e.g., `.bashrc`, `.zshrc`):

```bash
# Get the absolute path to your project directory
# PROJECT_DIR=$(pwd) # if you are in the project root
# Or set it manually:
# PROJECT_DIR="/path/to/your/google-ai-project"

# Example alias (adjust PROJECT_DIR and default model as needed):
# alias ai='uv run --no-project -p '"$PROJECT_DIR"'/.venv/bin/python aider --no-attribute-author --no-attribute-committer --dark-mode --model vertex_ai/gemini-1.5-pro-preview-0514'
```
The original alias example was:
```
# Example from original README:
# ❯ which ai
# ai: aliased to uv run --no-project -p /Users/sander/.config/google-ai/.venv/bin/python aider --no-attribute-author --no-attribute-committer --dark-mode --model gemini-2.5-pro-preview-05-06
```
To adapt this, replace `/Users/sander/.config/google-ai/` with the actual path to this project directory on your system. The model name `gemini-2.5-pro-preview-05-06` should be prefixed with `vertex_ai/` if using Aider's Vertex AI integration, e.g., `vertex_ai/gemini-2.5-pro-preview-05-06` (ensure this specific model identifier is supported by Aider/Vertex).

## Makefile Targets

Some useful `make` targets include:

*   `make help`: Shows all available targets and their descriptions.
*   `make install` or `make sync`: Sets up the virtual environment and installs dependencies.
*   `make run-aider`: Runs Aider within the `uv` managed environment. You can pass arguments using `AIDER_ARGS`.
*   `make install-playwright`: Installs Playwright and its browser dependencies if needed for specific Aider features.
*   `make clean`: Removes the virtual environment, `uv.lock`, and Python cache files.

Refer to the `Makefile` for more details or run `make help`.
