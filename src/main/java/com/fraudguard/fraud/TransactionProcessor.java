package com.fraudguard.fraud;

import com.fraudguard.exception.InvalidTransactionException;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskScore;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.model.User;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Concurrent Transaction Processing Engine.
 * Coordinates multi-threaded evaluation, state management, in-memory context caching,
 * and throughput statistics.
 *
 * Demonstrates:
 * - Multithreading: ExecutorService, Future, Callable, custom ThreadFactory
 * - Thread Safety: AtomicLong counters, ConcurrentHashMap cache, synchronized block for cache update
 * - Collections: ConcurrentHashMap, synchronized lists
 * - Exception Handling: Structured propagation of business and operational exceptions
 */
public class TransactionProcessor {

    private final FraudDetector fraudDetector;
    private final ExecutorService executorService;
    private final Map<Long, List<Transaction>> userHistoryCache;

    // Concurrency Statistics
    private final AtomicLong totalProcessed = new AtomicLong(0);
    private final AtomicLong approvedCount = new AtomicLong(0);
    private final AtomicLong flaggedCount = new AtomicLong(0);
    private final AtomicLong rejectedCount = new AtomicLong(0);

    public TransactionProcessor() {
        this(new FraudDetector(), Runtime.getRuntime().availableProcessors() * 2);
    }

    public TransactionProcessor(FraudDetector fraudDetector, int poolSize) {
        this.fraudDetector = fraudDetector != null ? fraudDetector : new FraudDetector();
        this.userHistoryCache = new ConcurrentHashMap<>();

        AtomicInteger threadId = new AtomicInteger(1);
        ThreadFactory threadFactory = r -> {
            Thread t = new Thread(r, "FraudGuard-Worker-" + threadId.getAndIncrement());
            t.setDaemon(true);
            return t;
        };
        this.executorService = Executors.newFixedThreadPool(Math.max(2, poolSize), threadFactory);
    }

    /**
     * Synchronously processes a transaction through validation, fraud scoring,
     * status assignment, and alert generation.
     */
    public ProcessingResult process(Transaction transaction, User user) {
        if (transaction == null) {
            throw new InvalidTransactionException("Cannot process null transaction.");
        }
        transaction.validate();

        // Build context from user's cache
        TransactionContext context = getContextForUser(transaction.getUserId());

        // Perform fraud evaluation
        RiskScore riskScore = fraudDetector.evaluate(transaction, user, context);

        // Assign status according to risk score
        FraudAlert alert = null;
        if (riskScore.isCritical()) {
            transaction.setStatus(TransactionStatus.REJECTED);
            transaction.setNotes("Auto-rejected by FraudGuard: " + riskScore.getExplanation());
            alert = fraudDetector.generateAlertIfNeeded(transaction, riskScore);
            rejectedCount.incrementAndGet();
        } else if (riskScore.isHighOrCritical()) {
            transaction.setStatus(TransactionStatus.FLAGGED);
            transaction.setNotes("Flagged for manual compliance review: " + riskScore.getExplanation());
            alert = fraudDetector.generateAlertIfNeeded(transaction, riskScore);
            flaggedCount.incrementAndGet();
        } else if (riskScore.requiresAlert()) {
            // Medium risk: approved but monitored / low alert generated
            transaction.setStatus(TransactionStatus.APPROVED);
            transaction.setNotes("Approved with monitoring: " + riskScore.getExplanation());
            alert = fraudDetector.generateAlertIfNeeded(transaction, riskScore);
            approvedCount.incrementAndGet();
        } else {
            transaction.setStatus(TransactionStatus.APPROVED);
            transaction.setNotes("Approved: Clear transaction profile.");
            approvedCount.incrementAndGet();
        }

        totalProcessed.incrementAndGet();

        // Update in-memory history cache
        recordTransactionHistory(transaction);

        return new ProcessingResult(transaction, riskScore, alert);
    }

    /**
     * Asynchronously submits a transaction for processing on the worker thread pool.
     */
    public Future<ProcessingResult> submitAsync(Transaction transaction, User user) {
        Callable<ProcessingResult> task = () -> process(transaction, user);
        return executorService.submit(task);
    }

    private TransactionContext getContextForUser(Long userId) {
        TransactionContext context = new TransactionContext();
        if (userId == null) {
            return context;
        }

        List<Transaction> cached = userHistoryCache.get(userId);
        if (cached != null) {
            synchronized (cached) {
                for (Transaction tx : cached) {
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
            }
        }
        return context;
    }

    private void recordTransactionHistory(Transaction transaction) {
        if (transaction == null || transaction.getUserId() == null) return;
        List<Transaction> list = userHistoryCache.computeIfAbsent(
                transaction.getUserId(),
                k -> Collections.synchronizedList(new ArrayList<>())
        );
        synchronized (list) {
            list.add(transaction);
            // Cap history to last 50 transactions to prevent memory leak
            if (list.size() > 50) {
                list.remove(0);
            }
        }
    }

    public void seedUserKnownDevice(Long userId, String deviceFingerprint) {
        if (userId != null && deviceFingerprint != null) {
            List<Transaction> list = userHistoryCache.computeIfAbsent(
                    userId,
                    k -> Collections.synchronizedList(new ArrayList<>())
            );
            Transaction dummy = new Transaction();
            dummy.setUserId(userId);
            dummy.setDeviceFingerprint(deviceFingerprint);
            list.add(dummy);
        }
    }

    public void shutdown() {
        executorService.shutdown();
    }

    public boolean awaitTermination(long timeout, TimeUnit unit) throws InterruptedException {
        return executorService.awaitTermination(timeout, unit);
    }

    public boolean isShutdown() {
        return executorService.isShutdown();
    }

    // Getters for thread-safe metrics
    public long getTotalProcessed() {
        return totalProcessed.get();
    }

    public long getApprovedCount() {
        return approvedCount.get();
    }

    public long getFlaggedCount() {
        return flaggedCount.get();
    }

    public long getRejectedCount() {
        return rejectedCount.get();
    }

    public FraudDetector getFraudDetector() {
        return fraudDetector;
    }

    /**
     * DTO containing the result of transaction processing.
     */
    public static class ProcessingResult implements Serializable {
        private static final long serialVersionUID = 1L;

        private final Transaction transaction;
        private final RiskScore riskScore;
        private final FraudAlert fraudAlert;

        public ProcessingResult(Transaction transaction, RiskScore riskScore, FraudAlert fraudAlert) {
            this.transaction = transaction;
            this.riskScore = riskScore;
            this.fraudAlert = fraudAlert;
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

        public boolean isAlertGenerated() {
            return fraudAlert != null;
        }

        @Override
        public String toString() {
            return "ProcessingResult{" +
                    "status=" + transaction.getStatus() +
                    ", score=" + riskScore.getScore() +
                    ", level=" + riskScore.getLevel() +
                    ", alertGenerated=" + isAlertGenerated() +
                    '}';
        }
    }
}
