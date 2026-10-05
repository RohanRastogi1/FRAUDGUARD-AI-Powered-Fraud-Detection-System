package com.fraudguard.exception;

/**
 * Thrown when a transaction fails domain invariants or validation rules
 * (e.g. negative amount, missing recipient, invalid account number).
 */
public class InvalidTransactionException extends FraudGuardException {

    private static final long serialVersionUID = 1L;

    public InvalidTransactionException(String message) {
        super("INVALID_TRANSACTION", message);
    }

    public InvalidTransactionException(String message, Throwable cause) {
        super("INVALID_TRANSACTION", message, cause);
    }
}
