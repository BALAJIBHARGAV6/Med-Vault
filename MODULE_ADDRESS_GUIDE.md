# How to Find and Update Your MODULE_ADDRESS

## Quick Summary
After deploying your smart contract, your **MODULE_ADDRESS** is the same as your **account address** that deployed the contract.

## Method 1: Automated Deployment (Recommended)

Run the deployment script:
```powershell
# Navigate to your project
cd C:\MedVault

# Run the deployment script
.\deploy.ps1
```

This script will:
1. Deploy your contract to Aptos blockchain
2. Automatically extract your MODULE_ADDRESS
3. Update your frontend configuration
4. Switch from DEV_MODE to live blockchain

## Method 2: Manual Deployment

### Step 1: Deploy Contract
```powershell
cd C:\MedVault\move\medvault

# Initialize account (if not done)
aptos init

# Deploy contract
aptos move publish
```

### Step 2: Find Your Address
After successful deployment, look for the "sender" field in the output:
```json
{
  "Result": {
    "sender": "0x742d35cc6de3a0e5c8..."  ← This is your MODULE_ADDRESS
  }
}
```

### Step 3: Update Configuration
Edit `C:\MedVault\frontend\medvault\src\utils\deployment.ts`:

**Before:**
```typescript
export const DEPLOYMENT_CONFIG = {
  MODULE_ADDRESS: '0x1', // Replace with actual deployed address
  NETWORK: 'testnet',
  NODE_URL: 'https://fullnode.testnet.aptoslabs.com/v1',
};

export const DEV_MODE = false;
```

**After:**
```typescript
export const DEPLOYMENT_CONFIG = {
  MODULE_ADDRESS: '0x742d35cc6de3a0e5c8...', // ← Your actual address
  NETWORK: 'testnet',  // or 'mainnet' for production
  NODE_URL: 'https://fullnode.testnet.aptoslabs.com/v1',
};

export const DEV_MODE = false; // ← Keep as false for live blockchain
```

## Method 3: Using Existing Account

If you already have an Aptos account:
```powershell
# Check your current account address
aptos account list

# Use that address as your MODULE_ADDRESS
```

## Verification

After updating, verify your contract is accessible:
```powershell
aptos move view --function-id "YOUR_ADDRESS::medvault::get_organizations"
```

## Network Options

### Testnet (Recommended for development):
```typescript
NETWORK: 'testnet',
NODE_URL: 'https://fullnode.testnet.aptoslabs.com/v1',
```

### Mainnet (For production):
```typescript
NETWORK: 'mainnet',
NODE_URL: 'https://fullnode.mainnet.aptoslabs.com/v1',
```

## Example Real Addresses

Here are examples of what real Aptos addresses look like:
- `0x742d35cc6de3a0e5c8db6d5b5e5f4e3d2c1b0a9f8e7d6c5b4a39281f7e6d5c4b3a2`
- `0x1a2b3c4d5e6f7890abcdef1234567890abcdef1234567890abcdef1234567890`

Your address will be 64 characters long (excluding the '0x' prefix).

## Troubleshooting

**"Module not found" error:** 
- Make sure your MODULE_ADDRESS is correct
- Ensure contract was deployed successfully
- Check you're using the right network (testnet vs mainnet)

**"Account not found" error:**
- Fund your account with testnet/mainnet tokens
- Make sure you're connected to the right network

**Compilation errors:**
- Check Move.toml configuration
- Ensure all dependencies are correct
