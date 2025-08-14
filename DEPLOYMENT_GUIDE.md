# MedVault Smart Contract Deployment Guide

## Step 1: Install Aptos CLI

### Option A: Using Chocolatey (Recommended)
```powershell
# Install Chocolatey if not already installed
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Aptos CLI
choco install aptos-cli
```

### Option B: Manual Installation
1. Download from: https://github.com/aptos-labs/aptos-core/releases/latest
2. Download `aptos-cli-*-Windows-x86_64.zip`
3. Extract and add to PATH

### Option C: Using Cargo (if Rust is installed)
```powershell
cargo install --git https://github.com/aptos-labs/aptos-core.git aptos --branch mainnet
```

## Step 2: Initialize Aptos Account

```powershell
# Navigate to your Move project
cd C:\MedVault\move\medvault

# Initialize a new Aptos account (this will create .aptos folder)
aptos init

# Follow the prompts:
# - Choose network: testnet (for testing) or mainnet (for production)
# - This will generate a new private key and account address
```

## Step 3: Fund Your Account (Testnet Only)

```powershell
# Get testnet tokens (only needed for testnet)
aptos account fund-with-faucet --account YOUR_ACCOUNT_ADDRESS
```

## Step 4: Compile Your Smart Contract

```powershell
# Compile the Move modules
aptos move compile
```

## Step 5: Deploy Your Smart Contract

```powershell
# Deploy to the blockchain
aptos move publish
```

## Step 6: Get Your Module Address

After successful deployment, you'll see output like:
```
{
  "Result": {
    "transaction_hash": "0x123...",
    "gas_used": 1234,
    "gas_unit_price": 100,
    "sender": "0xYOUR_ACCOUNT_ADDRESS",
    "success": true
  }
}
```

**Your MODULE_ADDRESS will be your account address (sender field)!**

## Step 7: Update Your Frontend Configuration

Update the file `C:\MedVault\frontend\medvault\src\utils\deployment.ts`:

```typescript
export const DEPLOYMENT_CONFIG = {
  MODULE_ADDRESS: '0xYOUR_ACCOUNT_ADDRESS', // ← Replace with your address
  NETWORK: 'testnet', // or 'mainnet'
  NODE_URL: 'https://fullnode.testnet.aptoslabs.com/v1', // or mainnet URL
};

export const DEV_MODE = false; // ← Set to false for live blockchain
```

## Alternative: Quick Test Deployment

If you want to test without full deployment, you can use a known testnet address:

```typescript
export const DEPLOYMENT_CONFIG = {
  MODULE_ADDRESS: '0x1', // Standard test address
  NETWORK: 'testnet',
  NODE_URL: 'https://fullnode.testnet.aptoslabs.com/v1',
};
```

## Verification

After deployment, verify your contract is deployed:

```powershell
# Check if your module exists
aptos move view --function-id "YOUR_ADDRESS::medvault::get_organizations"
```

## Production Deployment

For mainnet deployment:
1. Use `aptos init` with mainnet
2. Fund your account with real APT tokens
3. Deploy with `aptos move publish`
4. Update frontend config with mainnet URLs

## Troubleshooting

### Common Issues:
1. **"Module already exists"**: Use `--upgrade-policy compatible` flag
2. **"Insufficient gas"**: Fund your account with more APT
3. **"Compilation errors"**: Check Move.toml dependencies

### Re-deployment:
```powershell
aptos move publish --upgrade-policy compatible
```
