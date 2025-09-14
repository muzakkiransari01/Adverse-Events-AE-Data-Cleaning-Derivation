Clinical SAS Project 2 – Adverse Events (AE) Data Cleaning & Derivation

Project Overview
This project demonstrates the cleaning, standardization, and derivation of an Adverse Events (AE) dataset in a clinical trial.  
The workflow follows CDISC SDTM AE domain standards, ensuring consistency, traceability, and analysis readiness.

📂 Datasets
- adverse_ae.csv → Raw AE dataset (messy patient IDs, inconsistent terms, mixed date formats).  
- ae_final.csv → Cleaned dataset, mapped to SDTM variables.  
- ae_final_deriv.csv → Final dataset with derived variables.  

🔧 Steps Performed
1. Import raw AE dataset using PROC IMPORT.  
2. Cleaning & Standardization  
   - Patient ID standardized to `P###` → USUBJID.  
   - AE Terms corrected for typos, proper case applied → AEDECOD.  
   - Start/End dates standardized to SAS DATE9 format → AESDTC, AEENDTC.  
   - Seriousness mapped to YES/NO/UNK → AESER.  
   - Outcomes mapped to RECOVERED / ONGOING / NOT RECOVERED / FATAL → AEOUT.  
   - Action Taken standardized to NONE / DOSE REDUCED / DRUG WITHDRAWN → AEACN.  
   - Relation to study drug mapped to RELATED / NOT RELATED / POSSIBLE / UNLIKELY / UNKNOWN → AEREL.  
3. Renaming variables for SDTM compliance.  
4. Derivations  
   - Duration = AEENDTC – AESDTC + 1.  
   - AESERFL = Flag if AE is Serious.  
   - AEONGOFL = Flag if AE is Ongoing (no AEENDTC).  

Outputs
- `ae_final.csv` → Cleaned SDTM-aligned AE dataset.  
- `ae_final_deriv.csv` → Derived dataset with Duration and flags.  


🛠️ Tools Used
- SAS 9.4 (DATA step, PROC IMPORT, PROC EXPORT, PROC PRINT, PROC FREQ).  

👤 Author
Muzakkir Ansari 
B.Sc. Statistics, 2024 | Mumbai, India  
📧 muzakkiransari001@gmail.com

