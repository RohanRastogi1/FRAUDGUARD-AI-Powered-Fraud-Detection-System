package com.fraudguard.model;

/**
 * Lifecycle states of a financial transaction.
 * - PENDING: Initial state before complete processing
 * - APPROVED: Cleared by fraud engine (low/safe risk)
 * - FLAGGED: Under fraud alert review (medium/high risk)
 * - REJECTED: Blocked immediately by critical fraud rule or admin
 */
public enum TransactionStatus {
    PENDING("Pending"),
    APPROVED("Approved"),
    FLAGGED("Flagged for Review"),
    REJECTED("Rejected");

    private final String displayName;

    TransactionStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static TransactionStatus fromString(String str) {
        if (str == null || str.trim().isEmpty()) {
            return PENDING;
        }
        for (TransactionStatus s : TransactionStatus.values()) {
            if (s.name().equalsIgnoreCase(str.trim())) {
                return s;
            }
        }
        return PENDING;
    }
}
