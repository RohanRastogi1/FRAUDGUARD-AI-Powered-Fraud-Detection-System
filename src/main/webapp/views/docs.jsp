<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.User" %>
<jsp:include page="common/header.jsp" />

<div class="docs-layout">
    <!-- Sidebar Navigation -->
    <aside class="docs-sidebar">
        <div class="docs-sidebar-header">
            <span class="docs-version-badge">v3.0 &bull; Enterprise</span>
            <h4>Documentation</h4>
        </div>
        <nav class="docs-nav-tree">
            <a href="#intro" class="docs-nav-link active">1. Overview & Purpose</a>
            <a href="#quickstart" class="docs-nav-link">2. Quickstart & Setup</a>
            <a href="#portals" class="docs-nav-link">3. Portal User Guides</a>
            <a href="#rule-specs" class="docs-nav-link">4. Fraud Rules Specification</a>
            <a href="#api-reference" class="docs-nav-link">5. REST API & Payloads</a>
            <a href="#security" class="docs-nav-link">6. Security & Privacy Model</a>
            <a href="#troubleshooting" class="docs-nav-link">7. Troubleshooting & FAQ</a>
            <a href="#team" class="docs-nav-link">8. TeamRootOps Credits</a>
        </nav>
        <div class="docs-sidebar-footer">
            <a href="<%= request.getContextPath() %>/architecture" class="btn btn-secondary btn-sm" style="width: 100%; justify-content: center;">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                View Architecture
            </a>
        </div>
    </aside>

    <!-- Main Documentation Content -->
    <main class="docs-content">
        <!-- Hero Header -->
        <div class="docs-header">
            <span class="docs-badge">DEVELOPER & OPERATOR MANUAL</span>
            <h1>FraudGuard Documentation</h1>
            <p class="docs-lead">
                Welcome to the official technical manual for <strong>FraudGuard</strong> &mdash; the AI-powered autonomous fraud prevention engine engineered by <strong>TeamRootOps</strong> at Galgotias University.
            </p>
        </div>

        <!-- Section 1: Overview -->
        <article id="intro" class="docs-article">
            <h2>1. Overview & Purpose</h2>
            <p>
                FraudGuard is a real-time, low-latency transaction processing engine designed to autonomously detect and intercept fraudulent financial activity. Operating with an evaluation latency under <strong>25 milliseconds</strong>, FraudGuard inspects transactions through stateful heuristic pipelines, behavioral anomaly detection, and composite scoring algorithms before committing balance mutations to persistent ACID storage.
            </p>
            <div class="docs-callout note">
                <strong>Core Philosophy:</strong> Deterministic security, transparent risk scoring, strict isolation of sensitive personal identifiers (PII), and frictionless user experience for legitimate transactions.
            </div>
            <h3>Core System Capabilities</h3>
            <ul>
                <li><strong>Stateful Velocity Tracking:</strong> Micro-burst monitoring preventing carding attacks and account takeover attempts.</li>
                <li><strong>Dynamic Risk Tiering:</strong> Automatic division into <code>LOW</code>, <code>MEDIUM</code>, <code>HIGH</code>, and <code>CRITICAL</code> risk tiers with adaptive enforcement.</li>
                <li><strong>Autonomous Triage & Alerting:</strong> Real-time incident dispatching notifying security analysts with full rule audit trails.</li>
                <li><strong>Enterprise RBAC:</strong> Role-based access control protecting executive dashboards, transaction telemetry, and account management.</li>
            </ul>
        </article>

        <!-- Section 2: Quickstart & Setup -->
        <article id="quickstart" class="docs-article">
            <h2>2. Quickstart & Setup Guide</h2>
            <p>Follow these steps to deploy and run FraudGuard on your local development or staging environment.</p>

            <h3>Prerequisites</h3>
            <div class="table-container">
                <table class="data-table responsive-card-table">
                    <thead>
                        <tr><th>Component</th><th>Required Version</th><th>Purpose</th></tr>
                    </thead>
                    <tbody>
                        <tr><td data-label="Component"><strong>Java Development Kit (JDK)</strong></td><td data-label="Required Version">17 LTS or 21 LTS</td><td data-label="Purpose">Compiler & runtime environment</td></tr>
                        <tr><td data-label="Component"><strong>Apache Tomcat</strong></td><td data-label="Required Version">10.1.x</td><td data-label="Purpose">Jakarta EE 10 Servlet Container</td></tr>
                        <tr><td data-label="Component"><strong>MySQL Database</strong></td><td data-label="Required Version">8.0+</td><td data-label="Purpose">Relational transactional storage (InnoDB)</td></tr>
                        <tr><td data-label="Component"><strong>Apache Maven</strong></td><td data-label="Required Version">3.8+</td><td data-label="Purpose">Build automation & dependency management</td></tr>
                    </tbody>
                </table>
            </div>

            <h3>Step 1: Database Initialization</h3>
            <p>Create the database schema and seed default administrative and test customer accounts:</p>
            <div class="code-snippet">
