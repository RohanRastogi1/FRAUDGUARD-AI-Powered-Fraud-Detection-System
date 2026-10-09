package com.fraudguard.service.impl;

import com.fraudguard.dao.AuditLogDAO;
import com.fraudguard.dao.UserDAO;
import com.fraudguard.dao.impl.AuditLogDAOImpl;
import com.fraudguard.dao.impl.UserDAOImpl;
import com.fraudguard.exception.AuthenticationException;
import com.fraudguard.model.AuditLog;
import com.fraudguard.model.Role;
import com.fraudguard.model.User;
import com.fraudguard.model.UserStatus;
import com.fraudguard.service.AuthenticationService;
import com.fraudguard.util.SecurityUtil;

import java.math.BigDecimal;
import java.util.Optional;

/**
 * Service implementation for user authentication, registration, and credential security.
 */
public class AuthenticationServiceImpl implements AuthenticationService {

    private final UserDAO userDAO;
    private final AuditLogDAO auditLogDAO;

    public AuthenticationServiceImpl() {
        this(new UserDAOImpl(), new AuditLogDAOImpl());
    }

    public AuthenticationServiceImpl(UserDAO userDAO, AuditLogDAO auditLogDAO) {
        this.userDAO = userDAO;
        this.auditLogDAO = auditLogDAO;
    }

    @Override
    public User authenticate(String username, String plainPassword, String ipAddress) {
        if (username == null || username.trim().isEmpty() || plainPassword == null || plainPassword.isEmpty()) {
            throw new AuthenticationException("Username and password are required.");
        }

        String lookup = username.trim();
        if ("superadmin@rohanrastogi.in".equalsIgnoreCase(lookup)) {
            lookup = "superadmin";
        }

        Optional<User> userOpt = userDAO.findByUsername(lookup);
        if (userOpt.isEmpty()) {
            userOpt = userDAO.findByEmail(lookup);
        }
        if (userOpt.isEmpty()) {
            auditLogDAO.create(new AuditLog(null, username, "LOGIN_FAILED", "USER", null, "Unknown username attempted", ipAddress));
            throw new AuthenticationException("Invalid username or password. Available test accounts: admin / Admin@123, analyst / Analyst@123, john_doe / Customer@123");
        }

        User user = userOpt.get();

        if (user.getStatus() == UserStatus.BLOCKED) {
            auditLogDAO.create(new AuditLog(user.getId(), user.getUsername(), "LOGIN_BLOCKED", "USER", user.getId(), "Blocked account login rejected", ipAddress));
            throw new AuthenticationException("Account is blocked due to security violations. Please contact support.");
        }

        if (user.getStatus() == UserStatus.SUSPENDED) {
            auditLogDAO.create(new AuditLog(user.getId(), user.getUsername(), "LOGIN_SUSPENDED", "USER", user.getId(), "Suspended account login rejected", ipAddress));
            throw new AuthenticationException("Account is temporarily suspended pending compliance review.");
        }

        boolean verified = SecurityUtil.verifyPassword(plainPassword, user.getPasswordHash());
        if (!verified) {
            auditLogDAO.create(new AuditLog(user.getId(), user.getUsername(), "LOGIN_FAILED", "USER", user.getId(), "Incorrect password", ipAddress));
            throw new AuthenticationException("Invalid username or password.");
        }

        // Record successful login
        auditLogDAO.create(new AuditLog(user.getId(), user.getUsername(), "LOGIN_SUCCESS", "USER", user.getId(), "Successful authentication", ipAddress));

        return user;
    }

    @Override
    public User register(String username, String plainPassword, String email, String fullName, Role role) {
        if (username == null || username.trim().length() < 3) {
            throw new AuthenticationException("Username must be at least 3 characters.");
        }
        if (plainPassword == null || plainPassword.length() < 6) {
            throw new AuthenticationException("Password must be at least 6 characters.");
        }
        if (email == null || !email.contains("@")) {
            throw new AuthenticationException("Please enter a valid email address.");
        }

        if (userDAO.findByUsername(username.trim()).isPresent()) {
            throw new AuthenticationException("Username '" + username + "' is already taken.");
        }
        if (userDAO.findByEmail(email.trim()).isPresent()) {
            throw new AuthenticationException("Email '" + email + "' is already registered.");
        }

        String passwordHash = SecurityUtil.hashPassword(plainPassword);
        User user = new User(username.trim(), passwordHash, email.trim().toLowerCase(), fullName != null ? fullName.trim() : username, role);
        user.setStatus(UserStatus.ACTIVE);
        user.setBalance(new BigDecimal("1000.00")); // Sign-up welcome deposit for demonstration

        User created = userDAO.create(user);
        auditLogDAO.create(new AuditLog(created.getId(), created.getUsername(), "USER_REGISTERED", "USER", created.getId(), "Account created with role " + role, "127.0.0.1"));
        return created;
    }

    @Override
    public void logout(User user, String ipAddress) {
        if (user != null) {
            auditLogDAO.create(new AuditLog(user.getId(), user.getUsername(), "LOGOUT", "USER", user.getId(), "User signed out", ipAddress));
        }
    }

    @Override
    public boolean changePassword(Long userId, String currentPassword, String newPassword) {
        if (userId == null || currentPassword == null || newPassword == null || newPassword.length() < 6) {
            return false;
        }

        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) return false;

        User user = userOpt.get();
        if (!SecurityUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
            return false;
        }

        user.setPasswordHash(SecurityUtil.hashPassword(newPassword));
        return userDAO.update(user);
    }
}
