#!/bin/bash

# MedVault Frontend Deployment Script for Vercel
# This script builds and deploys the frontend to Vercel

set -e

echo "🌐 MedVault Frontend Deployment"
echo "==============================="

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Not in frontend directory. Navigating..."
    cd "$(dirname "$0")/../frontend/medvault"
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "❌ Please update .env with your configuration before deploying"
    echo "   Required variables:"
    echo "   - VITE_MODULE_ADDR (your deployed module address)"
    echo "   - VITE_WEB3_STORAGE_TOKEN (your web3.storage API token)"
    exit 1
fi

# Check if required environment variables are set
if grep -q "your_web3_storage_token_here" .env; then
    echo "❌ Please update VITE_WEB3_STORAGE_TOKEN in .env before deploying"
    exit 1
fi

if grep -q "0x1" .env; then
    echo "❌ Please update VITE_MODULE_ADDR in .env with your deployed module address"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Type check
echo "🔍 Running type checks..."
npm run type-check

# Build the project
echo "🔨 Building project..."
npm run build

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📥 Installing Vercel CLI..."
    npm install -g vercel
fi

# Deploy to Vercel
echo "🚀 Deploying to Vercel..."
vercel --prod

echo ""
echo "🎉 Deployment successful!"
echo "=========================="
echo ""
echo "📋 Post-deployment checklist:"
echo "✅ Set environment variables in Vercel dashboard:"
echo "   - VITE_NODE_URL"
echo "   - VITE_MODULE_ADDR" 
echo "   - VITE_WEB3_STORAGE_TOKEN"
echo "   - VITE_APTOS_EXPLORER_URL"
echo ""
echo "✅ Test the deployment:"
echo "   - Connect Petra wallet"
echo "   - Test each user interface (Admin, Doctor, Patient)"
echo "   - Verify record creation and access flows"
echo ""
echo "🔗 Useful links:"
echo "   - Vercel Dashboard: https://vercel.com/dashboard"
echo "   - Aptos Explorer: https://explorer.aptoslabs.com"
echo "   - Web3.Storage: https://web3.storage"
