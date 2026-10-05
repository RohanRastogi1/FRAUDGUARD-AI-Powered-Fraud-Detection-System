package com.fraudguard.dao;

import com.fraudguard.model.User;
import com.fraudguard.model.UserStatus;

import java.math.BigDecimal;
import java.sql.Connection;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for User entities.
 * Defines standard CRUD operations and balance management methods.
 */
public interface UserDAO {

    User create(User user);
    User create(User user, Connection conn);

    Optional<User> findById(Long id);
    Optional<User> findById(Long id, Connection conn);

    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);

    List<User> findAll();
    List<User> findAll(int limit, int offset);

    boolean update(User user);
    boolean update(User user, Connection conn);

    boolean updateBalance(Long userId, BigDecimal newBalance, Connection conn);

    boolean updateStatus(Long userId, UserStatus status);

    boolean delete(Long id);

    long countUsers();
}
