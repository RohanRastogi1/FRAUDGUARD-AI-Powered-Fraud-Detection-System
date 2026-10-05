package com.fraudguard.fraud;

import com.fraudguard.exception.InvalidTransactionException;
import com.fraudguard.fraud.rules.BlacklistAccountRule;
import com.fraudguard.fraud.rules.GeographicAnomalyRule;
import com.fraudguard.fraud.rules.HighAmountRule;
import com.fraudguard.fraud.rules.NewDeviceRule;
import com.fraudguard.fraud.rules.RapidBalanceDrainRule;
import com.fraudguard.fraud.rules.UnusualHourRule;
import com.fraudguard.fraud.rules.VelocityRule;
import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.RiskScore;
import com.fraudguard.model.Role;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.TransactionType;
import com.fraudguard.model.User;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Milestone 2 - Fraud Detection Engine and Rules Tests")
public class FraudDetectionEngineTest {

    private FraudDetector detector;
    private TransactionProcessor processor;
    private User testUser;

    @BeforeEach
    void setUp() {
        detector = new FraudDetector();
        processor = new TransactionProcessor(detector, 4);
        testUser = new User("johndoe", "hash123", "john@example.com", "John Doe", Role.CUSTOMER);
        testUser.setId(101L);
        testUser.setBalance(new BigDecimal("10000.00"));
    }

    @AfterEach
    void tearDown() {
        if (processor != null && !processor.isShutdown()) {
            processor.shutdown();
        }
    }

