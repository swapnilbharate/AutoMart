package com.automart.dao;

import com.automart.model.User;
import com.automart.util.DBConnection;
import com.automart.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public boolean register(User user) throws SQLException {
        String sql = "INSERT INTO Users (name, email, phone, password_hash, city, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, PasswordUtil.hash(user.getPasswordHash()));
            ps.setString(5, user.getCity());
            ps.setString(6, user.getRole());
            boolean created = ps.executeUpdate() > 0;
            if (created && "ADMIN".equalsIgnoreCase(user.getRole())) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        try (PreparedStatement admin = con.prepareStatement("INSERT INTO Admin (user_id) VALUES (?)")) {
                            admin.setInt(1, keys.getInt(1));
                            admin.executeUpdate();
                        }
                    }
                }
            }
            return created;
        }
    }

    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && PasswordUtil.verify(password, rs.getString("password_hash"))) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapUser(rs) : null;
            }
        }
    }

    public List<User> findAll() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }
        return users;
    }

    public boolean updateProfile(User user) throws SQLException {
        String sql = "UPDATE Users SET name=?, phone=?, city=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getCity());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean changePassword(int userId, String password) throws SQLException {
        String sql = "UPDATE Users SET password_hash=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hash(password));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET name=?, phone=?, city=?, role=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getCity());
            ps.setString(4, user.getRole());
            ps.setInt(5, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE user_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setCity(rs.getString("city"));
        user.setRole(rs.getString("role"));
        return user;
    }
}