<pre><code># Connect to MySQL 8.0 CLI
mysql -u root -p

# Execute initialization scripts from repository root
mysql> source database/schema.sql;
mysql> source database/seed.sql;</code></pre>
            </div>

            <h3>Step 2: Compile & Package via Maven</h3>
            <div class="code-snippet">
<pre><code># Clean and compile war package (skips unit tests for quick packaging)
mvn clean package -DskipTests</code></pre>
            </div>

            <h3>Step 3: Deploy to Apache Tomcat</h3>
            <div class="code-snippet">
<pre><code># Copy generated WAR to Tomcat webapps directory
cp target/fraudguard.war $CATALINA_HOME/webapps/

# Start Tomcat server
$CATALINA_HOME/bin/startup.sh   # Linux/macOS
$CATALINA_HOME\bin\catalina.bat run   # Windows</code></pre>
            </div>
            <p>Navigate to <code>http://localhost:8080/fraudguard/</code> to access the system.</p>
        </article>

        <!-- Section 3: Portals Guide -->
        <article id="portals" class="docs-article">
            <h2>3. Portal User Guides</h2>
            <p>FraudGuard features dedicated, role-tailored interfaces:</p>

            <div class="portal-cards-grid">
                <div class="portal-card">
                    <h4>Customer Portal</h4>
                    <p>Designed for end-users to send funds, monitor real-time wallet balances, review transaction status, and acknowledge security alerts.</p>
                    <div class="portal-card-footer">
                        <code>/dashboard</code> &bull; <code>/transaction/new</code>
                    </div>
                </div>
                <div class="portal-card">
                    <h4>Executive & Analyst Portal</h4>
                    <p>Designed for fraud analysts and security officers to inspect global transaction streams, evaluate rule trigger breakdowns, and resolve alerts.</p>
                    <div class="portal-card-footer">
                        <code>/admin/dashboard</code> &bull; <code>/admin/alerts</code>
                    </div>
                </div>
            </div>

            <h3>Default System Credentials (Testing)</h3>
            <div class="table-container">
                <table class="data-table responsive-card-table">
                    <thead>
                        <tr><th>Role</th><th>Username</th><th>Password</th><th>Privileges</th></tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td data-label="Role"><span class="badge badge-danger">ADMIN</span></td>
                            <td data-label="Username"><code>admin</code></td>
                            <td data-label="Password"><code>Admin@123</code></td>
                            <td data-label="Privileges">Full Executive Dashboard, User Accounts, Rule Configuration</td>
                        </tr>
                        <tr>
                            <td data-label="Role"><span class="badge badge-info">ANALYST</span></td>
                            <td data-label="Username"><code>analyst</code></td>
                            <td data-label="Password"><code>Analyst@123</code></td>
                            <td data-label="Privileges">Transaction Monitor, Fraud Alerts Triage, Incident Notes</td>
                        </tr>
                        <tr>
                            <td data-label="Role"><span class="badge badge-success">CUSTOMER</span></td>
                            <td data-label="Username"><code>user</code></td>
                            <td data-label="Password"><code>User@123</code></td>
                            <td data-label="Privileges">Send Funds, Wallet Balance, Personal History, Alert Feedback</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </article>

        <!-- Section 4: 7 Fraud Detection Rules -->
        <article id="rule-specs" class="docs-article">
            <h2>4. Fraud Rules Specification</h2>
            <p>
                The detection engine orchestrates 7 autonomous heuristic rules implementing the Strategy Pattern. Each rule evaluates the transaction independently:
            </p>

            <div class="table-container">
                <table class="data-table responsive-card-table">
                    <thead>
                        <tr>
                            <th>Rule Name</th>
                            <th>Trigger Heuristic</th>
                            <th>Weight</th>
                            <th>Risk Impact</th>
                            <th>Automated Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td data-label="Rule Name"><strong>BlacklistAccountRule</strong></td>
                            <td data-label="Trigger">Target account exists in sanctions/fraud ring registry</td>
                            <td data-label="Weight">+100</td>
                            <td data-label="Risk Impact"><span class="badge badge-critical">CRITICAL</span></td>
                            <td data-label="Action">Immediate Transaction Block & Incident Alert</td>
                        </tr>
                        <tr>
                            <td data-label="Rule Name"><strong>HighAmountRule</strong></td>
                            <td data-label="Trigger">Amount &gt; ₹50,000 or exceeds 300% historical baseline</td>
                            <td data-label="Weight">+35</td>
                            <td data-label="Risk Impact"><span class="badge badge-danger">HIGH</span></td>
                            <td data-label="Action">Flagged for Analyst Triage / Secondary Review</td>
                        </tr>
                        <tr>
                            <td data-label="Rule Name"><strong>VelocityRule</strong></td>
                            <td data-label="Trigger">&gt; 3 transactions from same account in sliding 5-min window</td>
                            <td data-label="Weight">+40</td>
                            <td data-label="Risk Impact"><span class="badge badge-danger">HIGH</span></td>
                            <td data-label="Action">Velocity Throttle & Notification Dispatch</td>
                        </tr>
                        <tr>
                            <td data-label="Rule Name"><strong>GeographicAnomalyRule</strong></td>
                            <td data-label="Trigger">Distance between subsequent locations implies speed &gt; 800 km/h</td>
                            <td data-label="Weight">+50</td>
                            <td data-label="Risk Impact"><span class="badge badge-danger">HIGH</span></td>
                            <td data-label="Action">Session Freeze & Out-of-Band Verification</td>
                        </tr>
                        <tr>
                            <td data-label="Rule Name"><strong>UnusualHourRule</strong></td>
                            <td data-label="Trigger">Transfer executed between 01:00 AM and 05:00 AM local time</td>
                            <td data-label="Weight">+20</td>
                            <td data-label="Risk Impact"><span class="badge badge-warning">MEDIUM</span></td>
                            <td data-label="Action">Telemetry Tag & Elevated Scrutiny</td>
                        </tr>
                        <tr>
                            <td data-label="Rule Name"><strong>NewDeviceRule</strong></td>
                            <td data-label="Trigger">Hardware hash / user-agent not recorded in account history</td>
                            <td data-label="Weight">+25</td>
                            <td data-label="Risk Impact"><span class="badge badge-warning">MEDIUM</span></td>
                            <td data-label="Action">Device Confirmation Challenge</td>
                        </tr>
                        <tr>
                            <td data-label="Rule Name"><strong>RapidBalanceDrainRule</strong></td>
                            <td data-label="Trigger">Single transfer withdraws &gt; 80% of current available balance</td>
                            <td data-label="Weight">+45</td>
                            <td data-label="Risk Impact"><span class="badge badge-critical">CRITICAL</span></td>
                            <td data-label="Action">Hold on Funds & Critical Alert Generation</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h3>Composite Risk Scoring Formula</h3>
            <p>The total risk score is calculated via the formula:</p>
            <div class="code-snippet">
