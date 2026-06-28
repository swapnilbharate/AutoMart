package com.automart.dao;

import com.automart.model.ContactRequest;
import com.automart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactRequestDAO {

    // ─────────────────────────────────────────────
    // INSERT a new contact request
    // ─────────────────────────────────────────────
    public boolean create(ContactRequest request) throws SQLException {
        String sql = "INSERT INTO ContactRequests (car_id, user_id, name, email, phone, message) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, request.getCarId());

            // user_id is optional (guest users won't have one)
            if (request.getUserId() != null) {
                ps.setInt(2, request.getUserId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setString(3, request.getName());
            ps.setString(4, request.getEmail());
            ps.setString(5, request.getPhone());
            ps.setString(6, request.getMessage());

            return ps.executeUpdate() > 0;
        }
    }

    // ─────────────────────────────────────────────
    // GET ALL requests (Admin view)
    // ─────────────────────────────────────────────
    public List<ContactRequest> findAll() throws SQLException {
        List<ContactRequest> requests = new ArrayList<>();

        String sql = "SELECT cr.*, c.car_name "
                   + "FROM ContactRequests cr "
                   + "JOIN Cars c ON cr.car_id = c.car_id "
                   + "ORDER BY cr.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                requests.add(mapRow(rs));
            }
        }
        return requests;
    }

    // ─────────────────────────────────────────────
    // GET requests by logged-in user (Customer view)
    // ─────────────────────────────────────────────
    public List<ContactRequest> getRequestsByUserId(int userId) throws SQLException {
        List<ContactRequest> list = new ArrayList<>();

        String sql = "SELECT cr.*, c.car_name "
                   + "FROM ContactRequests cr "
                   + "JOIN Cars c ON cr.car_id = c.car_id "
                   + "WHERE cr.user_id = ? "
                   + "ORDER BY cr.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    // ─────────────────────────────────────────────
    // UPDATE status (Admin action)
    // ─────────────────────────────────────────────
    public boolean updateStatus(int requestId, String status) throws SQLException {
        String sql = "UPDATE ContactRequests SET status = ? WHERE request_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        }
    }

    // ─────────────────────────────────────────────
    // HELPER — map a ResultSet row to ContactRequest
    // ─────────────────────────────────────────────
    private ContactRequest mapRow(ResultSet rs) throws SQLException {
        ContactRequest cr = new ContactRequest();
        cr.setRequestId(rs.getInt("request_id"));
        cr.setCarId(rs.getInt("car_id"));

        // safely read nullable user_id
        int uid = rs.getInt("user_id");
        cr.setUserId(rs.wasNull() ? null : uid);

        cr.setCarName(rs.getString("car_name"));
        cr.setName(rs.getString("name"));
        cr.setEmail(rs.getString("email"));
        cr.setPhone(rs.getString("phone"));
        cr.setMessage(rs.getString("message"));
        cr.setStatus(rs.getString("status"));
        cr.setCreatedAt(rs.getString("created_at"));
        return cr;
    }
}