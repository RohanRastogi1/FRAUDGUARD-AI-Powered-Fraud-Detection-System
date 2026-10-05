package com.fraudguard.fraud;

import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

/**
 * Interface defining the contract for modular fraud detection rules.
 * Implements the Strategy Pattern: each rule evaluates specific risk factors
 * independently and contributes to the composite risk score.
 */
public interface FraudRule {

    /**
     * Unique identifier for the fraud rule.
     */
    String getRuleName();

    /**
     * Human-readable description of what this rule detects.
     */
    String getDescription();

    /**
     * Default risk score points assigned when this rule triggers (0-100).
     */
    int getDefaultWeight();

    /**
     * Indicates whether this rule is actively enabled in the engine.
     */
    boolean isEnabled();

    /**
     * Evaluates a transaction against this specific rule logic.
     *
     * @param transaction the candidate transaction
     * @param user the account holder initiating the transaction
     * @param context behavioral context including past transactions and devices
     * @return RuleEvaluation outcome
     */
    RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context);
}