<pre><code>Score = Min(100, Sum(Evaluations[i].Weight * Evaluations[i].SeverityFactor))</code></pre>
            </div>
            <p>If any rule triggers a critical hard-block condition (such as <code>BlacklistAccountRule</code>), the score instantly saturates at <strong>100</strong>.</p>
        </article>

        <!-- Section 5: REST API Reference -->
        <article id="api-reference" class="docs-article">
            <h2>5. REST API & Payload Specification</h2>
            <p>FraudGuard provides REST-compatible servlet endpoints for automated transaction intake and scoring.</p>

            <h3>Endpoint: Initiate Transaction</h3>
            <div class="api-method-badge">
                <span class="method post">POST</span>
                <span class="url">/transaction</span>
            </div>

            <h4>Headers</h4>
            <div class="code-snippet">
<pre><code>Content-Type: application/x-www-form-urlencoded
Cookie: JSESSIONID=...</code></pre>
            </div>

            <h4>Form Parameters</h4>
            <div class="table-container">
                <table class="data-table responsive-card-table">
                    <thead>
                        <tr><th>Parameter</th><th>Type</th><th>Required</th><th>Description</th></tr>
                    </thead>
                    <tbody>
                        <tr><td data-label="Parameter"><code>amount</code></td><td data-label="Type">Decimal</td><td data-label="Required">Yes</td><td data-label="Description">Transaction amount (e.g., <code>1500.00</code>)</td></tr>
                        <tr><td data-label="Parameter"><code>recipientAccount</code></td><td data-label="Type">String</td><td data-label="Required">Yes</td><td data-label="Description">Target IBAN or account identifier</td></tr>
                        <tr><td data-label="Parameter"><code>location</code></td><td data-label="Type">String</td><td data-label="Required">No</td><td data-label="Description">Originating city or geo-coordinates</td></tr>
                        <tr><td data-label="Parameter"><code>deviceFingerprint</code></td><td data-label="Type">String</td><td data-label="Required">No</td><td data-label="Description">Client hardware / browser canvas hash</td></tr>
                    </tbody>
                </table>
            </div>

            <h4>Sample JSON Response (Result Object)</h4>
            <div class="code-snippet">
