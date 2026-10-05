package com.fraudguard.exception;

/**
 * Base exception class for all FraudGuard application exceptions.
 * Encapsulates error message, underlying cause, and optional error code.
 */
public class FraudGuardException extends RuntimeException {

    private static final long serialVersionUID = 1L;
    private final String errorCode;

    public FraudGuardException(String message) {
        super(message);
        this.errorCode = "FG_GENERAL_ERROR";
    }

    public FraudGuardException(String message, Throwable cause) {
        super(message, cause);
        this.errorCode = "FG_GENERAL_ERROR";
    }

    public FraudGuardException(String errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }

    public FraudGuardException(String errorCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
    }

    public String getErrorCode() {
        return errorCode;
    }
}
