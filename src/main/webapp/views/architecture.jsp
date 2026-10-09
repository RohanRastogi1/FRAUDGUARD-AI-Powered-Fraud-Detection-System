<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.User" %>
<jsp:include page="common/header.jsp" />

<div class="arch-container">
    <!-- Hero Banner -->
    <div class="arch-hero">
        <div class="arch-hero-badge">
            <span class="pulse-dot pulse-dot-green"></span>
            <span>ENTERPRISE PIPELINE TOPOLOGY &bull; HIGH-THROUGHPUT ENGINE</span>
        </div>
        <h1 class="arch-hero-title">
            FraudGuard System Architecture
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle;">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                <path d="M9 12l2 2 4-4"/>
            </svg>
        </h1>
        <p class="arch-hero-subtitle">
            Comprehensive technical overview of the autonomous risk scoring pipeline, modular strategy heuristics, 
            ACID transaction pools, and multi-tier security engineered by <strong>TeamRootOps</strong> at Galgotias University.
        </p>

        <!-- KPI Metrics Ribbon -->
        <div class="arch-metrics-ribbon">
            <div class="arch-metric-card">
                <span class="metric-num">&lt; 24ms</span>
                <span class="metric-label">Pipeline Latency SLA</span>
            </div>
            <div class="arch-metric-card">
                <span class="metric-num">7 Heuristics</span>
                <span class="metric-label">Strategy Pattern Rules</span>
            </div>
            <div class="arch-metric-card">
                <span class="metric-num">ACID Strict</span>
                <span class="metric-label">MySQL 8.0 Dual-Phase</span>
            </div>
            <div class="arch-metric-card">
                <span class="metric-num">Zero-Trust</span>
                <span class="metric-label">Role-Based RBAC</span>
            </div>
        </div>
    </div>

    <!-- Navigation Jump Bar -->
    <div class="arch-nav-jump">
        <a href="#pipeline" class="arch-jump-btn active">End-to-End Pipeline</a>
        <a href="#heuristics" class="arch-jump-btn">7 Fraud Rules</a>
        <a href="#patterns" class="arch-jump-btn">Design Patterns</a>
        <a href="#database" class="arch-jump-btn">Database Schema</a>
        <a href="#deployment" class="arch-jump-btn">Deployment Topology</a>
        <a href="<%= request.getContextPath() %>/docs" class="arch-jump-btn highlight">View Full Docs &rarr;</a>
    </div>

    <!-- Section 1: End-to-End Pipeline Flowchart -->
    <section id="pipeline" class="arch-section">
        <div class="arch-section-header">
            <div class="section-tag">EXECUTION LIFECYCLE</div>
            <h2>Autonomous Fraud Triage & Scoring Pipeline</h2>
            <p>Every transaction undergoes an end-to-end multi-phase evaluation before funds are debited or alerts are triggered.</p>
        </div>

        <div class="pipeline-grid">
            <!-- Stage 1 -->
            <div class="pipeline-card">
                <div class="pipeline-step-header">
                    <span class="step-badge">Stage 01</span>
                    <span class="step-timing">&sim; 2ms</span>
                </div>
                <div class="pipeline-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                </div>
                <h3>Ingestion & Gateway</h3>
                <p>Client submits <code>POST /transaction</code> via secure HTTPS. Captures amount, recipient IBAN, IP address, geo-location coordinates, and device fingerprint.</p>
                <div class="pipeline-tag-group">
                    <span class="pipeline-tag">HTTPS TLS 1.3</span>
                    <span class="pipeline-tag">Device Hash</span>
                    <span class="pipeline-tag">Geo-IP</span>
                </div>
            </div>

            <!-- Stage 2 -->
            <div class="pipeline-card">
                <div class="pipeline-step-header">
                    <span class="step-badge">Stage 02</span>
                    <span class="step-timing">&sim; 1ms</span>
                </div>
                <div class="pipeline-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                </div>
                <h3>Validation & Boundaries</h3>
                <p>Ensures sender balance adequacy, positive currency limits, non-empty recipient, and invokes SQL injection & XSS sanitization filters.</p>
                <div class="pipeline-tag-group">
                    <span class="pipeline-tag">Boundary Guard</span>
                    <span class="pipeline-tag">Balance Check</span>
                    <span class="pipeline-tag">XSS Guard</span>
                </div>
            </div>

            <!-- Stage 3 -->
            <div class="pipeline-card">
                <div class="pipeline-step-header">
                    <span class="step-badge">Stage 03</span>
                    <span class="step-timing">&sim; 4ms</span>
                </div>
                <div class="pipeline-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path></svg>
                </div>
                <h3>Context Hydration</h3>
                <p>Constructs <code>TransactionContext</code> by querying user history: sliding 5-minute velocity, 24h cumulative volume, known devices list, and historical baseline.</p>
                <div class="pipeline-tag-group">
                    <span class="pipeline-tag">5-min Sliding Window</span>
                    <span class="pipeline-tag">Device Cache</span>
                    <span class="pipeline-tag">User Baseline</span>
                </div>
            </div>

            <!-- Stage 4 -->
            <div class="pipeline-card featured">
                <div class="pipeline-step-header">
                    <span class="step-badge featured">Stage 04</span>
                    <span class="step-timing">&sim; 6ms</span>
                </div>
                <div class="pipeline-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                </div>
                <h3>Rule Matrix (Strategy Engine)</h3>
                <p>Executes 7 registered <code>FraudRule</code> implementations concurrently in thread-safe <code>CopyOnWriteArrayList</code>, generating structured evaluations.</p>
                <div class="pipeline-tag-group">
                    <span class="pipeline-tag">Strategy Pattern</span>
                    <span class="pipeline-tag">7 Heuristics</span>
                    <span class="pipeline-tag">Thread-Safe</span>
                </div>
            </div>

            <!-- Stage 5 -->
            <div class="pipeline-card">
                <div class="pipeline-step-header">
                    <span class="step-badge">Stage 05</span>
                    <span class="step-timing">&sim; 2ms</span>
                </div>
                <div class="pipeline-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 2 7 12 12 22 7 12 2"></polygon><polyline points="2 17 12 22 22 17"></polyline><polyline points="2 12 12 17 22 12"></polyline></svg>
                </div>
                <h3>Risk Score Synthesis</h3>
                <p>Synthesizes weighted evaluations via <code>RiskCalculator</code>. Classifies into 4 risk tiers: LOW (&lt;30), MEDIUM (30-59), HIGH (60-84), CRITICAL (85-100).</p>
                <div class="pipeline-tag-group">
                    <span class="pipeline-tag">Score Matrix</span>
                    <span class="pipeline-tag">0 - 100 Clamping</span>
                    <span class="pipeline-tag">4 Triage Tiers</span>
                </div>
            </div>

            <!-- Stage 6 -->
            <div class="pipeline-card">
                <div class="pipeline-step-header">
                    <span class="step-badge">Stage 06</span>
                    <span class="step-timing">&sim; 7ms</span>
                </div>
                <div class="pipeline-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                </div>
                <h3>ACID Commit & Telemetry</h3>
                <p>Atomically persists transaction in MySQL 8.0, dispatches incident alerts for HIGH/CRITICAL scores, and streams updates to the live executive dashboard.</p>
                <div class="pipeline-tag-group">
                    <span class="pipeline-tag">ACID Commit</span>
                    <span class="pipeline-tag">Dual-Write Log</span>
                    <span class="pipeline-tag">Telemetry Event</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Section 2: 7 Fraud Heuristics Grid -->
    <section id="heuristics" class="arch-section">
        <div class="arch-section-header">
            <div class="section-tag">BEHAVIORAL RULES</div>
            <h2>The 7 Autonomous Fraud Detection Rules</h2>
            <p>Each rule encapsulates isolated heuristics, dynamic weights, and specific failure triggers under the Strategy Pattern.</p>
        </div>

        <div class="rules-grid">
            <!-- Rule 1 -->
            <div class="rule-spec-card critical">
                <div class="rule-spec-top">
                    <span class="rule-spec-badge critical">CRITICAL &bull; BLOCK</span>
                    <span class="rule-spec-weight">Score: +100</span>
                </div>
                <h3>BlacklistAccountRule</h3>
                <p>Detects if recipient account or IBAN matches global sanctions lists, known mule rings, or previously flagged malicious entities.</p>
                <div class="rule-details">
                    <div class="rule-detail-item"><strong>Condition:</strong> Matches sanction database</div>
                    <div class="rule-detail-item"><strong>Action:</strong> Instant Auto-Block & Account Quarantine</div>
                </div>
            </div>

            <!-- Rule 2 -->
            <div class="rule-spec-card">
                <div class="rule-spec-top">
                    <span class="rule-spec-badge high">HIGH RISK</span>
                    <span class="rule-spec-weight">Score: +35</span>
                </div>
                <h3>HighAmountRule</h3>
                <p>Triggers when transfer amount exceeds predefined maximum limits (₹50,000+) or deviates more than 300% from sender's 30-day historical mean.</p>
                <div class="rule-details">
                    <div class="rule-detail-item"><strong>Condition:</strong> Amount &gt; ₹50,000 or &gt; 3x baseline</div>
                    <div class="rule-detail-item"><strong>Action:</strong> Step-up challenge / Analyst review</div>
                </div>
            </div>

            <!-- Rule 3 -->
            <div class="rule-spec-card">
                <div class="rule-spec-top">
                    <span class="rule-spec-badge high">HIGH RISK</span>
                    <span class="rule-spec-weight">Score: +40</span>
                </div>
                <h3>VelocityRule</h3>
                <p>Flags micro-burst payment activity where more than 3 transactions occur within a sliding 5-minute window from the same account.</p>
                <div class="rule-details">
                    <div class="rule-detail-item"><strong>Condition:</strong> &gt; 3 transfers in 5 minutes</div>
                    <div class="rule-detail-item"><strong>Action:</strong> Velocity throttle & Rate-limit alert</div>
                </div>
            </div>

            <!-- Rule 4 -->
            <div class="rule-spec-card">
                <div class="rule-spec-top">
                    <span class="rule-spec-badge high">HIGH RISK</span>
                    <span class="rule-spec-weight">Score: +50</span>
                </div>
                <h3>GeographicAnomalyRule</h3>
                <p>Calculates Haversine distance and elapsed time between subsequent transactions to flag physical impossibility (velocity &gt; 800 km/h).</p>
                <div class="rule-details">
                    <div class="rule-detail-item"><strong>Condition:</strong> Impossible travel speed</div>
                    <div class="rule-detail-item"><strong>Action:</strong> Geographic alert & Session freeze</div>
                </div>
            </div>

            <!-- Rule 5 -->
            <div class="rule-spec-card">
                <div class="rule-spec-top">
                    <span class="rule-spec-badge medium">MEDIUM RISK</span>
                    <span class="rule-spec-weight">Score: +20</span>
                </div>
                <h3>UnusualHourRule</h3>
                <p>Applies risk multiplier to transactions initiated during high-risk off-peak time windows (01:00 AM to 05:00 AM local time).</p>
                <div class="rule-details">
                    <div class="rule-detail-item"><strong>Condition:</strong> 01:00 &ndash; 05:00 local time</div>
                    <div class="rule-detail-item"><strong>Action:</strong> Secondary verification prompt</div>
                </div>
            </div>

            <!-- Rule 6 -->
            <div class="rule-spec-card">
                <div class="rule-spec-top">
                    <span class="rule-spec-badge medium">MEDIUM RISK</span>
                    <span class="rule-spec-weight">Score: +25</span>
                </div>
                <h3>NewDeviceRule</h3>
                <p>Detects novel browser fingerprints, unknown OS signatures, or unverified hardware configurations not seen on account in past 90 days.</p>
                <div class="rule-details">
                    <div class="rule-detail-item"><strong>Condition:</strong> Unrecognized hardware hash</div>
                    <div class="rule-detail-item"><strong>Action:</strong> Device trust challenge</div>
                </div>
            </div>

            <!-- Rule 7 -->
            <div class="rule-spec-card critical">
                <div class="rule-spec-top">
                    <span class="rule-spec-badge critical">CRITICAL</span>
                    <span class="rule-spec-weight">Score: +45</span>
                </div>
                <h3>RapidBalanceDrainRule</h3>
                <p>Detects sudden catastrophic balance depletion exceeding 80% of total liquid wallet holdings within a compressed time frame.</p>
                <div class="rule-details">
                    <div class="rule-detail-item"><strong>Condition:</strong> Depletes &gt; 80% total balance</div>
                    <div class="rule-detail-item"><strong>Action:</strong> Auto-Hold & Critical incident notification</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Section 3: Software Design Patterns -->
    <section id="patterns" class="arch-section">
        <div class="arch-section-header">
            <div class="section-tag">ENGINEERING PRINCIPLES</div>
            <h2>Object-Oriented Design Patterns in FraudGuard</h2>
            <p>Adhering to strict SOLID design principles, modularity, and enterprise separation of concerns.</p>
        </div>

        <div class="patterns-grid">
            <div class="pattern-card">
                <div class="pattern-header">
                    <span class="pattern-type">Behavioral Pattern</span>
                    <h3>Strategy Pattern</h3>
                </div>
                <p class="pattern-desc">
                    The <code>FraudRule</code> interface defines the evaluation contract. Every detection heuristic inherits from <code>AbstractFraudRule</code>, allowing dynamic runtime rule additions, removals, and hot-swaps without touching core engine logic.
                </p>
                <div class="code-snippet">
