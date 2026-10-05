package com.fraudguard.fraud;

import java.io.Serializable;

/**
 * Result of evaluating a specific FraudRule against a transaction.
 * Encapsulates whether the rule triggered, points assigned, and explanation.
 */
public class RuleEvaluation implements Serializable {

    private static final long serialVersionUID = 1L;

    private final String ruleName;
    private final boolean triggered;
    private final int scoreContribution;
    private final String reason;
    private final boolean critical;

    private RuleEvaluation(String ruleName, boolean triggered, int scoreContribution, String reason, boolean critical) {
        this.ruleName = ruleName;
        this.triggered = triggered;
        this.scoreContribution = scoreContribution;
        this.reason = reason;
        this.critical = critical;
    }

    public static RuleEvaluation pass(String ruleName) {
        return new RuleEvaluation(ruleName, false, 0, "Rule passed: No anomaly detected", false);
    }

    public static RuleEvaluation trigger(String ruleName, int score, String reason) {
        return new RuleEvaluation(ruleName, true, score, reason, false);
    }

    public static RuleEvaluation criticalTrigger(String ruleName, int score, String reason) {
        return new RuleEvaluation(ruleName, true, score, reason, true);
    }

    public String getRuleName() {
        return ruleName;
    }

    public boolean isTriggered() {
        return triggered;
    }

    public int getScoreContribution() {
        return scoreContribution;
    }

    public String getReason() {
        return reason;
    }

    public boolean isCritical() {
        return critical;
    }

    @Override
    public String toString() {
        return "RuleEvaluation{" +
                "ruleName='" + ruleName + '\'' +
                ", triggered=" + triggered +
                ", scoreContribution=" + scoreContribution +
                ", reason='" + reason + '\'' +
                ", critical=" + critical +
                '}';
    }
}
