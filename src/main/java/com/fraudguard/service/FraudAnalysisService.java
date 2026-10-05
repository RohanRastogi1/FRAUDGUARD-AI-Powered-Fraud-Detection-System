package com.fraudguard.service;

import com.fraudguard.fraud.FraudDetector;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskScore;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.util.List;
import java.util.Optional;

/**
 * Service orchestrating fraud risk assessment, anomaly detection,
 * and fraud alert investigation lifecycle.
 */
public interface FraudAnalysisService {

    /**
     * Evaluates a transaction against all active fraud detection rules.
     */
    RiskScore evaluateRisk(Transaction transaction, User user, TransactionContext context);

    /**
     * Generates a FraudAlert entity if the risk evaluation justifies alerting.
     */
    FraudAlert createAlertIfNeeded(Transaction transaction, RiskScore score);

    Optional<FraudAlert> getAlertById(Long alertId);
    Optional<FraudAlert> getAlertByTransactionId(Long transactionId);

    List<FraudAlert> getAlertsByUserId(Long userId);
    List<FraudAlert> getAllAlerts(int limit, int offset);
    List<FraudAlert> getAlertsByStatus(AlertStatus status, int limit, int offset);

    boolean updateAlertStatus(Long alertId, AlertStatus status, String analystUsername, String reviewNotes);

    long getOpenAlertCount();
    long getTotalAlertCount();

    FraudDetector getFraudDetector();
}
