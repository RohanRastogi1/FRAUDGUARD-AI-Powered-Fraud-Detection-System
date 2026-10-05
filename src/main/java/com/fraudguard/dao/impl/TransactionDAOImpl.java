package com.fraudguard.dao.impl;

import com.fraudguard.dao.AuditLogDAO;
import com.fraudguard.dao.FraudAlertDAO;
import com.fraudguard.dao.TransactionDAO;
import com.fraudguard.dao.UserDAO;
import com.fraudguard.exception.DatabaseException;
import com.fraudguard.model.AuditLog;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.TransactionType;
import com.fraudguard.model.User;
import com.fraudguard.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JDBC implementation of TransactionDAO.
 * Features PreparedStatement querying, indexed paging, aggregation analytics,
 * and ACID atomic transaction management with rollback.
 *
 * Demonstrates:
 * - setAutoCommit(false), commit(), rollback()
 * - PreparedStatement and Statement.RETURN_GENERATED_KEYS
 * - Try-with-resources and proper JDBC connection cleanup
 */
public class TransactionDAOImpl implements TransactionDAO {

    private final UserDAO userDAO;
    private final FraudAlertDAO fraudAlertDAO;
    private final AuditLogDAO auditLogDAO;

    public TransactionDAOImpl() {
        this.userDAO = new UserDAOImpl();
        this.fraudAlertDAO = new FraudAlertDAOImpl();
        this.auditLogDAO = new AuditLogDAOImpl();
    }

    public TransactionDAOImpl(UserDAO userDAO, FraudAlertDAO fraudAlertDAO, AuditLogDAO auditLogDAO) {
        this.userDAO = userDAO;
        this.fraudAlertDAO = fraudAlertDAO;
        this.auditLogDAO = auditLogDAO;
    }

