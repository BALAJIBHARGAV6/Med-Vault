# MedVault Testing Guide

This document outlines the comprehensive testing strategy for MedVault, including unit tests, integration tests, and manual acceptance testing.

## 🧪 Test Categories

### 1. Smart Contract Tests (Move)
- **Location**: `move/medvault/tests/`
- **Framework**: Aptos Move Test Framework
- **Coverage**: All entry functions, view functions, and error cases

### 2. Frontend Unit Tests
- **Location**: `frontend/medvault/src/__tests__/`
- **Framework**: Jest + React Testing Library
- **Coverage**: Components, utilities, and business logic

### 3. Integration Tests
- **Location**: `tests/integration/`
- **Framework**: Custom test suite
- **Coverage**: End-to-end workflows across smart contracts and frontend

### 4. Manual Acceptance Tests
- **Location**: This document
- **Coverage**: User workflows and acceptance criteria

## 🔧 Running Tests

### Smart Contract Tests

```bash
cd move/medvault
aptos move test
```

### Frontend Tests

```bash
cd frontend/medvault
npm test
npm run test:coverage
```

### Integration Tests

```bash
./scripts/run-integration-tests.sh
```

## 📋 Manual Acceptance Test Cases

### Test Case 1: Organization & Doctor Lifecycle

**Objective**: Verify organization creation and doctor management functionality

**Preconditions**:
- Admin account with sufficient APT balance
- Aptos network accessible

**Steps**:
1. **Admin connects Petra wallet**
   - Navigate to `/admin`
   - Connect Petra wallet
   - Verify wallet address displayed in header

2. **Create organization**
   - Click "Create Organization"
   - Enter org ID: `test_hospital_001`
   - Enter org name: `Test Hospital`
   - Submit transaction
   - **Expected**: Transaction succeeds, organization created event emitted

3. **Register doctor**
   - Click "Register Doctor"
   - Enter doctor address: `0x{doctor_wallet_address}`
   - Enter doctor handle: `Dr. Test Smith`
   - Enter license hash: `MD-TEST-123`
   - Submit transaction
   - **Expected**: Doctor registered with active=false, DoctorRegistered event emitted

4. **Activate doctor**
   - Find doctor in doctors list
   - Click "Activate"
   - Submit transaction
   - **Expected**: Doctor status changes to active=true, DoctorStatusChanged event emitted

5. **Verify doctor status**
   - Call `is_doctor_active(doctor_address)` view function
   - **Expected**: Returns true

**Acceptance Criteria**:
- ✅ Organization created successfully
- ✅ Doctor registered and activated
- ✅ Events emitted correctly
- ✅ Admin can only manage doctors, not patient data

---

### Test Case 2: Medical Record Creation & NFT Minting

**Objective**: Verify encrypted medical record creation and NFT minting

**Preconditions**:
- Active doctor account
- Patient account with registered public key
- Web3.storage token configured

**Steps**:
1. **Doctor connects and navigates to create report**
   - Connect doctor wallet
   - Navigate to `/doctor/create-report`
   - Verify doctor is authenticated and active

2. **Fill medical record form**
   - Patient wallet: `{patient_address}`
   - Patient name: `Test Patient`
   - Age: `30`
   - Disease: `Hypertension`
   - Prescription: `Lisinopril 10mg daily`
   - Observations: `Blood pressure elevated`
   - Vital signs: BP=`140/90`, HR=`75`
   - Doctor notes: `Follow up in 3 months`
   - File type: `PDF`
   - Upload test PDF file

3. **Submit record creation**
   - Click "Create Record"
   - **Expected**: 
     - Data encrypted client-side
     - Encrypted blob uploaded to IPFS
     - Record ID generated deterministically
     - Wrapped key created for patient
     - `create_record` transaction submitted
     - Soulbound NFT minted to patient
     - RecordCreated event emitted

4. **Verify record creation**
   - Check transaction hash in explorer
   - Verify NFT minted to patient address
   - Call `get_record_header(record_id)` view function
   - **Expected**: Record header contains correct metadata

5. **Verify patient record index**
   - Call `list_records_of(patient_address)`
   - **Expected**: Record ID appears in patient's record list

6. **Verify wrapped key storage**
   - Call `get_wrapped_key(record_id, patient_address)`
   - **Expected**: Returns wrapped key bytes

