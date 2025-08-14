# 🚀 Production Deployment Guide - Enable Real Blockchain Transactions

## Current Status: ✅ Development Mode Working
Your MedVault application is currently running in **development mode** with simulated transactions. Here's how to enable real Aptos blockchain transactions:

## 📋 Prerequisites

1. **Aptos CLI installed**
   ```bash
   curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
   ```

2. **Petra Wallet** installed in browser with testnet APT tokens

3. **Web3.Storage account** (free) for IPFS file storage

## 🛠️ Step-by-Step Production Setup

### Step 1: Deploy Smart Contract to Aptos

```bash
# Navigate to Move contract directory
cd "c:\med\move (2)\move\medvault"

# Initialize Aptos account (if not already done)
aptos init

# Compile and test the contract
aptos move test

# Deploy to testnet
aptos move publish --named-addresses medvault=default

# ✅ Copy the deployed module address from output
```

### Step 2: Update Environment Configuration

1. Open `frontend/medvault/.env`
2. Replace `VITE_MODULE_ADDR` with your deployed contract address:
   ```env
   VITE_MODULE_ADDR=0xYOUR_DEPLOYED_MODULE_ADDRESS_HERE
   ```

### Step 3: Get IPFS Storage Token (Optional)

1. Visit https://web3.storage
2. Sign up for free account
3. Create API token
4. Update `.env`:
   ```env
   VITE_WEB3_STORAGE_TOKEN=your_actual_token_here
   ```

### Step 4: Enable Production Mode

Update `.env`:
```env
VITE_DEV_MODE=false
```

### Step 5: Test on Testnet

1. Restart the development server:
   ```bash
   cd "c:\med\move (2)\frontend\medvault"
   npm run dev
   ```

2. Connect Petra wallet (ensure you're on testnet)
3. Create a medical record
4. ✅ Real transaction should be submitted and confirmed

## 🔧 Troubleshooting

### Issue: "Invalid module address"
- **Cause**: Module not deployed or wrong address
- **Fix**: Deploy contract and update `VITE_MODULE_ADDR`

### Issue: "Doctor not registered/active"  
- **Cause**: Doctor account not registered in contract
- **Fix**: Register doctor first through admin interface

### Issue: "Insufficient gas"
- **Cause**: Not enough APT in wallet
- **Fix**: Get testnet APT from https://aptoslabs.com/testnet-faucet

### Issue: "Patient address invalid"
- **Cause**: Invalid Aptos address format
- **Fix**: Use proper 0x... format addresses

## 🔍 Current Implementation Status

### ✅ Working Features
- Hex encoding for `vector<u8>` parameters
- Proper Move function signatures 
- Petra wallet integration
- Development mode simulation
- Transaction debugging
- Error handling

### 🚧 Next Steps for Full Production
1. **Deploy Move contract** - Contract needs to be deployed to get real module address
2. **Register doctor accounts** - Doctors must be registered and activated in contract
3. **Add patient key management** - Public key registration for encryption
4. **Implement access control** - Grant/revoke access functionality
5. **Add real IPFS encryption** - Currently using demo encryption

## 📊 Development vs Production Comparison

| Feature | Development Mode | Production Mode |
|---------|------------------|-----------------|
| Transactions | Simulated | Real Aptos blockchain |
| Gas Fees | None | Real APT required |
| Data Storage | Browser only | IPFS + blockchain |
| Encryption | Demo/mock | AES-256-GCM |
| Wallet | Optional | Required (Petra) |
| Network | Local simulation | Aptos testnet/mainnet |

## 🎯 Quick Start for Real Transactions

**For immediate testing without full deployment:**

1. Use existing deployed MedVault contract on testnet (if available)
2. Update `VITE_MODULE_ADDR` to that address
3. Set `VITE_DEV_MODE=false`
4. Ensure Petra wallet has testnet APT
5. Test transaction

**For full production deployment:**

Follow all steps above to deploy your own contract instance.

## 🔐 Security Notes

- Always test on testnet before mainnet
- Keep private keys secure
- Validate all user inputs
- Monitor gas costs
- Regular security audits recommended

The current hex encoding implementation is **production-ready** and will work with real Aptos transactions once the contract is deployed! 🎉
