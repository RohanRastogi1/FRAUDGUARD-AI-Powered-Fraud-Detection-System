package com.fraudguard.service.impl;

import com.fraudguard.dao.AuditLogDAO;
import com.fraudguard.dao.FraudAlertDAO;
import com.fraudguard.dao.TransactionDAO;
import com.fraudguard.dao.UserDAO;
import com.fraudguard.dao.impl.AuditLogDAOImpl;
import com.fraudguard.dao.impl.FraudAlertDAOImpl;
import com.fraudguard.dao.impl.TransactionDAOImpl;
import com.fraudguard.dao.impl.UserDAOImpl;
import com.fraudguard.model.AuditLog;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.User;
import com.fraudguard.model.UserStatus;
import com.fraudguard.service.AdminService;

import java.math.BigDecimal;
import java.util.List;

/**
 * Implementation of AdminService aggregating real system metrics and managing security policies.
 */
public class AdminServiceImpl implements AdminService {

    private final UserDAO userDAO;
    private final TransactionDAO transactionDAO;
    private final FraudAlertDAO fraudAlertDAO;
    private final AuditLogDAO auditLogDAO;

    public AdminServiceImpl() {
        this.userDAO = new UserDAOImpl();
        this.auditLogDAO = new AuditLogDAOImpl();
        this.fraudAlertDAO = new FraudAlertDAOImpl();
        this.transactionDAO = new TransactionDAOImpl(userDAO, fraudAlertDAO, auditLogDAO);
    }

    public AdminServiceImpl(UserDAO userDAO, TransactionDAO transactionDAO,
                            FraudAlertDAO fraudAlertDAO, AuditLogDAO auditLogDAO) {
        this.userDAO = userDAO;
        this.transactionDAO = transactionDAO;
        this.fraudAlertDAO = fraudAlertDAO;
        this.auditLogDAO = auditLogDAO;
    }

    @Override
    public DashboardStatistics getDashboardStatistics() {
        long totalUsers = userDAO.countUsers();
        long totalTransactions = transactionDAO.countTotalTransactions();
        long approvedCount = transactionDAO.countByStatus(TransactionStatus.APPROVED);
        long flaggedCount = transactionDAO.countByStatus(TransactionStatus.FLAGGED);
        long rejectedCount = transactionDAO.countByStatus(TransactionStatus.REJECTED);
        BigDecimal totalVolume = transactionDAO.sumTotalApprovedVolume();
        long totalAlerts = fraudAlertDAO.countTotalAlerts();
        long openAlerts = fraudAlertDAO.countOpenAlerts();

        List<Transaction> recentTransactions = transactionDAO.findAll(10, 0);
        List<FraudAlert> recentAlerts = fraudAlertDAO.findAll(10, 0);
        List<AuditLog> recentAuditLogs = auditLogDAO.findRecent(10);

        return new DashboardStatistics(
                totalUsers,
                totalTransactions,
                approvedCount,
                flaggedCount,
                rejectedCount,
                totalVolume,
                totalAlerts,
                openAlerts,
                recentTransactions,
                recentAlerts,
                recentAuditLogs
        );
    }

    @Override
    public List<User> getAllUsers(int limit, int offset) {
        return userDAO.findAll(limit, offset);
    }

    @Override
    public boolean updateUserStatus(Long userId, UserStatus status, String adminUsername) {
        boolean updated = userDAO.updateStatus(userId, status);
        if (updated) {
            auditLogDAO.create(new AuditLog(
                    null,
                    adminUsername,
                    "USER_STATUS_CHANGE",
                    "USER",
                    userId,
                    String.format("User ID %d status changed to %s by admin '%s'", userId, status.name(), adminUsername),
                    "127.0.0.1"
            ));
        }
        return updated;
    }

    @Override
    public List<AuditLog> getRecentAuditLogs(int limit) {
        return auditLogDAO.findRecent(limit);
    }
}
