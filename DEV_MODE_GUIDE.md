# MedVault Development Mode Guide

## 🧪 Development Mode vs Production Mode

MedVault can run in two modes to help with development and testing:

### Development Mode (Current)
- **Status**: Currently active (orange indicators in UI)
- **Transactions**: Simulated for testing
- **Storage**: Mock IPFS responses
- **Wallet**: Petra wallet required but transactions are simulated
- **Purpose**: Safe development and testing environment

### Production Mode
- **Status**: Ready to activate
- **Transactions**: Real blockchain transactions on Aptos
- **Storage**: Live IPFS network
- **Wallet**: Petra wallet required for real transactions
- **Purpose**: Live medical record management

## 🔄 Switching Between Modes

### To Enable Production Mode:
1. Deploy the Move smart contract to Aptos (see PRODUCTION_DEPLOYMENT.md)
2. Update `.env` file:
   ```
   VITE_DEV_MODE=false
   VITE_MODULE_ADDR=0x[your-deployed-contract-address]
   ```
3. Restart the application

### To Return to Development Mode:
1. Update `.env` file:
   ```
   VITE_DEV_MODE=true
   ```
2. Restart the application

## 🎯 Current Status Indicators

### UI Indicators:
- **Orange banners**: Development mode active
- **System status cards**: Show "DEV" instead of "IPFS"
- **Dashboard indicators**: Display simulated vs live status

### Transaction Behavior:
- **Dev Mode**: Creates mock transaction hashes
- **Production Mode**: Creates real blockchain transactions

## 📋 What Works in Each Mode

### Development Mode ✅
- ✅ UI navigation and forms
- ✅ Encryption/decryption testing
- ✅ Wallet connection testing
- ✅ Transaction simulation
- ✅ Mock IPFS responses
- ✅ All user interactions

### Production Mode ⚠️ (Requires deployment)
- ⚠️ Smart contract must be deployed first
- ✅ Real blockchain transactions
- ✅ Live IPFS storage
- ✅ Permanent medical records
- ✅ Real transaction fees

## 🛠 Development Workflow

1. **Start in Dev Mode**: Test all functionality safely
2. **Deploy Contract**: Follow PRODUCTION_DEPLOYMENT.md
3. **Switch to Production**: Update environment variables
4. **Test Production**: Verify real transactions work
5. **Go Live**: Ready for actual medical record management

## 🔍 Verifying Current Mode

Check for these indicators:
- **Dev Mode**: Orange banners, "🧪 Development Mode Active"
- **Production Mode**: Green indicators, "🚀 Production Mode"
- **Browser Console**: Logs show "DEV MODE" vs "PRODUCTION MODE"

## 📚 Additional Resources

- **PRODUCTION_DEPLOYMENT.md**: Complete production setup guide
- **README.md**: General application documentation
- **Environment Variables**: See `.env` file for all configuration options

---

*This guide helps developers understand the current development mode setup and how to transition to production when ready.*
