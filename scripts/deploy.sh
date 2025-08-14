#!/bin/bash

# MedVault Smart Contract Deployment Script
# This script deploys the MedVault Move module to Aptos blockchain

set -e

echo "🏥 MedVault Smart Contract Deployment"
echo "======================================"

# Check if Aptos CLI is installed
if ! command -v aptos &> /dev/null; then
    echo "❌ Aptos CLI not found. Installing..."
    curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
    echo "✅ Aptos CLI installed"
fi

# Navigate to Move module directory
cd "$(dirname "$0")/../move/medvault"

# Default to devnet if no argument provided
NETWORK=${1:-devnet}
echo "🌐 Target network: $NETWORK"

# Initialize Aptos account if .aptos/config.yaml doesn't exist
if [ ! -f ".aptos/config.yaml" ]; then
    echo "🔑 Initializing Aptos account..."
    aptos init --network $NETWORK
    echo "✅ Account initialized"
fi

# Fund account on devnet/testnet
if [ "$NETWORK" = "devnet" ] || [ "$NETWORK" = "testnet" ]; then
    echo "💰 Funding account from faucet..."
    aptos account fund-with-faucet --account default --amount 100000000
    echo "✅ Account funded"
fi

# Get account address
ACCOUNT_ADDRESS=$(aptos config show-profiles --profile default | grep "account" | awk '{print $2}')
echo "📍 Deploying from account: $ACCOUNT_ADDRESS"

# Compile Move module
echo "🔨 Compiling Move module..."
aptos move compile --named-addresses medvault=$ACCOUNT_ADDRESS
echo "✅ Compilation successful"

# Run tests
echo "🧪 Running Move tests..."
aptos move test --named-addresses medvault=$ACCOUNT_ADDRESS
echo "✅ All tests passed"

# Publish module
echo "📦 Publishing module to $NETWORK..."
aptos move publish --named-addresses medvault=$ACCOUNT_ADDRESS --assume-yes

# Get the published module address
MODULE_ADDRESS=$ACCOUNT_ADDRESS
echo ""
echo "🎉 Deployment successful!"
echo "======================================"
echo "📍 Module Address: $MODULE_ADDRESS"
echo "🌐 Network: $NETWORK"
echo "🔗 Explorer: https://explorer.aptoslabs.com/account/$MODULE_ADDRESS?network=$NETWORK"
echo ""
echo "📋 Next steps:"
echo "1. Update frontend/.env with VITE_MODULE_ADDR=$MODULE_ADDRESS"
echo "2. Update frontend/.env with VITE_NODE_URL for your network"
echo "3. Get web3.storage API token and update VITE_WEB3_STORAGE_TOKEN"
echo "4. Run 'npm run dev' in the frontend directory"
echo ""
echo "📚 Useful commands:"
echo "  View module: aptos account list --query modules --account $MODULE_ADDRESS"
echo "  Check balance: aptos account list --query balance --account $MODULE_ADDRESS"
echo ""

# Save deployment info
cat > deployment.json << EOF
{
  "network": "$NETWORK",
  "moduleAddress": "$MODULE_ADDRESS",
  "deployedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "explorerUrl": "https://explorer.aptoslabs.com/account/$MODULE_ADDRESS?network=$NETWORK"
}
EOF

echo "💾 Deployment information saved to deployment.json"