    @Test
    @DisplayName("HighAmountRule triggers appropriately for elevated and critical thresholds")
    void testHighAmountRule() {
        HighAmountRule rule = new HighAmountRule();

        // Normal amount ($500)
        Transaction tNormal = new Transaction(101L, new BigDecimal("500.00"), "ACC-100", "Alice", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        RuleEvaluation evalNormal = rule.evaluate(tNormal, testUser, new TransactionContext());
        assertFalse(evalNormal.isTriggered());

        // Elevated amount ($15,000)
        Transaction tElevated = new Transaction(101L, new BigDecimal("15000.00"), "ACC-100", "Alice", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        RuleEvaluation evalElevated = rule.evaluate(tElevated, testUser, new TransactionContext());
        assertTrue(evalElevated.isTriggered());
        assertEquals(35, evalElevated.getScoreContribution());

        // Critical amount ($60,000)
        Transaction tCritical = new Transaction(101L, new BigDecimal("60000.00"), "ACC-100", "Alice", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        RuleEvaluation evalCritical = rule.evaluate(tCritical, testUser, new TransactionContext());
        assertTrue(evalCritical.isTriggered());
        assertEquals(60, evalCritical.getScoreContribution());
    }

    @Test
    @DisplayName("VelocityRule detects rapid bursts of transactions in short timeframe")
    void testVelocityRule() {
        VelocityRule rule = new VelocityRule();
        TransactionContext context = new TransactionContext();
        LocalDateTime now = LocalDateTime.now();

        // Add 3 past transactions in the last 2 minutes
        for (int i = 0; i < 3; i++) {
            Transaction past = new Transaction(101L, new BigDecimal("100.00"), "ACC-" + i, "Recip " + i, TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
            past.setTimestamp(now.minusMinutes(1));
            context.addRecentTransaction(past);
        }

        // 4th transaction triggers velocity
        Transaction incoming = new Transaction(101L, new BigDecimal("150.00"), "ACC-99", "Target", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        incoming.setTimestamp(now);

        RuleEvaluation eval = rule.evaluate(incoming, testUser, context);
        assertTrue(eval.isTriggered());
        assertTrue(eval.getScoreContribution() >= 40);
    }

    @Test
    @DisplayName("GeographicAnomalyRule detects impossible physical travel")
    void testGeographicAnomalyRule() {
        GeographicAnomalyRule rule = new GeographicAnomalyRule();
        TransactionContext context = new TransactionContext();
        LocalDateTime now = LocalDateTime.now();

        // 10 minutes ago in Tokyo, Japan
        Transaction past = new Transaction(101L, new BigDecimal("200.00"), "ACC-1", "Shop JP", TransactionType.PAYMENT, "Tokyo, JP", "1.1.1.1", "dev-1");
        past.setTimestamp(now.minusMinutes(10));
        context.addRecentTransaction(past);

        // Current transaction in New York, US
        Transaction current = new Transaction(101L, new BigDecimal("300.00"), "ACC-2", "Shop US", TransactionType.PAYMENT, "New York, US", "2.2.2.2", "dev-1");
        current.setTimestamp(now);

        RuleEvaluation eval = rule.evaluate(current, testUser, context);
        assertTrue(eval.isTriggered());
        assertEquals(45, eval.getScoreContribution());
        assertTrue(eval.getReason().contains("Impossible travel"));
    }

    @Test
    @DisplayName("BlacklistAccountRule flags sanctioned accounts critically")
    void testBlacklistAccountRule() {
        BlacklistAccountRule rule = new BlacklistAccountRule();

        // Transfer to sanctioned recipient
        Transaction badTx = new Transaction(101L, new BigDecimal("100.00"), "ACC-SANCTIONED-999", "Bad Actor", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        RuleEvaluation eval = rule.evaluate(badTx, testUser, new TransactionContext());

        assertTrue(eval.isTriggered());
        assertTrue(eval.isCritical());
        assertEquals(95, eval.getScoreContribution());
    }

    @Test
    @DisplayName("UnusualHourRule flags off-hours activity between 1 AM and 5 AM")
    void testUnusualHourRule() {
        UnusualHourRule rule = new UnusualHourRule();

        // Transaction at 03:30 AM
        Transaction lateNight = new Transaction(101L, new BigDecimal("100.00"), "ACC-1", "Store", TransactionType.PAYMENT, "NY", "1.1.1.1", "dev-1");
        lateNight.setTimestamp(LocalDateTime.of(2026, 10, 5, 3, 30));
        RuleEvaluation evalNight = rule.evaluate(lateNight, testUser, new TransactionContext());
        assertTrue(evalNight.isTriggered());

        // Transaction at 14:30 PM (2:30 PM)
        Transaction dayTime = new Transaction(101L, new BigDecimal("100.00"), "ACC-1", "Store", TransactionType.PAYMENT, "NY", "1.1.1.1", "dev-1");
        dayTime.setTimestamp(LocalDateTime.of(2026, 10, 5, 14, 30));
        RuleEvaluation evalDay = rule.evaluate(dayTime, testUser, new TransactionContext());
        assertFalse(evalDay.isTriggered());
    }

    @Test
    @DisplayName("NewDeviceRule flags unrecognized hardware for known user")
    void testNewDeviceRule() {
        NewDeviceRule rule = new NewDeviceRule();
        TransactionContext context = new TransactionContext();
        context.addKnownDevice("iphone-15-pro-mac");

        // Transaction from untrusted/new device
        Transaction newDevTx = new Transaction(101L, new BigDecimal("250.00"), "ACC-1", "Store", TransactionType.PAYMENT, "NY", "1.1.1.1", "unknown-android-dev");
        RuleEvaluation eval = rule.evaluate(newDevTx, testUser, context);
        assertTrue(eval.isTriggered());
        assertEquals(25, eval.getScoreContribution());

        // Transaction from known device
        Transaction knownDevTx = new Transaction(101L, new BigDecimal("250.00"), "ACC-1", "Store", TransactionType.PAYMENT, "NY", "1.1.1.1", "iphone-15-pro-mac");
        RuleEvaluation evalKnown = rule.evaluate(knownDevTx, testUser, context);
        assertFalse(evalKnown.isTriggered());
    }

    @Test
    @DisplayName("RapidBalanceDrainRule flags transactions liquidating over 85% of balance")
    void testRapidBalanceDrainRule() {
        RapidBalanceDrainRule rule = new RapidBalanceDrainRule();
        testUser.setBalance(new BigDecimal("1000.00"));

        // Draining $950 out of $1000 (95%)
        Transaction drainTx = new Transaction(101L, new BigDecimal("950.00"), "ACC-1", "Transfer", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        RuleEvaluation evalDrain = rule.evaluate(drainTx, testUser, new TransactionContext());
        assertTrue(evalDrain.isTriggered());
        assertEquals(30, evalDrain.getScoreContribution());

        // Moderate amount ($100 out of $1000 - 10%)
        Transaction normalTx = new Transaction(101L, new BigDecimal("100.00"), "ACC-1", "Transfer", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        RuleEvaluation evalNormal = rule.evaluate(normalTx, testUser, new TransactionContext());
        assertFalse(evalNormal.isTriggered());
    }

    @Test
    @DisplayName("Normal transaction completes with LOW risk and APPROVED status")
    void testNormalTransactionApproval() {
        Transaction tx = new Transaction(101L, new BigDecimal("75.00"), "ACC-CLEAN-1", "Grocery Mart", TransactionType.PAYMENT, "Chicago, US", "10.0.0.1", "dev-laptop");
        tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 11, 0)); // Daytime

        TransactionProcessor.ProcessingResult result = processor.process(tx, testUser);

        assertEquals(TransactionStatus.APPROVED, result.getTransaction().getStatus());
        assertEquals(RiskLevel.LOW, result.getRiskScore().getLevel());
        assertTrue(result.getRiskScore().getScore() < 30);
        assertFalse(result.isAlertGenerated());
        assertEquals(1, processor.getApprovedCount());
    }

    @Test
    @DisplayName("Suspicious transaction is monitored and generates alert")
    void testSuspiciousTransactionHandling() {
        // Set user balance high ($100,000) so balance drain rule does not trigger
        testUser.setBalance(new BigDecimal("100000.00"));
        // Amount $12,000 triggers HighAmountRule (35 points) -> MEDIUM Risk (30-59)
        Transaction tx = new Transaction(101L, new BigDecimal("12000.00"), "ACC-CORP-5", "Wholesale Dist", TransactionType.TRANSFER, "NY", "10.0.0.1", "dev-laptop");
        tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 12, 0));

        TransactionProcessor.ProcessingResult result = processor.process(tx, testUser);

        assertEquals(RiskLevel.MEDIUM, result.getRiskScore().getLevel());
        assertTrue(result.isAlertGenerated());
        assertTrue(result.getRiskScore().getTriggeredRules().contains("HIGH_AMOUNT_RULE"));
    }

    @Test
    @DisplayName("Multi-rule compound triggers elevate risk to HIGH and FLAGGED status")
    void testHighRiskCompoundRules() {
        // Balance is $10,000; Transfer $9,000 (90% drain = 30 pts) + late night 3 AM (20 pts) = 50 pts
        // Or drain (30 pts) + high amount $12,000 (35 pts) = 65 pts -> HIGH Risk
        testUser.setBalance(new BigDecimal("10000.00"));
        Transaction tx = new Transaction(101L, new BigDecimal("9500.00"), "ACC-CORP-5", "Wholesale Dist", TransactionType.TRANSFER, "NY", "10.0.0.1", "dev-laptop");
        tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 3, 30)); // Late night (20 pts) + balance drain (30 pts) + high amount is < 10000

        // Let's add High Amount as well: $12,000 -> 35 pts (high amount) + 30 pts (drain) = 65 pts (HIGH)
        Transaction txCompound = new Transaction(101L, new BigDecimal("12000.00"), "ACC-CORP-5", "Wholesale Dist", TransactionType.TRANSFER, "NY", "10.0.0.1", "dev-laptop");
        txCompound.setTimestamp(LocalDateTime.of(2026, 10, 5, 12, 0));

        TransactionProcessor.ProcessingResult result = processor.process(txCompound, testUser);

        assertEquals(TransactionStatus.FLAGGED, result.getTransaction().getStatus());
        assertEquals(RiskLevel.HIGH, result.getRiskScore().getLevel());
        assertTrue(result.getRiskScore().getScore() >= 60 && result.getRiskScore().getScore() < 85);
        assertTrue(result.isAlertGenerated());
        assertEquals(1, processor.getFlaggedCount());
    }

    @Test
    @DisplayName("Critical transaction to blacklisted account is immediately REJECTED")
    void testCriticalTransactionRejection() {
        Transaction tx = new Transaction(101L, new BigDecimal("500.00"), "ACC-FRAUD-007", "Scam Merchant", TransactionType.TRANSFER, "NY", "10.0.0.1", "dev-laptop");
        tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 12, 0));

        TransactionProcessor.ProcessingResult result = processor.process(tx, testUser);

        assertEquals(TransactionStatus.REJECTED, result.getTransaction().getStatus());
        assertEquals(RiskLevel.CRITICAL, result.getRiskScore().getLevel());
        assertTrue(result.getRiskScore().getScore() >= 95);
        assertTrue(result.isAlertGenerated());
        assertEquals(1, processor.getRejectedCount());
    }

