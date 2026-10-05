package com.fraudguard.dao.impl;

import com.fraudguard.dao.AuditLogDAO;
import com.fraudguard.exception.DatabaseException;
import com.fraudguard.model.AuditLog;
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

/**
 * JDBC implementation of AuditLogDAO.
 */
public class AuditLogDAOImpl implements AuditLogDAO {

    @Override
    public AuditLog create(AuditLog log) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return create(log, conn);
        } catch (SQLException e) {
            throw new DatabaseException("Failed to persist audit log: " + e.getMessage(), e);
        }
    }

    @Override
    public AuditLog create(AuditLog log, Connection conn) {
        String sql = "INSERT INTO audit_logs (user_id, username, action, entity_type, entity_id, details, ip_address, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (log.getUserId() != null) {
                stmt.setLong(1, log.getUserId());
            } else {
                stmt.setNull(1, java.sql.Types.BIGINT);
            }
            stmt.setString(2, log.getUsername());
            stmt.setString(3, log.getAction());
            stmt.setString(4, log.getEntityType());
            if (log.getEntityId() != null) {
                stmt.setLong(5, log.getEntityId());
            } else {
                stmt.setNull(5, java.sql.Types.BIGINT);
            }
            stmt.setString(6, log.getDetails());
            stmt.setString(7, log.getIpAddress());
            stmt.setTimestamp(8, Timestamp.valueOf(log.getTimestamp() != null ? log.getTimestamp() : LocalDateTime.now()));

            int affected = stmt.executeUpdate();
            if (affected == 0) {
                throw new DatabaseException("Failed to insert audit log, 0 rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    log.setId(generatedKeys.getLong(1));
                }
            }
            return log;
        } catch (SQLException e) {
            throw new DatabaseException("Error creating audit log: " + e.getMessage(), e);
        }
    }

    @Override
    public List<AuditLog> findRecent(int limit) {
        String sql = "SELECT id, user_id, username, action, entity_type, entity_id, details, ip_address, created_at " +
                     "FROM audit_logs ORDER BY created_at DESC LIMIT ?";
        List<AuditLog> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAuditLog(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving recent audit logs: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public List<AuditLog> findByUserId(Long userId, int limit) {
        String sql = "SELECT id, user_id, username, action, entity_type, entity_id, details, ip_address, created_at " +
                     "FROM audit_logs WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        List<AuditLog> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAuditLog(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving audit logs for user " + userId, e);
        }
        return list;
    }

    @Override
    public List<AuditLog> findByAction(String action, int limit) {
        String sql = "SELECT id, user_id, username, action, entity_type, entity_id, details, ip_address, created_at " +
                     "FROM audit_logs WHERE action = ? ORDER BY created_at DESC LIMIT ?";
        List<AuditLog> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, action);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAuditLog(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving audit logs for action " + action, e);
        }
        return list;
    }

    @Override
    public long countLogs() {
        String sql = "SELECT COUNT(*) FROM audit_logs";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting audit logs: " + e.getMessage(), e);
        }
        return 0;
    }

    private AuditLog mapResultSetToAuditLog(ResultSet rs) throws SQLException {
        Timestamp createdTs = rs.getTimestamp("created_at");
        long userIdVal = rs.getLong("user_id");
        Long userId = rs.wasNull() ? null : userIdVal;
        long entityIdVal = rs.getLong("entity_id");
        Long entityId = rs.wasNull() ? null : entityIdVal;

        return new AuditLog(
                rs.getLong("id"),
                userId,
                rs.getString("username"),
                rs.getString("action"),
                rs.getString("entity_type"),
                entityId,
                rs.getString("details"),
                rs.getString("ip_address"),
                createdTs != null ? createdTs.toLocalDateTime() : null
        );
    }
}
