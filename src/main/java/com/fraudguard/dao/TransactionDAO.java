package com.fraudguard.dao;

import com.fraudguard.model.AuditLog;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.User;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for financial Transactions.
 * Also defines the contract for atomic ACID transaction-processing workflows.
 */
public interface TransactionDAO {

    Transaction create(Transaction tx);
    Transaction create(Transaction tx, Connection conn);

    Optional<Transaction> findById(Long id);
    Optional<Transaction> findByRef(String ref);

    List<Transaction> findByUserId(Long userId, int limit, int offset);
    List<Transaction> findRecentByUserId(Long userId, int limit);

    List<Transaction> findAll(int limit, int offset);
    List<Transaction> findByStatus(TransactionStatus status, int limit, int offset);
    List<Transaction> findByRiskLevel(RiskLevel riskLevel, int limit, int offset);

    boolean updateStatus(Long txId, TransactionStatus status, String notes, Connection conn);

    long countTotalTransactions();
    long countByStatus(TransactionStatus status);
    BigDecimal sumTotalApprovedVolume();
    BigDecimal sumVolumeByUserId(Long userId);

    /**
     * Executes an atomic transfer workflow under explicit JDBC transaction management.
     * Guarantees all-or-nothing atomicity using setAutoCommit(false), commit(), rollback().
     */
    AtomicTransferResult executeAtomicTransfer(Transaction tx, User sender, Long recipientUserId,
                                              FraudAlert alert, AuditLog auditLog);

    /**
     * Value object capturing the outcome of an atomic transfer transaction.
     */
    class AtomicTransferResult implements Serializable {
        private static final long serialVersionUID = 1L;

        private final boolean success;
        private final Transaction transaction;
        private final String message;

        public AtomicTransferResult(boolean success, Transaction transaction, String message) {
            this.success = success;
            this.transaction = transaction;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public Transaction getTransaction() {
            return transaction;
        }

        public String getMessage() {
            return message;
        }
    }
}
