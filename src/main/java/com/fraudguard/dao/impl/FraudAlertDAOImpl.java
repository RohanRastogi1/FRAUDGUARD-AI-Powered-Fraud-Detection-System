package com.fraudguard.dao.impl;

import com.fraudguard.dao.FraudAlertDAO;
import com.fraudguard.exception.DatabaseException;
import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskLevel;
import com.fraudguard.util.DatabaseConnection;

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
 * JDBC implementation of FraudAlertDAO.
 */
public class FraudAlertDAOImpl implements FraudAlertDAO {

    @Override
    public FraudAlert create(FraudAlert alert) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return create(alert, conn);
        } catch (SQLException e) {
            throw new DatabaseException("Failed to persist fraud alert: " + e.getMessage(), e);
        }
    }

    @Override
    public FraudAlert create(FraudAlert alert, Connection conn) {
        String sql = "INSERT INTO fraud_alerts (transaction_id, transaction_ref, user_id, amount, " +
                     "risk_score, risk_level, triggered_rules, reason, status, reviewed_by, review_notes, " +
                     "created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, alert.getTransactionId());
            stmt.setString(2, alert.getTransactionRef());
            stmt.setLong(3, alert.getUserId());
            stmt.setBigDecimal(4, alert.getAmount());
            stmt.setInt(5, alert.getRiskScore());
            stmt.setString(6, alert.getRiskLevel().name());
            stmt.setString(7, alert.getTriggeredRules());
            stmt.setString(8, alert.getReason());
            stmt.setString(9, alert.getStatus().name());
            stmt.setString(10, alert.getReviewedBy());
            stmt.setString(11, alert.getReviewNotes());
            stmt.setTimestamp(12, Timestamp.valueOf(alert.getCreatedAt() != null ? alert.getCreatedAt() : LocalDateTime.now()));
            stmt.setTimestamp(13, Timestamp.valueOf(alert.getUpdatedAt() != null ? alert.getUpdatedAt() : LocalDateTime.now()));

            int affected = stmt.executeUpdate();
            if (affected == 0) {
                throw new DatabaseException("Failed to insert alert, 0 rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    alert.setId(generatedKeys.getLong(1));
                }
            }
            return alert;
        } catch (SQLException e) {
            throw new DatabaseException("Error creating fraud alert record: " + e.getMessage(), e);
        }
    }

    @Override
    public Optional<FraudAlert> findById(Long id) {
        String sql = "SELECT a.id, a.transaction_id, a.transaction_ref, a.user_id, u.full_name as user_name, " +
                     "a.amount, a.risk_score, a.risk_level, a.triggered_rules, a.reason, a.status, " +
                     "a.reviewed_by, a.review_notes, a.created_at, a.updated_at " +
                     "FROM fraud_alerts a LEFT JOIN users u ON a.user_id = u.id WHERE a.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToFraudAlert(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding alert by ID " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<FraudAlert> findByTransactionId(Long transactionId) {
        String sql = "SELECT a.id, a.transaction_id, a.transaction_ref, a.user_id, u.full_name as user_name, " +
                     "a.amount, a.risk_score, a.risk_level, a.triggered_rules, a.reason, a.status, " +
                     "a.reviewed_by, a.review_notes, a.created_at, a.updated_at " +
                     "FROM fraud_alerts a LEFT JOIN users u ON a.user_id = u.id WHERE a.transaction_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, transactionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToFraudAlert(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding alert by transaction ID " + transactionId, e);
        }
        return Optional.empty();
    }

    @Override
    public List<FraudAlert> findByUserId(Long userId) {
        String sql = "SELECT a.id, a.transaction_id, a.transaction_ref, a.user_id, u.full_name as user_name, " +
                     "a.amount, a.risk_score, a.risk_level, a.triggered_rules, a.reason, a.status, " +
                     "a.reviewed_by, a.review_notes, a.created_at, a.updated_at " +
                     "FROM fraud_alerts a LEFT JOIN users u ON a.user_id = u.id WHERE a.user_id = ? " +
                     "ORDER BY a.created_at DESC";
        List<FraudAlert> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFraudAlert(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding alerts for user " + userId, e);
        }
        return list;
    }

    @Override
    public List<FraudAlert> findAll(int limit, int offset) {
        String sql = "SELECT a.id, a.transaction_id, a.transaction_ref, a.user_id, u.full_name as user_name, " +
                     "a.amount, a.risk_score, a.risk_level, a.triggered_rules, a.reason, a.status, " +
                     "a.reviewed_by, a.review_notes, a.created_at, a.updated_at " +
                     "FROM fraud_alerts a LEFT JOIN users u ON a.user_id = u.id " +
                     "ORDER BY a.created_at DESC LIMIT ? OFFSET ?";
        List<FraudAlert> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFraudAlert(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching fraud alerts: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public List<FraudAlert> findByStatus(AlertStatus status, int limit, int offset) {
        String sql = "SELECT a.id, a.transaction_id, a.transaction_ref, a.user_id, u.full_name as user_name, " +
                     "a.amount, a.risk_score, a.risk_level, a.triggered_rules, a.reason, a.status, " +
                     "a.reviewed_by, a.review_notes, a.created_at, a.updated_at " +
                     "FROM fraud_alerts a LEFT JOIN users u ON a.user_id = u.id WHERE a.status = ? " +
                     "ORDER BY a.created_at DESC LIMIT ? OFFSET ?";
        List<FraudAlert> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFraudAlert(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding alerts by status: " + status, e);
        }
        return list;
    }

    @Override
    public List<FraudAlert> findByRiskLevel(RiskLevel riskLevel, int limit, int offset) {
        String sql = "SELECT a.id, a.transaction_id, a.transaction_ref, a.user_id, u.full_name as user_name, " +
                     "a.amount, a.risk_score, a.risk_level, a.triggered_rules, a.reason, a.status, " +
                     "a.reviewed_by, a.review_notes, a.created_at, a.updated_at " +
                     "FROM fraud_alerts a LEFT JOIN users u ON a.user_id = u.id WHERE a.risk_level = ? " +
                     "ORDER BY a.created_at DESC LIMIT ? OFFSET ?";
        List<FraudAlert> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, riskLevel.name());
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFraudAlert(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding alerts by risk level: " + riskLevel, e);
        }
        return list;
    }

    @Override
    public boolean updateStatus(Long alertId, AlertStatus status, String reviewedBy, String reviewNotes) {
        String sql = "UPDATE fraud_alerts SET status = ?, reviewed_by = ?, review_notes = ?, updated_at = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setString(2, reviewedBy);
            stmt.setString(3, reviewNotes);
            stmt.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(5, alertId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating fraud alert status: " + e.getMessage(), e);
        }
    }

    @Override
    public long countOpenAlerts() {
        String sql = "SELECT COUNT(*) FROM fraud_alerts WHERE status = 'OPEN' OR status = 'UNDER_REVIEW'";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting open alerts: " + e.getMessage(), e);
        }
        return 0;
    }

    @Override
    public long countTotalAlerts() {
        String sql = "SELECT COUNT(*) FROM fraud_alerts";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting total alerts: " + e.getMessage(), e);
        }
        return 0;
    }

    private FraudAlert mapResultSetToFraudAlert(ResultSet rs) throws SQLException {
        Timestamp createdTs = rs.getTimestamp("created_at");
        Timestamp updatedTs = rs.getTimestamp("updated_at");

        return new FraudAlert(
                rs.getLong("id"),
                rs.getLong("transaction_id"),
                rs.getString("transaction_ref"),
                rs.getLong("user_id"),
                rs.getString("user_name"),
                rs.getBigDecimal("amount"),
                rs.getInt("risk_score"),
                RiskLevel.fromString(rs.getString("risk_level")),
                rs.getString("triggered_rules"),
                rs.getString("reason"),
                AlertStatus.fromString(rs.getString("status")),
                rs.getString("reviewed_by"),
                rs.getString("review_notes"),
                createdTs != null ? createdTs.toLocalDateTime() : null,
                updatedTs != null ? updatedTs.toLocalDateTime() : null
        );
    }
}
