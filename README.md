# FraudGuard — AI-Powered Fraud Detection System

[![Java](https://img.shields.io/badge/Java-25%20LTS-orange.svg)](https://adoptium.net/)
[![Maven](https://img.shields.io/badge/Maven-3.10.0-blue.svg)](https://maven.apache.org/)
[![Tomcat](https://img.shields.io/badge/Tomcat-10.1.60-yellow.svg)](https://tomcat.apache.org/)
[![Servlet](https://img.shields.io/badge/Servlet-Jakarta%206.0-red.svg)](https://jakarta.ee/)
[![Database](https://img.shields.io/badge/Database-MySQL%208.0%2B-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

An enterprise-grade, real-time financial fraud detection and risk scoring engine built from the ground up using **Core Java**, **Jakarta Servlet 6.0**, **JDBC**, **MySQL**, and **Vanilla CSS**. Designed for high-throughput anomaly evaluation, ACID transaction integrity, and educational viva demonstration.

---

## 1. Problem Statement & Objectives

Modern digital payment networks process billions of financial events daily. Financial institutions face mounting threats from account takeovers, bot testing, impossible physical travel, sanctions evasion, and rapid balance liquidation. 

### Key Objectives
1. **Millisecond Anomaly Detection**: Evaluate incoming transactions across 7 modular behavioral rules in real time.
2. **ACID Financial Integrity**: Ensure atomic balance debits, credits, and transaction logging with automatic rollback on error.
3. **Role-Based Access Control**: Provide distinct, secured operational experiences for Customers, Fraud Analysts, and System Administrators.
4. **Viva-First Design**: Codebase structured specifically to demonstrate Core Java OOP, Collections, Multithreading, JDBC, and Servlets during academic evaluations.

---

## 2. System Architecture

```mermaid
graph TD
    Client["Web Browser / Client (JSP / Vanilla CSS)"] -->|HTTP GET / POST| Servlets["Jakarta Servlet 6.0 Layer"]
    Servlets -->|RBAC & Session Inspection| Filter["AuthenticationFilter"]
    Filter -->|Validated Request| Services["Service Layer (Auth, Tx, Fraud, Admin)"]
    Services -->|Context & Invariants| Engine["Fraud Detection Engine (Core Java)"]
    Engine -->|Rule Evaluation| Rules["Modular Fraud Rules (Strategy Pattern)"]
    Rules -->|Composite Score| Engine
    Services -->|ACID Atomic Transfer| DAO["DAO Layer (User, Tx, Alert, Audit)"]
    DAO -->|JDBC PreparedStatement| DB[(MySQL 8.0+ / InnoDB)]
```

---

## 3. Fraud Detection Flowchart

```mermaid
flowchart TD
    Start([Incoming Transaction]) --> Validate{Valid Invariants?}
    Validate -- No --> Error([Throw InvalidTransactionException])
    Validate -- Yes --> FetchHistory[Fetch User Behavioral History & Known Devices]
    FetchHistory --> ParallelRules[Evaluate Rules in Parallel / Sequence]
    
    subgraph Modular Fraud Rules
        R1[High Amount Rule]
        R2[Velocity Spike Rule]
        R3[Geographic Anomaly Rule]
        R4[Sanctions Blacklist Rule]
        R5[Unusual Hour Rule]
        R6[New Device Rule]
        R7[Rapid Balance Drain Rule]
    end
    
    ParallelRules --> R1 & R2 & R3 & R4 & R5 & R6 & R7
    R1 & R2 & R3 & R4 & R5 & R6 & R7 --> RiskCalc[RiskCalculator: Aggregate & Normalize Score 0-100]
    
    RiskCalc --> Decision{Risk Level?}
    Decision -- "CRITICAL (>= 85)" --> Reject[Status: REJECTED\nGenerate Critical Alert\nRollback Transfer]
    Decision -- "HIGH (60 - 84)" --> Flag[Status: FLAGGED\nGenerate Investigation Alert\nHold for Analyst Review]
    Decision -- "MEDIUM (30 - 59)" --> Monitor[Status: APPROVED\nGenerate Advisory Flag\nCommit Balance Debit]
    Decision -- "LOW (0 - 29)" --> Approve[Status: APPROVED\nCommit Balance Debit]
    
    Reject & Flag & Monitor & Approve --> End([Persist & Log Audit Trail])
```

---

## 4. Entity-Relationship (ER) Diagram

```mermaid
erDiagram
    USERS ||--o{ TRANSACTIONS : initiates
    USERS ||--o{ FRAUD_ALERTS : targets
    USERS ||--o{ AUDIT_LOGS : triggers
    TRANSACTIONS ||--o| FRAUD_ALERTS : produces

    USERS {
        bigint id PK
        varchar username UK
        varchar password_hash
        varchar email UK
        varchar full_name
        enum role
        enum status
        decimal balance
        timestamp created_at
    }

    TRANSACTIONS {
        bigint id PK
        varchar transaction_ref UK
        bigint user_id FK
        decimal amount
        varchar currency
        varchar recipient_account
        varchar recipient_name
        enum type
        enum status
        varchar location
        varchar ip_address
        varchar device_fingerprint
        int risk_score
        enum risk_level
        text notes
        timestamp created_at
    }

    FRAUD_ALERTS {
        bigint id PK
        bigint transaction_id FK
        varchar transaction_ref
        bigint user_id FK
        decimal amount
        int risk_score
        enum risk_level
        varchar triggered_rules
        text reason
        enum status
        varchar reviewed_by
        text review_notes
        timestamp created_at
    }

    AUDIT_LOGS {
        bigint id PK
        bigint user_id
        varchar username
        varchar action
        varchar entity_type
        bigint entity_id
        text details
        varchar ip_address
        timestamp created_at
    }
```

---

## 5. Class Diagram

```mermaid
classDiagram
    class User {
        -Long id
        -String username
        -String passwordHash
        -String email
        -String fullName
        -Role role
        -UserStatus status
        -BigDecimal balance
        +canTransact() boolean
        +isAdmin() boolean
        +isAnalyst() boolean
    }

    class Transaction {
        -Long id
        -String transactionRef
        -Long userId
        -BigDecimal amount
        -TransactionStatus status
        -RiskLevel riskLevel
        -Integer riskScore
        +validate() void
    }

    class FraudRule {
        <<interface>>
        +getRuleName() String
        +getDefaultWeight() int
        +evaluate(tx, user, context) RuleEvaluation
    }

    class HighAmountRule {
        +evaluate(tx, user, context) RuleEvaluation
    }

    class BlacklistAccountRule {
        -Set~String~ blacklistedAccounts
        +evaluate(tx, user, context) RuleEvaluation
    }

    class VelocityRule {
        +evaluate(tx, user, context) RuleEvaluation
    }

    class FraudDetector {
        -List~FraudRule~ rules
        -RiskCalculator riskCalculator
        +evaluate(tx, user, context) RiskScore
        +generateAlertIfNeeded(tx, score) FraudAlert
    }

    class TransactionProcessor {
        -ExecutorService executorService
        -AtomicLong totalProcessed
        +process(tx, user) ProcessingResult
        +submitAsync(tx, user) Future
    }

    FraudRule <|.. HighAmountRule
    FraudRule <|.. BlacklistAccountRule
    FraudRule <|.. VelocityRule
    FraudDetector o-- FraudRule
    TransactionProcessor o-- FraudDetector
```

---

## 6. Pre-Configured Demonstration Accounts

| Role | Username | Password | Purpose | Initial Balance |
|---|---|---|---|---|
| **System Administrator** | `admin` | `Admin@123` | Executive KPI analytics, user status changes, audit logs | $0.00 |
| **Fraud Analyst** | `analyst` | `Analyst@123` | Alert investigation triage, incident resolution | $0.00 |
| **Customer** | `john_doe` | `Customer@123` | Primary demonstration account for submitting transfers | $25,000.00 |
| **Customer** | `jane_smith` | `Customer@123` | Secondary customer account | $15,400.00 |
| **Customer** | `bob_taylor` | `Customer@123` | High-risk customer profile | $4,800.00 |

---

## 7. Installation & Running Instructions

### 7.1 Prerequisites
- **Java Development Kit (JDK)**: OpenJDK 25 LTS (or JDK 17+)
- **Build Tool**: Apache Maven 3.9+
- **Application Server**: Apache Tomcat 10.1.x (Jakarta EE 10 / Servlet 6.0 compatible)
- **Database**: MySQL 8.0+

### 7.2 Database Setup
1. Open your MySQL client or terminal:
   ```bash
   mysql -u root -p
   ```
2. Execute the schema script:
   ```sql
   SOURCE database/schema.sql;
   ```
3. Seed test records and initial accounts:
   ```sql
   SOURCE database/seed.sql;
   ```

### 7.3 Database Configuration
Copy the template configuration in `src/main/resources/db.properties.example` to `src/main/resources/db.properties`:
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/fraudguard_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
db.user=root
db.password=your_password
```
*(Alternatively, configure environment variables `DB_URL`, `DB_USER`, `DB_PASSWORD`)*

### 7.4 Building the Application
Run Maven to compile, execute all unit and integration test suites, and package the WAR:
```bash
mvn clean package
```
This generates:
```
target/fraudguard.war
```

### 7.5 Deployment to Apache Tomcat 10
1. Copy `target/fraudguard.war` to your Tomcat `webapps/` folder:
   ```bash
   cp target/fraudguard.war $CATALINA_HOME/webapps/
   ```
2. Start Tomcat:
   - **Linux / macOS**: `$CATALINA_HOME/bin/startup.sh`
   - **Windows**: `$CATALINA_HOME\bin\startup.bat`
3. Access FraudGuard in your browser:
   ```
   http://localhost:8080/fraudguard/
   ```

---

## 8. Automated Testing & Verification

The test suite runs 36 tests across 5 test suites with zero external dependencies (backed by in-memory H2 in MySQL compatibility mode):

```bash
mvn clean test
```

### Test Coverage Highlights:
- **`ModelTest`**: Validates encapsulation, role privileges, domain invariants, and risk score aggregation.
- **`FraudDetectionEngineTest`**: Evaluates individual rules (High Amount, Velocity bursts, Impossible Travel, Blacklists, Unusual Hours, Balance Drain) and multithreaded concurrency.
- **`SecurityUtilTest`**: Verifies salted SHA-256 cryptographic hashing and XSS sanitation.
- **`JdbcDaoTest`**: Validates CRUD and atomic ACID transaction rollbacks on insufficient funds.
- **`ServiceLayerTest`**: Tests business orchestration and service isolation.
- **`FullPipelineIntegrationTest`**: End-to-end customer registration, transaction scoring, alert triage, and score boundary tests.

---

## 9. Viva Explanation & Source Code Sitemap

For in-depth explanations of every Core Java, JDBC, and Servlet concept used throughout the project, refer to:
[docs/IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)
