package com.fraudguard.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("SecurityUtil Tests")
public class SecurityUtilTest {

    @Test
    @DisplayName("Password hashing and verification should succeed with correct candidate")
    void testPasswordHashAndVerify() {
        String rawPassword = "Admin@123Secure!";
        String hash = SecurityUtil.hashPassword(rawPassword);

        assertNotNull(hash);
        assertTrue(hash.contains("$"));
        assertTrue(SecurityUtil.verifyPassword(rawPassword, hash));
        assertFalse(SecurityUtil.verifyPassword("WrongPassword", hash));
    }

    @Test
    @DisplayName("Deterministic salt verification works reliably")
    void testDeterministicSalt() {
        String salt = "fg_salt_2026";
        String adminHash = SecurityUtil.hashPassword("Admin@123", salt);
        String analystHash = SecurityUtil.hashPassword("Analyst@123", salt);
        String customerHash = SecurityUtil.hashPassword("Customer@123", salt);

        System.out.println("ADMIN_HASH: " + adminHash);
        System.out.println("ANALYST_HASH: " + analystHash);
        System.out.println("CUSTOMER_HASH: " + customerHash);

        assertTrue(SecurityUtil.verifyPassword("Admin@123", adminHash));
        assertTrue(SecurityUtil.verifyPassword("Analyst@123", analystHash));
        assertTrue(SecurityUtil.verifyPassword("Customer@123", customerHash));
        assertFalse(SecurityUtil.verifyPassword("Admin@999", adminHash));
    }

    @Test
    @DisplayName("HTML sanitization strips dangerous characters")
    void testSanitization() {
        String input = "<script>alert('xss')</script>";
        String sanitized = SecurityUtil.sanitize(input);
        assertFalse(sanitized.contains("<"));
        assertFalse(sanitized.contains(">"));
    }
}
