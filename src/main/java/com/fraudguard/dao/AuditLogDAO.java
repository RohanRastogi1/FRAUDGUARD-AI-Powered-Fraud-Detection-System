package com.fraudguard.dao;

import com.fraudguard.model.AuditLog;

import java.sql.Connection;
import java.util.List;

/**
 * Data Access Object interface for system Audit Logs.
 */
public interface AuditLogDAO {

    AuditLog create(AuditLog log);
    AuditLog create(AuditLog log, Connection conn);

    List<AuditLog> findRecent(int limit);
    List<AuditLog> findByUserId(Long userId, int limit);
    List<AuditLog> findByAction(String action, int limit);

    long countLogs();
}
