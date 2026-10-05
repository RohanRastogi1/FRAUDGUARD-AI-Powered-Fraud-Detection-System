package com.fraudguard.dao;

import com.fraudguard.dao.impl.AuditLogDAOImpl;
import com.fraudguard.dao.impl.FraudAlertDAOImpl;
import com.fraudguard.dao.impl.TransactionDAOImpl;
import com.fraudguard.dao.impl.UserDAOImpl;
import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.AuditLog;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.Role;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.TransactionType;
import com.fraudguard.model.User;
import com.fraudguard.model.UserStatus;
import com.fraudguard.util.DatabaseConnection;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Milestone 4 - JDBC DAO Layer & ACID Transaction Management Tests")
public class JdbcDaoTest {

    private static UserDAO userDAO;
    private static TransactionDAO transactionDAO;
    private static FraudAlertDAO fraudAlertDAO;
    private static AuditLogDAO auditLogDAO;

    @BeforeAll
    static void initDatabase() throws Exception {
        // Point DatabaseConnection to in-memory H2 instance with MySQL compatibility mode
        String h2Url = "jdbc:h2:mem:fraudguard_test;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
        DatabaseConnection.setOverrideConfig(h2Url, "sa", "", "org.h2.Driver");

        userDAO = new UserDAOImpl();
        fraudAlertDAO = new FraudAlertDAOImpl();
        auditLogDAO = new AuditLogDAOImpl();
        transactionDAO = new TransactionDAOImpl(userDAO, fraudAlertDAO, auditLogDAO);

        // Create in-memory tables
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(50) NOT NULL UNIQUE, " +
                    "password_hash VARCHAR(255) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "full_name VARCHAR(100) NOT NULL, " +
                    "role VARCHAR(20) NOT NULL, " +
                    "status VARCHAR(20) NOT NULL, " +
                    "balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            stmt.execute("CREATE TABLE IF NOT EXISTS transactions (" +
                    "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                    "transaction_ref VARCHAR(64) NOT NULL UNIQUE, " +
                    "user_id BIGINT NOT NULL, " +
                    "amount DECIMAL(15, 2) NOT NULL, " +
                    "currency VARCHAR(3) NOT NULL, " +
                    "recipient_account VARCHAR(64) NOT NULL, " +
                    "recipient_name VARCHAR(100) NOT NULL, " +
                    "type VARCHAR(20) NOT NULL, " +
                    "status VARCHAR(20) NOT NULL, " +
                    "location VARCHAR(100), " +
                    "ip_address VARCHAR(45), " +
                    "device_fingerprint VARCHAR(100), " +
                    "risk_score INT NOT NULL, " +
                    "risk_level VARCHAR(20) NOT NULL, " +
                    "notes TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            stmt.execute("CREATE TABLE IF NOT EXISTS fraud_alerts (" +
                    "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                    "transaction_id BIGINT NOT NULL, " +
                    "transaction_ref VARCHAR(64) NOT NULL, " +
                    "user_id BIGINT NOT NULL, " +
                    "amount DECIMAL(15, 2) NOT NULL, " +
                    "risk_score INT NOT NULL, " +
                    "risk_level VARCHAR(20) NOT NULL, " +
                    "triggered_rules VARCHAR(500) NOT NULL, " +
                    "reason TEXT NOT NULL, " +
                    "status VARCHAR(20) NOT NULL, " +
                    "reviewed_by VARCHAR(50), " +
                    "review_notes TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            stmt.execute("CREATE TABLE IF NOT EXISTS audit_logs (" +
                    "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id BIGINT, " +
                    "username VARCHAR(50), " +
                    "action VARCHAR(100) NOT NULL, " +
                    "entity_type VARCHAR(50) NOT NULL, " +
                    "entity_id BIGINT, " +
                    "details TEXT, " +
                    "ip_address VARCHAR(45), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
        }
    }

    @AfterAll
    static void cleanup() {
        DatabaseConnection.clearOverrideConfig();
    }

    @BeforeEach
    void resetTables() throws Exception {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute("DELETE FROM audit_logs");
            stmt.execute("DELETE FROM fraud_alerts");
            stmt.execute("DELETE FROM transactions");
            stmt.execute("DELETE FROM users");
        }
    }

    @Test
    @DisplayName("UserDAO CRUD operations and balance updates operate correctly")
    void testUserDaoCrud() throws Exception {
        User user = new User("test_alice", "hash_abc", "alice@test.com", "Alice Tester", Role.CUSTOMER);
        user.setBalance(new BigDecimal("5000.00"));

        User created = userDAO.create(user);
        assertNotNull(created.getId());
        assertTrue(created.getId() > 0);

        // Find by ID
        Optional<User> found = userDAO.findById(created.getId());
        assertTrue(found.isPresent());
        assertEquals("test_alice", found.get().getUsername());
        assertEquals(0, new BigDecimal("5000.00").compareTo(found.get().getBalance()));

        // Find by Username
        Optional<User> byUser = userDAO.findByUsername("test_alice");
        assertTrue(byUser.isPresent());

        // Update balance
        try (Connection conn = DatabaseConnection.getConnection()) {
            boolean updated = userDAO.updateBalance(created.getId(), new BigDecimal("4500.00"), conn);
            assertTrue(updated);
        }
        assertEquals(0, new BigDecimal("4500.00").compareTo(userDAO.findById(created.getId()).get().getBalance()));

        // Update status
        userDAO.updateStatus(created.getId(), UserStatus.SUSPENDED);
        assertEquals(UserStatus.SUSPENDED, userDAO.findById(created.getId()).get().getStatus());

        assertEquals(1, userDAO.countUsers());
    }

    @Test
    @DisplayName("TransactionDAO CRUD and aggregation queries function properly")
    void testTransactionDaoCrudAndAggregation() {
        User user = userDAO.create(new User("tx_user", "hash", "tx@test.com", "Tx User", Role.CUSTOMER));

        Transaction tx1 = new Transaction(user.getId(), new BigDecimal("150.00"), "ACC-1", "Shop 1", TransactionType.PAYMENT, "NY", "1.1.1.1", "dev-1");
        tx1.setStatus(TransactionStatus.APPROVED);
        Transaction saved1 = transactionDAO.create(tx1);
        assertNotNull(saved1.getId());

        Transaction tx2 = new Transaction(user.getId(), new BigDecimal("350.00"), "ACC-2", "Shop 2", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        tx2.setStatus(TransactionStatus.APPROVED);
        transactionDAO.create(tx2);

        Transaction tx3 = new Transaction(user.getId(), new BigDecimal("12000.00"), "ACC-3", "Shop 3", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        tx3.setStatus(TransactionStatus.FLAGGED);
        tx3.setRiskScore(65);
        tx3.setRiskLevel(RiskLevel.HIGH);
        transactionDAO.create(tx3);

        assertEquals(3, transactionDAO.countTotalTransactions());
        assertEquals(2, transactionDAO.countByStatus(TransactionStatus.APPROVED));
        assertEquals(1, transactionDAO.countByStatus(TransactionStatus.FLAGGED));
        assertEquals(0, new BigDecimal("500.00").compareTo(transactionDAO.sumTotalApprovedVolume()));

        List<Transaction> userTxs = transactionDAO.findByUserId(user.getId(), 10, 0);
        assertEquals(3, userTxs.size());
    }

    @Test
    @DisplayName("FraudAlertDAO creates, retrieves, and updates alert lifecycle state")
    void testFraudAlertDaoOperations() {
        User user = userDAO.create(new User("alert_user", "hash", "alert@test.com", "Alert User", Role.CUSTOMER));
        Transaction tx = transactionDAO.create(new Transaction(user.getId(), new BigDecimal("20000.00"), "ACC-X", "Merchant", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1"));

        FraudAlert alert = new FraudAlert(
                tx.getId(), tx.getTransactionRef(), user.getId(),
                new BigDecimal("20000.00"), 75, RiskLevel.HIGH,
                "HIGH_AMOUNT_RULE", "Transferred $20,000"
        );
        FraudAlert created = fraudAlertDAO.create(alert);
        assertNotNull(created.getId());
        assertEquals(AlertStatus.OPEN, created.getStatus());

        assertEquals(1, fraudAlertDAO.countOpenAlerts());

        // Analyst review update
        boolean updated = fraudAlertDAO.updateStatus(created.getId(), AlertStatus.RESOLVED, "sarah_analyst", "Customer verified transfer via phone OTP.");
        assertTrue(updated);

        FraudAlert resolved = fraudAlertDAO.findById(created.getId()).orElseThrow();
        assertEquals(AlertStatus.RESOLVED, resolved.getStatus());
        assertEquals("sarah_analyst", resolved.getReviewedBy());
        assertEquals("Customer verified transfer via phone OTP.", resolved.getReviewNotes());
        assertEquals(0, fraudAlertDAO.countOpenAlerts());
    }

    @Test
    @DisplayName("AuditLogDAO persists and retrieves audit records")
    void testAuditLogDao() {
        AuditLog log = new AuditLog(1L, "admin", "SYSTEM_START", "SYSTEM", 1L, "System booted", "127.0.0.1");
        AuditLog created = auditLogDAO.create(log);
        assertNotNull(created.getId());

        List<AuditLog> recent = auditLogDAO.findRecent(10);
        assertEquals(1, recent.size());
        assertEquals("SYSTEM_START", recent.get(0).getAction());
    }

    @Test
    @DisplayName("Atomic transfer succeeds: debits sender, credits recipient, records tx and audit in single commit")
    void testAtomicTransferSuccess() throws Exception {
        User sender = userDAO.create(new User("sender", "h", "sender@t.com", "Sender User", Role.CUSTOMER));
        sender.setBalance(new BigDecimal("1000.00"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            userDAO.updateBalance(sender.getId(), sender.getBalance(), conn);
        }

        User recipient = userDAO.create(new User("recipient", "h", "recip@t.com", "Recipient User", Role.CUSTOMER));
        recipient.setBalance(new BigDecimal("200.00"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            userDAO.updateBalance(recipient.getId(), recipient.getBalance(), conn);
        }

        Transaction tx = new Transaction(sender.getId(), new BigDecimal("300.00"), "ACC-RECIP", recipient.getFullName(), TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        tx.setStatus(TransactionStatus.APPROVED);

        AuditLog auditLog = new AuditLog(sender.getId(), sender.getUsername(), "TRANSFER_EXECUTED", "TRANSACTION", null, "Transferred $300", "1.1.1.1");

        TransactionDAO.AtomicTransferResult result = transactionDAO.executeAtomicTransfer(
                tx, sender, recipient.getId(), null, auditLog
        );

        assertTrue(result.isSuccess());
        assertNotNull(result.getTransaction().getId());

        // Verify sender was debited to $700
        User updatedSender = userDAO.findById(sender.getId()).orElseThrow();
        assertEquals(0, new BigDecimal("700.00").compareTo(updatedSender.getBalance()));

        // Verify recipient was credited to $500
        User updatedRecipient = userDAO.findById(recipient.getId()).orElseThrow();
        assertEquals(0, new BigDecimal("500.00").compareTo(updatedRecipient.getBalance()));

        // Verify audit log exists
        List<AuditLog> logs = auditLogDAO.findRecent(5);
        assertEquals(1, logs.size());
    }

    @Test
    @DisplayName("Atomic transfer rolls back on insufficient funds without modifying balances or persisting partial data")
    void testAtomicTransferRollbackOnInsufficientFunds() throws Exception {
        User sender = userDAO.create(new User("poor_sender", "h", "p@t.com", "Poor Sender", Role.CUSTOMER));
        sender.setBalance(new BigDecimal("50.00")); // Only $50
        try (Connection conn = DatabaseConnection.getConnection()) {
            userDAO.updateBalance(sender.getId(), sender.getBalance(), conn);
        }

        User recipient = userDAO.create(new User("recip2", "h", "r2@t.com", "Recipient 2", Role.CUSTOMER));
        recipient.setBalance(new BigDecimal("100.00"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            userDAO.updateBalance(recipient.getId(), recipient.getBalance(), conn);
        }

        // Attempt transfer of $500 (exceeds $50 balance)
        Transaction tx = new Transaction(sender.getId(), new BigDecimal("500.00"), "ACC-R2", recipient.getFullName(), TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        tx.setStatus(TransactionStatus.APPROVED);

        AuditLog auditLog = new AuditLog(sender.getId(), sender.getUsername(), "TRANSFER_ATTEMPT", "TRANSACTION", null, "Attempted $500", "1.1.1.1");

        TransactionDAO.AtomicTransferResult result = transactionDAO.executeAtomicTransfer(
                tx, sender, recipient.getId(), null, auditLog
        );

        // Transfer should fail and rollback
        assertFalse(result.isSuccess());
        assertEquals("Insufficient funds in account.", result.getMessage());

        // Verify sender balance is unchanged ($50.00)
        User reloadedSender = userDAO.findById(sender.getId()).orElseThrow();
        assertEquals(0, new BigDecimal("50.00").compareTo(reloadedSender.getBalance()));

        // Verify recipient balance is unchanged ($100.00)
        User reloadedRecipient = userDAO.findById(recipient.getId()).orElseThrow();
        assertEquals(0, new BigDecimal("100.00").compareTo(reloadedRecipient.getBalance()));

        // Verify no orphaned transaction was committed
        assertEquals(0, transactionDAO.countTotalTransactions());
    }
}
