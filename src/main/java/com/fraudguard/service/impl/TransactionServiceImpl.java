package com.fraudguard.service.impl;

import com.fraudguard.dao.AuditLogDAO;
import com.fraudguard.dao.TransactionDAO;
import com.fraudguard.dao.UserDAO;
import com.fraudguard.dao.impl.AuditLogDAOImpl;
import com.fraudguard.dao.impl.FraudAlertDAOImpl;
import com.fraudguard.dao.impl.TransactionDAOImpl;
import com.fraudguard.dao.impl.UserDAOImpl;
import com.fraudguard.exception.InvalidTransactionException;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.AuditLog;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.RiskScore;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.User;
import com.fraudguard.service.FraudAnalysisService;
import com.fraudguard.service.TransactionService;

import java.util.List;
import java.util.Optional;

/**
 * Implementation of TransactionService.
 * Coordinates Servlet request parameters, Fraud Detection Engine,
 * and ACID atomic JDBC transaction persistence.
 */
public class TransactionServiceImpl implements TransactionService {

    private final TransactionDAO transactionDAO;
    private final UserDAO userDAO;
    private final FraudAnalysisService fraudAnalysisService;
    private final AuditLogDAO auditLogDAO;

    public TransactionServiceImpl() {
        this.userDAO = new UserDAOImpl();
        this.auditLogDAO = new AuditLogDAOImpl();
        this.transactionDAO = new TransactionDAOImpl(userDAO, new FraudAlertDAOImpl(), auditLogDAO);
        this.fraudAnalysisService = new FraudAnalysisServiceImpl();
    }

    public TransactionServiceImpl(TransactionDAO transactionDAO, UserDAO userDAO,
                                  FraudAnalysisService fraudAnalysisService, AuditLogDAO auditLogDAO) {
        this.transactionDAO = transactionDAO;
        this.userDAO = userDAO;
        this.fraudAnalysisService = fraudAnalysisService;
        this.auditLogDAO = auditLogDAO;
    }

    @Override
    public TransactionProcessResult processTransaction(Transaction transaction, User user) {
        if (transaction == null) {
            throw new InvalidTransactionException("Transaction payload cannot be null.");
        }
        if (user == null) {
            throw new InvalidTransactionException("Initiating user cannot be null.");
        }
        if (!user.canTransact()) {
            throw new InvalidTransactionException("User account is not eligible for transaction operations (Status: " + user.getStatus() + ").");
        }

        // 1. Validate domain invariants
        transaction.validate();

        // 2. Build temporal behavioral context from database
        TransactionContext context = buildContextForUser(user.getId());

        // 3. Evaluate transaction through the Fraud Engine
        RiskScore riskScore = fraudAnalysisService.evaluateRisk(transaction, user, context);

        // 4. Assign status based on evaluated score and critical rules
        FraudAlert alert = null;
        String statusNotes;

        if (riskScore.isCritical()) {
            transaction.setStatus(TransactionStatus.REJECTED);
            statusNotes = "Auto-rejected by FraudGuard: " + riskScore.getExplanation();
            transaction.setNotes(statusNotes);
            alert = fraudAnalysisService.createAlertIfNeeded(transaction, riskScore);
        } else if (riskScore.isHighOrCritical()) {
            transaction.setStatus(TransactionStatus.FLAGGED);
            statusNotes = "Flagged for analyst compliance review: " + riskScore.getExplanation();
            transaction.setNotes(statusNotes);
            alert = fraudAnalysisService.createAlertIfNeeded(transaction, riskScore);
        } else if (riskScore.requiresAlert()) {
            transaction.setStatus(TransactionStatus.APPROVED);
            statusNotes = "Approved with security monitoring: " + riskScore.getExplanation();
            transaction.setNotes(statusNotes);
            alert = fraudAnalysisService.createAlertIfNeeded(transaction, riskScore);
        } else {
            transaction.setStatus(TransactionStatus.APPROVED);
            statusNotes = "Approved: Standard risk verification passed.";
            transaction.setNotes(statusNotes);
        }

        // 5. Construct Audit Log entry
        AuditLog auditLog = new AuditLog(
                user.getId(),
                user.getUsername(),
                "TRANSACTION_" + transaction.getStatus().name(),
                "TRANSACTION",
                null,
                String.format("Transaction %s ($%s to %s) evaluated with Risk Score %d (%s). %s",
                        transaction.getTransactionRef(), transaction.getAmount(), transaction.getRecipientName(),
                        riskScore.getScore(), riskScore.getLevel().name(), statusNotes),
                transaction.getIpAddress()
        );

        // 6. Check if recipient account matches an internal customer to credit
        Long recipientUserId = findInternalRecipientUserId(transaction.getRecipientAccount());

        // 7. Execute atomic database transaction
        TransactionDAO.AtomicTransferResult dbResult = transactionDAO.executeAtomicTransfer(
                transaction, user, recipientUserId, alert, auditLog
        );

        if (!dbResult.isSuccess()) {
            return new TransactionProcessResult(false, transaction, riskScore, alert, dbResult.getMessage());
        }

        String userDisplayMessage;
        switch (transaction.getStatus()) {
            case APPROVED:
                userDisplayMessage = "Transaction executed successfully! Reference: " + transaction.getTransactionRef();
                break;
            case FLAGGED:
                userDisplayMessage = "Transaction has been held for compliance verification due to elevated risk parameters.";
                break;
            case REJECTED:
                userDisplayMessage = "Transaction declined: Security parameters violated sanctions or safety limits.";
                break;
            default:
                userDisplayMessage = "Transaction processed.";
        }

        return new TransactionProcessResult(true, transaction, riskScore, alert, userDisplayMessage);
    }

    @Override
    public Optional<Transaction> getTransactionById(Long id) {
        return transactionDAO.findById(id);
    }

    @Override
    public Optional<Transaction> getTransactionByRef(String ref) {
        return transactionDAO.findByRef(ref);
    }

    @Override
    public List<Transaction> getUserTransactions(Long userId, int limit, int offset) {
        return transactionDAO.findByUserId(userId, limit, offset);
    }

    @Override
    public List<Transaction> getAllTransactions(int limit, int offset) {
        return transactionDAO.findAll(limit, offset);
    }

    @Override
    public List<Transaction> getTransactionsByStatus(TransactionStatus status, int limit, int offset) {
        return transactionDAO.findByStatus(status, limit, offset);
    }

    @Override
    public List<Transaction> getTransactionsByRiskLevel(RiskLevel level, int limit, int offset) {
        return transactionDAO.findByRiskLevel(level, limit, offset);
    }

    private TransactionContext buildContextForUser(Long userId) {
        TransactionContext context = new TransactionContext();
        if (userId == null) return context;

        List<Transaction> recent = transactionDAO.findRecentByUserId(userId, 20);
        for (Transaction tx : recent) {
            context.addRecentTransaction(tx);
            if (tx.getDeviceFingerprint() != null) {
                context.addKnownDevice(tx.getDeviceFingerprint());
            }
            if (tx.getLocation() != null) {
                context.addKnownLocation(tx.getLocation());
            }
            if (tx.getIpAddress() != null) {
                context.addKnownIp(tx.getIpAddress());
            }
        }
        return context;
    }

    private Long findInternalRecipientUserId(String recipientAccount) {
        if (recipientAccount == null) return null;
        // Check if recipient account matches any user's username
        Optional<User> recipientUser = userDAO.findByUsername(recipientAccount.trim());
        return recipientUser.map(User::getId).orElse(null);
    }
}
