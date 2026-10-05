package com.fraudguard.exception;

/**
 * Thrown when an authenticated user attempts to access a protected resource
 * without having the requisite role or privileges (e.g. non-admin accessing admin portal).
 */
public class AuthorizationException extends FraudGuardException {

    private static final long serialVersionUID = 1L;

    public AuthorizationException(String message) {
        super("AUTHORIZATION_DENIED", message);
    }

    public AuthorizationException(String message, Throwable cause) {
        super("AUTHORIZATION_DENIED", message, cause);
    }
}
