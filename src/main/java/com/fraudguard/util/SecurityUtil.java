package com.fraudguard.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Security utility class providing cryptographic hashing and input sanitation.
 * Implements salted SHA-256 password hashing.
 *
 * Demonstrates:
 * - Java Cryptography Architecture (MessageDigest, SecureRandom)
 * - Safe credential handling
 */
public final class SecurityUtil {

    private static final String HASH_ALGORITHM = "SHA-256";
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private SecurityUtil() {
        // Prevent instantiation of utility class
    }

    /**
     * Generates a random 16-byte cryptographic salt encoded in Base64.
     */
    public static String generateSalt() {
        byte[] salt = new byte[16];
        SECURE_RANDOM.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    /**
     * Hashes a plain-text password using SHA-256 with the given salt.
     * Output format: salt$hash
     */
    public static String hashPassword(String plainPassword, String salt) {
        if (plainPassword == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        if (salt == null || salt.trim().isEmpty()) {
            salt = "fraudguard_default_salt";
        }

        try {
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt.getBytes(StandardCharsets.UTF_8));
            byte[] hashedBytes = md.digest(plainPassword.getBytes(StandardCharsets.UTF_8));
            String hash = Base64.getEncoder().encodeToString(hashedBytes);
            return salt + "$" + hash;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Cryptographic algorithm unavailable: " + HASH_ALGORITHM, e);
        }
    }

    /**
     * Hashes password with a newly generated salt.
     */
    public static String hashPassword(String plainPassword) {
        return hashPassword(plainPassword, generateSalt());
    }

    /**
     * Verifies a plain-text candidate password against a stored formatted hash (salt$hash).
     * Also supports deterministic seed salts for migration and testing.
     */
    public static boolean verifyPassword(String candidatePassword, String storedHash) {
        if (candidatePassword == null || storedHash == null) {
            return false;
        }

        if (!storedHash.contains("$")) {
            // Legacy / simple hash fallback if any
            return hashPassword(candidatePassword, "fraudguard_default_salt").equals(storedHash);
        }

        String[] parts = storedHash.split("\\$", 2);
        if (parts.length != 2) {
            return false;
        }

        String salt = parts[0];
        String expectedComputed = hashPassword(candidatePassword, salt);
        return MessageDigest.isEqual(
                expectedComputed.getBytes(StandardCharsets.UTF_8),
                storedHash.getBytes(StandardCharsets.UTF_8)
        );
    }

    /**
     * Sanitizes strings to prevent basic cross-site scripting (XSS) in HTML display.
     */
    public static String sanitize(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
}