<pre><code>public interface FraudRule {
    String getRuleName();
    boolean isEnabled();
    RuleEvaluation evaluate(Transaction tx, User u, TransactionContext ctx);
}</code></pre>
                </div>
            </div>

            <div class="pattern-card">
                <div class="pattern-header">
                    <span class="pattern-type">Structural Pattern</span>
                    <h3>Facade Pattern</h3>
                </div>
                <p class="pattern-desc">
                    <code>FraudDetector</code> and <code>TransactionProcessor</code> provide simplified, high-level facades over complex sub-systems including database pools, context builders, scoring formulas, and alert dispatchers.
                </p>
                <div class="code-snippet">
<pre><code>public class TransactionProcessor {
    public TransactionResult process(Transaction tx, User u) {
        // Hydrates context, evaluates rules, commits ACID tx
    }
}</code></pre>
                </div>
            </div>

            <div class="pattern-card">
                <div class="pattern-header">
                    <span class="pattern-type">Creational Pattern</span>
                    <h3>Singleton & Connection Pool</h3>
                </div>
                <p class="pattern-desc">
                    <code>DatabaseConnection</code> maintains a single instance managing an active pool of pre-warmed JDBC connections, ensuring maximum throughput and minimal socket connection overhead on high-load bursts.
                </p>
                <div class="code-snippet">
