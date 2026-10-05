# FraudGuard — Complete Implementation Summary & Viva Defense Guide

This document provides a comprehensive mapping of every core Java, JDBC, Servlet, Database, and Testing concept implemented across the **FraudGuard AI-Powered Fraud Detection System**.
It is specifically designed for college/university vivas, code reviews, and architectural evaluations.

---

## 1. Quick Reference Matrix

| Architectural Layer | Key Classes & Interfaces | Core Java / Enterprise Concept |
|---|---|---|
| **Domain Models** | `User`, `Transaction`, `FraudAlert`, `RiskScore`, `AuditLog` | OOP Encapsulation, Immutability, Enums, Serializable |
| **Fraud Detection Engine** | `FraudDetector`, `FraudRule`, `RiskCalculator`, `RuleEvaluation` | Strategy Pattern, Polymorphism, Abstraction |
| **Concurrency Pipeline** | `TransactionProcessor` | `ExecutorService`, `Future`, `Callable`, `AtomicLong`, `ThreadFactory` |
| **In-Memory Cache & Rules** | `TransactionContext`, `BlacklistAccountRule` | Java Collections (`ConcurrentHashMap`, `CopyOnWriteArrayList`, `Set`) |
| **Exception Hierarchy** | `FraudGuardException`, `InvalidTransactionException`, `DatabaseException` | Checked/Unchecked Exception Handling, Error Codes |
| **Security Layer** | `SecurityUtil`, `AuthenticationFilter` | Salted SHA-256 Hashing, SecureRandom, XSS Sanitization, RBAC |
| **Persistence (JDBC/DAO)** | `DatabaseConnection`, `UserDAOImpl`, `TransactionDAOImpl`, `FraudAlertDAOImpl` | JDBC, `PreparedStatement`, `ResultSet`, Try-With-Resources |
| **Transaction Management** | `TransactionDAOImpl.executeAtomicTransfer` | ACID Atomicity: `setAutoCommit(false)`, `commit()`, `rollback()` |
| **Web & Servlets** | `LoginServlet`, `TransactionServlet`, `DashboardServlet`, `AdminDashboardServlet` | Jakarta Servlet 6.0, `HttpServletRequest/Response`, `HttpSession` |
| **Database Schema** | `database/schema.sql`, `database/seed.sql` | Relational 3NF, Foreign Keys, B-Tree Indexes, InnoDB Engine |
| **Automated Testing** | 36 unit/integration tests across 5 suites | JUnit 5 Jupiter, H2 In-Memory DB, Multi-Threaded Stress Tests |

---

## 2. Core Java Concepts Breakdown

### 2.1 Object-Oriented Programming (OOP)
- **Encapsulation**:
  - All domain model fields are `private` (`User`, `Transaction`, `FraudAlert`, `RiskScore`).
  - Access is mediated exclusively through strictly validated getters and setters.
  - Sensitive fields (e.g. `passwordHash`) are excluded from `toString()` representations to eliminate logging leaks.
  - Lists and maps in `RiskScore` and `TransactionContext` are protected via defensive copying (`Collections.unmodifiableList()`, `Collections.unmodifiableMap()`).
- **Abstraction**:
  - The `FraudRule` interface defines the core behavioral contract:
    ```java
    public interface FraudRule {
        String getRuleName();
        String getDescription();
        int getDefaultWeight();
        boolean isEnabled();
        RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context);
    }
    ```
  - Abstract base class `AbstractFraudRule` provides default boilerplate implementations of state and weight management.
- **Inheritance & Polymorphism (Strategy Pattern)**:
  - Concrete rule implementations extend `AbstractFraudRule`:
    - `HighAmountRule`: Monetary safety thresholds ($10k elevated, $50k critical).
    - `VelocityRule`: Rapid bursts within 5-minute time windows.
    - `GeographicAnomalyRule`: Detects impossible physical travel.
    - `BlacklistAccountRule`: Sanctioned entities and malicious IP nodes.
    - `UnusualHourRule`: Off-hour late-night transactions (01:00–05:00).
    - `NewDeviceRule`: Unrecognized hardware and client signatures.
    - `RapidBalanceDrainRule`: Detects liquidation of >85% of available funds.
  - The `FraudDetector` iterates polymorphically over `List<FraudRule>`, allowing dynamic addition and removal of rules at runtime without modifying the engine code (Open-Closed Principle).

