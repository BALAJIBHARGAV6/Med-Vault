# MedVault Demo Script (2-3 Minutes)

This script provides a step-by-step guide for demonstrating MedVault's core functionality in a live presentation.

## 🎬 Demo Overview

**Total Time**: 2-3 minutes  
**Audience**: Technical stakeholders, healthcare professionals, investors  
**Goal**: Showcase privacy-first medical records with blockchain security  

## 🎯 Demo Flow

### Setup (Before Demo)
- All accounts funded and ready
- Smart contracts deployed on testnet
- Frontend deployed and accessible
- Sample data prepared
- Browser windows positioned

---

### **Scene 1: Admin Setup (10 seconds)**

**Narrator**: *"Let's start with a hospital administrator setting up their organization."*

**Actions**:
1. **[Admin Portal]** - Navigate to `/admin`
2. **[Connect Wallet]** - Connect Petra wallet (pre-connected)
3. **[Quick View]** - Show org already created with "General Hospital"
4. **[Doctor Management]** - Show Dr. Alice Smith registered and activated

**Key Points**:
- Organizations manage their doctor verification
- Admins cannot access patient data
- Doctor activation ensures credentialing

---

### **Scene 2: Medical Record Creation (50 seconds)**

**Narrator**: *"Now Dr. Alice creates an encrypted medical record for a patient."*

**Actions**:
1. **[Doctor Portal]** - Navigate to `/doctor/create-report`
2. **[Patient Info]** - Enter patient wallet address (paste pre-copied)
3. **[Medical Data]** - Fill form quickly:
   - Patient: "John Doe" 
   - Condition: "Hypertension"
   - Prescription: "Lisinopril 10mg daily"
   - Vital Signs: "BP: 140/90, HR: 75"
   - Notes: "Follow up in 3 months"
4. **[File Upload]** - Upload sample PDF report (pre-selected)
5. **[Submit]** - Click "Create Record"

**During Processing** (while transaction processes):
- **Explain**: "Data encrypted client-side with AES"
- **Explain**: "Encrypted blob uploaded to IPFS"
- **Explain**: "Record metadata stored on Aptos blockchain"

6. **[Success]** - Show transaction hash and minted NFT
7. **[QR Code]** - Show record verification QR code

**Key Points**:
- Client-side encryption preserves privacy
- IPFS provides decentralized storage
- Soulbound NFT provides authenticity
- Patient receives the NFT, not the doctor

---

### **Scene 3: Patient Access (30 seconds)**

**Narrator**: *"The patient can now view and decrypt their medical record."*

**Actions**:
1. **[Patient Portal]** - Navigate to `/patient` (switch browser/tab)
2. **[Connect Patient Wallet]** - Connect patient's Petra wallet
3. **[Timeline View]** - Show medical records timeline
4. **[New Record]** - Highlight the new record from Dr. Alice
5. **[Decrypt]** - Click to open and decrypt the record
6. **[Full View]** - Show decrypted medical data and attached PDF

**Key Points**:
- Patient sees records from all organizations
- Only patient can decrypt their data initially
- Original data integrity maintained
- NFT certificate visible

---

### **Scene 4: Access Granting (20 seconds)**

**Narrator**: *"The patient can grant access to other doctors as needed."*

**Actions**:
1. **[Access Management]** - Click "Grant Access" button
2. **[Doctor Selection]** - Enter Dr. Bob Johnson's wallet address (paste)
3. **[Key Wrapping]** - Show system wrapping encryption key for Dr. Bob
4. **[Grant Transaction]** - Submit grant access transaction
5. **[Confirmation]** - Show "Access granted to Dr. Bob" message

**Key Points**:
- Patient controls all access permissions
- Cryptographic key wrapping ensures security
- Doctor-specific access keys generated

---

### **Scene 5: Cross-Doctor Access (30 seconds)**

**Narrator**: *"Dr. Bob can now access the patient's record with permission."*

**Actions**:
1. **[Doctor Portal]** - Switch to Dr. Bob's session
2. **[Patient Search]** - Search for patient by wallet address
3. **[Timeline View]** - Show patient's medical timeline
4. **[Access Record]** - Click on Dr. Alice's record
5. **[Decrypt Success]** - Show decrypted record with full medical data
6. **[Cross-Org Access]** - Highlight that Dr. Bob can see records from other doctors/orgs

