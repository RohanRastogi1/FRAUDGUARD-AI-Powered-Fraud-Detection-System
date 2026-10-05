-- ============================================================
-- FRAUDGUARD: AI-Powered Fraud Detection System
-- Initial Production Seed Data (Users & System Accounts Only)
-- All transactions and fraud alerts are generated live.
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
-- 1. SEED SYSTEM & DEMO USERS
-- Passwords:
-- superadmin@rohanrastogi.in, admin / Admin@123
-- analyst / Analyst@123
-- john_doe, jane_smith, bob_taylor / Customer@123
-- ------------------------------------------------------------
INSERT INTO users (id, username, password_hash, email, full_name, role, status, balance, created_at)
VALUES
(1, 'admin', 'fg_salt_2026$lML0jFQ4sxiZuEX+1XvhD7v/IcbANyCsPazOFN4sq7Q=', 'admin@fraudguard.local', 'Chief Risk Officer (Admin)', 'ADMIN', 'ACTIVE', 0.00, NOW()),
(2, 'analyst', 'fg_salt_2026$Qz407HNlbKg1qqRlg8iPixcRzhI9L+QngCCpyYM4NaI=', 'analyst@fraudguard.local', 'Sarah Connor (Fraud Analyst)', 'ANALYST', 'ACTIVE', 0.00, NOW()),
(3, 'john_doe', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'john.doe@example.com', 'Johnathan Doe', 'CUSTOMER', 'ACTIVE', 25000.00, NOW()),
(4, 'jane_smith', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'jane.smith@example.com', 'Jane Smith', 'CUSTOMER', 'ACTIVE', 15400.00, NOW()),
(5, 'bob_taylor', 'fg_salt_2026$UZ8WCuNPDCV7P3WGTjTUxpRsdT7iRnkvojDsu5DHOcs=', 'bob.taylor@example.com', 'Robert Taylor', 'CUSTOMER', 'ACTIVE', 4800.00, NOW()),
(6, 'superadmin@rohanrastogi.in', 'fg_salt_2026$lML0jFQ4sxiZuEX+1XvhD7v/IcbANyCsPazOFN4sq7Q=', 'superadmin@rohanrastogi.in', 'Rohan Rastogi (SuperAdmin)', 'ADMIN', 'ACTIVE', 50000.00, NOW());

-- Transactions, Fraud Alerts, and Audit Logs are populated exclusively from live traffic.

