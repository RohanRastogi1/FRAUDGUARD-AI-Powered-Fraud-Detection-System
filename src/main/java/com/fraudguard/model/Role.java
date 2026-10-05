package com.fraudguard.model;

/**
 * Enumeration representing user roles in the FraudGuard system.
 * Used for role-based access control (RBAC).
 */
public enum Role {
    CUSTOMER("Customer"),
    ANALYST("Fraud Analyst"),
    ADMIN("System Administrator");

    private final String displayName;

    Role(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static Role fromString(String roleStr) {
        if (roleStr == null || roleStr.trim().isEmpty()) {
            return CUSTOMER;
        }
        for (Role r : Role.values()) {
            if (r.name().equalsIgnoreCase(roleStr.trim())) {
                return r;
            }
        }
        return CUSTOMER;
    }
}
