package com.fraudguard.integration;

import com.fraudguard.dao.AuditLogDAO;
import com.fraudguard.dao.FraudAlertDAO;
import com.fraudguard.dao.TransactionDAO;
import com.fraudguard.dao.UserDAO;
import com.fraudguard.dao.impl.AuditLogDAOImpl;
import com.fraudguard.dao.impl.FraudAlertDAOImpl;
import com.fraudguard.dao.impl.TransactionDAOImpl;
import com.fraudguard.dao.impl.UserDAOImpl;
import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.Role;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.TransactionType;
import com.fraudguard.model.User;
import com.fraudguard.service.AdminService;
import com.fraudguard.service.AuthenticationService;
import com.fraudguard.service.FraudAnalysisService;
import com.fraudguard.service.TransactionService;
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
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Milestone 9 - End-to-End Pipeline & Boundary Quality Tests")
public class FullPipelineIntegrationTest {

    private static UserDAO userDAO;
    private static TransactionDAO transactionDAO;
    private static FraudAlertDAO fraudAlertDAO;
    private static AuditLogDAO auditLogDAO;

    private static AuthenticationService authService;
    private static FraudAnalysisService fraudAnalysisService;
    private static TransactionService transactionService;
    private static AdminService adminService;

    @BeforeAll
    static void initSuite() throws Exception {
        String h2Url = "jdbc:h2:mem:fraudguard_pipeline_test;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
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
        fraudAnalysisService = new FraudAnalysisServiceImpl(new com.fraudguard.fraud.FraudDetector(), fraudAlertDAO, auditLogDAO);
        transactionService = new TransactionServiceImpl(transactionDAO, userDAO, fraudAnalysisService, auditLogDAO);
        adminService = new AdminServiceImpl(userDAO, transactionDAO, fraudAlertDAO, auditLogDAO);
    }

    @AfterAll
    static void teardown() {
        DatabaseConnection.clearOverrideConfig();
    }

    @BeforeEach
    void clean() throws Exception {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute("DELETE FROM audit_logs");
            stmt.execute("DELETE FROM fraud_alerts");
            stmt.execute("DELETE FROM transactions");
            stmt.execute("DELETE FROM users");
        }
    }

    @Test
    @DisplayName("End-to-End: Customer registers, logs in, executes safe transfer, and checks balance")
    void testEndToEndCustomerLifecycle() throws Exception {
        // 1. Registration
        User customer = authService.register("grace_hopper", "Secret123!", "grace@hopper.org", "Grace Hopper", Role.CUSTOMER);
        assertNotNull(customer.getId());
        assertEquals(0, new BigDecimal("1000.00").compareTo(customer.getBalance()));

        // 2. Authentication
        User loggedIn = authService.authenticate("grace_hopper", "Secret123!", "192.168.1.10");
        assertEquals(customer.getId(), loggedIn.getId());

        // 3. Submit safe transaction ($200)
        Transaction tx = new Transaction(loggedIn.getId(), new BigDecimal("200.00"), "ACC-LIB", "Tech Library",
                TransactionType.PAYMENT, "Boston, US", "192.168.1.10", "grace-mac-dev");
        tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 10, 0));

        TransactionService.TransactionProcessResult result = transactionService.processTransaction(tx, loggedIn);

        assertTrue(result.isSuccess());
        assertEquals(TransactionStatus.APPROVED, result.getTransaction().getStatus());
        assertEquals(RiskLevel.LOW, result.getRiskScore().getLevel());

        // 4. Verify balance is debited to $800.00
        User updated = userDAO.findById(loggedIn.getId()).orElseThrow();
        assertEquals(0, new BigDecimal("800.00").compareTo(updated.getBalance()));

        // 5. Verify transaction history contains 1 record
        List<Transaction> history = transactionService.getUserTransactions(loggedIn.getId(), 10, 0);
        assertEquals(1, history.size());
    }

    @Test
    @DisplayName("End-to-End: Flagged transaction creates alert, analyst resolves alert with review notes")
    void testEndToEndAlertTriageWorkflow() throws Exception {
        // Customer with large balance
        User user = authService.register("rich_user", "RichPass123", "rich@bank.com", "Rich User", Role.CUSTOMER);
        user.setBalance(new BigDecimal("100000.00"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            userDAO.updateBalance(user.getId(), user.getBalance(), conn);
        }

        // Analyst user
        User analyst = authService.register("analyst_clara", "Analyst123!", "clara@bank.com", "Clara Barton", Role.ANALYST);

        // $15,000 transfer triggers HighAmountRule -> FLAGGED
        Transaction tx = new Transaction(user.getId(), new BigDecimal("15000.00"), "ACC-OVERSEAS-1", "Overseas Corp",
                TransactionType.TRANSFER, "Zurich, CH", "10.0.0.1", "dev-pc");
        tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 14, 0));

        TransactionService.TransactionProcessResult result = transactionService.processTransaction(tx, user);

        assertTrue(result.isSuccess());
        assertNotNull(result.getFraudAlert());
        Long alertId = result.getFraudAlert().getId();

        // Verify open alert exists
        assertEquals(1, fraudAnalysisService.getOpenAlertCount());

        // Analyst triages and resolves alert
        boolean resolved = fraudAnalysisService.updateAlertStatus(alertId, AlertStatus.RESOLVED, analyst.getUsername(), "Customer contacted; legitimate procurement transfer.");
        assertTrue(resolved);

        // Verify alert state is now RESOLVED and open count is 0
        FraudAlert reloadedAlert = fraudAnalysisService.getAlertById(alertId).orElseThrow();
        assertEquals(AlertStatus.RESOLVED, reloadedAlert.getStatus());
        assertEquals("analyst_clara", reloadedAlert.getReviewedBy());
        assertEquals(0, fraudAnalysisService.getOpenAlertCount());
    }

    @Test
    @DisplayName("Boundary scoring verifies risk levels 29(LOW), 30(MEDIUM), 59(MEDIUM), 60(HIGH), 84(HIGH), 85(CRITICAL)")
    void testBoundaryScores() {
        assertEquals(RiskLevel.LOW, RiskLevel.fromScore(0));
        assertEquals(RiskLevel.LOW, RiskLevel.fromScore(29));

        assertEquals(RiskLevel.MEDIUM, RiskLevel.fromScore(30));
        assertEquals(RiskLevel.MEDIUM, RiskLevel.fromScore(59));

        assertEquals(RiskLevel.HIGH, RiskLevel.fromScore(60));
        assertEquals(RiskLevel.HIGH, RiskLevel.fromScore(84));

        assertEquals(RiskLevel.CRITICAL, RiskLevel.fromScore(85));
        assertEquals(RiskLevel.CRITICAL, RiskLevel.fromScore(100));
    }
}
