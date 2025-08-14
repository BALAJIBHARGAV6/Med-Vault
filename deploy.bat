@echo off
echo ========================================
echo    MedVault Smart Contract Deployment
echo ========================================
echo.

:: Check if Aptos CLI is installed
aptos --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Aptos CLI not found!
    echo Please install Aptos CLI first:
    echo 1. Download from: https://github.com/aptos-labs/aptos-core/releases/latest
    echo 2. Or use: choco install aptos-cli
    echo 3. Or use: cargo install --git https://github.com/aptos-labs/aptos-core.git aptos --branch mainnet
    echo.
    pause
    exit /b 1
)

echo ✓ Aptos CLI found
echo.

:: Navigate to Move project directory
cd /d "%~dp0move\medvault"
echo Current directory: %CD%
echo.

:: Check if already initialized
if exist ".aptos\config.yaml" (
    echo ✓ Aptos account already initialized
) else (
    echo Initializing new Aptos account...
    echo Please follow the prompts to set up your account:
    echo - Choose network: testnet (recommended for testing)
    echo - A new private key will be generated
    echo.
    aptos init
    if errorlevel 1 (
        echo ERROR: Failed to initialize Aptos account
        pause
        exit /b 1
    )
    echo ✓ Account initialized successfully
)

echo.

:: Get account address
echo Getting account address...
for /f "tokens=*" %%i in ('aptos account list --query balance 2^>nul ^| findstr "0x"') do set ACCOUNT_ADDRESS=%%i
if "%ACCOUNT_ADDRESS%"=="" (
    echo ERROR: Could not retrieve account address
    pause
    exit /b 1
)

echo ✓ Account Address: %ACCOUNT_ADDRESS%
echo.

:: Fund account (testnet only)
echo Funding account with testnet tokens...
aptos account fund-with-faucet --account %ACCOUNT_ADDRESS%
if errorlevel 1 (
    echo WARNING: Could not fund account (might be on mainnet or already funded)
)
echo.

:: Compile the contract
echo Compiling Move modules...
aptos move compile
if errorlevel 1 (
    echo ERROR: Compilation failed
    pause
    exit /b 1
)
echo ✓ Compilation successful
echo.

:: Deploy the contract
echo Deploying smart contract...
aptos move publish --assume-yes
if errorlevel 1 (
    echo ERROR: Deployment failed
    echo Trying with upgrade policy...
    aptos move publish --upgrade-policy compatible --assume-yes
    if errorlevel 1 (
        echo ERROR: Deployment failed even with upgrade policy
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo           DEPLOYMENT SUCCESSFUL!
echo ========================================
echo.
echo Your MODULE_ADDRESS is: %ACCOUNT_ADDRESS%
echo.
echo Next steps:
echo 1. Update C:\MedVault\frontend\medvault\src\utils\deployment.ts
echo 2. Replace MODULE_ADDRESS with: %ACCOUNT_ADDRESS%
echo 3. Set DEV_MODE = false
echo.
echo Would you like to automatically update the frontend config? (Y/N)
set /p UPDATE_CONFIG=

if /i "%UPDATE_CONFIG%"=="Y" (
    echo Updating frontend configuration...
    
    :: Create backup
    copy "..\..\..\frontend\medvault\src\utils\deployment.ts" "..\..\..\frontend\medvault\src\utils\deployment.ts.backup" >nul 2>&1
    
    :: Update the configuration file
    powershell -Command "(Get-Content '..\..\..\frontend\medvault\src\utils\deployment.ts') -replace \"MODULE_ADDRESS: '.*'\", \"MODULE_ADDRESS: '%ACCOUNT_ADDRESS%'\" -replace \"DEV_MODE = true\", \"DEV_MODE = false\" | Set-Content '..\..\..\frontend\medvault\src\utils\deployment.ts'"
    
    echo ✓ Frontend configuration updated!
)

echo.
echo Deployment complete! Your contract is now live on the blockchain.
echo.
pause
