package com.fraudguard.fraud.rules;

import com.fraudguard.fraud.RuleEvaluation;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Detects rapid automated transaction bursts (Velocity Spikes).
 * Common in credit card testing, account takeovers, and bot attacks.
 */
public class VelocityRule extends AbstractFraudRule {

    public static final String RULE_NAME = "VELOCITY_SPIKE_RULE";
    private final int maxAllowedTransactions;
    private final Duration windowDuration;

    public VelocityRule() {
        this(3, Duration.ofMinutes(5));
    }

    public VelocityRule(int maxAllowedTransactions, Duration windowDuration) {
        super(RULE_NAME, "Detects excessive transaction frequency within a short time window", 40);
        this.maxAllowedTransactions = maxAllowedTransactions;
        this.windowDuration = windowDuration;
    }

    @Override
    public RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context) {
        if (!isEnabled() || transaction == null || context == null) {
            return RuleEvaluation.pass(getRuleName());
        }

        List<Transaction> recents = context.getRecentTransactions();
        if (recents == null || recents.isEmpty()) {
            return RuleEvaluation.pass(getRuleName());
        }

        LocalDateTime now = transaction.getTimestamp() != null ? transaction.getTimestamp() : LocalDateTime.now();
        LocalDateTime windowStart = now.minus(windowDuration);

        long recentCount = recents.stream()
                .filter(t -> t.getTimestamp() != null && t.getTimestamp().isAfter(windowStart))
                .count();

        if (recentCount >= maxAllowedTransactions) {
            int score = recentCount >= (maxAllowedTransactions + 2) ? 50 : getDefaultWeight();
            return RuleEvaluation.trigger(
                    getRuleName(),
                    score,
                    String.format("Velocity spike: %d transactions in the last %d minutes exceeds baseline threshold of %d",
                            recentCount, windowDuration.toMinutes(), maxAllowedTransactions)
            );
        }

        return RuleEvaluation.pass(getRuleName());
    }
}
