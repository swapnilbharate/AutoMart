package com.automart.dao;

import com.automart.model.Car;
import com.automart.util.DBConnection;

import java.sql.*;
import java.util.List;

public class WishlistDAO {
    public boolean add(int userId, int carId) throws SQLException {
        String sql = "INSERT IGNORE INTO Wishlist (user_id, car_id) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, carId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean remove(int userId, int carId) throws SQLException {
        String sql = "DELETE FROM Wishlist WHERE user_id=? AND car_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, carId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean exists(int userId, int carId) throws SQLException {
        String sql = "SELECT wishlist_id FROM Wishlist WHERE user_id=? AND car_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, carId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Car> findByUser(int userId) throws SQLException {
        CarDAO carDAO = new CarDAO();
        return carDAO.findAll(null, null, null, null, null, null, null, null).stream()
                .filter(car -> {
                    try {
                        return exists(userId, car.getCarId());
                    } catch (SQLException ex) {
                        return false;
                    }
                }).collect(java.util.stream.Collectors.toList());
    }
}
