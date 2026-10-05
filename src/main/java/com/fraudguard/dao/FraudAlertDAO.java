package com.fraudguard.dao;

import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskLevel;

import java.sql.Connection;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Fraud Alerts.
 */
public interface FraudAlertDAO {

    FraudAlert create(FraudAlert alert);
    FraudAlert create(FraudAlert alert, Connection conn);

    Optional<FraudAlert> findById(Long id);
    Optional<FraudAlert> findByTransactionId(Long transactionId);

    List<FraudAlert> findByUserId(Long userId);
    List<FraudAlert> findAll(int limit, int offset);
    List<FraudAlert> findByStatus(AlertStatus status, int limit, int offset);
    List<FraudAlert> findByRiskLevel(RiskLevel riskLevel, int limit, int offset);

    boolean updateStatus(Long alertId, AlertStatus status, String reviewedBy, String reviewNotes);

    long countOpenAlerts();
    long countTotalAlerts();
}
