package com.fraudguard.model;

import com.fraudguard.exception.InvalidTransactionException;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Domain entity representing a Financial Transaction processed through FraudGuard.
 * Encapsulates financial payload, contextual signals (IP, device, location),
 * and processing status.
 */
public class Transaction implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String transactionRef;
    private Long userId;
    private BigDecimal amount;
    private String currency;
    private String recipientAccount;
    private String recipientName;
    private TransactionType type;
    private TransactionStatus status;
    private String location;
    private String ipAddress;
    private String deviceFingerprint;
    private Integer riskScore;
    private RiskLevel riskLevel;
    private String notes;
    private LocalDateTime timestamp;

    public Transaction() {
        this.transactionRef = "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        this.currency = "INR";
        this.type = TransactionType.TRANSFER;
        this.status = TransactionStatus.PENDING;
        this.riskScore = 0;
        this.riskLevel = RiskLevel.LOW;
        this.timestamp = LocalDateTime.now();
    }

    public Transaction(Long userId, BigDecimal amount, String recipientAccount,
                       String recipientName, TransactionType type, String location,
                       String ipAddress, String deviceFingerprint) {
        this();
        this.userId = userId;
        this.amount = amount;
        this.recipientAccount = recipientAccount;
        this.recipientName = recipientName;
        this.type = type != null ? type : TransactionType.TRANSFER;
        this.location = location;
        this.ipAddress = ipAddress;
        this.deviceFingerprint = deviceFingerprint;
    }

    public Transaction(Long id, String transactionRef, Long userId, BigDecimal amount,
                       String currency, String recipientAccount, String recipientName,
                       TransactionType type, TransactionStatus status, String location,
                       String ipAddress, String deviceFingerprint, Integer riskScore,
                       RiskLevel riskLevel, String notes, LocalDateTime timestamp) {
        this.id = id;
        this.transactionRef = transactionRef;
        this.userId = userId;
        this.amount = amount;
        this.currency = currency != null ? currency : "INR";
        this.recipientAccount = recipientAccount;
        this.recipientName = recipientName;
        this.type = type != null ? type : TransactionType.TRANSFER;
        this.status = status != null ? status : TransactionStatus.PENDING;
        this.location = location;
        this.ipAddress = ipAddress;
        this.deviceFingerprint = deviceFingerprint;
        this.riskScore = riskScore != null ? riskScore : 0;
        this.riskLevel = riskLevel != null ? riskLevel : RiskLevel.fromScore(this.riskScore);
        this.notes = notes;
        this.timestamp = timestamp != null ? timestamp : LocalDateTime.now();
    }

    /**
     * Validates transaction invariants before processing.
     * Throws InvalidTransactionException if fields violate domain rules.
     */
    public void validate() throws InvalidTransactionException {
        if (userId == null || userId <= 0) {
            throw new InvalidTransactionException("Transaction must be associated with a valid User ID.");
        }
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new InvalidTransactionException("Transaction amount must be strictly greater than zero.");
        }
        if (amount.compareTo(new BigDecimal("10000000.00")) > 0) {
            throw new InvalidTransactionException("Transaction amount exceeds single transfer ceiling ($10,000,000).");
        }
        if (recipientAccount == null || recipientAccount.trim().isEmpty()) {
            throw new InvalidTransactionException("Recipient account number cannot be empty.");
        }
        if (recipientName == null || recipientName.trim().isEmpty()) {
            throw new InvalidTransactionException("Recipient name cannot be empty.");
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getRecipientAccount() {
        return recipientAccount;
    }

    public void setRecipientAccount(String recipientAccount) {
        this.recipientAccount = recipientAccount;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public TransactionType getType() {
        return type;
    }

    public void setType(TransactionType type) {
        this.type = type != null ? type : TransactionType.TRANSFER;
    }

    public TransactionStatus getStatus() {
        return status;
    }

    public void setStatus(TransactionStatus status) {
        this.status = status != null ? status : TransactionStatus.PENDING;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getDeviceFingerprint() {
        return deviceFingerprint;
    }

    public void setDeviceFingerprint(String deviceFingerprint) {
        this.deviceFingerprint = deviceFingerprint;
    }

    public Integer getRiskScore() {
        return riskScore;
    }

    public void setRiskScore(Integer riskScore) {
        this.riskScore = riskScore != null ? riskScore : 0;
        this.riskLevel = RiskLevel.fromScore(this.riskScore);
    }

    public RiskLevel getRiskLevel() {
        return riskLevel;
    }

    public void setRiskLevel(RiskLevel riskLevel) {
        this.riskLevel = riskLevel;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Transaction that = (Transaction) o;
        return Objects.equals(id, that.id) || Objects.equals(transactionRef, that.transactionRef);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, transactionRef);
    }

    @Override
    public String toString() {
        return "Transaction{" +
                "id=" + id +
                ", transactionRef='" + transactionRef + '\'' +
                ", userId=" + userId +
                ", amount=" + amount +
                ", recipientAccount='" + recipientAccount + '\'' +
                ", status=" + status +
                ", riskScore=" + riskScore +
                ", riskLevel=" + riskLevel +
                ", timestamp=" + timestamp +
                '}';
    }
}