**Acceptance Criteria**:
- ✅ Medical record encrypted and uploaded to IPFS
- ✅ Blockchain record created with correct metadata
- ✅ Soulbound NFT minted to patient
- ✅ Wrapped key stored for patient access
- ✅ Record appears in patient's index

---

### Test Case 3: Patient Record Access & Decryption

**Objective**: Verify patient can view and decrypt their medical records

**Preconditions**:
- Patient account with registered private key
- At least one medical record created for patient
- Frontend encryption utilities functional

**Steps**:
1. **Patient connects and views timeline**
   - Connect patient wallet
   - Navigate to `/patient`
   - **Expected**: Timeline shows all patient's records

2. **Decrypt and view record**
   - Click on specific record
   - **Expected**:
     - Wrapped key retrieved from blockchain
     - Key unwrapped using patient's private key
     - Encrypted data fetched from IPFS
     - Data decrypted client-side
     - Original medical record displayed

3. **Verify data integrity**
   - Compare decrypted data with original input
   - **Expected**: Binary equality (data unchanged)

4. **View NFT certificate**
   - Check NFT status in record details
   - **Expected**: NFT address and metadata displayed

**Acceptance Criteria**:
- ✅ Patient can view all their records
- ✅ Decryption works correctly
- ✅ Original data integrity maintained
- ✅ NFT certificate visible

---

### Test Case 4: Access Granting & Cross-Doctor Access

**Objective**: Verify patient can grant access to doctors and doctors can access granted records

**Preconditions**:
- Patient with existing medical records
- Second doctor (Doctor B) with registered public key
- Original doctor (Doctor A) created the record

**Steps**:
1. **Patient grants access to Doctor B**
   - Navigate to record access management
   - Enter Doctor B's wallet address
   - **Expected**:
     - Doctor B's public key fetched from blockchain
     - Symmetric key wrapped for Doctor B
     - `grant_access` transaction submitted
     - AccessGranted event emitted

2. **Verify access granted**
   - Call `get_wrapped_key(record_id, doctor_b_address)`
   - **Expected**: Returns wrapped key for Doctor B

3. **Doctor B accesses record**
   - Doctor B connects to doctor portal
   - Searches for patient by wallet address
   - Views patient's timeline
   - Clicks on granted record
   - **Expected**:
     - Record decrypts successfully
     - Full medical data visible to Doctor B

4. **Verify access control**
   - Doctor B tries to access non-granted records
   - **Expected**: Cannot decrypt, shows "Access required"

**Acceptance Criteria**:
- ✅ Patient can grant access to specific doctors
- ✅ Granted doctors can decrypt records
- ✅ Non-granted doctors cannot access records
- ✅ Access events logged correctly

---

### Test Case 5: Access Revocation

**Objective**: Verify patient can revoke doctor access to records

**Preconditions**:
- Doctor B has been granted access to patient's record
- Doctor B can currently decrypt the record

**Steps**:
1. **Patient revokes access**
   - Navigate to access management
   - Find Doctor B in access list
   - Click "Revoke Access"
   - Submit transaction
   - **Expected**: AccessRevoked event emitted

2. **Verify access removed**
   - Call `get_wrapped_key(record_id, doctor_b_address)`
   - **Expected**: Returns null/none

3. **Doctor B cannot access record**
   - Doctor B tries to decrypt record
   - **Expected**: Decryption fails, shows "Access revoked"

**Acceptance Criteria**:
- ✅ Patient can revoke access
- ✅ Revoked doctors cannot decrypt records
- ✅ Access revocation logged

---

### Test Case 6: Record Revocation

**Objective**: Verify patient can revoke entire medical records

**Preconditions**:
- Patient with at least one active medical record
- Record is currently accessible

**Steps**:
1. **Patient revokes record**
   - Navigate to record management
   - Click "Revoke Record"
   - Confirm action
   - Submit transaction
   - **Expected**: RecordRevoked event emitted

2. **Verify record marked as revoked**
   - Call `get_record_header(record_id)`
   - **Expected**: `revoked` field = true

3. **Verify decryption blocked**
   - Patient tries to decrypt revoked record
   - **Expected**: Shows "Record revoked" message

