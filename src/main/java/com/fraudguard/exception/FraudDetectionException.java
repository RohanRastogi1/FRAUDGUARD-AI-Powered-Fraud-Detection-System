package com.fraudguard.exception;

/**
 * Thrown when an internal error occurs during fraud evaluation,
 * rule execution, or anomaly calculation.
 */
public class FraudDetectionException extends FraudGuardException {

    private static final long serialVersionUID = 1L;

    public FraudDetectionException(String message) {
        super("FRAUD_DETECTION_ERROR", message);
    }

    public FraudDetectionException(String message, Throwable cause) {
        super("FRAUD_DETECTION_ERROR", message, cause);
    }
}
