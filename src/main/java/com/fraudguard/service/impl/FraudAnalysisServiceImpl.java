package com.fraudguard.service.impl;

import com.fraudguard.dao.AuditLogDAO;
import com.fraudguard.dao.FraudAlertDAO;
import com.fraudguard.dao.impl.AuditLogDAOImpl;
import com.fraudguard.dao.impl.FraudAlertDAOImpl;
import com.fraudguard.fraud.FraudDetector;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.AuditLog;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskScore;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;
import com.fraudguard.service.FraudAnalysisService;

import java.util.List;
import java.util.Optional;

/**
 * Implementation of FraudAnalysisService coordinating the FraudDetector rule engine
 * with database persistence.
 */
public class FraudAnalysisServiceImpl implements FraudAnalysisService {

    private final FraudDetector fraudDetector;
    private final FraudAlertDAO fraudAlertDAO;
    private final AuditLogDAO auditLogDAO;

    public FraudAnalysisServiceImpl() {
        this(new FraudDetector(), new FraudAlertDAOImpl(), new AuditLogDAOImpl());
    }

    public FraudAnalysisServiceImpl(FraudDetector fraudDetector, FraudAlertDAO fraudAlertDAO, AuditLogDAO auditLogDAO) {
        this.fraudDetector = fraudDetector != null ? fraudDetector : new FraudDetector();
        this.fraudAlertDAO = fraudAlertDAO;
        this.auditLogDAO = auditLogDAO;
    }

    @Override
    public RiskScore evaluateRisk(Transaction transaction, User user, TransactionContext context) {
        return fraudDetector.evaluate(transaction, user, context);
    }

    @Override
    public FraudAlert createAlertIfNeeded(Transaction transaction, RiskScore score) {
        return fraudDetector.generateAlertIfNeeded(transaction, score);
    }

    @Override
    public Optional<FraudAlert> getAlertById(Long alertId) {
        return fraudAlertDAO.findById(alertId);
    }

    @Override
    public Optional<FraudAlert> getAlertByTransactionId(Long transactionId) {
        return fraudAlertDAO.findByTransactionId(transactionId);
    }

    @Override
    public List<FraudAlert> getAlertsByUserId(Long userId) {
        return fraudAlertDAO.findByUserId(userId);
    }

    @Override
    public List<FraudAlert> getAllAlerts(int limit, int offset) {
        return fraudAlertDAO.findAll(limit, offset);
    }

    @Override
    public List<FraudAlert> getAlertsByStatus(AlertStatus status, int limit, int offset) {
        return fraudAlertDAO.findByStatus(status, limit, offset);
    }

    @Override
    public boolean updateAlertStatus(Long alertId, AlertStatus status, String analystUsername, String reviewNotes) {
        boolean updated = fraudAlertDAO.updateStatus(alertId, status, analystUsername, reviewNotes);
        if (updated) {
            auditLogDAO.create(new AuditLog(
                    null,
                    analystUsername,
                    "ALERT_STATUS_UPDATE",
                    "FRAUD_ALERT",
                    alertId,
                    String.format("Alert #%d status updated to %s. Notes: %s", alertId, status.name(), reviewNotes),
                    "127.0.0.1"
            ));
        }
        return updated;
    }

    @Override
    public long getOpenAlertCount() {
        return fraudAlertDAO.countOpenAlerts();
    }

    @Override
    public long getTotalAlertCount() {
        return fraudAlertDAO.countTotalAlerts();
    }

    @Override
    public FraudDetector getFraudDetector() {
        return fraudDetector;
    }
}