    @Test
    @DisplayName("Invalid transaction throws InvalidTransactionException")
    void testInvalidTransactionThrowsException() {
        Transaction invalidTx = new Transaction(101L, new BigDecimal("-100.00"), "ACC-1", "Bob", TransactionType.TRANSFER, "NY", "1.1.1.1", "dev-1");
        assertThrows(InvalidTransactionException.class, () -> processor.process(invalidTx, testUser));
    }

    @Test
    @DisplayName("Concurrent transaction processing across worker threads operates safely")
    void testConcurrentTransactionProcessing() throws ExecutionException, InterruptedException {
        int transactionCount = 20;
        List<Future<TransactionProcessor.ProcessingResult>> futures = new ArrayList<>();

        for (int i = 0; i < transactionCount; i++) {
            final int index = i;
            BigDecimal amount = new BigDecimal(50 + index * 10);
            Transaction tx = new Transaction(101L, amount, "ACC-CONCURRENT-" + index, "Merchant " + index,
                    TransactionType.PAYMENT, "Dallas, US", "192.168.1." + (index + 1), "device-" + index);
            tx.setTimestamp(LocalDateTime.of(2026, 10, 5, 14, 0));

            futures.add(processor.submitAsync(tx, testUser));
        }

        for (Future<TransactionProcessor.ProcessingResult> future : futures) {
            TransactionProcessor.ProcessingResult result = future.get();
            assertNotNull(result);
            assertNotNull(result.getTransaction().getStatus());
            assertNotNull(result.getRiskScore());
        }

        assertEquals(transactionCount, processor.getTotalProcessed());
        assertTrue(processor.getApprovedCount() + processor.getFlaggedCount() + processor.getRejectedCount() == transactionCount);
    }
}
