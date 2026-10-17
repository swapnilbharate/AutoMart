package com.automart.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.net.URI;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/automart_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "root";

    private static volatile HikariDataSource dataSource = null;
    private static volatile Throwable lastInitError = null;

    static {
        // Attempt eager initialization on class load, but failures will not be fatal
        try {
            initDataSource();
        } catch (Throwable t) {
            // Logged inside initDataSource
        }
    }

    private DBConnection() {
    }

    private static String getEnvUrl() {
        String url = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = System.getenv("DATABASE_URL");
        }
        if (url == null || url.trim().isEmpty()) {
            url = System.getenv("MYSQL_URL");
        }
        return (url != null && !url.trim().isEmpty()) ? url.trim() : null;
    }

    private static synchronized void initDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            return;
        }

        String rawUrl = getEnvUrl();
        String user = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");
        String jdbcUrl;

        try {
            if (rawUrl != null) {
                if (rawUrl.startsWith("mysql://")) {
                    URI uri = new URI(rawUrl);
                    String host = uri.getHost();
                    int port = uri.getPort() > 0 ? uri.getPort() : 3306;
                    String path = uri.getPath() != null ? uri.getPath() : "/defaultdb";
                    String query = uri.getQuery();

                    if ((user == null || user.trim().isEmpty()) && uri.getUserInfo() != null) {
                        String[] creds = uri.getUserInfo().split(":", 2);
                        user = creds[0];
                        if (creds.length > 1 && (password == null || password.trim().isEmpty())) {
                            password = creds[1];
                        }
                    }

                    jdbcUrl = "jdbc:mysql://" + host + ":" + port + path;
                    if (query != null && !query.trim().isEmpty()) {
                        jdbcUrl += "?" + query;
                    }
                } else if (rawUrl.startsWith("jdbc:mysql://")) {
                    jdbcUrl = rawUrl;
                } else {
                    jdbcUrl = "jdbc:mysql://" + rawUrl;
                }
            } else {
                jdbcUrl = DEFAULT_URL;
            }

            if (user == null || user.trim().isEmpty()) {
                user = DEFAULT_USER;
            }
            if (password == null) {
                password = DEFAULT_PASSWORD;
            }

            System.out.println("[AutoMart DB] Initializing connection pool to: " + maskUrl(jdbcUrl) + " (user: " + user + ")");

            Class.forName("com.mysql.cj.jdbc.Driver");
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(user);
            config.setPassword(password);
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(1);
            config.setIdleTimeout(60000);
            config.setConnectionTimeout(30000);
            config.setMaxLifetime(1800000);
            config.setInitializationFailTimeout(15000);

            dataSource = new HikariDataSource(config);
            lastInitError = null;
            System.out.println("[AutoMart DB] Connection pool successfully initialized!");
        } catch (Throwable t) {
            lastInitError = t;
            dataSource = null;
            System.err.println("[AutoMart DB] Failed to initialize connection pool: " + t.getMessage());
            t.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null || dataSource.isClosed()) {
            initDataSource();
        }

        if (dataSource == null) {
            String rawUrl = getEnvUrl();
            String target = (rawUrl != null) ? maskUrl(rawUrl) : "default (localhost:3306)";
            String reason = (lastInitError != null) ? lastInitError.getMessage() : "Check environment variables and network reachability.";
            throw new SQLException("AutoMart Database Connection Failed! Target: " + target + ". Reason: " + reason, lastInitError);
        }

        return dataSource.getConnection();
    }

    private static String maskUrl(String url) {
        if (url == null) return "null";
        return url.replaceAll("(?<=://)[^:@]+:[^@]+(?=@)", "***:***");
    }
}