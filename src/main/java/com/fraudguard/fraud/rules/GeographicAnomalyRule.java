package com.fraudguard.fraud.rules;

import com.fraudguard.fraud.RuleEvaluation;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Detects geographic anomalies such as impossible travel or location mismatches.
 * For instance, a transaction occurring in New York followed 15 minutes later by London.
 */
public class GeographicAnomalyRule extends AbstractFraudRule {

    public static final String RULE_NAME = "GEOGRAPHIC_ANOMALY_RULE";
    private final Duration impossibleTravelThreshold;

    public GeographicAnomalyRule() {
        this(Duration.ofHours(2));
    }

    public GeographicAnomalyRule(Duration impossibleTravelThreshold) {
        super(RULE_NAME, "Detects impossible travel between consecutive transactions", 45);
        this.impossibleTravelThreshold = impossibleTravelThreshold;
    }

    @Override
    public RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context) {
        if (!isEnabled() || transaction == null || transaction.getLocation() == null || context == null) {
            return RuleEvaluation.pass(getRuleName());
        }

        String currentLocation = transaction.getLocation().trim();
        List<Transaction> recents = context.getRecentTransactions();

        if (recents == null || recents.isEmpty()) {
            return RuleEvaluation.pass(getRuleName());
        }

        LocalDateTime currentTs = transaction.getTimestamp() != null ? transaction.getTimestamp() : LocalDateTime.now();

        // Check the most recent transaction
        for (int i = recents.size() - 1; i >= 0; i--) {
            Transaction prior = recents.get(i);
            if (prior.getLocation() != null && prior.getTimestamp() != null) {
                String priorLocation = prior.getLocation().trim();
                if (!priorLocation.equalsIgnoreCase(currentLocation)) {
                    Duration gap = Duration.between(prior.getTimestamp(), currentTs).abs();
                    if (gap.compareTo(impossibleTravelThreshold) < 0) {
                        return RuleEvaluation.trigger(
                                getRuleName(),
                                getDefaultWeight(),
                                String.format("Impossible travel detected: location jump from '%s' to '%s' within %d minutes",
                                        priorLocation, currentLocation, Math.max(1, gap.toMinutes()))
                        );
                    }
                }
                break;
            }
        }

        return RuleEvaluation.pass(getRuleName());
    }
}
