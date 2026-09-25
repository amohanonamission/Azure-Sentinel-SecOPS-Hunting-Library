# Microsoft Sentinel SecOps: Threat Hunting & SOAR Library

🎯 **Focus:** Microsoft Sentinel • KQL Threat Hunting • SOAR (Logic Apps) • MITRE ATT&CK • Continuous Monitoring

## Objective
A structured library of Kusto Query Language (KQL) detection rules and Security Orchestration, Automation, and Response (SOAR) playbook architectures designed for Microsoft Sentinel. 

This repository demonstrates the ability to translate raw Azure telemetry (Identity, Network, Platform logs) into actionable, high-fidelity security alerts mapped to the MITRE ATT&CK framework, and automate the subsequent incident response lifecycle.

---

## 🧠 Threat Hunting Library (KQL)

The query library focuses on identifying "living off the land" techniques, identity compromise, and network reconnaissance. 

| Category | Query File | MITRE ATT&CK Mapping | Description |
| :--- | :--- | :--- | :--- |
| **Identity** | `MFA-Fatigue-Detection.kql` | T1621 (MFA Request Gen) | Detects rapid, consecutive MFA failures followed by a suspicious success, indicating an attacker successfully spammed push notifications. |
| **Identity** | `Impossible-Travel.kql` | T1078 (Valid Accounts) | Correlates Entra ID Sign-in logs to detect logins from geographically impossible distances within a short timeframe. |
| **Network** | `NSG-Brute-Force-Spike.kql` | T1110 (Brute Force) | Analyzes AzureDiagnostics to detect massive spikes in blocked perimeter traffic targeting SSH/RDP ports. |

---

## ⚡ SOAR: Automated Incident Response (Playbook Library)

Detecting a threat is only half the battle. This project architects automated Azure Logic App playbooks to reduce Mean Time to Remediate (MTTR) to near zero.

### Architecture: How it Works
1. **Detection:** Sentinel Analytics Rules identify a threat (using the KQL library above).
2. **Trigger:** Sentinel triggers an automation rule linked to a Logic App Playbook.
3. **Authentication:** The Logic App authenticates using a **System-Assigned Managed Identity** (zero stored credentials) utilizing Least Privilege RBAC (e.g., `Network Contributor`).
4. **Response:** The playbook executes automated remediation logic without human intervention.

### Automated Playbooks (The Workflow Library)

| Playbook Name | Trigger Alert | Automated Action |
| :--- | :--- | :--- |
| `Incident-Enrichment` | Any New Incident | Fetches IP reputation from VirusTotal and adds it as a comment to the Sentinel incident. |
| `Compromised-User-Lockdown` | "Impossible Travel" | Automatically disables the user account in Entra ID and revokes all active refresh tokens. |
| `Brute-Force-Blocker` | Multiple Failed Logins | Adds the attacking Source IP to a "Blocked" NSG (Network Security Group) rule automatically. |

> **Security Note:** The IaC templates in `/SOAR-Playbooks` deploy these workflows to rely strictly on Managed Identities for Azure Resource Manager (ARM) interaction, ensuring no Service Principal secrets are exposed in the JSON logic.

---

## 🏗️ Repository Structure

```text

├── Identity-Threats/
│   ├── MFA-Fatigue-Detection.kql
│   └── Impossible-Travel-Login.kql
├── Network-Threats/
│   ├── NSG-Brute-Force-Spike.kql
├── SOAR-Playbooks/
│   └── Block-IP-LogicApp-Template.json
└── README.md

```
---

## 📌 SecOps Use Case 
This repository serves as a practical implementation guide for modern Security Operations Center (SOC) workflows. It emphasizes:
*   **Detection Engineering:** Writing optimized, time-binned queries for high-volume log spaces.
*   **Identity Governance:** Recognizing telemetry indicators of compromised Entra ID mechanisms.
*   **Infrastructure Defense:** Using automation to close the loop between detection and perimeter defense.




# Microsoft Sentinel SecOps: Threat Hunting & SOAR Library

🎯 **Focus:** Microsoft Sentinel • KQL Threat Hunting • SOAR (Logic Apps) • MITRE ATT&CK • Continuous Monitoring

## Objective
A structured library of Kusto Query Language (KQL) detection rules and Security Orchestration, Automation, and Response (SOAR) playbook architectures designed for Microsoft Sentinel. 

This repository demonstrates the ability to translate raw Azure telemetry (Identity, Network, Platform logs) into actionable, high-fidelity security alerts mapped to the MITRE ATT&CK framework, and automate the subsequent incident response lifecycle.

## 🧠 Threat Hunting Library (KQL)

The query library focuses on identifying "living off the land" techniques, identity compromise, and network reconnaissance. 

| Category | Query File | MITRE ATT&CK Mapping | Description |
| :--- | :--- | :--- | :--- |
| **Identity** | `MFA-Fatigue-Detection.kql` | T1621 (MFA Request Gen) | Detects rapid, consecutive MFA failures followed by a suspicious success, indicating an attacker successfully spammed push notifications. |
| **Identity** | `Impossible-Travel.kql` | T1078 (Valid Accounts) | Correlates Entra ID Sign-in logs to detect logins from geographically impossible distances within a short timeframe. |
| **Network** | `NSG-Brute-Force-Spike.kql` | T1110 (Brute Force) | Analyzes AzureDiagnostics to detect massive spikes in blocked perimeter traffic targeting SSH/RDP ports. |

## ⚡️ SOAR: Automated Incident Response

Detecting a threat is only half the battle. This project architects automated Azure Logic App playbooks to reduce Mean Time to Remediate (MTTR) to near zero.

**The Automation Architecture:**
1. **Trigger:** A Sentinel Analytics Rule fires based on the KQL detection logic above.
2. **Authentication:** The Logic App authenticates using a System-Assigned Managed Identity (zero stored credentials) utilizing Least Privilege RBAC (e.g., `Network Contributor` for NSG updates).
3. **Execution:** The playbook executes automated remediation logic without human intervention.

**Playbook Blueprints:**
*   **Compromised-User-Lockdown:** Triggers on "Impossible Travel." Automatically communicates with the Microsoft Graph API to disable the Entra ID user and revoke all active refresh tokens.
*   **Brute-Force-Blocker:** Triggers on NSG drop spikes. Automatically appends the attacking IP address to a centralized Deny-List on the perimeter Azure Firewall / NSG.

## 🏗️ Repository Structure

```text

├── Identity-Threats/
│   ├── MFA-Fatigue-Detection.kql
│   └── Impossible-Travel-Login.kql
├── Network-Threats/
│   ├── NSG-Brute-Force-Spike.kql
├── SOAR-Playbooks/
│   └── Block-IP-LogicApp-Template.json
└── README.md

```

## 📌 SecOps Use Case & Exam Alignment
This repository serves as a practical implementation guide for modern Security Operations Center (SOC) workflows and aligns directly with the objectives of the **Microsoft SC-500 (Cybersecurity Architect / Security Operations)** certification track. 

It emphasizes:
*   **Detection Engineering:** Writing optimized, time-binned queries for high-volume log spaces.
*   **Identity Governance:** Recognizing telemetry indicators of compromised Entra ID mechanisms.
*   **Infrastructure Defense:** Using automation to close the loop between detection and perimeter defense.
