package com.fraudguard.fraud;

import com.fraudguard.exception.FraudDetectionException;
import com.fraudguard.exception.InvalidTransactionException;
import com.fraudguard.fraud.rules.BlacklistAccountRule;
import com.fraudguard.fraud.rules.GeographicAnomalyRule;
import com.fraudguard.fraud.rules.HighAmountRule;
import com.fraudguard.fraud.rules.NewDeviceRule;
import com.fraudguard.fraud.rules.RapidBalanceDrainRule;
import com.fraudguard.fraud.rules.UnusualHourRule;
import com.fraudguard.fraud.rules.VelocityRule;
import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.RiskScore;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Core Fraud Detection Engine orchestrator.
 * Maintains registered fraud rules, executes evaluation pipelines,
 * and synthesizes RiskScore and FraudAlert objects.
 *
 * Demonstrates:
 * - OOP: Facade and Strategy Patterns
 * - Collections: CopyOnWriteArrayList for thread-safe rule registry
 * - Exception Handling: Throws checked/unchecked domain exceptions on evaluation failure
 */
public class FraudDetector {

    private final List<FraudRule> rules;
    private final RiskCalculator riskCalculator;

    public FraudDetector() {
        this(new RiskCalculator());
    }

    public FraudDetector(RiskCalculator riskCalculator) {
        this.riskCalculator = riskCalculator != null ? riskCalculator : new RiskCalculator();
        this.rules = new CopyOnWriteArrayList<>();
        registerDefaultRules();
    }

    private void registerDefaultRules() {
        rules.add(new BlacklistAccountRule());
        rules.add(new HighAmountRule());
        rules.add(new VelocityRule());
        rules.add(new GeographicAnomalyRule());
        rules.add(new UnusualHourRule());
        rules.add(new NewDeviceRule());
        rules.add(new RapidBalanceDrainRule());
    }

    public void registerRule(FraudRule rule) {
        if (rule != null) {
            rules.add(rule);
        }
    }

    public boolean removeRule(String ruleName) {
        if (ruleName == null) return false;
        return rules.removeIf(r -> r.getRuleName().equalsIgnoreCase(ruleName));
    }

    public List<FraudRule> getRegisteredRules() {
        return Collections.unmodifiableList(rules);
    }

    /**
     * Executes fraud risk assessment on a candidate transaction.
     *
     * @param transaction the candidate transaction to evaluate
     * @param user the account holder initiating the transaction
     * @param context behavioral context (recent transactions, devices)
     * @return calculated RiskScore
     * @throws InvalidTransactionException if transaction is invalid
     * @throws FraudDetectionException if internal engine failure occurs
     */
    public RiskScore evaluate(Transaction transaction, User user, TransactionContext context) {
        if (transaction == null) {
            throw new InvalidTransactionException("Cannot evaluate null transaction.");
        }
        transaction.validate();

        try {
            List<RuleEvaluation> evaluations = new ArrayList<>();
            for (FraudRule rule : rules) {
                if (rule.isEnabled()) {
                    RuleEvaluation eval = rule.evaluate(transaction, user, context);
                    evaluations.add(eval);
                }
            }

            RiskScore score = riskCalculator.calculate(evaluations);
            transaction.setRiskScore(score.getScore());
            transaction.setRiskLevel(score.getLevel());

            return score;
        } catch (InvalidTransactionException ite) {
            throw ite;
        } catch (Exception e) {
            throw new FraudDetectionException("Unexpected error during fraud rule execution: " + e.getMessage(), e);
        }
    }

    /**
     * Helper method to generate a FraudAlert entity if the risk evaluation justifies alerting.
     *
     * @param transaction the evaluated transaction
     * @param score the calculated risk score
     * @return FraudAlert or null if no alert required
     */
    public FraudAlert generateAlertIfNeeded(Transaction transaction, RiskScore score) {
        if (transaction == null || score == null || !score.requiresAlert()) {
            return null;
        }

        String triggeredRules = String.join(", ", score.getTriggeredRules());
        FraudAlert alert = new FraudAlert(
                transaction.getId(),
                transaction.getTransactionRef(),
                transaction.getUserId(),
                transaction.getAmount(),
                score.getScore(),
                score.getLevel(),
                triggeredRules,
                score.getExplanation()
        );
        alert.setStatus(AlertStatus.OPEN);
        return alert;
    }
}
