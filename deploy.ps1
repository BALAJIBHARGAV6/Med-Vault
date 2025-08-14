# MedVault Smart Contract Deployment Script
# PowerShell version for better Windows compatibility

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    MedVault Smart Contract Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Aptos CLI is installed
try {
    $aptosVersion = aptos --version 2>$null
    Write-Host "✓ Aptos CLI found: $aptosVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Aptos CLI not found!" -ForegroundColor Red
    Write-Host "Please install Aptos CLI first:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://github.com/aptos-labs/aptos-core/releases/latest" -ForegroundColor Yellow
    Write-Host "2. Or use: choco install aptos-cli" -ForegroundColor Yellow
    Write-Host "3. Or use: cargo install --git https://github.com/aptos-labs/aptos-core.git aptos --branch mainnet" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Navigate to Move project directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$moveProjectPath = Join-Path $scriptPath "move\medvault"
Set-Location $moveProjectPath

Write-Host "Current directory: $(Get-Location)" -ForegroundColor Blue
Write-Host ""

# Check if already initialized
if (Test-Path ".aptos\config.yaml") {
    Write-Host "✓ Aptos account already initialized" -ForegroundColor Green
} else {
    Write-Host "Initializing new Aptos account..." -ForegroundColor Yellow
    Write-Host "Please follow the prompts to set up your account:" -ForegroundColor Yellow
    Write-Host "- Choose network: testnet (recommended for testing)" -ForegroundColor Yellow
    Write-Host "- A new private key will be generated" -ForegroundColor Yellow
    Write-Host ""
    
    aptos init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to initialize Aptos account" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "✓ Account initialized successfully" -ForegroundColor Green
}

Write-Host ""

# Get account address
Write-Host "Getting account address..." -ForegroundColor Blue
try {
    $accountInfo = aptos account list --query balance 2>$null | Select-String "0x" | Select-Object -First 1
    $accountAddress = $accountInfo.Line.Trim()
    
    if ([string]::IsNullOrEmpty($accountAddress)) {
        # Try alternative method
        $configContent = Get-Content ".aptos\config.yaml" -Raw
        if ($configContent -match 'account:\s*([0-9a-fA-Fx]+)') {
            $accountAddress = $matches[1]
        }
    }
    
    if ([string]::IsNullOrEmpty($accountAddress)) {
        throw "Could not retrieve account address"
    }
    
    Write-Host "✓ Account Address: $accountAddress" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Could not retrieve account address" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Fund account (testnet only)
Write-Host "Funding account with testnet tokens..." -ForegroundColor Blue
aptos account fund-with-faucet --account $accountAddress 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: Could not fund account (might be on mainnet or already funded)" -ForegroundColor Yellow
} else {
    Write-Host "✓ Account funded successfully" -ForegroundColor Green
}

Write-Host ""

# Compile the contract
Write-Host "Compiling Move modules..." -ForegroundColor Blue
aptos move compile
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Compilation failed" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "✓ Compilation successful" -ForegroundColor Green

Write-Host ""

# Deploy the contract
Write-Host "Deploying smart contract..." -ForegroundColor Blue
aptos move publish --assume-yes
if ($LASTEXITCODE -ne 0) {
    Write-Host "Deployment failed, trying with upgrade policy..." -ForegroundColor Yellow
    aptos move publish --upgrade-policy compatible --assume-yes
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Deployment failed even with upgrade policy" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "           DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your MODULE_ADDRESS is: $accountAddress" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Update C:\MedVault\frontend\medvault\src\utils\deployment.ts" -ForegroundColor Yellow
Write-Host "2. Replace MODULE_ADDRESS with: $accountAddress" -ForegroundColor Yellow
Write-Host "3. Set DEV_MODE = false" -ForegroundColor Yellow
Write-Host ""

$updateConfig = Read-Host "Would you like to automatically update the frontend config? (Y/N)"

if ($updateConfig -eq "Y" -or $updateConfig -eq "y") {
    Write-Host "Updating frontend configuration..." -ForegroundColor Blue
    
    $frontendConfigPath = Join-Path $scriptPath "frontend\medvault\src\utils\deployment.ts"
    
    # Create backup
    if (Test-Path $frontendConfigPath) {
        Copy-Item $frontendConfigPath "$frontendConfigPath.backup" -Force
        
        # Update the configuration file
        $content = Get-Content $frontendConfigPath -Raw
        $content = $content -replace "MODULE_ADDRESS: '[^']*'", "MODULE_ADDRESS: '$accountAddress'"
        $content = $content -replace "DEV_MODE = true", "DEV_MODE = false"
        $content = $content -replace "export const DEV_MODE = true", "export const DEV_MODE = false"
        
        Set-Content $frontendConfigPath $content -NoNewline
        
        Write-Host "✓ Frontend configuration updated!" -ForegroundColor Green
        Write-Host "✓ Backup created at: $frontendConfigPath.backup" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Could not find frontend config file at: $frontendConfigPath" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Deployment complete! Your contract is now live on the blockchain." -ForegroundColor Green
Write-Host ""
Write-Host "To verify deployment, run:" -ForegroundColor Yellow
Write-Host "aptos move view --function-id `"$accountAddress::medvault::get_organizations`"" -ForegroundColor Cyan
Write-Host ""

Read-Host "Press Enter to exit"
