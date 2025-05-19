@echo off
setlocal enabledelayedexpansion

echo [92m🦌 DeerFlow Quick Setup Script[0m
echo [96m===============================[0m

:: Check Python version
where python >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [91m❌ Python not found. Please install Python 3.12+ and try again.[0m
    exit /b 1
)

for /f "tokens=2" %%I in ('python --version 2^>^&1') do set PYTHON_VERSION=%%I
for /f "tokens=1,2 delims=." %%a in ("!PYTHON_VERSION!") do (
    set PYTHON_MAJOR=%%a
    set PYTHON_MINOR=%%b
)

if !PYTHON_MAJOR! LSS 3 (
    echo [91m❌ Python 3.12+ is required. You have !PYTHON_VERSION!.[0m
    echo [93mPlease upgrade your Python version and try again.[0m
    exit /b 1
)

if !PYTHON_MAJOR! EQU 3 (
    if !PYTHON_MINOR! LSS 12 (
        echo [91m❌ Python 3.12+ is required. You have !PYTHON_VERSION!.[0m
        echo [93mPlease upgrade your Python version and try again.[0m
        exit /b 1
    )
)

echo [92m✅ Python !PYTHON_VERSION! detected[0m

:: Check for uv
where uv >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [93m🔄 uv not found. Please install manually:[0m
    echo [93mVisit: https://docs.astral.sh/uv/getting-started/installation/[0m
    echo [93mAfter installing, run this script again.[0m
    exit /b 1
)

echo [92m✅ uv detected[0m

:: Check for Node.js
where node >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [91m❌ Node.js not found. Please install Node.js 22+ and try again.[0m
    echo [93mVisit: https://nodejs.org/en/download/[0m
    exit /b 1
)

for /f "tokens=1" %%n in ('node --version') do set NODE_VERSION=%%n
set NODE_VERSION=!NODE_VERSION:~1!
for /f "tokens=1 delims=." %%a in ("!NODE_VERSION!") do set NODE_MAJOR=%%a

if !NODE_MAJOR! LSS 22 (
    echo [91m❌ Node.js 22+ is required. You have !NODE_VERSION!.[0m
    echo [93mPlease upgrade your Node.js version and try again.[0m
    exit /b 1
)

echo [92m✅ Node.js !NODE_VERSION! detected[0m

:: Check for pnpm
where pnpm >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [93m🔄 pnpm not found. Installing...[0m
    npm install -g pnpm
    
    where pnpm >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo [91m❌ Failed to install pnpm. Please install manually:[0m
        echo [93mnpm install -g pnpm[0m
        exit /b 1
    )
)

echo [92m✅ pnpm detected[0m

:: Check for marp-cli
where marp >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [93m🔄 marp-cli not found. Installing...[0m
    npm install -g @marp-team/marp-cli
    
    where marp >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo [93m⚠️ Failed to install marp-cli automatically.[0m
        echo [93mYou can install it manually later if needed for PPT generation:[0m
        echo [93mnpm install -g @marp-team/marp-cli[0m
    )
) else (
    echo [92m✅ marp-cli detected[0m
)

:: Install Python dependencies
echo.
echo [96m📦 Installing Python dependencies...[0m
uv sync

if %ERRORLEVEL% neq 0 (
    echo [91m❌ Failed to install Python dependencies.[0m
    exit /b 1
)

echo [92m✅ Python dependencies installed[0m

:: Create configuration files
echo.
echo [96m🔧 Setting up configuration files...[0m

:: .env file
if not exist .env (
    copy .env.example .env
    echo [92m✅ Created .env file from template[0m
    echo [93m⚠️ Remember to edit .env with your API keys[0m
) else (
    echo [93m⚠️ .env file already exists, skipping[0m
)

:: conf.yaml file
if not exist conf.yaml (
    copy conf.yaml.example conf.yaml
    echo [92m✅ Created conf.yaml file from template[0m
    echo [93m⚠️ Remember to edit conf.yaml with your LLM model settings[0m
) else (
    echo [93m⚠️ conf.yaml file already exists, skipping[0m
)

:: Ask if user wants to install web UI dependencies
echo.
echo [96m🌐 Do you want to install web UI dependencies? (y/n)[0m
set /p install_web=

if /i "!install_web!"=="y" (
    echo [96m📦 Installing web UI dependencies...[0m
    cd web && pnpm install && cd ..
    
    if %ERRORLEVEL% neq 0 (
        echo [91m❌ Failed to install web UI dependencies.[0m
        echo [93mYou can try again later with: cd web ^&^& pnpm install[0m
    ) else (
        echo [92m✅ Web UI dependencies installed[0m
    )
) else (
    echo [93m⚠️ Skipping web UI dependencies installation[0m
)

echo.
echo [92m🎉 Setup completed![0m
echo [96m===============================[0m
echo [93mNext steps:[0m
echo [97m1. Edit .env with your API keys[0m
echo [97m2. Edit conf.yaml with your LLM model settings[0m
echo [97m3. Run DeerFlow with: uv run main.py[0m
echo [97m4. Or run with web UI: bootstrap.bat -d[0m
echo [96m===============================[0m
echo [92mSee SETUP.md for more detailed instructions[0m

endlocal

