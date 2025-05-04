-- Create database
CREATE DATABASE IF NOT EXISTS trackswift;
USE trackswift;

-- Create Shop table
CREATE TABLE IF NOT EXISTS Shop (
    shop_id INT AUTO_INCREMENT PRIMARY KEY,
    shop_name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    contact_info VARCHAR(100) NOT NULL
);

-- Create Driver table
CREATE TABLE IF NOT EXISTS Driver (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    vehicle_info VARCHAR(255) NOT NULL
);

-- Create Delivery table
CREATE TABLE IF NOT EXISTS Delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    origin_shop_id INT NOT NULL,
    destination_shop_id INT NOT NULL,
    status ENUM('Pending', 'In Transit', 'Delivered') NOT NULL DEFAULT 'Pending',
    dispatch_date DATETIME,
    arrival_date DATETIME,
    assigned_driver INT,
    FOREIGN KEY (origin_shop_id) REFERENCES Shop(shop_id),
    FOREIGN KEY (destination_shop_id) REFERENCES Shop(shop_id),
    FOREIGN KEY (assigned_driver) REFERENCES Driver(driver_id)
);

-- Create Order table
CREATE TABLE IF NOT EXISTS `Order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    delivery_id INT NOT NULL,
    item_description TEXT NOT NULL,
    quantity INT NOT NULL,
    order_status ENUM('Packed', 'In Transit', 'Delivered') NOT NULL DEFAULT 'Packed',
    FOREIGN KEY (delivery_id) REFERENCES Delivery(delivery_id)
);

-- Create TrackingUpdate table
CREATE TABLE IF NOT EXISTS TrackingUpdate (
    update_id INT AUTO_INCREMENT PRIMARY KEY,
    delivery_id INT NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(255) NOT NULL,
    status_update TEXT NOT NULL,
    FOREIGN KEY (delivery_id) REFERENCES Delivery(delivery_id)
); 