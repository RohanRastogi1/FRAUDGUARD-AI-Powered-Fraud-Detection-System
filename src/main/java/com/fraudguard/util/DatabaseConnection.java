package com.fraudguard.util;

import com.fraudguard.exception.DatabaseException;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Manages JDBC database connectivity for the FraudGuard platform.
 * Supports configurable connection properties from classpath, environment variables,
 * JVM system properties, and dynamic overrides for unit/integration testing.
 *
 * Demonstrates:
 * - JDBC: DriverManager, Connection lifecycle management
 * - Exception Handling: Translates low-level SQLExceptions to domain DatabaseException
 * - Try-with-resources and defensive connection handling
 */
public class DatabaseConnection {

    private static final String DEFAULT_PROPERTIES_FILE = "db.properties";
    private static Properties cachedProperties = null;

    // Overrides for testing (e.g. H2 in-memory mode)
    private static volatile String overrideUrl = null;
    private static volatile String overrideUser = null;
    private static volatile String overridePassword = null;
    private static volatile String overrideDriver = null;

    static {
        loadProperties();
    }

    private DatabaseConnection() {
        // Prevent instantiation
    }

    private static synchronized void loadProperties() {
        if (cachedProperties != null) return;

        cachedProperties = new Properties();
        try (InputStream in = DatabaseConnection.class.getClassLoader().getResourceAsStream(DEFAULT_PROPERTIES_FILE)) {
            if (in != null) {
                cachedProperties.load(in);
            }
        } catch (Exception e) {
            // Silently fallback to defaults/env vars
        }
    }

    /**
     * Sets dynamic override configuration. Primarily used by unit tests to supply
     * an in-memory database connection without affecting production settings.
     */
    public static void setOverrideConfig(String url, String user, String password, String driver) {
        overrideUrl = url;
        overrideUser = user;
        overridePassword = password;
        overrideDriver = driver;
        if (driver != null) {
            try {
                Class.forName(driver);
            } catch (ClassNotFoundException e) {
                throw new DatabaseException("Failed to load override JDBC driver: " + driver, e);
            }
        }
    }

    public static void clearOverrideConfig() {
        overrideUrl = null;
        overrideUser = null;
        overridePassword = null;
        overrideDriver = null;
    }

    public static String getUrl() {
        if (overrideUrl != null) return overrideUrl;
        String env = System.getenv("DB_URL");
        if (env != null && !env.isEmpty()) return env;
        String sys = System.getProperty("db.url");
        if (sys != null && !sys.isEmpty()) return sys;
        return cachedProperties.getProperty("db.url", "jdbc:mysql://localhost:3306/fraudguard_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&connectTimeout=3000&socketTimeout=3000");
    }

    public static String getUser() {
        if (overrideUser != null) return overrideUser;
        String env = System.getenv("DB_USER");
        if (env != null && !env.isEmpty()) return env;
        String sys = System.getProperty("db.user");
        if (sys != null && !sys.isEmpty()) return sys;
        return cachedProperties.getProperty("db.user", "root");
    }

    public static String getPassword() {
        if (overridePassword != null) return overridePassword;
        String env = System.getenv("DB_PASSWORD");
        if (env != null) return env;
        String sys = System.getProperty("db.password");
        if (sys != null) return sys;
        return cachedProperties.getProperty("db.password", "root");
    }

    public static String getDriver() {
        if (overrideDriver != null) return overrideDriver;
        String sys = System.getProperty("db.driver");
        if (sys != null && !sys.isEmpty()) return sys;
        return cachedProperties.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
    }

    /**
     * Obtains a new physical JDBC Connection.
     * Callers must close this connection or manage it within a try-with-resources statement.
     *
     * @return active java.sql.Connection
     * @throws DatabaseException if connection establishment fails
     */
    public static Connection getConnection() {
        try {
            Class.forName(getDriver());
            return DriverManager.getConnection(getUrl(), getUser(), getPassword());
        } catch (ClassNotFoundException e) {
            throw new DatabaseException("JDBC Driver class not found: " + getDriver(), e);
        } catch (SQLException e) {
            throw new DatabaseException("Failed to establish database connection to: " + getUrl() + " - " + e.getMessage(), e);
        }
    }

    /**
     * Quietly closes resources without throwing checked exceptions.
     */
    public static void closeQuietly(AutoCloseable... resources) {
        if (resources == null) return;
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}
