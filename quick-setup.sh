#!/bin/bash
# DeerFlow Quick Setup Script

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to print colored text
print_color() {
  COLOR=$1
  TEXT=$2
  echo -e "\033[${COLOR}m${TEXT}\033[0m"
}

print_color "1;32" "🦌 DeerFlow Quick Setup Script"
print_color "1;36" "==============================="

# Check Python version
if command_exists python3; then
  PYTHON_CMD="python3"
elif command_exists python; then
  PYTHON_CMD="python"
else
  print_color "1;31" "❌ Python not found. Please install Python 3.12+ and try again."
  exit 1
fi

PYTHON_VERSION=$($PYTHON_CMD --version | cut -d " " -f 2)
PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 12 ]); then
  print_color "1;31" "❌ Python 3.12+ is required. You have $PYTHON_VERSION."
  print_color "1;33" "Please upgrade your Python version and try again."
  exit 1
fi

print_color "1;32" "✅ Python $PYTHON_VERSION detected"

# Check for uv
if ! command_exists uv; then
  print_color "1;33" "🔄 uv not found. Installing..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  
  # Add uv to PATH for this session
  export PATH="$HOME/.cargo/bin:$PATH"
  
  if ! command_exists uv; then
    print_color "1;31" "❌ Failed to install uv. Please install manually:"
    print_color "1;33" "curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
  fi
fi

print_color "1;32" "✅ uv detected"

# Check for Node.js
if ! command_exists node; then
  print_color "1;31" "❌ Node.js not found. Please install Node.js 22+ and try again."
  print_color "1;33" "Visit: https://nodejs.org/en/download/"
  exit 1
fi

NODE_VERSION=$(node --version | cut -c 2-)
NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1)

if [ "$NODE_MAJOR" -lt 22 ]; then
  print_color "1;31" "❌ Node.js 22+ is required. You have $NODE_VERSION."
  print_color "1;33" "Please upgrade your Node.js version and try again."
  exit 1
fi

print_color "1;32" "✅ Node.js $NODE_VERSION detected"

# Check for pnpm
if ! command_exists pnpm; then
  print_color "1;33" "🔄 pnpm not found. Installing..."
  npm install -g pnpm
  
  if ! command_exists pnpm; then
    print_color "1;31" "❌ Failed to install pnpm. Please install manually:"
    print_color "1;33" "npm install -g pnpm"
    exit 1
  fi
fi

print_color "1;32" "✅ pnpm detected"

# Check for marp-cli
if ! command_exists marp; then
  print_color "1;33" "🔄 marp-cli not found. Installing..."
  
  if command_exists brew; then
    brew install marp-cli
  else
    npm install -g @marp-team/marp-cli
  fi
  
  if ! command_exists marp; then
    print_color "1;33" "⚠️ Failed to install marp-cli automatically."
    print_color "1;33" "You can install it manually later if needed for PPT generation:"
    print_color "1;33" "npm install -g @marp-team/marp-cli"
  fi
else
  print_color "1;32" "✅ marp-cli detected"
fi

# Install Python dependencies
print_color "1;36" "\n📦 Installing Python dependencies..."
uv sync

if [ $? -ne 0 ]; then
  print_color "1;31" "❌ Failed to install Python dependencies."
  exit 1
fi

print_color "1;32" "✅ Python dependencies installed"

# Create configuration files
print_color "1;36" "\n🔧 Setting up configuration files..."

# .env file
if [ ! -f .env ]; then
  cp .env.example .env
  print_color "1;32" "✅ Created .env file from template"
  print_color "1;33" "⚠️ Remember to edit .env with your API keys"
else
  print_color "1;33" "⚠️ .env file already exists, skipping"
fi

# conf.yaml file
if [ ! -f conf.yaml ]; then
  cp conf.yaml.example conf.yaml
  print_color "1;32" "✅ Created conf.yaml file from template"
  print_color "1;33" "⚠️ Remember to edit conf.yaml with your LLM model settings"
else
  print_color "1;33" "⚠️ conf.yaml file already exists, skipping"
fi

# Ask if user wants to install web UI dependencies
print_color "1;36" "\n🌐 Do you want to install web UI dependencies? (y/n)"
read -r install_web

if [[ $install_web =~ ^[Yy]$ ]]; then
  print_color "1;36" "📦 Installing web UI dependencies..."
  cd web && pnpm install && cd ..
  
  if [ $? -ne 0 ]; then
    print_color "1;31" "❌ Failed to install web UI dependencies."
    print_color "1;33" "You can try again later with: cd web && pnpm install"
  else
    print_color "1;32" "✅ Web UI dependencies installed"
  fi
else
  print_color "1;33" "⚠️ Skipping web UI dependencies installation"
fi

print_color "1;32" "\n🎉 Setup completed!"
print_color "1;36" "==============================="
print_color "1;33" "Next steps:"
print_color "1;37" "1. Edit .env with your API keys"
print_color "1;37" "2. Edit conf.yaml with your LLM model settings"
print_color "1;37" "3. Run DeerFlow with: uv run main.py"
print_color "1;37" "4. Or run with web UI: ./bootstrap.sh -d"
print_color "1;36" "==============================="
print_color "1;32" "See SETUP.md for more detailed instructions"

