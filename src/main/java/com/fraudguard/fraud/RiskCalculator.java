package com.fraudguard.fraud;

import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.RiskScore;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Calculates composite risk score and maps results to risk bands and recommendations.
 * Ensures critical rule triggers automatically escalate the transaction to CRITICAL risk.
 */
public class RiskCalculator {

    /**
     * Aggregates individual rule evaluation results into a comprehensive RiskScore.
     *
     * @param evaluations list of evaluated rule outcomes
     * @return populated RiskScore domain object
     */
    public RiskScore calculate(List<RuleEvaluation> evaluations) {
        if (evaluations == null || evaluations.isEmpty()) {
            return new RiskScore();
        }

        int totalScore = 0;
        boolean hasCritical = false;
        List<String> triggeredRuleNames = new ArrayList<>();
        Map<String, Integer> breakdown = new LinkedHashMap<>();
        StringBuilder reasons = new StringBuilder();

        for (RuleEvaluation eval : evaluations) {
            if (eval != null && eval.isTriggered()) {
                triggeredRuleNames.add(eval.getRuleName());
                breakdown.put(eval.getRuleName(), eval.getScoreContribution());
                totalScore += eval.getScoreContribution();

                if (eval.isCritical()) {
                    hasCritical = true;
                }

                if (reasons.length() > 0) {
                    reasons.append(" | ");
                }
                reasons.append(eval.getReason());
            }
        }

        if (hasCritical) {
            totalScore = Math.max(95, totalScore);
        }

        // Clamp between 0 and 100
        int finalScore = Math.max(0, Math.min(100, totalScore));
        RiskLevel level = RiskLevel.fromScore(finalScore);

        String recommendation;
        switch (level) {
            case LOW:
                recommendation = "APPROVE";
                break;
            case MEDIUM:
                recommendation = "MONITOR";
                break;
            case HIGH:
                recommendation = "FLAG_FOR_REVIEW";
                break;
            case CRITICAL:
                recommendation = "REJECT_IMMEDIATELY";
                break;
            default:
                recommendation = "APPROVE";
        }

        String explanation = reasons.length() > 0 ? reasons.toString() : "All fraud risk rules evaluated successfully with normal parameters.";

        return new RiskScore(finalScore, triggeredRuleNames, breakdown, recommendation, explanation);
    }
}
