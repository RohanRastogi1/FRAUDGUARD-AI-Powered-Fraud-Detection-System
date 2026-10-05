package com.fraudguard.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Domain entity representing the quantified risk evaluated for a transaction.
 * Demonstrates OOP encapsulation, immutable lists/defensive copying,
 * and comprehensive risk level resolution.
 */
public class RiskScore implements Serializable {

    private static final long serialVersionUID = 1L;

    private int score; // 0 to 100
    private RiskLevel level;
    private final List<String> triggeredRules;
    private final Map<String, Integer> ruleBreakdown;
    private String recommendation;
    private String explanation;

    public RiskScore() {
        this.score = 0;
        this.level = RiskLevel.LOW;
        this.triggeredRules = new ArrayList<>();
        this.ruleBreakdown = new LinkedHashMap<>();
        this.recommendation = "APPROVE";
        this.explanation = "No suspicious indicators detected.";
    }

    public RiskScore(int score, List<String> triggeredRules, Map<String, Integer> ruleBreakdown, String recommendation, String explanation) {
        this.score = Math.max(0, Math.min(100, score));
        this.level = RiskLevel.fromScore(this.score);
        this.triggeredRules = triggeredRules != null ? new ArrayList<>(triggeredRules) : new ArrayList<>();
        this.ruleBreakdown = ruleBreakdown != null ? new LinkedHashMap<>(ruleBreakdown) : new LinkedHashMap<>();
        this.recommendation = recommendation != null ? recommendation : deriveRecommendation(this.level);
        this.explanation = explanation != null ? explanation : "Risk evaluation completed.";
    }

    private static String deriveRecommendation(RiskLevel level) {
        switch (level) {
            case LOW:
                return "APPROVE";
            case MEDIUM:
                return "MONITOR";
            case HIGH:
                return "FLAG_FOR_REVIEW";
            case CRITICAL:
                return "REJECT_IMMEDIATELY";
            default:
                return "APPROVE";
        }
    }

    public synchronized void addRuleTrigger(String ruleName, int points, String reason) {
        if (ruleName == null) return;
        this.triggeredRules.add(ruleName);
        this.ruleBreakdown.put(ruleName, points);
        this.score = Math.min(100, this.score + points);
        this.level = RiskLevel.fromScore(this.score);
        this.recommendation = deriveRecommendation(this.level);
        if (this.explanation == null || this.explanation.contains("No suspicious indicators")) {
            this.explanation = reason;
        } else {
            this.explanation += " | " + reason;
        }
    }

    public boolean requiresAlert() {
        return this.score >= 30;
    }

    public boolean isCritical() {
        return this.level == RiskLevel.CRITICAL;
    }

    public boolean isHighOrCritical() {
        return this.level == RiskLevel.HIGH || this.level == RiskLevel.CRITICAL;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = Math.max(0, Math.min(100, score));
        this.level = RiskLevel.fromScore(this.score);
        this.recommendation = deriveRecommendation(this.level);
    }

    public RiskLevel getLevel() {
        return level;
    }

    public List<String> getTriggeredRules() {
        return Collections.unmodifiableList(triggeredRules);
    }

    public Map<String, Integer> getRuleBreakdown() {
        return Collections.unmodifiableMap(ruleBreakdown);
    }

    public String getRecommendation() {
        return recommendation;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RiskScore riskScore = (RiskScore) o;
        return score == riskScore.score && level == riskScore.level;
    }

    @Override
    public int hashCode() {
        return Objects.hash(score, level);
    }

    @Override
    public String toString() {
        return "RiskScore{" +
                "score=" + score +
                ", level=" + level +
                ", triggeredRules=" + triggeredRules +
                ", recommendation='" + recommendation + '\'' +
                '}';
    }
}
