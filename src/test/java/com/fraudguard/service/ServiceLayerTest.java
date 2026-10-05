package com.fraudguard.service;

import com.fraudguard.dao.AuditLogDAO;
import com.fraudguard.dao.FraudAlertDAO;
import com.fraudguard.dao.TransactionDAO;
import com.fraudguard.dao.UserDAO;
import com.fraudguard.dao.impl.AuditLogDAOImpl;
import com.fraudguard.dao.impl.FraudAlertDAOImpl;
import com.fraudguard.dao.impl.TransactionDAOImpl;
import com.fraudguard.dao.impl.UserDAOImpl;
import com.fraudguard.exception.AuthenticationException;
import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.Role;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.TransactionType;
import com.fraudguard.model.User;
import com.fraudguard.model.UserStatus;
import com.fraudguard.service.impl.AdminServiceImpl;
import com.fraudguard.service.impl.AuthenticationServiceImpl;
import com.fraudguard.service.impl.FraudAnalysisServiceImpl;
import com.fraudguard.service.impl.TransactionServiceImpl;
import com.fraudguard.util.DatabaseConnection;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Statement;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Milestone 5 - Service Layer Business Logic & Pipeline Tests")
public class ServiceLayerTest {

    private static UserDAO userDAO;
    private static TransactionDAO transactionDAO;
    private static FraudAlertDAO fraudAlertDAO;
    private static AuditLogDAO auditLogDAO;

    private static AuthenticationService authService;
    private static TransactionService transactionService;
    private static FraudAnalysisService fraudAnalysisService;
    private static AdminService adminService;

    @BeforeAll
    static void initDatabase() throws Exception {
        String h2Url = "jdbc:h2:mem:fraudguard_service_test;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
        DatabaseConnection.setOverrideConfig(h2Url, "sa", "", "org.h2.Driver");

        userDAO = new UserDAOImpl();
        fraudAlertDAO = new FraudAlertDAOImpl();
        auditLogDAO = new AuditLogDAOImpl();
        transactionDAO = new TransactionDAOImpl(userDAO, fraudAlertDAO, auditLogDAO);

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

        authService = new AuthenticationServiceImpl(userDAO, auditLogDAO);
        fraudAnalysisService = new FraudAnalysisServiceImpl();
        transactionService = new TransactionServiceImpl(transactionDAO, userDAO, fraudAnalysisService, auditLogDAO);
        adminService = new AdminServiceImpl(userDAO, transactionDAO, fraudAlertDAO, auditLogDAO);
    }

    @AfterAll
    static void cleanup() {
        DatabaseConnection.clearOverrideConfig();
    }