### 2.2 Collections Framework
- **`List` / `CopyOnWriteArrayList`**:
  - `FraudDetector.rules` utilizes `CopyOnWriteArrayList<FraudRule>` to allow concurrent transaction threads to iterate through rules safely while administrative threads dynamically register or disable rules.
- **`Set` / `ConcurrentHashMap.newKeySet()`**:
  - `BlacklistAccountRule` utilizes thread-safe hash sets for instant $O(1)$ lookups of blacklisted accounts and sanctioned IPs.
- **`Map` / `ConcurrentHashMap`**:
  - `TransactionProcessor.userHistoryCache` maintains an in-memory per-user sliding window of recent transactions for low-latency velocity analysis.
- **`LinkedHashMap`**:
  - `RiskScore.ruleBreakdown` maintains insertion-ordered contributions of each triggered rule for crystal-clear analyst audit trails.

### 2.3 Exception Handling
- **Exception Hierarchy**:
  - `FraudGuardException` (Root custom runtime exception)
    - `InvalidTransactionException` (Thrown for negative amounts, missing accounts, or ceiling violations)
    - `FraudDetectionException` (Thrown for rule evaluation or internal engine issues)
    - `DatabaseException` (Translates low-level `SQLException` into clean business domain exceptions)
    - `AuthenticationException` (Thrown for invalid credentials or blocked accounts)
    - `AuthorizationException` (Thrown when an unauthorized role accesses restricted operations)
    - `ResourceNotFoundException` (Thrown when records are missing)
- **Defensive Error Handling**:
  - Standardized try-with-resources across all database connections and statement closures.
  - Robust exception translation: raw SQL state and database error codes are logged internally while sanitized user-facing messages are surfaced to the UI.

### 2.4 Multithreading & Concurrency
- **`ExecutorService` & Thread Pools**:
  - `TransactionProcessor` establishes a fixed thread pool sized according to available CPU cores with a custom daemon `ThreadFactory` (`FraudGuard-Worker-N`).
- **Asynchronous Execution (`Future` / `Callable`)**:
  - Asynchronous transaction submission via `submitAsync(Transaction, User)` allows non-blocking transaction ingestion.
- **Thread Safety**:
  - Thread-safe throughput telemetry using `AtomicLong` counters (`totalProcessed`, `approvedCount`, `flaggedCount`, `rejectedCount`).
  - Thread-safe context cache management using synchronized blocks on per-user history lists.
  - Clean lifecycle management with `shutdown()` and `awaitTermination()`.

---

## 3. JDBC & Database Persistence

### 3.1 CRUD Implementation
- **Create**: Implemented across `UserDAOImpl`, `TransactionDAOImpl`, `FraudAlertDAOImpl`, and `AuditLogDAOImpl` using `Statement.RETURN_GENERATED_KEYS` to retrieve auto-generated IDs.
- **Read**: Direct primary key lookups (`findById`), indexed queries (`findByUsername`, `findByStatus`, `findByUserId`), and paginated batch retrieval (`findAll(limit, offset)`).
- **Update**: Atomic field updates (`updateBalance`, `updateStatus`).
- **Delete**: Soft and hard delete support with foreign key integrity.

### 3.2 JDBC Transaction Management (ACID Workflow)
- Location: `TransactionDAOImpl.executeAtomicTransfer`
- Workflow:
  1. `conn.setAutoCommit(false)`: Disables automatic committing to begin the ACID transaction boundary.
  2. **Balance Check & Debit**: Debits the sender's balance in `users` only if the transaction status is `APPROVED` and funds are sufficient.
  3. **Recipient Credit**: Credits the recipient account if the recipient is an internal customer.
  4. **Transaction Record**: Inserts the transaction record into `transactions`.
  5. **Alert Record**: If risk score requires investigation, inserts the alert into `fraud_alerts` linked via foreign key.
  6. **Audit Log**: Inserts the audit entry into `audit_logs`.
  7. `conn.commit()`: Atomically commits all changes if every step succeeds.
  8. `conn.rollback()`: In the event of any runtime failure, insufficient balance, or SQL exception, rolls back all changes to guarantee zero balance discrepancies.
  9. `finally`: Restores `conn.setAutoCommit(true)` and safely closes the connection.

