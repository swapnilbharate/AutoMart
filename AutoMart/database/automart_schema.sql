CREATE DATABASE IF NOT EXISTS automart_db;
USE automart_db;

CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    city VARCHAR(80) NOT NULL,
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Admin (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    permissions VARCHAR(255) DEFAULT 'FULL_ACCESS',
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    car_name VARCHAR(120) NOT NULL,
    model VARCHAR(80) NOT NULL,
    manufacturing_year INT NOT NULL,
    fuel_type ENUM('Petrol', 'Diesel', 'CNG', 'Electric', 'Hybrid') NOT NULL,
    transmission_type ENUM('Manual', 'Automatic') NOT NULL,
    mileage DECIMAL(10,2) NOT NULL,
    color VARCHAR(50) NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    city VARCHAR(80) NOT NULL,
    seller_name VARCHAR(100) NOT NULL,
    seller_phone VARCHAR(20) NOT NULL,
    seller_email VARCHAR(120) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('AVAILABLE', 'SOLD') NOT NULL DEFAULT 'AVAILABLE',
    featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES Brands(brand_id)
);

CREATE TABLE IF NOT EXISTS VehicleImages (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    car_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_car (user_id, car_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ContactRequests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    car_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('NEW', 'CONTACTED', 'CLOSED') NOT NULL DEFAULT 'NEW',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE CASCADE
);

INSERT IGNORE INTO Brands (brand_name) VALUES
('Maruti Suzuki'), ('Hyundai'), ('Honda'), ('Toyota'), ('Mahindra'), ('Tata'), ('Kia'), ('Ford'), ('Volkswagen'), ('Renault');

INSERT IGNORE INTO Users (user_id, name, email, phone, password_hash, city, role) VALUES
(1, 'AutoMart Admin', 'admin@automart.com', '9999999999', '0192023a7bbd73250516f069df18b500', 'Mumbai', 'ADMIN');

INSERT IGNORE INTO Admin (user_id) VALUES (1);

INSERT IGNORE INTO Cars
(car_id, brand_id, car_name, model, manufacturing_year, fuel_type, transmission_type, mileage, color, price, city, seller_name, seller_phone, seller_email, description, status, featured)
VALUES
(1, 2, 'Hyundai Creta SX', 'Creta SX', 2021, 'Petrol', 'Manual', 26500, 'White', 1125000, 'Pune', 'Rahul Motors', '9876543210', 'sales@rahulmotors.in', 'Single-owner SUV with complete service history, clean interior, insurance active, and excellent city/highway performance.', 'AVAILABLE', TRUE),
(2, 1, 'Maruti Suzuki Baleno Zeta', 'Baleno Zeta', 2020, 'Petrol', 'Manual', 31400, 'Blue', 625000, 'Mumbai', 'Prime Cars', '9876501234', 'contact@primecars.in', 'Well-maintained hatchback with new tyres, company service record, and smooth engine response.', 'AVAILABLE', TRUE),
(3, 4, 'Toyota Innova Crysta VX', 'Innova Crysta VX', 2019, 'Diesel', 'Manual', 58400, 'Silver', 1780000, 'Delhi', 'North Auto Hub', '9811112233', 'hello@northautohub.in', 'Spacious family MPV with seven seats, strong diesel engine, and verified ownership documents.', 'AVAILABLE', FALSE),
(4, 6, 'Tata Nexon XZ Plus', 'Nexon XZ+', 2022, 'Petrol', 'Automatic', 18200, 'Red', 975000, 'Bengaluru', 'Urban Wheels', '9988776655', 'dealer@urbanwheels.in', 'Compact SUV with automatic transmission, touchscreen infotainment, rear camera, and excellent safety rating.', 'SOLD', FALSE);

INSERT IGNORE INTO VehicleImages (car_id, image_path, is_primary) VALUES
(1, 'assets/uploads/creta.svg', TRUE),
(2, 'assets/uploads/baleno.svg', TRUE),
(3, 'assets/uploads/innova.svg', TRUE),
(4, 'assets/uploads/nexon.svg', TRUE);