<pre><code>{
  "status": "FLAGGED",
  "transactionRef": "TXN-8F92A14D",
  "amount": 7500.00,
  "riskScore": 75,
  "riskLevel": "HIGH",
  "triggeredRules": [
    "HighAmountRule (+35)",
    "VelocityRule (+40)"
  ],
  "requiresAnalystReview": true,
  "timestamp": "2026-10-05T18:30:00Z"
}</code></pre>
            </div>
        </article>

        <!-- Section 6: Security & Privacy Model -->
        <article id="security" class="docs-article">
            <h2>6. Security & Privacy Model</h2>
            <div class="docs-callout warning">
                <strong>Data Privacy Guarantee:</strong> Zero personal email addresses, student IDs, or sensitive customer PII are ever exposed in client-facing HTML views, network responses, or client payloads.
            </div>
            <ul>
                <li><strong>Cryptographic Password Salting:</strong> Passwords hashed with PBKDF2 / SHA-256 with cryptographically secure salts.</li>
                <li><strong>SQL Injection Immunity:</strong> 100% of database queries use JDBC <code>PreparedStatement</code> with strict parameter binding.</li>
                <li><strong>Session & Cookie Protection:</strong> <code>HttpOnly</code> cookies preventing cross-site scripting token theft, session rotation upon login.</li>
                <li><strong>HTTP Defense Headers:</strong> <code>X-Content-Type-Options: nosniff</code>, <code>X-Frame-Options: DENY</code>, and <code>X-XSS-Protection</code> injected on all responses.</li>
            </ul>
        </article>

        <!-- Section 7: Troubleshooting -->
        <article id="troubleshooting" class="docs-article">
            <h2>7. Troubleshooting & FAQ</h2>
            <div class="faq-item">
                <h4>Q: Why does my transaction score 100 immediately?</h4>
                <p>The recipient account matches a blacklisted entity or sanction list in <code>BlacklistAccountRule</code>. Switch to a standard test recipient account to test lower risk tiers.</p>
            </div>
            <div class="faq-item">
                <h4>Q: How do I switch themes?</h4>
                <p>Use the celestial theme toggle switch in the top-right navigation bar to switch seamlessly between Obsidian Dark Mode and Refined Ivory Light Mode.</p>
            </div>
        </article>

        <!-- Section 8: TeamRootOps Credits -->
        <article id="team" class="docs-article">
            <h2>8. TeamRootOps Engineering Credits</h2>
            <p>
                FraudGuard was engineered as a core security research initiative by <strong>TeamRootOps</strong> at the <strong>School of Computing Science and Engineering (SCSE), Galgotias University</strong>.
            </p>
            <div class="team-credits-box">
                <div class="team-credits-item">
                    <strong>Rohan Rastogi</strong> &mdash; <em>Team Leader</em>
                </div>
                <div class="team-credits-item">
                    <strong>Anant Kumar</strong> &mdash; <em>Member</em>
                </div>
                <div class="team-credits-item">
                    <strong>Kumar Arya</strong> &mdash; <em>Member</em>
                </div>
                <div class="team-credits-item">
                    <strong>ROHAN TEVATIA</strong> &mdash; <em>Member</em>
                </div>
            </div>
            <div style="margin-top: 1.5rem;">
                <button type="button" class="btn btn-primary" onclick="openTeamModal()">Open TeamRootOps Roster &rarr;</button>
            </div>
        </article>
    </main>
</div>

<jsp:include page="common/footer.jsp" />