---

## 4. Servlets, Filters & Session Management

### 4.1 Request & Response Processing
- Clean MVC Architecture:
  - **Model**: Domain entities in `com.fraudguard.model`.
  - **View**: Responsive JSP pages in `src/main/webapp/views/`.
  - **Controller**: Jakarta Servlets in `com.fraudguard.servlet`.
- Proper HTTP method semantics (`doGet` for retrieval and page rendering; `doPost` for state-modifying actions).

### 4.2 Session Management & Security
- `HttpSession` tracking with 30-minute inactivity timeout configured in `WEB-INF/web.xml`.
- **Session Fixation Defense**: Old session is explicitly invalidated upon authentication and a clean new session is generated (`LoginServlet.java`).
- `currentUser` stored in session context and refreshed dynamically on dashboard loads.

### 4.3 Authentication & Role-Based Access Control (RBAC)
- `AuthenticationFilter` intercepts all incoming requests:
  - Grants access to public assets (`/css/*`, `/js/*`, `/images/*`, `/login`, `/logout`, `/hello`).
  - Redirects unauthenticated requests to `/login?error=auth_required`.
  - Strictly enforces that `/admin/*` routes require `ADMIN` or `ANALYST` roles.
  - Enforces that account administration actions (`/admin/user-action`) require `ADMIN` privileges.
  - Injects OWASP recommended security headers:
    - `X-Content-Type-Options: nosniff`
    - `X-Frame-Options: DENY`
    - `X-XSS-Protection: 1; mode=block`

---

## 5. Viva Preparation: Sample Questions & Answers

**Q1: Why did you use an interface for `FraudRule` instead of hardcoding rules?**
> *Answer*: Using the `FraudRule` interface demonstrates the Strategy Pattern and Open-Closed Principle (SOLID). Each rule encapsulates its own detection logic. The `FraudDetector` orchestrator executes rules polymorphically. New rules can be added without modifying the core engine or touching existing rule implementations.

**Q2: How do you guarantee thread safety during concurrent transaction processing?**
> *Answer*: In `TransactionProcessor`, we utilize `ExecutorService` with a fixed worker pool. Thread-safe metrics use `AtomicLong` to prevent lost updates without heavy locking. The user history cache is stored in a `ConcurrentHashMap` with thread-safe synchronized lists. Rule registries in `FraudDetector` use `CopyOnWriteArrayList` so iterations do not throw `ConcurrentModificationException`.

**Q3: How does your application demonstrate ACID transactions in JDBC?**
> *Answer*: In `TransactionDAOImpl.executeAtomicTransfer`, we call `conn.setAutoCommit(false)`. We perform sender balance deduction, recipient credit, transaction insertion, alert creation, and audit logging within the same connection. If any step fails or funds are insufficient, `conn.rollback()` restores the original state. Only when all operations succeed do we call `conn.commit()`.

**Q4: How are passwords stored and validated?**
> *Answer*: Passwords are never stored in plain text. `SecurityUtil` generates a cryptographically secure 16-byte random salt using `SecureRandom` and computes a salted SHA-256 hash using `MessageDigest`. The resulting hash is stored in `salt$hash` format. Validation hashes candidate passwords against the stored salt using constant-time comparison `MessageDigest.isEqual` to prevent timing attacks.

**Q5: Why are database statistics not hardcoded on the admin dashboard?**
> *Answer*: `AdminService` issues real SQL aggregation queries (`COUNT`, `SUM`, `COALESCE`) via `TransactionDAO`, `FraudAlertDAO`, and `UserDAO`. The dashboard numbers reflect live database state and update dynamically after every transaction.