    @BeforeEach
    void resetData() throws Exception {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute("DELETE FROM audit_logs");
            stmt.execute("DELETE FROM fraud_alerts");
            stmt.execute("DELETE FROM transactions");
            stmt.execute("DELETE FROM users");
        }
    }

    @Test
    @DisplayName("AuthenticationService registers, authenticates, and rejects invalid credentials")
    void testAuthenticationWorkflow() {
        User registered = authService.register("charlie", "Secret@123", "charlie@bank.com", "Charlie Brown", Role.CUSTOMER);
        assertNotNull(registered.getId());
        assertEquals("charlie", registered.getUsername());

        // Successful authentication
        User authenticated = authService.authenticate("charlie", "Secret@123", "127.0.0.1");
        assertNotNull(authenticated);
        assertEquals(registered.getId(), authenticated.getId());

        // Failed authentication (wrong password)
        assertThrows(AuthenticationException.class, () -> authService.authenticate("charlie", "WrongPassword", "127.0.0.1"));

        // Suspended account authentication rejection
        userDAO.updateStatus(registered.getId(), UserStatus.SUSPENDED);
        assertThrows(AuthenticationException.class, () -> authService.authenticate("charlie", "Secret@123", "127.0.0.1"));
    }

    @Test
    @DisplayName("TransactionService coordinates engine, approves safe transactions, and debits balance")
    void testNormalTransactionServicePipeline() throws Exception {
        User user = authService.register("david", "DavidPass123", "david@bank.com", "David Copperfield", Role.CUSTOMER);
        user.setBalance(new BigDecimal("5000.00"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            userDAO.updateBalance(user.getId(), user.getBalance(), conn);
        }

        Transaction tx = new Transaction(user.getId(), new BigDecimal("150.00"), "ACC-AMAZON", "Amazon Retail",
                TransactionType.PAYMENT, "Seattle, US", "192.168.1.50", "dev-laptop");
        tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 15, 0));

        TransactionService.TransactionProcessResult result = transactionService.processTransaction(tx, user);

        assertTrue(result.isSuccess());
        assertTrue(result.isApproved());
        assertEquals(TransactionStatus.APPROVED, result.getTransaction().getStatus());
        assertTrue(result.getRiskScore().getScore() < 30);
        assertNull(result.getFraudAlert());

        // Verify balance debited ($5000 - $150 = $4850)
        User reloaded = userDAO.findById(user.getId()).orElseThrow();
        assertEquals(0, new BigDecimal("4850.00").compareTo(reloaded.getBalance()));
    }

    @Test
    @DisplayName("TransactionService flags high-risk transaction and records FraudAlert")
    void testHighRiskTransactionServicePipeline() throws Exception {
        User user = authService.register("eva", "EvaPass123", "eva@bank.com", "Eva Green", Role.CUSTOMER);
        user.setBalance(new BigDecimal("50000.00"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            userDAO.updateBalance(user.getId(), user.getBalance(), conn);
        }

        // $15,000 transfer (HighAmountRule -> 35 pts)
        Transaction tx = new Transaction(user.getId(), new BigDecimal("15000.00"), "ACC-OVERSEAS-77", "Offshore Holdings",
                TransactionType.TRANSFER, "London, UK", "85.200.1.1", "dev-unknown");
        tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 14, 0));

        TransactionService.TransactionProcessResult result = transactionService.processTransaction(tx, user);

        assertTrue(result.isSuccess());
        // Should generate alert
        assertNotNull(result.getFraudAlert());
        assertTrue(result.getFraudAlert().getId() > 0);
        assertEquals(1, fraudAlertDAO.countOpenAlerts());
    }

    @Test
    @DisplayName("TransactionService auto-rejects blacklisted transactions and creates critical alert")
    void testCriticalBlacklistTransactionServicePipeline() {
        User user = authService.register("frank", "FrankPass123", "frank@bank.com", "Frank Castle", Role.CUSTOMER);

        Transaction badTx = new Transaction(user.getId(), new BigDecimal("250.00"), "ACC-SANCTIONED-999", "Sanctioned Entity",
                TransactionType.TRANSFER, "Unknown", "1.1.1.1", "dev-1");
        badTx.setTimestamp(LocalDateTime.of(2026, 10, 5, 12, 0));

        TransactionService.TransactionProcessResult result = transactionService.processTransaction(badTx, user);

        assertTrue(result.isSuccess());
        assertTrue(result.isRejected());
        assertEquals(TransactionStatus.REJECTED, result.getTransaction().getStatus());
        assertTrue(result.getRiskScore().getScore() >= 95);
        assertNotNull(result.getFraudAlert());
    }

    @Test
    @DisplayName("AdminService compiles real database dashboard statistics")
    void testAdminServiceLiveMetrics() {
        User user1 = authService.register("admin_test_1", "pwd12345", "at1@bank.com", "User 1", Role.CUSTOMER);
        User user2 = authService.register("admin_test_2", "pwd12345", "at2@bank.com", "User 2", Role.CUSTOMER);

        Transaction tx = new Transaction(user1.getId(), new BigDecimal("200.00"), "ACC-1", "Shop", TransactionType.PAYMENT, "NY", "1.1.1.1", "dev-1");
        transactionService.processTransaction(tx, user1);

        AdminService.DashboardStatistics stats = adminService.getDashboardStatistics();

        assertEquals(2, stats.getTotalUsers());
        assertEquals(1, stats.getTotalTransactions());
        assertEquals(1, stats.getApprovedCount());
        assertEquals(0, new BigDecimal("200.00").compareTo(stats.getTotalApprovedVolume()));
        assertFalse(stats.getRecentAuditLogs().isEmpty());
    }
}
