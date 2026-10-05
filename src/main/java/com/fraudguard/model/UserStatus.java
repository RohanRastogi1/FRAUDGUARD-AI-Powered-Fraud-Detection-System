package com.fraudguard.model;

/**
 * Enumeration representing user account lifecycle states.
 */
public enum UserStatus {
    ACTIVE,
    SUSPENDED,
    BLOCKED;

    public static UserStatus fromString(String statusStr) {
        if (statusStr == null || statusStr.trim().isEmpty()) {
            return ACTIVE;
        }
        for (UserStatus s : UserStatus.values()) {
            if (s.name().equalsIgnoreCase(statusStr.trim())) {
                return s;
            }
        }
        return ACTIVE;
    }
}
