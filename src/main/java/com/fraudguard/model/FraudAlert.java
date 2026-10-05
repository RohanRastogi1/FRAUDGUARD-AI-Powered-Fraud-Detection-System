package com.fraudguard.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Domain entity representing a Fraud Alert raised when a transaction triggers
 * suspicious or high-risk fraud rules.
 */
public class FraudAlert implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long transactionId;
    private String transactionRef;
    private Long userId;
    private String userName;
    private BigDecimal amount;
    private int riskScore;
    private RiskLevel riskLevel;
    private String triggeredRules;
    private String reason;
    private AlertStatus status;
    private String reviewedBy;
    private String reviewNotes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public FraudAlert() {
        this.status = AlertStatus.OPEN;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public FraudAlert(Long transactionId, String transactionRef, Long userId,
                      BigDecimal amount, int riskScore, RiskLevel riskLevel,
                      String triggeredRules, String reason) {
        this();
        this.transactionId = transactionId;
        this.transactionRef = transactionRef;
        this.userId = userId;
        this.amount = amount;
        this.riskScore = riskScore;
        this.riskLevel = riskLevel != null ? riskLevel : RiskLevel.fromScore(riskScore);
        this.triggeredRules = triggeredRules;
        this.reason = reason;
        this.status = AlertStatus.OPEN;
    }

    public FraudAlert(Long id, Long transactionId, String transactionRef, Long userId,
                      String userName, BigDecimal amount, int riskScore, RiskLevel riskLevel,
                      String triggeredRules, String reason, AlertStatus status,
                      String reviewedBy, String reviewNotes, LocalDateTime createdAt,
                      LocalDateTime updatedAt) {
        this.id = id;
        this.transactionId = transactionId;
        this.transactionRef = transactionRef;
        this.userId = userId;
        this.userName = userName;
        this.amount = amount;
        this.riskScore = riskScore;
        this.riskLevel = riskLevel != null ? riskLevel : RiskLevel.fromScore(riskScore);
        this.triggeredRules = triggeredRules;
        this.reason = reason;
        this.status = status != null ? status : AlertStatus.OPEN;
        this.reviewedBy = reviewedBy;
        this.reviewNotes = reviewNotes;
        this.createdAt = createdAt != null ? createdAt : LocalDateTime.now();
        this.updatedAt = updatedAt != null ? updatedAt : LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public String getTransactionRef() {
        return transactionRef;
    }

    public void setTransactionRef(String transactionRef) {
        this.transactionRef = transactionRef;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public int getRiskScore() {
        return riskScore;
    }

    public void setRiskScore(int riskScore) {
        this.riskScore = riskScore;
        this.riskLevel = RiskLevel.fromScore(riskScore);
    }

    public RiskLevel getRiskLevel() {
        return riskLevel;
    }

    public void setRiskLevel(RiskLevel riskLevel) {
        this.riskLevel = riskLevel;
    }

    public String getTriggeredRules() {
        return triggeredRules;
    }

    public void setTriggeredRules(String triggeredRules) {
        this.triggeredRules = triggeredRules;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public AlertStatus getStatus() {
        return status;
    }

    public void setStatus(AlertStatus status) {
        this.status = status != null ? status : AlertStatus.OPEN;
    }

    public String getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(String reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public String getReviewNotes() {
        return reviewNotes;
    }

    public void setReviewNotes(String reviewNotes) {
        this.reviewNotes = reviewNotes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FraudAlert that = (FraudAlert) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "FraudAlert{" +
                "id=" + id +
                ", transactionRef='" + transactionRef + '\'' +
                ", userId=" + userId +
                ", riskScore=" + riskScore +
                ", riskLevel=" + riskLevel +
                ", status=" + status +
                ", createdAt=" + createdAt +
                '}';
    }
}
