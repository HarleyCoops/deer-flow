# DeerFlow Setup Guide

This guide provides step-by-step instructions for setting up the DeerFlow environment on your local machine.

## Prerequisites

Before you begin, ensure you have the following tools installed:

### Required Tools

1. **Python 3.12+**
   - Download from [python.org](https://www.python.org/downloads/)
   - Verify installation: `python --version` or `python3 --version`

2. **Node.js 22+**
   - Download from [nodejs.org](https://nodejs.org/en/download/)
   - Alternatively, use nvm (recommended): [nvm installation guide](https://github.com/nvm-sh/nvm#installing-and-updating)
   - Verify installation: `node --version`

3. **uv (Python package manager)**
   - Install with: `curl -LsSf https://astral.sh/uv/install.sh | sh`
   - Windows: Follow instructions at [uv installation guide](https://docs.astral.sh/uv/getting-started/installation/)
   - Verify installation: `uv --version`

4. **pnpm (Node.js package manager)**
   - Install with: `npm install -g pnpm`
   - Verify installation: `pnpm --version`

5. **marp-cli (for PPT generation)**
   - macOS: `brew install marp-cli`
   - Other platforms: `npm install -g @marp-team/marp-cli`
   - Verify installation: `marp --version`

## Setup Steps

### 1. Clone the Repository

```bash
git clone https://github.com/HarleyCoops/deer-flow.git
cd deer-flow
```

### 2. Install Python Dependencies

```bash
# uv will automatically create a virtual environment and install all required packages
uv sync
```

### 3. Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit the .env file with your API keys
# At minimum, you need to set up a search API (Tavily recommended)
```

Open the `.env` file in your editor and update the following values:

- `TAVILY_API_KEY`: Get from [Tavily](https://app.tavily.com/home)
- Alternatively, set `SEARCH_API=duckduckgo` if you don't have a Tavily API key
- Optional: Configure TTS credentials if you want podcast generation features

### 4. Configure LLM Model

```bash
# Copy the example configuration file
cp conf.yaml.example conf.yaml
```

Open the `conf.yaml` file in your editor and update it with your preferred LLM model configuration:

```yaml
# Example for OpenAI
BASIC_MODEL:
  model: "gpt-4o"
  api_key: "your-openai-api-key"

# Example for Ollama (local)
BASIC_MODEL:
  model: "ollama/llama3"
  base_url: "http://localhost:11434"

# Example for other OpenAI-compatible APIs
BASIC_MODEL:
  base_url: "https://your-api-endpoint.com/v1"
  model: "model-name"
  api_key: "your-api-key"
```

Refer to [Configuration Guide](docs/configuration_guide.md) for more model options.

### 5. Install Web UI Dependencies (Optional)

If you want to use the web UI (recommended for a better experience):

```bash
cd web
pnpm install
cd ..
```

## Running DeerFlow

### Console UI

The simplest way to run DeerFlow:

```bash
uv run main.py
```

Or with a specific query:

```bash
uv run main.py "What is quantum computing?"
```

### Web UI (Recommended)

For a more interactive experience with the web UI:

#### Development Mode

```bash
# On macOS/Linux
./bootstrap.sh -d

# On Windows
bootstrap.bat -d
```

#### Production Mode

```bash
# On macOS/Linux
./bootstrap.sh

# On Windows
bootstrap.bat
```

The web UI will be available at [http://localhost:3000](http://localhost:3000).

## Docker Setup (Alternative)

If you prefer using Docker:

### Backend Only

```bash
# Build the Docker image
docker build -t deer-flow-api .

# Run the container
docker run -d -t -p 8000:8000 --env-file .env --name deer-flow-api-app deer-flow-api
```

### Full Stack (Backend + Frontend)

```bash
# Build and run with Docker Compose
docker compose build
docker compose up
```

## Troubleshooting

### Common Issues

1. **Python Version Error**
   - Ensure you have Python 3.12+ installed
   - Check with: `python --version` or `python3 --version`

2. **Node.js Version Error**
   - Ensure you have Node.js 22+ installed
   - If using nvm: `nvm install 22` and `nvm use 22`

3. **API Key Issues**
   - Verify your API keys are correctly set in the `.env` file
   - For model API keys, ensure they're correctly set in `conf.yaml`

4. **Web UI Not Loading**
   - Check if the backend server is running on port 8000
   - Verify Node.js dependencies are installed with `pnpm install`

5. **Search Not Working**
   - If using Tavily, verify your API key is correct
   - Try switching to DuckDuckGo by setting `SEARCH_API=duckduckgo` in `.env`

### Getting Help

If you encounter issues not covered here:

1. Check the [FAQ](docs/FAQ.md) for common questions
2. Review the [Configuration Guide](docs/configuration_guide.md) for detailed settings
3. Inspect the console output for error messages

## Next Steps

Once your environment is set up:

1. Try running a simple query: `uv run main.py "What is DeerFlow?"`
2. Explore the examples in the `examples/` directory
3. Check out the web UI for a more interactive experience
4. Read the [README.md](README.md) for more information about DeerFlow's capabilities

