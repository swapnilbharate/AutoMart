package com.automart.dao;

import com.automart.model.DashboardStats;
import com.automart.util.DBConnection;

import java.sql.*;
import java.util.Map;

public class DashboardDAO {
    public DashboardStats getStats() throws SQLException {
        DashboardStats stats = new DashboardStats();
        try (Connection con = DBConnection.getConnection()) {
            stats.setTotalUsers(count(con, "SELECT COUNT(*) FROM Users WHERE role='USER'"));
            stats.setTotalCars(count(con, "SELECT COUNT(*) FROM Cars"));
            stats.setAvailableCars(count(con, "SELECT COUNT(*) FROM Cars WHERE status='AVAILABLE'"));
            stats.setSoldCars(count(con, "SELECT COUNT(*) FROM Cars WHERE status='SOLD'"));
            stats.setWishlistEntries(count(con, "SELECT COUNT(*) FROM Wishlist"));
            fillMap(con, "SELECT b.brand_name, COUNT(*) total FROM Cars c JOIN Brands b ON c.brand_id=b.brand_id GROUP BY b.brand_name", stats.getListingsByBrand());
            fillMap(con, "SELECT CASE WHEN price < 500000 THEN 'Under 5L' WHEN price < 1000000 THEN '5L-10L' WHEN price < 2000000 THEN '10L-20L' ELSE '20L+' END label, COUNT(*) total FROM Cars GROUP BY label", stats.getPriceRanges());
            fillMap(con, "SELECT DATE(created_at) label, COUNT(*) total FROM Users GROUP BY DATE(created_at) ORDER BY label DESC LIMIT 7", stats.getUserActivity());
        }
        return stats;
    }

    private int count(Connection con, String sql) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private void fillMap(Connection con, String sql, Map<String, Integer> target) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                target.put(rs.getString(1), rs.getInt(2));
            }
        }
    }
}
