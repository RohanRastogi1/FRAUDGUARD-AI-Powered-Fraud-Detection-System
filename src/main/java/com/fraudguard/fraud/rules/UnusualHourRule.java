package com.fraudguard.fraud.rules;

import com.fraudguard.fraud.RuleEvaluation;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.time.LocalDateTime;

/**
 * Detects transactions occurring during unusual overnight hours (e.g. 01:00 to 05:00).
 * Fraudulent automated transfers frequently occur while account holders are asleep.
 */
public class UnusualHourRule extends AbstractFraudRule {

    public static final String RULE_NAME = "UNUSUAL_HOUR_RULE";
    private final int startHour;
    private final int endHour;

    public UnusualHourRule() {
        this(1, 5);
    }

    public UnusualHourRule(int startHour, int endHour) {
        super(RULE_NAME, "Detects anomalous transaction timing during late-night off hours", 20);
        this.startHour = startHour;
        this.endHour = endHour;
    }

    @Override
    public RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context) {
        if (!isEnabled() || transaction == null) {
            return RuleEvaluation.pass(getRuleName());
        }

        LocalDateTime timestamp = transaction.getTimestamp() != null ? transaction.getTimestamp() : LocalDateTime.now();
        int hour = timestamp.getHour();

        if (hour >= startHour && hour < endHour) {
            return RuleEvaluation.trigger(
                    getRuleName(),
                    getDefaultWeight(),
                    String.format("Unusual transaction hour: processed at %02d:%02d (outside normal hours %02d:00-%02d:00)",
                            hour, timestamp.getMinute(), startHour, endHour)
            );
        }

        return RuleEvaluation.pass(getRuleName());
    }
}
