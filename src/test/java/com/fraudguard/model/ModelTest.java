package com.fraudguard.model;

import com.fraudguard.exception.InvalidTransactionException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Milestone 1 - Domain Model and Core Java Foundation Tests")
public class ModelTest {

    @Test
    @DisplayName("User model should properly encapsulate fields and default to ACTIVE CUSTOMER")
    void testUserDefaultsAndEncapsulation() {
        User user = new User("alice", "hashed_pwd", "alice@example.com", "Alice Smith", Role.CUSTOMER);
        
        assertEquals("alice", user.getUsername());
        assertEquals("hashed_pwd", user.getPasswordHash());
        assertEquals("alice@example.com", user.getEmail());
        assertEquals("Alice Smith", user.getFullName());
        assertEquals(Role.CUSTOMER, user.getRole());
        assertEquals(UserStatus.ACTIVE, user.getStatus());
        assertTrue(user.isActive());
        assertFalse(user.isAdmin());
        assertTrue(user.canTransact());
        assertEquals(BigDecimal.ZERO, user.getBalance());
        assertNotNull(user.getCreatedAt());
    }

    @Test
    @DisplayName("User admin and analyst role checks should function properly")
    void testUserRoles() {
        User admin = new User(1L, "admin", "pwd", "admin@fraudguard.com", "Admin User",
                Role.ADMIN, UserStatus.ACTIVE, BigDecimal.ZERO, LocalDateTime.now(), LocalDateTime.now());
        assertTrue(admin.isAdmin());
        assertTrue(admin.isAnalyst());

        User analyst = new User(2L, "analyst", "pwd", "analyst@fraudguard.com", "Analyst User",
                Role.ANALYST, UserStatus.ACTIVE, BigDecimal.ZERO, LocalDateTime.now(), LocalDateTime.now());
        assertFalse(analyst.isAdmin());
        assertTrue(analyst.isAnalyst());

        User blockedUser = new User("blocked", "pwd", "b@b.com", "Blocked", Role.CUSTOMER);
        blockedUser.setStatus(UserStatus.BLOCKED);
        assertFalse(blockedUser.canTransact());
    }

    @Test
    @DisplayName("Transaction validation passes for valid parameters")
    void testValidTransactionValidation() {
        Transaction tx = new Transaction(
                1L,
                new BigDecimal("1500.00"),
                "ACC-987654",
                "Bob Jones",
                TransactionType.TRANSFER,
                "New York, US",
                "192.168.1.100",
                "device-fingerprint-abc"
        );

        assertDoesNotThrow(tx::validate);
        assertNotNull(tx.getTransactionRef());
        assertEquals(TransactionStatus.PENDING, tx.getStatus());
        assertEquals("USD", tx.getCurrency());
    }

    @Test
    @DisplayName("Transaction validation throws InvalidTransactionException on bad input")
    void testInvalidTransactionValidation() {
        // Null user
        Transaction tx1 = new Transaction();
        assertThrows(InvalidTransactionException.class, tx1::validate);

        // Zero or negative amount
        Transaction tx2 = new Transaction(1L, BigDecimal.ZERO, "ACC-123", "Bob", TransactionType.TRANSFER, "NY", "127.0.0.1", "dev1");
        assertThrows(InvalidTransactionException.class, tx2::validate);

        Transaction tx3 = new Transaction(1L, new BigDecimal("-50.00"), "ACC-123", "Bob", TransactionType.TRANSFER, "NY", "127.0.0.1", "dev1");
        assertThrows(InvalidTransactionException.class, tx3::validate);

        // Missing recipient account
        Transaction tx4 = new Transaction(1L, new BigDecimal("100.00"), "", "Bob", TransactionType.TRANSFER, "NY", "127.0.0.1", "dev1");
        assertThrows(InvalidTransactionException.class, tx4::validate);

        // Missing recipient name
        Transaction tx5 = new Transaction(1L, new BigDecimal("100.00"), "ACC-123", "  ", TransactionType.TRANSFER, "NY", "127.0.0.1", "dev1");
        assertThrows(InvalidTransactionException.class, tx5::validate);
    }

    @Test
    @DisplayName("RiskScore correctly computes levels and aggregates rule contributions")
    void testRiskScoreAggregation() {
        RiskScore score = new RiskScore();
        assertEquals(0, score.getScore());
        assertEquals(RiskLevel.LOW, score.getLevel());
        assertEquals("APPROVE", score.getRecommendation());
        assertFalse(score.requiresAlert());

        // Add medium risk trigger
        score.addRuleTrigger("HIGH_AMOUNT_RULE", 35, "Amount exceeds typical baseline");
        assertEquals(35, score.getScore());
        assertEquals(RiskLevel.MEDIUM, score.getLevel());
        assertTrue(score.requiresAlert());
        assertEquals("MONITOR", score.getRecommendation());

        // Add additional trigger to push to HIGH
        score.addRuleTrigger("GEOGRAPHIC_ANOMALY_RULE", 30, "Impossible travel detected");
        assertEquals(65, score.getScore());
        assertEquals(RiskLevel.HIGH, score.getLevel());
        assertEquals("FLAG_FOR_REVIEW", score.getRecommendation());
        assertTrue(score.isHighOrCritical());

        // Add critical push
        score.addRuleTrigger("BLACKLIST_RULE", 40, "Recipient in sanctions list");
        assertEquals(100, score.getScore()); // Clamped to 100 max
        assertEquals(RiskLevel.CRITICAL, score.getLevel());
        assertEquals("REJECT_IMMEDIATELY", score.getRecommendation());
        assertTrue(score.isCritical());

        assertEquals(3, score.getTriggeredRules().size());
        assertEquals(3, score.getRuleBreakdown().size());
    }

    @Test
    @DisplayName("FraudAlert encapsualtes incident data accurately")
    void testFraudAlertEncapsulation() {
        FraudAlert alert = new FraudAlert(
                10L, "TXN-998811", 5L,
                new BigDecimal("50000.00"), 85, RiskLevel.CRITICAL,
                "HIGH_AMOUNT_RULE,BLACKLIST_RULE", "High amount transfer to flagged account"
        );

        assertEquals(10L, alert.getTransactionId());
        assertEquals("TXN-998811", alert.getTransactionRef());
        assertEquals(5L, alert.getUserId());
        assertEquals(85, alert.getRiskScore());
        assertEquals(RiskLevel.CRITICAL, alert.getRiskLevel());
        assertEquals(AlertStatus.OPEN, alert.getStatus());
        assertNotNull(alert.getCreatedAt());
    }
}
