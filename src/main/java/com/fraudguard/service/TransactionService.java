package com.fraudguard.service;

import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.RiskScore;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.User;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

/**
 * Service managing financial transactions and coordinating the fraud engine pipeline
 * with atomic database persistence.
 */
public interface TransactionService {

    /**
     * Executes the end-to-end transaction processing pipeline:
     * Validation -> Context Assembly -> Rule Evaluation -> Atomic Persistence.
     */
    TransactionProcessResult processTransaction(Transaction transaction, User user);

    Optional<Transaction> getTransactionById(Long id);
    Optional<Transaction> getTransactionByRef(String ref);

    List<Transaction> getUserTransactions(Long userId, int limit, int offset);
    List<Transaction> getAllTransactions(int limit, int offset);
    List<Transaction> getTransactionsByStatus(TransactionStatus status, int limit, int offset);
    List<Transaction> getTransactionsByRiskLevel(RiskLevel level, int limit, int offset);

    /**
     * Result value object returned to caller servlets.
     */
    class TransactionProcessResult implements Serializable {
        private static final long serialVersionUID = 1L;

        private final boolean success;
        private final Transaction transaction;
        private final RiskScore riskScore;
        private final FraudAlert fraudAlert;
        private final String message;

        public TransactionProcessResult(boolean success, Transaction transaction, RiskScore riskScore, FraudAlert fraudAlert, String message) {
            this.success = success;
            this.transaction = transaction;
            this.riskScore = riskScore;
            this.fraudAlert = fraudAlert;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public Transaction getTransaction() {
            return transaction;
        }

        public RiskScore getRiskScore() {
            return riskScore;
        }

        public FraudAlert getFraudAlert() {
            return fraudAlert;
        }

        public String getMessage() {
            return message;
        }

        public boolean isApproved() {
            return transaction != null && transaction.getStatus() == TransactionStatus.APPROVED;
        }

        public boolean isFlagged() {
            return transaction != null && transaction.getStatus() == TransactionStatus.FLAGGED;
        }

        public boolean isRejected() {
            return transaction != null && transaction.getStatus() == TransactionStatus.REJECTED;
        }
    }
}
