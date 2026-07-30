package com.automart.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/automart_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
    private static final String PASSWORD = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "root";

    private static HikariDataSource dataSource;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(URL);
            config.setUsername(USER);
            config.setPassword(PASSWORD);
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000);
            config.setConnectionTimeout(10000);
            config.setMaxLifetime(1800000);
            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}