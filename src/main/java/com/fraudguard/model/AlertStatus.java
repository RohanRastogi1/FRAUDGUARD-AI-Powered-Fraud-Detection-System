package com.fraudguard.model;

/**
 * Status of a Fraud Alert in the investigation lifecycle.
 */
public enum AlertStatus {
    OPEN("Open"),
    UNDER_REVIEW("Under Review"),
    RESOLVED("Resolved"),
    DISMISSED("Dismissed");

    private final String displayName;

    AlertStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static AlertStatus fromString(String str) {
        if (str == null || str.trim().isEmpty()) {
            return OPEN;
        }
        for (AlertStatus s : AlertStatus.values()) {
            if (s.name().equalsIgnoreCase(str.trim())) {
                return s;
            }
        }
        return OPEN;
    }
}
