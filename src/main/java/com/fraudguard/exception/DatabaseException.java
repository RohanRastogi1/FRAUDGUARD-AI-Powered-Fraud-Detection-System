package com.fraudguard.exception;

/**
 * Thrown when a JDBC, SQL, transaction rollback, or database connection error occurs.
 */
public class DatabaseException extends FraudGuardException {

    private static final long serialVersionUID = 1L;

    public DatabaseException(String message) {
        super("DATABASE_ERROR", message);
    }

    public DatabaseException(String message, Throwable cause) {
        super("DATABASE_ERROR", message, cause);
    }
}
