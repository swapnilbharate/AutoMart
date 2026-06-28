package com.automart.dao;

import com.automart.model.Car;
import com.automart.model.VehicleImage;
import com.automart.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {
    private static final String BASE_SELECT =
            "SELECT c.*, b.brand_name, COALESCE((SELECT image_path FROM VehicleImages vi WHERE vi.car_id=c.car_id ORDER BY vi.is_primary DESC, vi.image_id ASC LIMIT 1), 'assets/uploads/default-car.svg') AS primary_image " +
            "FROM Cars c JOIN Brands b ON c.brand_id=b.brand_id";

    public List<Car> findAll(String keyword, String brandId, String fuelType, String transmissionType,
                             String minPrice, String maxPrice, String year, String city) throws SQLException {
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT).append(" WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.car_name LIKE ? OR c.model LIKE ? OR b.brand_name LIKE ? OR c.description LIKE ?)");
            String like = "%" + keyword.trim() + "%";
            params.add(like); params.add(like); params.add(like); params.add(like);
        }
        if (brandId != null && !brandId.isEmpty()) { sql.append(" AND c.brand_id=?"); params.add(Integer.parseInt(brandId)); }
        if (fuelType != null && !fuelType.isEmpty()) { sql.append(" AND c.fuel_type=?"); params.add(fuelType); }
        if (transmissionType != null && !transmissionType.isEmpty()) { sql.append(" AND c.transmission_type=?"); params.add(transmissionType); }
        if (minPrice != null && !minPrice.isEmpty()) { sql.append(" AND c.price>=?"); params.add(new BigDecimal(minPrice)); }
        if (maxPrice != null && !maxPrice.isEmpty()) { sql.append(" AND c.price<=?"); params.add(new BigDecimal(maxPrice)); }
        if (year != null && !year.isEmpty()) { sql.append(" AND c.manufacturing_year>=?"); params.add(Integer.parseInt(year)); }
        if (city != null && !city.trim().isEmpty()) { sql.append(" AND c.city LIKE ?"); params.add("%" + city.trim() + "%"); }
        sql.append(" ORDER BY c.featured DESC, c.created_at DESC");
        return queryCars(sql.toString(), params);
    }

    // ✅ Fixed: 'available' lowercase matches DB data
    public List<Car> featured(int limit) throws SQLException {
        return queryCars(BASE_SELECT + " WHERE c.featured=TRUE AND c.status='available' ORDER BY c.created_at DESC LIMIT ?", asList(limit));
    }

    public List<Car> latest(int limit) throws SQLException {
        return queryCars(BASE_SELECT + " ORDER BY c.created_at DESC LIMIT ?", asList(limit));
    }

    // ✅ New: returns total car count for home page
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Cars";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<Car> recommended(int carId, int brandId, String city) throws SQLException {
        return queryCars(BASE_SELECT + " WHERE c.car_id<>? AND (c.brand_id=? OR c.city=?) AND c.status='available' ORDER BY c.created_at DESC LIMIT 3", asList(carId, brandId, city));
    }

    public Car findById(int carId) throws SQLException {
        List<Car> cars = queryCars(BASE_SELECT + " WHERE c.car_id=?", asList(carId));
        if (cars.isEmpty()) return null;
        Car car = cars.get(0);
        car.setImages(findImages(carId));
        return car;
    }

    public int create(Car car) throws SQLException {
        String sql = "INSERT INTO Cars (brand_id, car_name, model, manufacturing_year, fuel_type, transmission_type, mileage, color, price, city, seller_name, seller_phone, seller_email, description, status, featured) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            fillCarStatement(ps, car);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public boolean update(Car car) throws SQLException {
        String sql = "UPDATE Cars SET brand_id=?, car_name=?, model=?, manufacturing_year=?, fuel_type=?, transmission_type=?, mileage=?, color=?, price=?, city=?, seller_name=?, seller_phone=?, seller_email=?, description=?, status=?, featured=? WHERE car_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            fillCarStatement(ps, car);
            ps.setInt(17, car.getCarId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int carId) throws SQLException {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement("DELETE FROM Cars WHERE car_id=?")) {
            ps.setInt(1, carId);
            return ps.executeUpdate() > 0;
        }
    }

    public void addImage(int carId, String imagePath, boolean primary) throws SQLException {
        String sql = "INSERT INTO VehicleImages (car_id, image_path, is_primary) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, carId);
            ps.setString(2, imagePath);
            ps.setBoolean(3, primary);
            ps.executeUpdate();
        }
    }

    private List<VehicleImage> findImages(int carId) throws SQLException {
        List<VehicleImage> images = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM VehicleImages WHERE car_id=? ORDER BY is_primary DESC, image_id")) {
            ps.setInt(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VehicleImage image = new VehicleImage();
                    image.setImageId(rs.getInt("image_id"));
                    image.setCarId(rs.getInt("car_id"));
                    image.setImagePath(rs.getString("image_path"));
                    image.setPrimary(rs.getBoolean("is_primary"));
                    images.add(image);
                }
            }
        }
        return images;
    }

    private List<Car> queryCars(String sql, List<Object> params) throws SQLException {
        List<Car> cars = new ArrayList<>();
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapCar(rs));
                }
            }
        }
        return cars;
    }

    private List<Object> asList(Object... values) {
        List<Object> list = new ArrayList<>();
        for (Object v : values) list.add(v);
        return list;
    }

    private void fillCarStatement(PreparedStatement ps, Car car) throws SQLException {
        ps.setInt(1, car.getBrandId());
        ps.setString(2, car.getCarName());
        ps.setString(3, car.getModel());
        ps.setInt(4, car.getManufacturingYear());
        ps.setString(5, car.getFuelType());
        ps.setString(6, car.getTransmissionType());
        ps.setDouble(7, car.getMileage());
        ps.setString(8, car.getColor());
        ps.setBigDecimal(9, car.getPrice());
        ps.setString(10, car.getCity());
        ps.setString(11, car.getSellerName());
        ps.setString(12, car.getSellerPhone());
        ps.setString(13, car.getSellerEmail());
        ps.setString(14, car.getDescription());
        ps.setString(15, car.getStatus());
        ps.setBoolean(16, car.isFeatured());
    }

    private Car mapCar(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setCarId(rs.getInt("car_id"));
        car.setBrandId(rs.getInt("brand_id"));
        car.setBrandName(rs.getString("brand_name"));
        car.setCarName(rs.getString("car_name"));
        car.setModel(rs.getString("model"));
        car.setManufacturingYear(rs.getInt("manufacturing_year"));
        car.setFuelType(rs.getString("fuel_type"));
        car.setTransmissionType(rs.getString("transmission_type"));
        car.setMileage(rs.getDouble("mileage"));
        car.setColor(rs.getString("color"));
        car.setPrice(rs.getBigDecimal("price"));
        car.setCity(rs.getString("city"));
        car.setSellerName(rs.getString("seller_name"));
        car.setSellerPhone(rs.getString("seller_phone"));
        car.setSellerEmail(rs.getString("seller_email"));
        car.setDescription(rs.getString("description"));
        car.setStatus(rs.getString("status"));
        car.setFeatured(rs.getBoolean("featured"));
        car.setPrimaryImage(rs.getString("primary_image"));
        return car;
    }
}