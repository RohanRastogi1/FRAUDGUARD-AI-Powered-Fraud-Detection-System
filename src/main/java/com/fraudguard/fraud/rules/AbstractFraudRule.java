package com.fraudguard.fraud.rules;

import com.fraudguard.fraud.FraudRule;

/**
 * Base abstract class for FraudRule implementations providing common state management.
 * Demonstrates OOP Inheritance and Abstraction.
 */
public abstract class AbstractFraudRule implements FraudRule {

    private final String ruleName;
    private final String description;
    private final int defaultWeight;
    private boolean enabled;

    protected AbstractFraudRule(String ruleName, String description, int defaultWeight) {
        this.ruleName = ruleName;
        this.description = description;
        this.defaultWeight = defaultWeight;
        this.enabled = true;
    }

    @Override
    public String getRuleName() {
        return ruleName;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public int getDefaultWeight() {
        return defaultWeight;
    }

    @Override
    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
}