<pre><code>public class DatabaseConnection {
    private static volatile DatabaseConnection instance;
    public Connection getConnection() throws SQLException { ... }
}</code></pre>
                </div>
            </div>

            <div class="pattern-card">
                <div class="pattern-header">
                    <span class="pattern-type">Architectural Pattern</span>
                    <h3>Data Access Object (DAO)</h3>
                </div>
                <p class="pattern-desc">
                    Persistence operations are strictly decoupled via interfaces: <code>UserDAO</code>, <code>TransactionDAO</code>, and <code>FraudAlertDAO</code>. All SQL statements use parameterized prepared statements to eliminate SQL injection vulnerabilities.
                </p>
                <div class="code-snippet">
<pre><code>public interface TransactionDAO {
    Optional&lt;Transaction&gt; findByRef(String ref);
    void save(Transaction tx) throws SQLException;
}</code></pre>
                </div>
            </div>
        </div>
    </section>

    <!-- Section 4: Relational Database Schema ER Topology -->
    <section id="database" class="arch-section">
        <div class="arch-section-header">
            <div class="section-tag">DATA TOPOLOGY</div>
            <h2>Relational Database Schema & Entities</h2>
            <p>Normalized schema implemented in MySQL 8.0 with InnoDB engine, B-Tree indexes on high-cardinality fields, and foreign key integrity.</p>
        </div>

        <div class="schema-grid">
            <!-- Table 1: users -->
            <div class="schema-card">
                <div class="schema-card-header">
                    <span class="table-name">TABLE: users</span>
                    <span class="table-engine">InnoDB &bull; UTF8MB4</span>
                </div>
                <div class="table-container" style="margin: 0; border: none; border-radius: 0;">
                    <table class="schema-table responsive-card-table">
                        <thead>
                            <tr><th>Field</th><th>Type</th><th>Key / Constraint</th></tr>
                        </thead>
                        <tbody>
                            <tr><td data-label="Field"><code>id</code></td><td data-label="Type">BIGINT AUTO_INCREMENT</td><td data-label="Constraint">PRIMARY KEY</td></tr>
                            <tr><td data-label="Field"><code>username</code></td><td data-label="Type">VARCHAR(64)</td><td data-label="Constraint">UNIQUE NOT NULL</td></tr>
                            <tr><td data-label="Field"><code>password_hash</code></td><td data-label="Type">VARCHAR(255)</td><td data-label="Constraint">NOT NULL (PBKDF2)</td></tr>
                            <tr><td data-label="Field"><code>full_name</code></td><td data-label="Type">VARCHAR(100)</td><td data-label="Constraint">NOT NULL</td></tr>
                            <tr><td data-label="Field"><code>email</code></td><td data-label="Type">VARCHAR(128)</td><td data-label="Constraint">NOT NULL (Internal)</td></tr>
                            <tr><td data-label="Field"><code>role</code></td><td data-label="Type">ENUM('ADMIN','ANALYST','CUSTOMER')</td><td data-label="Constraint">NOT NULL</td></tr>
                            <tr><td data-label="Field"><code>balance</code></td><td data-label="Type">DECIMAL(12,2)</td><td data-label="Constraint">DEFAULT 10000.00</td></tr>
                            <tr><td data-label="Field"><code>status</code></td><td data-label="Type">ENUM('ACTIVE','SUSPENDED','LOCKED')</td><td data-label="Constraint">DEFAULT 'ACTIVE'</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Table 2: transactions -->
            <div class="schema-card">
                <div class="schema-card-header">
                    <span class="table-name">TABLE: transactions</span>
                    <span class="table-engine">InnoDB &bull; UTF8MB4</span>
                </div>
                <div class="table-container" style="margin: 0; border: none; border-radius: 0;">
                    <table class="schema-table responsive-card-table">
                        <thead>
                            <tr><th>Field</th><th>Type</th><th>Key / Constraint</th></tr>
                        </thead>
                        <tbody>
                            <tr><td data-label="Field"><code>id</code></td><td data-label="Type">BIGINT AUTO_INCREMENT</td><td data-label="Constraint">PRIMARY KEY</td></tr>
                            <tr><td data-label="Field"><code>transaction_ref</code></td><td data-label="Type">VARCHAR(40)</td><td data-label="Constraint">UNIQUE INDEX</td></tr>
                            <tr><td data-label="Field"><code>user_id</code></td><td data-label="Type">BIGINT</td><td data-label="Constraint">FOREIGN KEY &rarr; users(id)</td></tr>
                            <tr><td data-label="Field"><code>amount</code></td><td data-label="Type">DECIMAL(12,2)</td><td data-label="Constraint">NOT NULL</td></tr>
                            <tr><td data-label="Field"><code>recipient_account</code></td><td data-label="Type">VARCHAR(64)</td><td data-label="Constraint">NOT NULL</td></tr>
                            <tr><td data-label="Field"><code>risk_score</code></td><td data-label="Type">INT</td><td data-label="Constraint">CHECK (0-100)</td></tr>
                            <tr><td data-label="Field"><code>risk_level</code></td><td data-label="Type">ENUM('LOW','MEDIUM','HIGH','CRITICAL')</td><td data-label="Constraint">NOT NULL</td></tr>
                            <tr><td data-label="Field"><code>status</code></td><td data-label="Type">ENUM('APPROVED','FLAGGED','BLOCKED')</td><td data-label="Constraint">NOT NULL</td></tr>
                            <tr><td data-label="Field"><code>created_at</code></td><td data-label="Type">TIMESTAMP</td><td data-label="Constraint">INDEX (Recent Tx)</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Table 3: fraud_alerts -->
            <div class="schema-card">
                <div class="schema-card-header">
                    <span class="table-name">TABLE: fraud_alerts</span>
                    <span class="table-engine">InnoDB &bull; UTF8MB4</span>
                </div>
                <div class="table-container" style="margin: 0; border: none; border-radius: 0;">
                    <table class="schema-table responsive-card-table">
                        <thead>
                            <tr><th>Field</th><th>Type</th><th>Key / Constraint</th></tr>
                        </thead>
                        <tbody>
                            <tr><td data-label="Field"><code>id</code></td><td data-label="Type">BIGINT AUTO_INCREMENT</td><td data-label="Constraint">PRIMARY KEY</td></tr>
                            <tr><td data-label="Field"><code>transaction_id</code></td><td data-label="Type">BIGINT</td><td data-label="Constraint">FOREIGN KEY &rarr; transactions(id)</td></tr>
                            <tr><td data-label="Field"><code>user_id</code></td><td data-label="Type">BIGINT</td><td data-label="Constraint">FOREIGN KEY &rarr; users(id)</td></tr>
                            <tr><td data-label="Field"><code>risk_score</code></td><td data-label="Type">INT</td><td data-label="Constraint">NOT NULL</td></tr>
                            <tr><td data-label="Field"><code>triggered_rules</code></td><td data-label="Type">TEXT</td><td data-label="Constraint">JSON Array of rules</td></tr>
                            <tr><td data-label="Field"><code>status</code></td><td data-label="Type">ENUM('PENDING','INVESTIGATING','RESOLVED','DISMISSED')</td><td data-label="Constraint">INDEX</td></tr>
                            <tr><td data-label="Field"><code>analyst_notes</code></td><td data-label="Type">TEXT</td><td data-label="Constraint">NULLABLE</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>

    <!-- Section 5: Deployment & System Infrastructure -->
    <section id="deployment" class="arch-section">
        <div class="arch-section-header">
            <div class="section-tag">INFRASTRUCTURE & ENVIRONMENT</div>
            <h2>Deployment Topology & Runtime Environment</h2>
            <p>High-availability enterprise architecture configuration running on Tomcat 10.1 and JVM 17+.</p>
        </div>

        <div class="deploy-grid">
            <div class="deploy-card">
                <h3>Application Tier (Jakarta EE)</h3>
                <ul>
                    <li><strong>Runtime:</strong> Apache Tomcat 10.1.x</li>
                    <li><strong>Servlet Spec:</strong> Jakarta Servlet 6.0</li>
                    <li><strong>Java Version:</strong> OpenJDK 17 LTS / 21 LTS</li>
                    <li><strong>Session Manager:</strong> StandardManager with HTTP-Only Cookie Protection</li>
                    <li><strong>Thread Pool:</strong> Default Executor (200 worker threads)</li>
                </ul>
            </div>

            <div class="deploy-card">
                <h3>Data Persistence Tier</h3>
                <ul>
                    <li><strong>RDBMS:</strong> MySQL 8.0 Enterprise / Community</li>
                    <li><strong>Storage Engine:</strong> InnoDB with ACID Strict Guarantees</li>
                    <li><strong>Connection Pool:</strong> Managed JDBC Connection Pool</li>
                    <li><strong>Transaction Isolation:</strong> READ COMMITTED</li>
                    <li><strong>Encoding:</strong> UTF-8 (utf8mb4_unicode_ci)</li>
                </ul>
            </div>

            <div class="deploy-card">
                <h3>Security & Boundary Protections</h3>
                <ul>
                    <li><strong>Filter Chain:</strong> <code>AuthenticationFilter</code> with RBAC enforcement</li>
                    <li><strong>Cryptographic Salting:</strong> PBKDF2 with SHA-256 for credentials</li>
                    <li><strong>Header Policies:</strong> nosniff, DENY frame options, XSS blocking</li>
                    <li><strong>Data Privacy:</strong> Zero PII / email exposure in user-facing views</li>
                    <li><strong>Engineering Team:</strong> Engineered by TeamRootOps</li>
                </ul>
            </div>
        </div>
    </section>

    <!-- Bottom CTA Bar -->
    <div class="arch-footer-cta">
        <div>
            <h3>Need In-Depth API Specs & Setup Instructions?</h3>
            <p>Read the comprehensive documentation covering curl examples, rule tuning, and installation steps.</p>
        </div>
        <div style="display: flex; gap: 0.75rem; align-items: center;">
            <button type="button" class="btn btn-secondary" onclick="openTeamModal()">TeamRootOps Roster</button>
            <a href="<%= request.getContextPath() %>/docs" class="btn btn-primary">Open Documentation &rarr;</a>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />
