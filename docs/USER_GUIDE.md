# FraudGuard — Complete User Guide & Operational Manual

> **🌐 Live Application URL**: [https://fraudguard.rohanrastogi.in](https://fraudguard.rohanrastogi.in)  
> **📦 GitHub Repository**: [https://github.com/RohanRastogi1/FRAUDGUARD-AI-Powered-Fraud-Detection-System](https://github.com/RohanRastogi1/FRAUDGUARD-AI-Powered-Fraud-Detection-System)  
> **⚡ Local Environment**: `http://localhost:8080/fraudguard/`

---

## Table of Contents
1. [Introduction](#1-introduction)
2. [Getting Started & Authentication](#2-getting-started--authentication)
3. [Pre-Configured Demo Personas](#3-pre-configured-demo-personas)
4. [Customer Portal Guide](#4-customer-portal-guide)
5. [Fraud Analyst Operations](#5-fraud-analyst-operations)
6. [Executive Administration Portal](#6-executive-administration-portal)
7. [How to Trigger the 7 Fraud Detection Rules](#7-how-to-trigger-the-7-fraud-detection-rules)
8. [User Interface & Accessibility Features](#8-user-interface--accessibility-features)
9. [Troubleshooting & FAQ](#9-troubleshooting--faq)

---

## 1. Introduction

**FraudGuard** is an enterprise-grade financial intelligence and automated risk-scoring system designed to safeguard digital payment rails against emerging cyber fraud vectors in real time.

Built using **Jakarta Servlet 6.0**, **Core Java 25**, **JDBC**, **MySQL 8.0**, and **Vanilla CSS**, FraudGuard delivers millisecond-level behavioral anomaly detection, ACID transactional integrity, and transparent explainability without third-party web framework dependencies.

---

## 2. Getting Started & Authentication

### 2.1 Accessing the Platform
- **Production URL**: Navigate to [https://fraudguard.rohanrastogi.in](https://fraudguard.rohanrastogi.in)
- **Local Development**: Launch your local server using `start.bat` (Windows) or Tomcat startup script, then visit `http://localhost:8080/fraudguard/`

### 2.2 Sign-In Experience
The authentication screen features:
- **Glowing Animated Border**: A circulating radiant light beam and warm ambient aura.
- **Role-Based Access Control (RBAC)**: Sessions automatically route users to their respective operational portals upon login.
- **One-Click Persona Autofill**: Fast demo pills allow one-click login for academic demonstrations and live evaluations.

---

## 3. Pre-Configured Demo Personas

| Persona | Role | Username | Password | Purpose & Capabilities |
|---|---|---|---|---|
| **SuperAdmin** | `ADMIN` | `admin` | `password` | Complete system oversight, executive risk analytics, customer status management (Suspend/Lock/Activate), and audit trail inspection. |
| **Fraud Analyst** | `ANALYST` | `analyst` | `password` | Security incident triage, rule investigation, and manual alert review (Approve vs Reject flagged funds). |
| **John Doe** | `CUSTOMER` | `john_doe` | `password` | High-volume primary customer account with standard behavioral history. Initial Balance: **₹2,50,000.00**. |
| **Jane Smith** | `CUSTOMER` | `jane_smith` | `password` | Moderate-activity customer profile. Initial Balance: **₹1,50,000.00**. |
| **Bob Taylor** | `CUSTOMER` | `bob_taylor` | `password` | High-risk baseline profile used for rapid drain and velocity burst testing. Initial Balance: **₹50,000.00**. |

> *All passwords in demonstration environments are standardized to `password` (hashed via salted SHA-256 in MySQL).*

---

## 4. Customer Portal Guide

### 4.1 Customer Dashboard (`/dashboard`)
Upon signing in as a Customer (e.g., `john_doe`), users are presented with:
- **Live Account Balance**: Real-time liquidity reflected in INR (₹) / USD ($).
- **Recent Activity Ledger**: Last 5 transactions with color-coded status badges (`APPROVED`, `FLAGGED`, `REJECTED`).
- **Security Health Indicator**: Autonomous anomaly scoring engine status (`Engine Live`).
- **Quick Action Bar**: One-click navigation to Send Funds, History, Security Alerts, Architecture, and Documentation.

### 4.2 Initiating a Fund Transfer (`/transaction/new`)
1. Click **Send Funds** from the top navbar or dashboard quick actions.
2. Enter the **Recipient Account Number** (e.g., `ACC-998822`).
3. Enter the **Recipient Name** (e.g., `Amit Sharma`).
4. Enter the **Transfer Amount**.
5. Select the **Transfer Type** (`P2P_TRANSFER`, `BILL_PAYMENT`, `MERCHANT_CHECKOUT`, `INTERNATIONAL_WIRE`).
6. Enter an optional **Transfer Purpose / Reference Note**.
7. Click **Authorize & Send Funds**.

### 4.3 Transaction Decision & Receipt (`/transaction/result`)
Every transaction is evaluated in real time through the Fraud Detection Engine before committing database changes:
- **APPROVED (Risk Score 0–29)**: The transaction is atomicly debited from sender and credited to recipient. Instant approval receipt displayed.
- **MONITORED (Risk Score 30–59)**: Transaction processed with advisory risk logging.
- **FLAGGED (Risk Score 60–84)**: Funds held in pending review status. A High-Priority Security Alert is dispatched to Fraud Analysts.
- **REJECTED (Risk Score 85–100)**: Critical anomaly detected. Transaction is immediately aborted, balances are rolled back via ACID transaction isolation, and sender is shown the security reason.

### 4.4 Transaction History (`/transactions`)
- Search by transaction reference number or recipient name.
- Filter by status: `ALL`, `APPROVED`, `FLAGGED`, `REJECTED`.
- Detailed breakdown of timestamp, IP address, location, and risk scores.

---

## 5. Fraud Analyst Operations

### 5.1 Fraud Alert Incident Queue (`/admin/alerts`)
Analysts monitor real-time security alerts generated across all customer transactions:
- **Severity Badges**:
  - `CRITICAL` (Score 85–100): High Amount + Sanctions, Multiple rapid drains.
  - `HIGH` (Score 60–84): Velocity spikes, impossible travel anomalies.
  - `MEDIUM` (Score 30–59): Unusual hour transactions.
  - `LOW` (Score 0–29): Nominal behavioral variances.
- **Filter Tabs**: Toggle between `ALL`, `OPEN`, `UNDER_REVIEW`, `RESOLVED`, `FALSE_POSITIVE`.

### 5.2 Investigating an Incident
1. Click on an alert reference from the queue.
2. **Triggered Rules Breakdown**: View exactly which behavioral rules fired (e.g., `[HIGH_AMOUNT, VELOCITY_BURST, GEOGRAPHIC_ANOMALY]`).
3. **Transaction Context**: Inspect transaction timestamp, originating IP, device fingerprint, and customer history.
4. **Resolution Actions**:
   - **Approve (Release Funds)**: Overrides flag and marks alert as `RESOLVED`.
   - **Reject (Block Transfer)**: Confirms fraud, permanently rejects transaction, and flags customer.
   - **Add Investigation Notes**: Persist mandatory analyst commentary for compliance audit trails.

---

## 6. Executive Administration Portal

### 6.1 Executive Dashboard (`/admin/dashboard`)
Designed for C-suite and security leadership:
- **Total Processed Volume**: Aggregate financial throughput.
- **Live Fraud Rate**: Percentage of transactions flagged or blocked.
- **Active Fraud Alerts**: Real-time incident counts categorized by severity.
- **Rule Distribution Breakdown**: Interactive visualization of which fraud rules trigger most frequently.
- **Hourly Volume & Anomaly Trends**: Real-time throughput graph.

### 6.2 Transaction Monitor (`/admin/transactions`)
- Global ledger of every transaction passing through FraudGuard.
- Real-time search across all customer IDs, recipient accounts, and transaction references.
- Export-ready audit views for compliance reporting.

### 6.3 Customer Lifecycle & Account Management
Administrators can inspect customer profiles and modify status:
- **ACTIVE**: Customer in good standing; transfers permitted.
- **SUSPENDED**: Account temporarily frozen due to suspicious activity; transfer attempts automatically rejected.
- **LOCKED**: Account locked after security breach; requires administrative unlock.

---

## 7. How to Trigger the 7 Fraud Detection Rules

Use these specific test scenarios to demonstrate each behavioral rule during viva and live testing:

### Rule 1: High Amount Anomaly (`HIGH_AMOUNT`)
- **Trigger**: Transaction amount exceeding threshold (e.g., $> ₹1,00,000$ or $> $10,000$).
- **How to Test**: Sign in as `john_doe`, send **₹2,00,000.00** to any recipient.
- **Outcome**: Triggers high amount weight (+45 risk points). Score escalates to `HIGH` or `CRITICAL`.

### Rule 2: Velocity Spike Anomaly (`VELOCITY_BURST`)
- **Trigger**: More than 3 transactions initiated within a 5-minute rolling window.
- **How to Test**: Send 4 consecutive transactions of ₹5,000 within 2 minutes.
- **Outcome**: The 4th transaction triggers velocity burst (+35 risk points).

### Rule 3: Geographic Travel Anomaly (`GEOGRAPHIC_ANOMALY`)
- **Trigger**: Two consecutive transactions originating from geographically distant locations within an impossible physical transit window (speed $> 800\text{ km/h}$).
- **How to Test**: Send a transaction from `Mumbai, India`, then immediately submit another from `London, UK` or `New York, USA`.
- **Outcome**: Triggers impossible speed travel flag (+50 risk points).

### Rule 4: Sanctions & Blacklisted Account (`SANCTIONS_BLACKLIST`)
- **Trigger**: Recipient account matches known international sanctions lists or stolen-account blacklists.
- **How to Test**: Send any amount to recipient account `ACC-BLACK-001` or `ACC-SANCTION-99`.
- **Outcome**: Immediate `CRITICAL` rejection (Risk Score: 100). Balance debit aborted.

### Rule 5: Unusual Hours Anomaly (`UNUSUAL_HOURS`)
- **Trigger**: Transactions initiated between 01:00 AM and 05:00 AM local time for customers without nocturnal transaction history.
- **How to Test**: Submit a transaction during late-night hours or simulate nighttime server timestamp.
- **Outcome**: Triggers nocturnal behavioral anomaly (+20 risk points).

### Rule 6: Unrecognized New Device (`NEW_DEVICE`)
- **Trigger**: Transfer authorized from a previously unseen device fingerprint / user-agent.
- **How to Test**: Log in from a private / incognito browsing window or different device.
- **Outcome**: Triggers new hardware fingerprint flag (+25 risk points).

### Rule 7: Rapid Balance Drain (`RAPID_DRAIN`)
- **Trigger**: Transaction draining more than 80% of account balance in a single transaction or within 1 hour.
- **How to Test**: Sign in as `bob_taylor` (Balance: ₹50,000) and transfer **₹48,000**.
- **Outcome**: Triggers liquidity liquidation rule (+40 risk points).

---

## 8. User Interface & Accessibility Features

1. **Light / Dark Theme Toggle**:
   - High-contrast **Light Mode** by default (warm cream background, crisp obsidian cards, amber accents).
   - Cyberpunk **Dark Mode** toggleable via the concentric pill toggle in header.
   - Preference saved automatically to browser `localStorage`.

2. **Smooth Scroll to Top**:
   - Floating action button dynamically appears after scrolling 250px or reaching the bottom.
   - Powered by a custom cubic-bezier gliding animation for zero-jerk transitions.

3. **Responsive Mobile Drawer**:
   - Universal support across smartphones (320px–480px), tablets (768px), and 4K displays.
   - Collapsible slide-down drawer with dedicated quick links, theme switcher, and sign-out controls.

4. **Highlighted GitHub Integration**:
   - Glowing GitHub repository badges in navbar and footer linking to the official source repository.

---

## 9. Troubleshooting & FAQ

- **Database Connection Error**:
  Verify MySQL is running (`systemctl status mysql` or `services.msc` on Windows) and `src/main/resources/db.properties` credentials match.
- **Tomcat 404 on Root Context**:
  If deployed as `fraudguard.war`, navigate to `http://localhost:8080/fraudguard/`. If renamed to `ROOT.war`, navigate directly to `http://localhost:8080/`.
- **CSS Not Updating**:
  Perform a hard refresh (`Ctrl + Shift + R` or `Cmd + Shift + R`) to invalidate cached stylesheets.

---

*Authored by Rohan Rastogi & TeamRootOps &bull; Galgotias University*
