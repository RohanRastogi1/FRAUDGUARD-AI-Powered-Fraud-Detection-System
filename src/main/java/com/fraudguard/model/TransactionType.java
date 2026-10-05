package com.fraudguard.model;

/**
 * Types of financial transactions supported by FraudGuard.
 */
public enum TransactionType {
    TRANSFER("Fund Transfer"),
    PAYMENT("Merchant Payment"),
    WITHDRAWAL("ATM/Bank Withdrawal"),
    DEPOSIT("Account Deposit");

    private final String displayName;

    TransactionType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static TransactionType fromString(String str) {
        if (str == null || str.trim().isEmpty()) {
            return TRANSFER;
        }
        for (TransactionType t : TransactionType.values()) {
            if (t.name().equalsIgnoreCase(str.trim())) {
                return t;
            }
        }
        return TRANSFER;
    }
}
