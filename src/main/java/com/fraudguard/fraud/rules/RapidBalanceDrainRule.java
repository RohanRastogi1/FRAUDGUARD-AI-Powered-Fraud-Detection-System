package com.fraudguard.fraud.rules;

import com.fraudguard.fraud.RuleEvaluation;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Detects aggressive balance liquidation attempts.
 * When fraudsters take over an account, they typically attempt to transfer
 * almost the entirety of the liquid balance immediately.
 */
public class RapidBalanceDrainRule extends AbstractFraudRule {

    public static final String RULE_NAME = "RAPID_BALANCE_DRAIN_RULE";
    private final BigDecimal drainPercentageThreshold;

    public RapidBalanceDrainRule() {
        this(new BigDecimal("0.85")); // 85% drain
    }

    public RapidBalanceDrainRule(BigDecimal drainPercentageThreshold) {
        super(RULE_NAME, "Detects anomalous drain of total available account balance", 30);
        this.drainPercentageThreshold = drainPercentageThreshold;
    }

    @Override
    public RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context) {
        if (!isEnabled() || transaction == null || user == null) {
            return RuleEvaluation.pass(getRuleName());
        }

        BigDecimal balance = user.getBalance();
        BigDecimal amount = transaction.getAmount();

        if (balance == null || amount == null || balance.compareTo(BigDecimal.ZERO) <= 0) {
            return RuleEvaluation.pass(getRuleName());
        }

        // Only evaluate if balance is significant (e.g. >= $500)
        if (balance.compareTo(new BigDecimal("500.00")) >= 0) {
            BigDecimal drainRatio = amount.divide(balance, 4, RoundingMode.HALF_UP);
            if (drainRatio.compareTo(drainPercentageThreshold) >= 0) {
                int percent = drainRatio.multiply(new BigDecimal(100)).intValue();
                return RuleEvaluation.trigger(
                        getRuleName(),
                        getDefaultWeight(),
                        String.format("High balance drain: transaction consumes %d%% of available user balance ($%s / $%s)",
                                percent, amount, balance)
                );
            }
        }

        return RuleEvaluation.pass(getRuleName());
    }
}