4. **Verify public verification shows revoked status**
   - Navigate to `/verify/{record_id}`
   - **Expected**: Shows record as revoked

**Acceptance Criteria**:
- ✅ Patient can revoke records
- ✅ Revoked records marked correctly
- ✅ Decryption blocked for revoked records
- ✅ Public verification shows revoked status

---

### Test Case 7: Admin Access Limitations

**Objective**: Verify organization admins cannot access patient data

**Preconditions**:
- Admin account
- Patient records exist in the system

**Steps**:
1. **Admin attempts to decrypt patient record**
   - Admin tries to call wrapped key functions
   - **Expected**: No wrapped keys exist for admin

2. **Admin attempts to modify patient record**
   - Admin tries to call patient-only functions
   - **Expected**: Transactions fail with permission errors

3. **Admin can only manage doctors**
   - Admin can register/activate/deactivate doctors
   - Admin can view audit logs for organization
   - **Expected**: Only organizational functions accessible

**Acceptance Criteria**:
- ✅ Admins cannot access patient medical data
- ✅ Admins cannot modify patient records
- ✅ Admins can only manage organizational functions

---

### Test Case 8: Public Verification

**Objective**: Verify public record verification functionality

**Preconditions**:
- At least one medical record with NFT minted
- Record ID available

**Steps**:
1. **Navigate to verification page**
   - Go to `/verify`
   - Enter record ID
   - **Expected**: Record header displayed

2. **Verify displayed information**
   - Check issuing doctor handle
   - Check issuing organization
   - Check creation date
   - Check file type
   - Check NFT token address
   - **Expected**: All non-sensitive metadata visible

3. **Verify sensitive data not exposed**
   - Confirm no patient PII visible
   - Confirm no medical content visible
   - **Expected**: Only public metadata shown

4. **Verify NFT certificate**
   - Check NFT explorer link
   - Verify token properties
   - **Expected**: NFT exists and is soulbound

**Acceptance Criteria**:
- ✅ Public can verify record authenticity
- ✅ Only non-sensitive metadata exposed
- ✅ NFT certificate verifiable
- ✅ Sensitive data remains private

---

## 🎯 Performance & Security Tests

### Load Testing
- Multiple concurrent record creations
- Bulk access grant/revoke operations
- Large file uploads to IPFS

### Security Testing
- Invalid signature attempts
- Unauthorized access attempts
- Key tampering scenarios
- Replay attack prevention

### Browser Compatibility
- Chrome, Firefox, Safari, Edge
- Mobile browser testing
- Petra wallet integration testing

## 📊 Test Execution Tracking

| Test Case | Status | Executed By | Date | Notes |
|-----------|--------|-------------|------|-------|
| TC1: Org & Doctor Lifecycle | ⏳ Pending | | | |
| TC2: Record Creation & NFT | ⏳ Pending | | | |
| TC3: Patient Access | ⏳ Pending | | | |
| TC4: Access Granting | ⏳ Pending | | | |
| TC5: Access Revocation | ⏳ Pending | | | |
| TC6: Record Revocation | ⏳ Pending | | | |
| TC7: Admin Limitations | ⏳ Pending | | | |
| TC8: Public Verification | ⏳ Pending | | | |

## 🐛 Known Issues & Limitations

### Current Limitations
- Session storage for private keys (production needs secure key management)
- Limited file size for IPFS uploads (demo constraint)
- Single organization per admin (MVP limitation)

### Future Enhancements
- Hardware wallet support
- Multi-signature organization management
- Advanced search and filtering
- Bulk operations support

## 📝 Test Report Template

### Test Execution Summary
- **Date**: {date}
- **Tester**: {name}
- **Environment**: {devnet/testnet/mainnet}
- **Module Address**: {address}
- **Frontend URL**: {url}

### Results
- **Total Test Cases**: 8
- **Passed**: {count}
- **Failed**: {count}
- **Blocked**: {count}

### Issues Found
1. **Issue ID**: {id}
   - **Severity**: {High/Medium/Low}
   - **Description**: {description}
   - **Steps to Reproduce**: {steps}
   - **Expected vs Actual**: {comparison}

### Recommendations
- {recommendation 1}
- {recommendation 2}

---

**Test execution checklist complete when all test cases pass and acceptance criteria are met.**
