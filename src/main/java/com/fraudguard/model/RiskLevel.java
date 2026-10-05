package com.fraudguard.model;

/**
 * Risk classification levels computed by the Fraud Detection Engine.
 */
public enum RiskLevel {
    LOW("Low Risk", 0, 29, "badge-success"),
    MEDIUM("Medium Risk", 30, 59, "badge-warning"),
    HIGH("High Risk", 60, 84, "badge-danger"),
    CRITICAL("Critical Risk", 85, 100, "badge-critical");

    private final String displayName;
    private final int minScore;
    private final int maxScore;
    private final String badgeClass;

    RiskLevel(String displayName, int minScore, int maxScore, String badgeClass) {
        this.displayName = displayName;
        this.minScore = minScore;
        this.maxScore = maxScore;
        this.badgeClass = badgeClass;
    }

    public String getDisplayName() {
        return displayName;
    }

    public int getMinScore() {
        return minScore;
    }

    public int getMaxScore() {
        return maxScore;
    }

    public String getBadgeClass() {
        return badgeClass;
    }

    public static RiskLevel fromScore(int score) {
        if (score < 30) {
            return LOW;
        } else if (score < 60) {
            return MEDIUM;
        } else if (score < 85) {
            return HIGH;
        } else {
            return CRITICAL;
        }
    }

    public static RiskLevel fromString(String str) {
        if (str == null || str.trim().isEmpty()) {
            return LOW;
        }
        for (RiskLevel l : RiskLevel.values()) {
            if (l.name().equalsIgnoreCase(str.trim())) {
                return l;
            }
        }
        return LOW;
    }
}
