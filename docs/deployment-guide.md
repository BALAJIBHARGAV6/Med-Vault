# MedVault Deployment Guide

This guide provides step-by-step instructions for deploying MedVault to production or testing environments.

## 🎯 Deployment Overview

MedVault consists of two main components:
1. **Smart Contracts** - Move modules deployed to Aptos blockchain
2. **Frontend Application** - React TypeScript app deployed to web hosting

## 🔧 Prerequisites

### Required Tools
- **Aptos CLI** - Version 1.0+ for smart contract deployment
- **Node.js** - Version 18+ for frontend build
- **Git** - For repository access
- **Petra Wallet** - For transaction signing

### Required Accounts
- **Deployer Account** - Funded Aptos account for module publication
- **Web3.Storage Account** - For IPFS storage (free tier available)
- **Hosting Account** - Vercel, Netlify, or similar (optional for frontend)

## 📋 Step-by-Step Deployment

### Step 1: Environment Setup

#### 1.1 Clone Repository
```bash
git clone https://github.com/your-org/medvault.git
cd medvault
```

#### 1.2 Install Dependencies
```bash
# Install Aptos CLI (if not already installed)
curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3

# For Windows users:
# winget install Aptos.CLI

# Install Node.js dependencies
cd frontend/medvault
npm install
cd ../..
```

### Step 2: Smart Contract Deployment

#### 2.1 Configure Deployment Account
```bash
cd move/medvault

# Initialize Aptos account
aptos init --network devnet  # or testnet/mainnet

# Fund account (devnet/testnet only)
aptos account fund-with-faucet --account default --amount 100000000

# Check account balance
aptos account list --query balance --account default
```

#### 2.2 Deploy Smart Contracts
```bash
# Option A: Use automated script (recommended)
../../scripts/deploy.sh devnet  # or testnet/mainnet

# Option B: Manual deployment
aptos move compile --named-addresses medvault=default
aptos move test --named-addresses medvault=default
aptos move publish --named-addresses medvault=default --assume-yes
```

#### 2.3 Verify Deployment
```bash
# Get account address
ACCOUNT_ADDRESS=$(aptos config show-profiles --profile default | grep "account" | awk '{print $2}')

# Check deployed modules
aptos account list --query modules --account $ACCOUNT_ADDRESS

# View in explorer
echo "Explorer: https://explorer.aptoslabs.com/account/$ACCOUNT_ADDRESS?network=devnet"
```

#### 2.4 Save Deployment Information
```bash
# The deployment script automatically creates deployment.json
cat deployment.json

# Example output:
# {
#   "network": "devnet",
#   "moduleAddress": "0x1234...abcd",
#   "deployedAt": "2024-01-15T10:30:00Z",
#   "explorerUrl": "https://explorer.aptoslabs.com/account/0x1234...abcd?network=devnet"
# }
```

### Step 3: Frontend Configuration

#### 3.1 Configure Environment Variables
```bash
cd frontend/medvault

# Copy example environment file
cp .env.example .env

# Edit .env with your configuration
nano .env  # or use your preferred editor
```

#### 3.2 Required Environment Variables
```env
# Aptos Network Configuration
VITE_NODE_URL=https://fullnode.devnet.aptoslabs.com/v1
VITE_MODULE_ADDR=0x1234...abcd  # Your deployed module address

# IPFS Configuration  
VITE_WEB3_STORAGE_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...  # Your token

# Optional
VITE_APTOS_EXPLORER_URL=https://explorer.aptoslabs.com
```

