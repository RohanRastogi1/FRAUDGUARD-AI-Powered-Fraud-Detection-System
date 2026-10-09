-- ============================================================
-- FRAUDGUARD: AI-Powered Fraud Detection System
-- Production Initial Seed Data (Indian Rupee / Live Telemetry)
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
-- 1. SEED SYSTEM & DEMO USERS (INR Balances)
-- Passwords:
-- superadmin, admin / Admin@123
-- analyst / Analyst@123
-- john_doe, jane_smith, bob_taylor / Customer@123
-- ------------------------------------------------------------
INSERT INTO users (id, username, password_hash, email, full_name, role, status, balance, created_at)
VALUES
(1, 'admin', 'fg_salt_2026$lML0jFQ4sxiZuEX+1XvhD7v/IcbANyCsPazOFN4sq7Q=', 'admin@fraudguard.local', 'TeamRootOps Admin', 'ADMIN', 'ACTIVE', 0.00, NOW()),
(2, 'analyst', 'fg_salt_2026$Qz407HNlbKg1qqRlg8iPixcRzhI9L+QngCCpyYM4NaI=', 'analyst@fraudguard.local', 'Sarah Connor', 'ANALYST', 'ACTIVE', 0.00, NOW()),
(3, 'john_doe', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'john.doe@example.com', 'Johnathan Doe', 'CUSTOMER', 'ACTIVE', 250000.00, NOW()),
(4, 'jane_smith', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'jane.smith@example.com', 'Jane Smith', 'CUSTOMER', 'ACTIVE', 185400.00, NOW()),
(5, 'superadmin', 'fg_salt_2026$lML0jFQ4sxiZuEX+1XvhD7v/IcbANyCsPazOFN4sq7Q=', 'superadmin@fraudguard.local', 'TeamRootOps', 'ADMIN', 'ACTIVE', 500000.00, NOW()),
(6, 'anant_kumar', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'anant@fraudguard.local', 'Anant Kumar', 'CUSTOMER', 'ACTIVE', 325000.00, NOW()),
(7, 'kumar_arya', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'kumar@fraudguard.local', 'Kumar Arya', 'CUSTOMER', 'ACTIVE', 210000.00, NOW()),
(8, 'rohan_tevatia', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'rohan.tevatia@fraudguard.local', 'Rohan Tevatia', 'CUSTOMER', 'ACTIVE', 480000.00, NOW());

-- ------------------------------------------------------------
-- 2. SEED REAL-TIME INDIAN TRANSACTIONS (INR)
-- ------------------------------------------------------------
INSERT INTO transactions (id, transaction_ref, user_id, amount, currency, recipient_account, recipient_name, type, status, location, ip_address, device_fingerprint, risk_score, risk_level, notes, created_at)
VALUES
(1, 'TXN-IN-982101', 3, 1240.00, 'INR', 'swiggy@icici', 'Swiggy Instamart', 'PAYMENT', 'APPROVED', 'Mumbai, Maharashtra', '103.21.124.50', 'web-mobile-in-01', 10, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -6, CURRENT_TIMESTAMP)),
(2, 'TXN-IN-982102', 4, 14999.00, 'INR', 'flipkart@hdfc', 'Flipkart India Online', 'PAYMENT', 'APPROVED', 'Bengaluru, Karnataka', '49.37.155.88', 'web-client-in-02', 15, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -18, CURRENT_TIMESTAMP)),
(3, 'TXN-IN-982103', 6, 850.00, 'INR', 'zomato@axis', 'Zomato Payments', 'PAYMENT', 'APPROVED', 'New Delhi, Delhi', '157.34.192.12', 'app-android-in-03', 5, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -34, CURRENT_TIMESTAMP)),
(4, 'TXN-IN-982104', 7, 3200.00, 'INR', 'tatapower@sbi', 'Tata Power EV Hub', 'PAYMENT', 'APPROVED', 'Pune, Maharashtra', '182.73.20.91', 'app-ios-in-04', 12, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -52, CURRENT_TIMESTAMP)),
(5, 'TXN-IN-982105', 8, 24800.00, 'INR', 'mmt@kotak', 'MakeMyTrip Booking', 'PAYMENT', 'APPROVED', 'Gurgaon, Haryana', '106.51.77.14', 'web-client-in-05', 22, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -75, CURRENT_TIMESTAMP)),
(6, 'TXN-IN-982106', 3, 2150.00, 'INR', 'apollo@icici', 'Apollo Pharmacy', 'PAYMENT', 'APPROVED', 'Hyderabad, Telangana', '103.21.124.50', 'web-mobile-in-01', 8, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -105, CURRENT_TIMESTAMP)),
(7, 'TXN-IN-982107', 4, 240000.00, 'INR', 'cryptovault@mule', 'CryptoVault Overseas INR', 'TRANSFER', 'FLAGGED', 'Unknown / Tor Proxy', '185.220.101.5', 'tor-exit-node-99', 78, 'HIGH', 'Flagged for analyst compliance review: HIGH_AMOUNT, VELOCITY_SURGE | Risk Score: 78', TIMESTAMPADD(MINUTE, -135, CURRENT_TIMESTAMP)),
(8, 'TXN-IN-982108', 6, 5490.00, 'INR', 'amazonpay@icici', 'Amazon Pay India', 'PAYMENT', 'APPROVED', 'Chennai, Tamil Nadu', '157.34.192.12', 'app-android-in-03', 14, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -160, CURRENT_TIMESTAMP)),
(9, 'TXN-IN-982109', 7, 42500.00, 'INR', 'hdfcbank@hdfc', 'HDFC Credit Card Bill', 'TRANSFER', 'APPROVED', 'Mumbai, Maharashtra', '182.73.20.91', 'app-ios-in-04', 18, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -190, CURRENT_TIMESTAMP)),
(10, 'TXN-IN-982110', 8, 50000.00, 'INR', 'mule9812@fraud', 'Mule Account Transfer', 'TRANSFER', 'REJECTED', 'Lagos, Nigeria (IP Spoofed)', '197.210.45.12', 'spoofed-mule-proxy-44', 95, 'CRITICAL', 'Auto-rejected by FraudGuard: BLACKLISTED_RECIPIENT, GEO_VELOCITY_ANOMALY | Risk Score: 95', TIMESTAMPADD(MINUTE, -240, CURRENT_TIMESTAMP)),
(11, 'TXN-IN-982111', 3, 68500.00, 'INR', 'reliancedigital@sbi', 'Reliance Digital Retail', 'PAYMENT', 'APPROVED', 'Ahmedabad, Gujarat', '103.21.124.50', 'web-mobile-in-01', 25, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -310, CURRENT_TIMESTAMP)),
(12, 'TXN-IN-982112', 6, 4320.00, 'INR', 'irctc@pnb', 'IRCTC Ticket Booking', 'PAYMENT', 'APPROVED', 'Kolkata, West Bengal', '157.34.192.12', 'app-android-in-03', 6, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -380, CURRENT_TIMESTAMP)),
(13, 'TXN-IN-982113', 4, 180000.00, 'INR', 'escrow991@rbl', 'Rapid Mule Drain Escrow', 'TRANSFER', 'FLAGGED', 'Jaipur, Rajasthan', '49.37.155.88', 'web-client-in-02', 82, 'HIGH', 'Flagged for analyst compliance review: RAPID_BALANCE_DRAIN | Risk Score: 82', TIMESTAMPADD(MINUTE, -450, CURRENT_TIMESTAMP)),
(14, 'TXN-IN-982114', 7, 7650.00, 'INR', 'nykaa@icici', 'Nykaa Retail E-commerce', 'PAYMENT', 'APPROVED', 'Bengaluru, Karnataka', '182.73.20.91', 'app-ios-in-04', 12, 'LOW', 'Approved: Standard risk verification passed.', TIMESTAMPADD(MINUTE, -520, CURRENT_TIMESTAMP));