    @Override
    public Transaction create(Transaction tx) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return create(tx, conn);
        } catch (SQLException e) {
            throw new DatabaseException("Failed to persist transaction: " + e.getMessage(), e);
        }
    }

    @Override
    public Transaction create(Transaction tx, Connection conn) {
        String sql = "INSERT INTO transactions (transaction_ref, user_id, amount, currency, " +
                     "recipient_account, recipient_name, type, status, location, ip_address, " +
                     "device_fingerprint, risk_score, risk_level, notes, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, tx.getTransactionRef());
            stmt.setLong(2, tx.getUserId());
            stmt.setBigDecimal(3, tx.getAmount());
            stmt.setString(4, tx.getCurrency());
            stmt.setString(5, tx.getRecipientAccount());
            stmt.setString(6, tx.getRecipientName());
            stmt.setString(7, tx.getType().name());
            stmt.setString(8, tx.getStatus().name());
            stmt.setString(9, tx.getLocation());
            stmt.setString(10, tx.getIpAddress());
            stmt.setString(11, tx.getDeviceFingerprint());
            stmt.setInt(12, tx.getRiskScore() != null ? tx.getRiskScore() : 0);
            stmt.setString(13, tx.getRiskLevel() != null ? tx.getRiskLevel().name() : RiskLevel.LOW.name());
            stmt.setString(14, tx.getNotes());
            stmt.setTimestamp(15, Timestamp.valueOf(tx.getTimestamp() != null ? tx.getTimestamp() : LocalDateTime.now()));

            int affected = stmt.executeUpdate();
            if (affected == 0) {
                throw new DatabaseException("Transaction insert failed, 0 rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    tx.setId(generatedKeys.getLong(1));
                }
            }
            return tx;
        } catch (SQLException e) {
            throw new DatabaseException("Error creating transaction record: " + e.getMessage(), e);
        }
    }

    @Override
    public Optional<Transaction> findById(Long id) {
        String sql = "SELECT id, transaction_ref, user_id, amount, currency, recipient_account, recipient_name, " +
                     "type, status, location, ip_address, device_fingerprint, risk_score, risk_level, notes, created_at " +
                     "FROM transactions WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding transaction by ID " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Transaction> findByRef(String ref) {
        String sql = "SELECT id, transaction_ref, user_id, amount, currency, recipient_account, recipient_name, " +
                     "type, status, location, ip_address, device_fingerprint, risk_score, risk_level, notes, created_at " +
                     "FROM transactions WHERE transaction_ref = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ref);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding transaction by ref " + ref, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Transaction> findByUserId(Long userId, int limit, int offset) {
        String sql = "SELECT id, transaction_ref, user_id, amount, currency, recipient_account, recipient_name, " +
                     "type, status, location, ip_address, device_fingerprint, risk_score, risk_level, notes, created_at " +
                     "FROM transactions WHERE user_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        List<Transaction> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error querying transactions for user " + userId, e);
        }
        return list;
    }

    @Override
    public List<Transaction> findRecentByUserId(Long userId, int limit) {
        return findByUserId(userId, limit, 0);
    }

    @Override
    public List<Transaction> findAll(int limit, int offset) {
        String sql = "SELECT id, transaction_ref, user_id, amount, currency, recipient_account, recipient_name, " +
                     "type, status, location, ip_address, device_fingerprint, risk_score, risk_level, notes, created_at " +
                     "FROM transactions ORDER BY created_at DESC LIMIT ? OFFSET ?";
        List<Transaction> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching transactions: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public List<Transaction> findByStatus(TransactionStatus status, int limit, int offset) {
        String sql = "SELECT id, transaction_ref, user_id, amount, currency, recipient_account, recipient_name, " +
                     "type, status, location, ip_address, device_fingerprint, risk_score, risk_level, notes, created_at " +
                     "FROM transactions WHERE status = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        List<Transaction> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error querying transactions by status: " + status, e);
        }
        return list;
    }

    @Override
    public List<Transaction> findByRiskLevel(RiskLevel riskLevel, int limit, int offset) {
        String sql = "SELECT id, transaction_ref, user_id, amount, currency, recipient_account, recipient_name, " +
                     "type, status, location, ip_address, device_fingerprint, risk_score, risk_level, notes, created_at " +
                     "FROM transactions WHERE risk_level = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        List<Transaction> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, riskLevel.name());
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error querying transactions by risk level: " + riskLevel, e);
        }
        return list;
    }

    @Override
    public boolean updateStatus(Long txId, TransactionStatus status, String notes, Connection conn) {
        String sql = "UPDATE transactions SET status = ?, notes = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setString(2, notes);
            stmt.setLong(3, txId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating transaction status for ID " + txId, e);
        }
    }

    @Override
    public long countTotalTransactions() {
        String sql = "SELECT COUNT(*) FROM transactions";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting transactions: " + e.getMessage(), e);
        }
        return 0;
    }

    @Override
    public long countByStatus(TransactionStatus status) {
        String sql = "SELECT COUNT(*) FROM transactions WHERE status = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting transactions by status: " + status, e);
        }
        return 0;
    }

    @Override
    public BigDecimal sumTotalApprovedVolume() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE status = 'APPROVED'";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error calculating approved volume: " + e.getMessage(), e);
        }
        return BigDecimal.ZERO;
    }

    @Override
    public BigDecimal sumVolumeByUserId(Long userId) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE user_id = ? AND status = 'APPROVED'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error calculating user volume: " + e.getMessage(), e);
        }
        return BigDecimal.ZERO;
    }

    /**
     * Executes an atomic transfer workflow demonstrating JDBC Transaction Management:
     * 1. conn.setAutoCommit(false)
     * 2. Checks sender balance and debits sender if APPROVED
     * 3. Credits recipient if known internal account
     * 4. Persists Transaction with generated ID
     * 5. If alert != null, persists FraudAlert linked to Transaction ID
     * 6. Persists AuditLog
     * 7. conn.commit()
     * On any error: conn.rollback()
     */
    @Override
    public AtomicTransferResult executeAtomicTransfer(Transaction tx, User sender, Long recipientUserId,
                                                      FraudAlert alert, AuditLog auditLog) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Begin ACID Transaction boundary

            // 1. Balance management: Only deduct if transaction is APPROVED
            if (tx.getStatus() == TransactionStatus.APPROVED) {
                if (sender.getBalance().compareTo(tx.getAmount()) < 0) {
                    conn.rollback();
                    return new AtomicTransferResult(false, tx, "Insufficient funds in account.");
                }

                BigDecimal newSenderBalance = sender.getBalance().subtract(tx.getAmount());
                boolean senderUpdated = userDAO.updateBalance(sender.getId(), newSenderBalance, conn);
                if (!senderUpdated) {
                    conn.rollback();
                    return new AtomicTransferResult(false, tx, "Failed to update sender account balance.");
                }
                sender.setBalance(newSenderBalance);

                // Credit recipient if internal user
                if (recipientUserId != null) {
                    Optional<User> recipientOpt = userDAO.findById(recipientUserId, conn);
                    if (recipientOpt.isPresent()) {
                        User recipient = recipientOpt.get();
                        BigDecimal newRecipientBalance = recipient.getBalance().add(tx.getAmount());
                        userDAO.updateBalance(recipient.getId(), newRecipientBalance, conn);
                    }
                }
            }

            // 2. Insert transaction record
            create(tx, conn);

            // 3. Insert alert if flagged or critical
            if (alert != null) {
                alert.setTransactionId(tx.getId());
                alert.setTransactionRef(tx.getTransactionRef());
                fraudAlertDAO.create(alert, conn);
            }

            // 4. Record audit log
            if (auditLog != null) {
                auditLog.setEntityId(tx.getId());
                auditLogDAO.create(auditLog, conn);
            }

            // 5. Commit atomic transaction
            conn.commit();
            return new AtomicTransferResult(true, tx, "Transaction processed and committed successfully.");

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback all changes upon error
                } catch (SQLException ex) {
                    // Suppress or log rollback failure
                }
            }
            throw new DatabaseException("Atomic transaction failed and was rolled back: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restore default
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    private Transaction mapResultSetToTransaction(ResultSet rs) throws SQLException {
        Timestamp createdTs = rs.getTimestamp("created_at");

        return new Transaction(
                rs.getLong("id"),
                rs.getString("transaction_ref"),
                rs.getLong("user_id"),
                rs.getBigDecimal("amount"),
                rs.getString("currency"),
                rs.getString("recipient_account"),
                rs.getString("recipient_name"),
                TransactionType.fromString(rs.getString("type")),
                TransactionStatus.fromString(rs.getString("status")),
                rs.getString("location"),
                rs.getString("ip_address"),
                rs.getString("device_fingerprint"),
                rs.getInt("risk_score"),
                RiskLevel.fromString(rs.getString("risk_level")),
                rs.getString("notes"),
                createdTs != null ? createdTs.toLocalDateTime() : null
        );
    }
}
