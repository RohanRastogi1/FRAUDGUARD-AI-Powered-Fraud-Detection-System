package com.fraudguard.exception;

/**
 * Thrown when user authentication fails due to invalid credentials,
 * locked accounts, or missing session tokens.
 */
public class AuthenticationException extends FraudGuardException {

    private static final long serialVersionUID = 1L;

    public AuthenticationException(String message) {
        super("AUTHENTICATION_FAILED", message);
    }

    public AuthenticationException(String message, Throwable cause) {
        super("AUTHENTICATION_FAILED", message, cause);
    }
}