-- ------------------------------------------------------------
-- 3. SEED REAL-TIME FRAUD ALERTS
-- ------------------------------------------------------------
INSERT INTO fraud_alerts (id, transaction_id, transaction_ref, user_id, amount, risk_score, risk_level, triggered_rules, reason, status, reviewed_by, review_notes, created_at, updated_at)
VALUES
(1, 7, 'TXN-IN-982107', 4, 240000.00, 78, 'HIGH', 'HIGH_AMOUNT, VELOCITY_SURGE', 'Single transfer ₹2,40,000.00 exceeded threshold and uncharacteristic velocity surge detected.', 'OPEN', NULL, NULL, TIMESTAMPADD(MINUTE, -135, CURRENT_TIMESTAMP), TIMESTAMPADD(MINUTE, -135, CURRENT_TIMESTAMP)),
(2, 10, 'TXN-IN-982110', 8, 50000.00, 95, 'CRITICAL', 'BLACKLISTED_RECIPIENT, GEO_VELOCITY_ANOMALY', 'Recipient account matches national mule registry blacklist; unfeasible geo-hop detected.', 'OPEN', NULL, NULL, TIMESTAMPADD(MINUTE, -240, CURRENT_TIMESTAMP), TIMESTAMPADD(MINUTE, -240, CURRENT_TIMESTAMP)),
(3, 13, 'TXN-IN-982113', 4, 180000.00, 82, 'HIGH', 'RAPID_BALANCE_DRAIN', 'Transfer represents >80% drain of available liquid balance within minutes of session start.', 'RESOLVED', 'TeamRootOps Admin', 'Customer verified via secondary out-of-band biometric authentication.', TIMESTAMPADD(MINUTE, -450, CURRENT_TIMESTAMP), TIMESTAMPADD(MINUTE, -420, CURRENT_TIMESTAMP));

-- ------------------------------------------------------------
-- 4. SEED AUDIT LOGS
-- ------------------------------------------------------------
INSERT INTO audit_logs (id, user_id, username, action, entity_type, entity_id, details, ip_address, created_at)
VALUES
(1, 1, 'admin', 'SYSTEM_INIT', 'SYSTEM', 1, 'FraudGuard AI engine initialized with INR currency and real-time behavioral heuristic rules.', '127.0.0.1', TIMESTAMPADD(MINUTE, -600, CURRENT_TIMESTAMP)),
(2, 4, 'jane_smith', 'FLAGGED_TRANSACTION', 'TRANSACTION', 7, 'Transaction TXN-IN-982107 flagged for compliance review (Risk Score: 78, Rules: HIGH_AMOUNT, VELOCITY_SURGE).', '185.220.101.5', TIMESTAMPADD(MINUTE, -135, CURRENT_TIMESTAMP)),
(3, 8, 'rohan_tevatia', 'BLOCKED_TRANSACTION', 'TRANSACTION', 10, 'Transaction TXN-IN-982110 auto-rejected by FraudGuard (Risk Score: 95, Rules: BLACKLISTED_RECIPIENT, GEO_VELOCITY_ANOMALY).', '197.210.45.12', TIMESTAMPADD(MINUTE, -240, CURRENT_TIMESTAMP)),
(4, 1, 'admin', 'RESOLVED_ALERT', 'FRAUD_ALERT', 3, 'Alert #3 for TXN-IN-982113 resolved by TeamRootOps Admin following customer authentication.', '127.0.0.1', TIMESTAMPADD(MINUTE, -420, CURRENT_TIMESTAMP));
