# 🏥 MedVault - Production Deployment Guide

MedVault is now configured for **production deployment** with real Aptos blockchain integration, IPFS file storage, and Petra wallet connectivity.

## 🚀 Quick Setup

### Prerequisites

1. **Node.js** (v16+)
2. **Aptos CLI** - [Installation Guide](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli)
3. **Petra Wallet** browser extension
4. **Web3.Storage** account for IPFS - [Get Token](https://web3.storage)

### Installation

**Windows:**
```powershell
.\setup-production.ps1
```

**Linux/Mac:**
```bash
chmod +x setup-production.sh
./setup-production.sh
```

## 🔧 Configuration

### 1. Environment Variables

Update `frontend/medvault/.env`:

```env
# Aptos Network Configuration
VITE_NETWORK=testnet
VITE_NODE_URL=https://fullnode.testnet.aptoslabs.com/v1
VITE_MODULE_ADDR=YOUR_DEPLOYED_CONTRACT_ADDRESS

# IPFS Configuration
VITE_WEB3_STORAGE_TOKEN=your_web3_storage_token_here

# Production Mode
VITE_DEV_MODE=false
```

### 2. Deploy Smart Contract

```bash
# Initialize Aptos CLI (first time only)
aptos init

# Fund your account (testnet)
# Visit: https://aptoslabs.com/testnet-faucet

# Deploy the contract
aptos move publish --package-dir ./move/medvault

# Copy the deployed address to .env as VITE_MODULE_ADDR
```

### 3. Get Web3.Storage Token

1. Visit [web3.storage](https://web3.storage)
2. Create account and generate API token
3. Add to `.env` file

## 🔗 Production Features

### ✅ Real Blockchain Integration

- **Smart Contract**: All medical records stored on Aptos blockchain
- **Gas Fees**: Real APT tokens required for transactions
- **Wallet Integration**: Petra wallet for signing transactions
- **Transaction Confirmation**: Wait for blockchain confirmation
- **Explorer Links**: View transactions on Aptos Explorer

### ✅ Secure Encryption

- **AES-256-GCM**: Client-side file encryption
- **RSA-OAEP**: Key wrapping for access control
- **IPFS Storage**: Decentralized file storage
- **Private Key Management**: Secure browser storage with password protection

### ✅ Production Security

- **Soulbound NFTs**: Immutable record authenticity
- **Access Control**: Blockchain-enforced permissions
- **Audit Trail**: All actions recorded on-chain
- **Data Integrity**: Cryptographic hash verification

## 🏃‍♂️ Running the Application

```bash
cd frontend/medvault
npm run dev
```

Visit `http://localhost:3000`

## 📱 Usage Flow

### For Doctors:

1. **Connect Wallet**: Install Petra wallet and connect
2. **Fund Account**: Get APT from testnet faucet
3. **Create Records**: 
   - Upload and encrypt medical files
   - Pay gas fees for blockchain storage
   - Generate soulbound NFT for patient
4. **View Patients**: Access granted medical records

### For Patients:

1. **Connect Wallet**: Connect Petra wallet
2. **View Records**: See all medical records
3. **Grant Access**: Allow doctors to view records (pays gas)
4. **Verify Records**: Check authenticity on blockchain
5. **Download Files**: Decrypt and download medical files (pays viewing fee)

## 🔒 Security Model

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Medical File  │───▶│  AES-256-GCM     │───▶│   IPFS Storage  │
│   (Original)    │    │  Encryption      │    │   (Encrypted)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │  Encryption Key  │
                       │  (RSA-OAEP       │
                       │   Wrapped)       │
                       └──────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │ Aptos Blockchain │
                       │ - Record Metadata│
                       │ - Access Control │
                       │ - Wrapped Keys   │
                       │ - NFT Token      │
                       └──────────────────┘
```

## 📊 Gas Fee Estimates

| Operation | Estimated Gas (APT) | Description |
|-----------|-------------------|-------------|
| Create Record | ~0.001 APT | Store metadata + mint NFT |
| Grant Access | ~0.0005 APT | Add access permission |
| View Record | ~0.0001 APT | Log access attempt |
| Revoke Access | ~0.0005 APT | Remove permission |

## 🐛 Troubleshooting

### Common Issues:

**1. "Petra wallet not found"**
- Install Petra wallet browser extension
- Refresh the page after installation

**2. "Transaction failed"**
- Ensure account has sufficient APT balance
- Check network connectivity
- Verify contract address in .env

**3. "IPFS upload failed"**
- Verify Web3.Storage token is valid
- Check file size limits
- Ensure stable internet connection

**4. "Access denied"**
- Patient must grant access first
- Check wallet address is correct
- Verify you're connected to correct network

## 🌐 Network Configuration

### Testnet (Recommended for testing):
```env
VITE_NETWORK=testnet
VITE_NODE_URL=https://fullnode.testnet.aptoslabs.com/v1
```

### Mainnet (Production):
```env
VITE_NETWORK=mainnet
VITE_NODE_URL=https://fullnode.mainnet.aptoslabs.com/v1
```

## 📝 Important Notes

- **Real Money**: Mainnet uses real APT tokens with actual value
- **Gas Fees**: Every transaction costs APT tokens
- **Irreversible**: Blockchain transactions cannot be undone
- **Private Keys**: Store securely - loss means permanent loss of access
- **Backup**: Always backup your Petra wallet seed phrase

## 🎯 Production Checklist

- [ ] Aptos CLI installed and configured
- [ ] Smart contract deployed to blockchain
- [ ] Web3.Storage token configured
- [ ] Petra wallet funded with APT
- [ ] Environment variables updated
- [ ] Application tested with real transactions
- [ ] Backup wallet seed phrase stored securely

## 🤝 Support

For issues:
1. Check blockchain transaction status on [Aptos Explorer](https://explorer.aptoslabs.com)
2. Verify wallet balance and network connection
3. Review browser console for error messages
4. Ensure all environment variables are correctly set

---

**⚠️ Security Notice**: This is a production-ready application that handles real cryptocurrency and blockchain transactions. Always test thoroughly on testnet before using mainnet.
