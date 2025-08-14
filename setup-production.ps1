# MedVault Production Setup Script for Windows
Write-Host "🏥 Setting up MedVault for Production Deployment" -ForegroundColor Green

# Navigate to frontend directory
Set-Location frontend\medvault

Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
npm install

Write-Host "🔧 Installing production dependencies..." -ForegroundColor Yellow
npm install @aptos-labs/ts-sdk@^1.4.0
npm install web3.storage@^4.5.5

Write-Host "🔨 Building the project..." -ForegroundColor Yellow
npm run build

Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Update .env file with your Web3.Storage token" -ForegroundColor White
Write-Host "2. Deploy Move contract using: aptos move publish --package-dir .\move\medvault" -ForegroundColor White
Write-Host "3. Update VITE_MODULE_ADDR in .env with deployed contract address" -ForegroundColor White
Write-Host "4. Start the app with: npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "🔗 For Aptos contract deployment:" -ForegroundColor Cyan
Write-Host "   - Install Aptos CLI: https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli" -ForegroundColor White
Write-Host "   - Initialize: aptos init" -ForegroundColor White
Write-Host "   - Fund account: visit https://aptoslabs.com/testnet-faucet" -ForegroundColor White
Write-Host "   - Deploy: aptos move publish --package-dir .\move\medvault" -ForegroundColor White
Write-Host ""

# Return to root directory
Set-Location ..\..
