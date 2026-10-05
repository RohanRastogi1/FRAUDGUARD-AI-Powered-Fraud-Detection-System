package com.fraudguard.exception;

/**
 * Thrown when an expected entity (User, Transaction, Alert) is not found in storage.
 */
public class ResourceNotFoundException extends FraudGuardException {

    private static final long serialVersionUID = 1L;

    public ResourceNotFoundException(String message) {
        super("RESOURCE_NOT_FOUND", message);
    }

    public ResourceNotFoundException(String message, Throwable cause) {
        super("RESOURCE_NOT_FOUND", message, cause);
    }
}
