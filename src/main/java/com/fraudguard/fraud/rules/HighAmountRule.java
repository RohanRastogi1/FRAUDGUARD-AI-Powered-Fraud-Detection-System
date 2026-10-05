package com.fraudguard.fraud.rules;

import com.fraudguard.fraud.RuleEvaluation;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.math.BigDecimal;

/**
 * Detects transactions exceeding predefined monetary thresholds.
 * High-value transactions pose higher loss potential and require elevated scrutiny.
 */
public class HighAmountRule extends AbstractFraudRule {

    public static final String RULE_NAME = "HIGH_AMOUNT_RULE";
    private final BigDecimal elevatedThreshold;
    private final BigDecimal criticalThreshold;

    public HighAmountRule() {
        this(new BigDecimal("10000.00"), new BigDecimal("50000.00"));
    }

    public HighAmountRule(BigDecimal elevatedThreshold, BigDecimal criticalThreshold) {
        super(RULE_NAME, "Flags transactions exceeding standard monetary safety thresholds", 35);
        this.elevatedThreshold = elevatedThreshold;
        this.criticalThreshold = criticalThreshold;
    }

    @Override
    public RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context) {
        if (!isEnabled() || transaction == null || transaction.getAmount() == null) {
            return RuleEvaluation.pass(getRuleName());
        }

        BigDecimal amount = transaction.getAmount();

        if (amount.compareTo(criticalThreshold) >= 0) {
            return RuleEvaluation.trigger(
                    getRuleName(),
                    60,
                    String.format("Critical high amount transfer: $%s exceeds threshold of $%s", amount, criticalThreshold)
            );
        } else if (amount.compareTo(elevatedThreshold) >= 0) {
            return RuleEvaluation.trigger(
                    getRuleName(),
                    getDefaultWeight(),
                    String.format("Elevated amount transfer: $%s exceeds threshold of $%s", amount, elevatedThreshold)
            );
        }

        return RuleEvaluation.pass(getRuleName());
    }
}
