package com.fraudguard.service;

import com.fraudguard.model.AuditLog;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;
import com.fraudguard.model.UserStatus;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * Service managing executive dashboard analytics, user account lifecycle administration,
 * and security audit logs.
 */
public interface AdminService {

    DashboardStatistics getDashboardStatistics();

    List<User> getAllUsers(int limit, int offset);

    boolean updateUserStatus(Long userId, UserStatus status, String adminUsername);

    List<AuditLog> getRecentAuditLogs(int limit);

    /**
     * DTO aggregating live production analytics directly from the database.
     */
    class DashboardStatistics implements Serializable {
        private static final long serialVersionUID = 1L;

        private final long totalUsers;
        private final long totalTransactions;
        private final long approvedCount;
        private final long flaggedCount;
        private final long rejectedCount;
        private final BigDecimal totalApprovedVolume;
        private final long totalAlerts;
        private final long openAlerts;
        private final List<Transaction> recentTransactions;
        private final List<FraudAlert> recentAlerts;
        private final List<AuditLog> recentAuditLogs;

        public DashboardStatistics(long totalUsers, long totalTransactions,
                                   long approvedCount, long flaggedCount, long rejectedCount,
                                   BigDecimal totalApprovedVolume, long totalAlerts, long openAlerts,
                                   List<Transaction> recentTransactions,
                                   List<FraudAlert> recentAlerts,
                                   List<AuditLog> recentAuditLogs) {
            this.totalUsers = totalUsers;
            this.totalTransactions = totalTransactions;
            this.approvedCount = approvedCount;
            this.flaggedCount = flaggedCount;
            this.rejectedCount = rejectedCount;
            this.totalApprovedVolume = totalApprovedVolume != null ? totalApprovedVolume : BigDecimal.ZERO;
            this.totalAlerts = totalAlerts;
            this.openAlerts = openAlerts;
            this.recentTransactions = recentTransactions;
            this.recentAlerts = recentAlerts;
            this.recentAuditLogs = recentAuditLogs;
        }

        public long getTotalUsers() {
            return totalUsers;
        }

        public long getTotalTransactions() {
            return totalTransactions;
        }

        public long getApprovedCount() {
            return approvedCount;
        }

        public long getFlaggedCount() {
            return flaggedCount;
        }

        public long getRejectedCount() {
            return rejectedCount;
        }

        public BigDecimal getTotalApprovedVolume() {
            return totalApprovedVolume;
        }

        public long getTotalAlerts() {
            return totalAlerts;
        }

        public long getOpenAlerts() {
            return openAlerts;
        }

        public List<Transaction> getRecentTransactions() {
            return recentTransactions;
        }

        public List<FraudAlert> getRecentAlerts() {
            return recentAlerts;
        }

        public List<AuditLog> getRecentAuditLogs() {
            return recentAuditLogs;
        }

        public double getFraudDetectionRate() {
            if (totalTransactions == 0) return 0.0;
            return ((double) (flaggedCount + rejectedCount) / totalTransactions) * 100.0;
        }
    }
}
