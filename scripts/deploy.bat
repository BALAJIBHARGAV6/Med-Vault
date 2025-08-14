@echo off
REM MedVault Smart Contract Deployment Script for Windows
REM This script deploys the MedVault Move module to Aptos blockchain

echo 🏥 MedVault Smart Contract Deployment
echo ======================================

REM Check if Aptos CLI is installed
aptos --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Aptos CLI not found. Please install from https://aptos.dev/tools/aptos-cli/install-cli/
    echo    Run: winget install Aptos.CLI
    pause
    exit /b 1
)

REM Navigate to Move module directory
cd /d "%~dp0\..\move\medvault"

REM Default to devnet if no argument provided
set NETWORK=%1
if "%NETWORK%"=="" set NETWORK=devnet
echo 🌐 Target network: %NETWORK%

REM Initialize Aptos account if .aptos/config.yaml doesn't exist
if not exist ".aptos\config.yaml" (
    echo 🔑 Initializing Aptos account...
    aptos init --network %NETWORK%
    echo ✅ Account initialized
)

REM Fund account on devnet/testnet
if "%NETWORK%"=="devnet" (
    echo 💰 Funding account from faucet...
    aptos account fund-with-faucet --account default --amount 100000000
    echo ✅ Account funded
)
if "%NETWORK%"=="testnet" (
    echo 💰 Funding account from faucet...
    aptos account fund-with-faucet --account default --amount 100000000
    echo ✅ Account funded
)

REM Get account address
for /f "tokens=2" %%i in ('aptos config show-profiles --profile default ^| findstr "account"') do set ACCOUNT_ADDRESS=%%i
echo 📍 Deploying from account: %ACCOUNT_ADDRESS%

REM Compile Move module
echo 🔨 Compiling Move module...
aptos move compile --named-addresses medvault=%ACCOUNT_ADDRESS%
if %errorlevel% neq 0 (
    echo ❌ Compilation failed
    pause
    exit /b 1
)
echo ✅ Compilation successful

REM Run tests
echo 🧪 Running Move tests...
aptos move test --named-addresses medvault=%ACCOUNT_ADDRESS%
if %errorlevel% neq 0 (
    echo ❌ Tests failed
    pause
    exit /b 1
)
echo ✅ All tests passed

REM Publish module
echo 📦 Publishing module to %NETWORK%...
aptos move publish --named-addresses medvault=%ACCOUNT_ADDRESS% --assume-yes

if %errorlevel% neq 0 (
    echo ❌ Deployment failed
    pause
    exit /b 1
)

REM Success message
echo.
echo 🎉 Deployment successful!
echo ======================================
echo 📍 Module Address: %ACCOUNT_ADDRESS%
echo 🌐 Network: %NETWORK%
echo 🔗 Explorer: https://explorer.aptoslabs.com/account/%ACCOUNT_ADDRESS%?network=%NETWORK%
echo.
echo 📋 Next steps:
echo 1. Update frontend\.env with VITE_MODULE_ADDR=%ACCOUNT_ADDRESS%
echo 2. Update frontend\.env with VITE_NODE_URL for your network
echo 3. Get web3.storage API token and update VITE_WEB3_STORAGE_TOKEN
echo 4. Run 'npm run dev' in the frontend directory
echo.
echo 📚 Useful commands:
echo   View module: aptos account list --query modules --account %ACCOUNT_ADDRESS%
echo   Check balance: aptos account list --query balance --account %ACCOUNT_ADDRESS%
echo.

REM Save deployment info
echo { > deployment.json
echo   "network": "%NETWORK%", >> deployment.json
echo   "moduleAddress": "%ACCOUNT_ADDRESS%", >> deployment.json
echo   "deployedAt": "%date% %time%", >> deployment.json
echo   "explorerUrl": "https://explorer.aptoslabs.com/account/%ACCOUNT_ADDRESS%?network=%NETWORK%" >> deployment.json
echo } >> deployment.json

echo 💾 Deployment information saved to deployment.json
pause