**Key Points**:
- Cross-organizational medical history access
- Doctors see complete patient timeline with permissions
- Seamless care coordination

---

### **Scene 6: Access Revocation (20 seconds)**

**Narrator**: *"The patient maintains full control and can revoke access anytime."*

**Actions**:
1. **[Patient Portal]** - Return to patient interface
2. **[Access Management]** - View current access permissions
3. **[Revoke Access]** - Click "Revoke" next to Dr. Bob's access
4. **[Confirmation]** - Submit revocation transaction
5. **[Verification]** - Show Dr. Bob can no longer decrypt the record

**Key Points**:
- Patient retains full control over their data
- Instant access revocation
- Previous access doesn't compromise future privacy

---

### **Scene 7: Public Verification (10 seconds)**

**Narrator**: *"Anyone can verify record authenticity without accessing private data."*

**Actions**:
1. **[Verify Page]** - Navigate to `/verify`
2. **[Record ID]** - Enter the record ID from earlier
3. **[Public Info]** - Show public metadata:
   - Issuing doctor: Dr. Alice Smith
   - Organization: General Hospital
   - Date created
   - NFT token address
   - File type
4. **[Privacy Preserved]** - Highlight that no medical data is visible

**Key Points**:
- Public verification without privacy compromise
- NFT provides tamper-proof authenticity
- Transparency with privacy protection

---

## 🎤 Key Messages for Audience

### **Privacy & Security**
- "All medical data encrypted client-side before leaving the patient's device"
- "Patients control who can access their records using cryptographic keys"
- "Hospital admins manage doctors but cannot access patient data"

### **Blockchain Benefits**
- "Immutable audit trails on Aptos blockchain"
- "Soulbound NFTs provide tamper-proof certificates"
- "Decentralized storage prevents single points of failure"

### **Healthcare Value**
- "Cross-organizational medical history access with patient permission"
- "Reduces duplicate tests and improves care coordination"  
- "Patient-controlled access eliminates data silos"

### **Technical Innovation**
- "Combines blockchain security with client-side encryption"
- "IPFS ensures data availability without vendor lock-in"
- "Smart contracts enforce access policies automatically"

---

## 🛠 Demo Preparation Checklist

### **Pre-Demo Setup** (30 minutes before)
- [ ] Deploy smart contracts to testnet
- [ ] Deploy frontend to staging environment  
- [ ] Fund all demo accounts with APT tokens
- [ ] Create General Hospital organization
- [ ] Register and activate Dr. Alice and Dr. Bob
- [ ] Prepare patient account with encryption keys
- [ ] Test full demo flow once
- [ ] Prepare browser bookmarks for quick navigation
- [ ] Set up screen sharing/projection

### **Demo Materials**
- [ ] Sample PDF medical report (< 1MB)
- [ ] Pre-copied wallet addresses for quick pasting
- [ ] Browser tabs pre-opened to correct pages
- [ ] Backup demo environment in case of issues
- [ ] Transaction hashes ready for explorer verification

### **Contingency Plans**
- [ ] Backup recording of successful demo run
- [ ] Static screenshots showing key interfaces
- [ ] Pre-deployed demo data if live creation fails
- [ ] Explanation script if blockchain is slow

---

## 📱 Mobile Demo Variation (Optional)

For mobile/tablet demonstrations:

1. **Show Petra mobile wallet integration**
2. **Demonstrate QR code scanning for record access**
3. **Highlight mobile-first patient experience**
4. **Show responsive design across devices**

---

## 🗣 Speaking Notes

### **Opening** (5 seconds)
*"Healthcare data is trapped in silos, but patients should control their medical records. Let me show you MedVault - a blockchain solution that gives patients full control while enabling seamless care coordination."*

### **Closing** (15 seconds)  
*"MedVault demonstrates how blockchain can revolutionize healthcare by combining security, privacy, and interoperability. Patients control their data, doctors get comprehensive medical histories, and organizations maintain compliance - all while preserving privacy through cryptographic access controls."*

---

## 🎥 Recording Tips

- **Use 1080p resolution minimum**
- **Enable clear audio narration**
- **Highlight cursor movements and clicks**
- **Show loading states briefly**
- **Capture transaction confirmations**
- **Include blockchain explorer views**

---

**Demo success criteria: Audience understands the value proposition and technical innovation while seeing live functionality.**
