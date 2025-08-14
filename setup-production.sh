#!/bin/bash

# MedVault Production Setup Script
echo "🏥 Setting up MedVault for Production Deployment"

# Navigate to frontend directory
cd frontend/medvault

echo "📦 Installing dependencies..."
npm install

echo "🔧 Installing production dependencies..."
npm install @aptos-labs/ts-sdk@^1.4.0
npm install web3.storage@^4.5.5

echo "🔨 Building the project..."
npm run build

echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Update .env file with your Web3.Storage token"
echo "2. Deploy Move contract using: cd ../../ && ./deploy.sh"
echo "3. Update VITE_MODULE_ADDR in .env with deployed contract address"
echo "4. Start the app with: npm run dev"
echo ""
echo "🔗 For Aptos contract deployment:"
echo "   - Install Aptos CLI: https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli"
echo "   - Run: aptos move publish --package-dir ./move/medvault"
echo ""
