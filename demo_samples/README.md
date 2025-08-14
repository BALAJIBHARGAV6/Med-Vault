# MedVault Demo Samples

This directory contains sample data and test accounts for demonstrating MedVault functionality.

## Sample Accounts

### Organization Admin
- **Address**: `0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef`
- **Role**: Hospital Administrator
- **Organization**: General Hospital
- **Private Key**: (For demo only - stored in demo-accounts.json)

### Doctors
1. **Dr. Alice Smith**
   - **Address**: `0x2345678901bcdef12345678901bcdef12345678901bcdef12345678901bcdef1`
   - **License**: MD-12345
   - **Specialty**: Cardiology
   - **Organization**: General Hospital

2. **Dr. Bob Johnson** 
   - **Address**: `0x3456789012cdef123456789012cdef123456789012cdef123456789012cdef12`
   - **License**: MD-67890
   - **Specialty**: Internal Medicine
   - **Organization**: General Hospital

### Patients
1. **Patient Charlie**
   - **Address**: `0x4567890123def1234567890123def1234567890123def1234567890123def123`
   - **Age**: 35
   - **Conditions**: Hypertension

2. **Patient Dana**
   - **Address**: `0x567890124ef12345678901234ef12345678901234ef12345678901234ef1234`
   - **Age**: 28
   - **Conditions**: Diabetes Type 2

## Sample Medical Records

### Record 1: Cardiology Consultation
- **Patient**: Charlie
- **Doctor**: Dr. Alice Smith
- **Date**: 2024-01-15
- **Type**: PDF Report
- **File**: `sample-cardiology-report.pdf`
- **Diagnosis**: Mild hypertension, recommend lifestyle changes

### Record 2: Blood Test Results
- **Patient**: Dana
- **Doctor**: Dr. Bob Johnson  
- **Date**: 2024-01-20
- **Type**: Lab Results
- **File**: `sample-lab-results.pdf`
- **Results**: HbA1c: 7.2%, requires medication adjustment

## Demo Flow Script

### Setup (30 seconds)
1. Start with all sample accounts funded on devnet
2. Deploy smart contracts with admin account
3. Admin creates "General Hospital" organization
4. Admin registers Dr. Alice and Dr. Bob
5. Admin activates both doctors

### Medical Record Creation (60 seconds)
1. Dr. Alice connects to doctor portal
2. Creates medical record for Patient Charlie:
   - Patient wallet: Charlie's address
   - Condition: Hypertension
   - Prescription: Lisinopril 10mg daily
   - Upload: sample-cardiology-report.pdf
   - Vital signs: BP 140/90, HR 72
3. System encrypts data, uploads to IPFS, creates blockchain record
4. NFT minted to Patient Charlie
5. Show transaction hash and record ID

### Patient Access (45 seconds)
1. Patient Charlie connects to patient portal
2. Views medical records timeline
3. Sees new record from Dr. Alice
4. Clicks to decrypt and view full report
5. Views attached PDF and prescription details

### Access Granting (30 seconds)
1. Patient Charlie grants access to Dr. Bob
2. Generates wrapped key for Dr. Bob's public key
3. Submits grant_access transaction
4. Shows access granted notification

### Cross-Doctor Access (30 seconds)
1. Dr. Bob connects to doctor portal
2. Searches for Patient Charlie by wallet address
3. Sees Charlie's medical record timeline
4. Opens Dr. Alice's record (now has access)
5. Views decrypted report and notes

### Access Revocation (15 seconds)
1. Patient Charlie revokes Dr. Bob's access
2. Submits revoke_access transaction
3. Dr. Bob can no longer decrypt the record

### Public Verification (20 seconds)
1. Navigate to verify page
2. Enter record ID from Charlie's report
3. Show public record header:
   - Issuing doctor: Dr. Alice Smith
   - Organization: General Hospital
   - Date created
   - NFT token information
   - File type: PDF
4. Show that sensitive data is not revealed

## Test Commands

```bash
# Deploy contracts
./scripts/deploy.sh devnet

# Fund demo accounts
aptos account fund-with-faucet --account 0x1234... --amount 100000000

# Create organization
aptos move run --function-id $MODULE_ADDR::medvault::create_org \
  --args string:"general_hospital" string:"General Hospital"

# Register doctor
aptos move run --function-id $MODULE_ADDR::medvault::register_doctor \
  --args address:0x2345... string:"Dr. Alice Smith" string:"MD-12345" string:"general_hospital"
```

## File Descriptions

- `demo-accounts.json`: Private keys for demo accounts (DEMO ONLY)
- `sample-cardiology-report.pdf`: Sample medical report PDF
- `sample-lab-results.pdf`: Sample laboratory test results
- `sample-prescription.json`: Sample prescription data structure
- `demo-script.md`: Detailed step-by-step demo instructions
- `test-data.json`: Pre-formatted test data for API calls

## Security Notice

⚠️ **WARNING**: The private keys in this demo directory are for demonstration purposes only. Never use these accounts or keys in production or with real funds.

## Running the Demo

1. Ensure MedVault is deployed and running
2. Use the demo accounts to test all functionality
3. Follow the demo script for a complete walkthrough
4. Reset demo data between presentations using the cleanup script

```bash
# Reset demo environment
./scripts/cleanup-demo.sh
./scripts/setup-demo.sh
```
