package com.fraudguard.service;

import com.fraudguard.model.Role;
import com.fraudguard.model.User;

/**
 * Service managing user authentication, registration, session tracking,
 * and credential security.
 */
public interface AuthenticationService {

    /**
     * Authenticates a user with username and candidate plain-text password.
     *
     * @param username username
     * @param plainPassword plain text password
     * @param ipAddress client IP for audit logging
     * @return authenticated User entity
     * @throws com.fraudguard.exception.AuthenticationException if credentials invalid or account locked
     */
    User authenticate(String username, String plainPassword, String ipAddress);

    /**
     * Registers a new customer or staff account.
     */
    User register(String username, String plainPassword, String email, String fullName, Role role);

    /**
     * Records a logout audit entry.
     */
    void logout(User user, String ipAddress);

    /**
     * Updates account password securely.
     */
    boolean changePassword(Long userId, String currentPassword, String newPassword);
}
