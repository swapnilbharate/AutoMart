package com.automart.dao;

import com.automart.model.Brand;
import com.automart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO {
    public List<Brand> findAll() throws SQLException {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT * FROM Brands ORDER BY brand_name";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                brands.add(new Brand(rs.getInt("brand_id"), rs.getString("brand_name")));
            }
        }
        return brands;
    }
}
