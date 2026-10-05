-- ============================================================
-- FRAUDGUARD: AI-Powered Fraud Detection System
-- Initial Production Seed Data
-- ============================================================

USE fraudguard_db;

-- Clear previous data in correct foreign key order
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE audit_logs;
TRUNCATE TABLE fraud_alerts;
TRUNCATE TABLE transactions;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- 1. SEED USERS
-- Passwords:
-- admin / Admin@123
-- analyst / Analyst@123
-- john_doe, jane_smith, bob_taylor / Customer@123
-- ------------------------------------------------------------
INSERT INTO users (id, username, password_hash, email, full_name, role, status, balance, created_at)
VALUES
(1, 'admin', 'fg_salt_2026$lML0jFQ4sxiZuEX+1XvhD7v/IcbANyCsPazOFN4sq7Q=', 'admin@fraudguard.local', 'Chief Risk Officer (Admin)', 'ADMIN', 'ACTIVE', 0.00, NOW() - INTERVAL 30 DAY),
(2, 'analyst', 'fg_salt_2026$Qz407HNlbKg1qqRlg8iPixcRzhI9L+QngCCpyYM4NaI=', 'analyst@fraudguard.local', 'Sarah Connor (Fraud Analyst)', 'ANALYST', 'ACTIVE', 0.00, NOW() - INTERVAL 25 DAY),
(3, 'john_doe', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'john.doe@example.com', 'Johnathan Doe', 'CUSTOMER', 'ACTIVE', 25000.00, NOW() - INTERVAL 20 DAY),
(4, 'jane_smith', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'jane.smith@example.com', 'Jane Smith', 'CUSTOMER', 'ACTIVE', 15400.00, NOW() - INTERVAL 15 DAY),
(5, 'bob_taylor', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'bob.taylor@example.com', 'Robert Taylor', 'CUSTOMER', 'ACTIVE', 4800.00, NOW() - INTERVAL 10 DAY);

-- ------------------------------------------------------------
-- 2. SEED TRANSACTIONS
-- ------------------------------------------------------------
INSERT INTO transactions (id, transaction_ref, user_id, amount, currency, recipient_account, recipient_name, type, status, location, ip_address, device_fingerprint, risk_score, risk_level, notes, created_at)
VALUES
(1, 'TXN-INIT-001', 3, 250.00, 'USD', 'ACC-RET-1001', 'Whole Foods Market', 'PAYMENT', 'APPROVED', 'New York, US', '192.168.1.15', 'dev-macbook-john', 0, 'LOW', 'Approved: Clear transaction profile.', NOW() - INTERVAL 5 DAY),
(2, 'TXN-INIT-002', 3, 1200.00, 'USD', 'ACC-RET-2002', 'Electric Utility Corp', 'TRANSFER', 'APPROVED', 'New York, US', '192.168.1.15', 'dev-macbook-john', 10, 'LOW', 'Approved: Normal recurring payment.', NOW() - INTERVAL 3 DAY),
(3, 'TXN-INIT-003', 4, 18500.00, 'USD', 'ACC-WIRE-8841', 'Apex Global Holdings', 'TRANSFER', 'FLAGGED', 'London, UK', '82.165.197.1', 'dev-windows-work', 65, 'HIGH', 'Flagged for manual compliance review: Elevated amount transfer: $18500.00 exceeds threshold of $10000.00 | High balance drain: transaction consumes 92% of available balance', NOW() - INTERVAL 2 DAY),
(4, 'TXN-INIT-004', 5, 500.00, 'USD', 'ACC-SANCTIONED-999', 'DarkWeb Exchange Node', 'TRANSFER', 'REJECTED', 'Eastern Europe', '198.51.100.99', 'dev-tor-browser-x', 95, 'CRITICAL', 'Auto-rejected by FraudGuard: CRITICAL: Recipient account ACC-SANCTIONED-999 is present on anti-fraud sanctions blacklist', NOW() - INTERVAL 1 DAY),
(5, 'TXN-INIT-005', 4, 150.00, 'USD', 'ACC-RET-3003', 'Metro Transit Card', 'PAYMENT', 'APPROVED', 'New York, US', '192.168.1.25', 'dev-iphone-jane', 0, 'LOW', 'Approved: Clear transaction profile.', NOW() - INTERVAL 12 HOUR);

-- ------------------------------------------------------------
-- 3. SEED FRAUD ALERTS
-- ------------------------------------------------------------
INSERT INTO fraud_alerts (id, transaction_id, transaction_ref, user_id, amount, risk_score, risk_level, triggered_rules, reason, status, reviewed_by, review_notes, created_at)
VALUES
(1, 3, 'TXN-INIT-003', 4, 18500.00, 65, 'HIGH', 'HIGH_AMOUNT_RULE, RAPID_BALANCE_DRAIN_RULE', 'Elevated transfer of $18,500.00 accompanied by 92% account balance drainage', 'OPEN', NULL, NULL, NOW() - INTERVAL 2 DAY),
(2, 4, 'TXN-INIT-004', 5, 500.00, 95, 'CRITICAL', 'BLACKLIST_ACCOUNT_RULE', 'Recipient account ACC-SANCTIONED-999 flagged under OFAC/Anti-Terror sanctions blacklist', 'UNDER_REVIEW', 'analyst', 'Initial triage performed. Case escalated to Federal Compliance Officer.', NOW() - INTERVAL 1 DAY);

-- ------------------------------------------------------------
-- 4. SEED AUDIT LOGS
-- ------------------------------------------------------------
INSERT INTO audit_logs (user_id, username, action, entity_type, entity_id, details, ip_address, created_at)
VALUES
(1, 'admin', 'SYSTEM_INIT', 'SYSTEM', 1, 'Database schema initialized and seed accounts provisioned.', '127.0.0.1', NOW() - INTERVAL 30 DAY),
(3, 'john_doe', 'LOGIN_SUCCESS', 'USER', 3, 'Successful customer authentication.', '192.168.1.15', NOW() - INTERVAL 5 DAY),
(3, 'john_doe', 'TRANSACTION_APPROVED', 'TRANSACTION', 1, 'Transaction TXN-INIT-001 approved automatically (Risk Score: 0).', '192.168.1.15', NOW() - INTERVAL 5 DAY),
(4, 'jane_smith', 'TRANSACTION_FLAGGED', 'TRANSACTION', 3, 'Transaction TXN-INIT-003 flagged for analyst review (Risk Score: 65, Level: HIGH).', '82.165.197.1', NOW() - INTERVAL 2 DAY),
(5, 'bob_taylor', 'TRANSACTION_REJECTED', 'TRANSACTION', 4, 'Transaction TXN-INIT-004 rejected immediately due to blacklist violation (Risk Score: 95).', '198.51.100.99', NOW() - INTERVAL 1 DAY),
(2, 'analyst', 'ALERT_STATUS_UPDATE', 'FRAUD_ALERT', 2, 'Analyst updated Alert #2 status to UNDER_REVIEW.', '127.0.0.1', NOW() - INTERVAL 1 DAY);