#### 3.3 Get Web3.Storage API Token
1. Visit [web3.storage](https://web3.storage)
2. Create account or sign in
3. Navigate to "API Tokens"
4. Create new token with name "MedVault"
5. Copy token to `.env` file

### Step 4: Frontend Deployment

#### Option A: Local Development
```bash
# Start development server
npm run dev

# Access at http://localhost:3000
```

#### Option B: Vercel Deployment (Recommended)
```bash
# Install Vercel CLI
npm install -g vercel

# Build and deploy
npm run build
vercel --prod

# Configure environment variables in Vercel dashboard
```

#### Option C: Netlify Deployment
```bash
# Build application
npm run build

# Deploy to Netlify (drag dist folder to netlify.com)
# Or use Netlify CLI:
npm install -g netlify-cli
netlify deploy --dir=dist --prod
```

#### Option D: Other Hosting Providers
```bash
# Build for production
npm run build

# Upload dist/ folder contents to your hosting provider
# Ensure proper routing for SPA (single page application)
```

### Step 5: Post-Deployment Verification

#### 5.1 Smart Contract Verification
```bash
# Test view functions
aptos move run --function-id $MODULE_ADDRESS::medvault::get_organization \
  --args string:"test_org"

# Should return empty/null for new deployment
```

#### 5.2 Frontend Verification
1. **Navigate to deployed URL**
2. **Test Petra wallet connection**
3. **Verify network configuration** (check console for errors)
4. **Test each portal** (Admin, Doctor, Patient, Verify)

#### 5.3 Integration Testing
1. **Create test organization** (Admin portal)
2. **Register test doctor** (Admin portal)
3. **Create test record** (Doctor portal)
4. **Verify patient access** (Patient portal)
5. **Test public verification** (Verify page)

## 🔒 Production Deployment Considerations

### Security Best Practices

#### Smart Contract Security
- **Audit contracts** before mainnet deployment
- **Use multi-sig** for module upgrades
- **Monitor events** for suspicious activity
- **Implement rate limiting** for expensive operations

#### Frontend Security
- **Enable HTTPS** for all traffic
- **Implement CSP headers** to prevent XSS
- **Validate all inputs** client and server-side
- **Secure API keys** using environment variables
- **Regular dependency updates** for security patches

#### Operational Security
- **Secure private keys** for deployment accounts
- **Backup deployment configurations**
- **Monitor application performance**
- **Set up alerting** for critical errors

### Scalability Considerations

#### IPFS Configuration
- **Use dedicated IPFS node** for production
- **Implement CDN** for faster file delivery
- **Set up backup pinning** services
- **Monitor storage usage** and costs

#### Frontend Performance
- **Enable compression** (gzip/brotli)
- **Implement caching** strategies
- **Optimize bundle size** 
- **Use CDN** for static assets
- **Monitor Core Web Vitals**

## 🌐 Network-Specific Configurations

### Devnet Configuration
```env
VITE_NODE_URL=https://fullnode.devnet.aptoslabs.com/v1
VITE_APTOS_EXPLORER_URL=https://explorer.aptoslabs.com
# Free faucet available for testing
```

### Testnet Configuration  
```env
VITE_NODE_URL=https://fullnode.testnet.aptoslabs.com/v1
VITE_APTOS_EXPLORER_URL=https://explorer.aptoslabs.com
# More stable than devnet, good for staging
```

### Mainnet Configuration
```env
VITE_NODE_URL=https://fullnode.mainnet.aptoslabs.com/v1
VITE_APTOS_EXPLORER_URL=https://explorer.aptoslabs.com
# Production environment - requires real APT tokens
```

## 📊 Monitoring & Maintenance

### Application Monitoring
- **Set up error tracking** (Sentry, Bugsnag)
- **Monitor transaction success rates**
- **Track user adoption metrics**
- **Monitor IPFS upload/download performance**

### Smart Contract Monitoring
- **Track contract events** for anomalies
- **Monitor gas usage** patterns
- **Set up alerts** for failed transactions
- **Regular balance checks** for contract accounts

### Maintenance Tasks
- **Regular dependency updates**
- **Security patch application**
- **Performance optimization**
- **Backup verification**
- **Documentation updates**

## 🆘 Troubleshooting

### Common Deployment Issues

#### Smart Contract Deployment Fails
```bash
# Check account balance
aptos account list --query balance --account default

# Verify network connectivity
curl -X GET "https://fullnode.devnet.aptoslabs.com/v1"

# Re-compile with verbose output
aptos move compile --named-addresses medvault=default --verbose
```

#### Frontend Build Errors
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install

# Check for type errors
npm run type-check

# Build with verbose output
npm run build -- --verbose
```

#### Wallet Connection Issues
1. **Clear browser cache** and local storage
2. **Update Petra wallet** to latest version
3. **Check network configuration** in wallet
4. **Verify wallet has sufficient balance**

#### IPFS Upload Failures
1. **Verify API token** is valid and active
2. **Check file size limits** (5MB recommended)
3. **Test with smaller files** first
4. **Monitor web3.storage quota** usage

### Getting Help

#### Documentation
- **Official Aptos Docs**: https://aptos.dev
- **Move Language Guide**: https://move-language.github.io
- **React Documentation**: https://react.dev

#### Community Support
- **Aptos Discord**: https://discord.gg/aptoslabs
- **MedVault Issues**: GitHub repository issues
- **Stack Overflow**: Tag questions with `aptos`, `move-lang`

#### Emergency Contacts
- **Critical Security Issues**: security@medvault.health
- **Production Outages**: ops@medvault.health
- **General Support**: support@medvault.health

## 📈 Deployment Checklist

### Pre-Deployment
- [ ] Smart contracts compiled and tested
- [ ] Frontend built without errors
- [ ] Environment variables configured
- [ ] API keys obtained and tested
- [ ] Deployment accounts funded
- [ ] Network configuration verified

### Deployment
- [ ] Smart contracts deployed successfully
- [ ] Module address recorded
- [ ] Frontend deployed to hosting provider
- [ ] Environment variables set in hosting dashboard
- [ ] DNS configured (if using custom domain)
- [ ] SSL certificates installed

### Post-Deployment
- [ ] Smart contract functions tested
- [ ] Frontend interfaces accessible
- [ ] Wallet integration working
- [ ] IPFS uploads functioning
- [ ] All user flows tested
- [ ] Monitoring and alerting configured
- [ ] Documentation updated with deployment details

---

**Deployment complete! Your MedVault instance is ready for use. 🎉**

For ongoing support and updates, refer to the README.md and join our community channels.
