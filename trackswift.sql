-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 04, 2025 at 12:58 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `trackswift`
--

-- --------------------------------------------------------

--
-- Table structure for table `delivery`
--

CREATE TABLE `delivery` (
  `delivery_id` int(11) NOT NULL,
  `origin_shop_id` int(11) NOT NULL,
  `destination_shop_id` int(11) NOT NULL,
  `status` enum('Pending','In Transit','Delivered') NOT NULL DEFAULT 'Pending',
  `dispatch_date` datetime DEFAULT NULL,
  `arrival_date` datetime DEFAULT NULL,
  `assigned_driver` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `delivery_agents`
--

CREATE TABLE `delivery_agents` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `vehicle_number` varchar(20) DEFAULT NULL,
  `status` enum('available','busy','offline') NOT NULL DEFAULT 'available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `delivery_agents`
--

INSERT INTO `delivery_agents` (`id`, `name`, `email`, `phone`, `vehicle_number`, `status`, `created_at`) VALUES
(1, 'richard', 'richard@gmail.com', '09815501477', 'LNA102', 'available', '2025-05-04 10:53:04');

-- --------------------------------------------------------

--
-- Table structure for table `delivery_updates`
--

CREATE TABLE `delivery_updates` (
  `id` int(11) NOT NULL,
  `order_id` varchar(50) NOT NULL,
  `location` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `update_time` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `delivery_updates`
--

INSERT INTO `delivery_updates` (`id`, `order_id`, `location`, `description`, `update_time`, `created_at`) VALUES
(1, '23123', 'linao', 'chill lng sir', '2025-05-04 18:52:16', '2025-05-04 10:52:16'),
(2, '23123', 'linao', 'success', '2025-05-04 18:52:34', '2025-05-04 10:52:34'),
(3, '23123', 'linao', 'sws', '2025-05-04 18:53:41', '2025-05-04 10:53:41'),
(4, '23123', 'linao', 'sws', '2025-05-04 18:53:46', '2025-05-04 10:53:46');

-- --------------------------------------------------------

--
-- Table structure for table `driver`
--

CREATE TABLE `driver` (
  `driver_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `vehicle_info` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `order_id` int(11) NOT NULL,
  `delivery_id` int(11) NOT NULL,
  `item_description` text NOT NULL,
  `quantity` int(11) NOT NULL,
  `order_status` enum('Packed','In Transit','Delivered') NOT NULL DEFAULT 'Packed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `order_id` varchar(50) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_email` varchar(100) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `order_date` datetime NOT NULL,
  `status` enum('pending','processing','shipped','delivered') NOT NULL DEFAULT 'pending',
  `estimated_delivery` date DEFAULT NULL,
  `shipping_address` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_id`, `customer_name`, `customer_email`, `customer_phone`, `order_date`, `status`, `estimated_delivery`, `shipping_address`, `created_at`, `updated_at`) VALUES
(1, '23123', 'ariel', 'ariel@gmail.com', '090912761', '2025-05-04 18:50:55', 'processing', NULL, 'Linao', '2025-05-04 10:50:55', '2025-05-04 10:53:41');

-- --------------------------------------------------------

--
-- Table structure for table `order_assignments`
--

CREATE TABLE `order_assignments` (
  `id` int(11) NOT NULL,
  `order_id` varchar(50) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `assigned_at` datetime NOT NULL,
  `completed_at` datetime DEFAULT NULL,
  `status` enum('assigned','in_progress','completed') NOT NULL DEFAULT 'assigned',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

CREATE TABLE `shop` (
  `shop_id` int(11) NOT NULL,
  `shop_name` varchar(100) NOT NULL,
  `location` varchar(255) NOT NULL,
  `contact_info` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trackingupdate`
--

CREATE TABLE `trackingupdate` (
  `update_id` int(11) NOT NULL,
  `delivery_id` int(11) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `location` varchar(255) NOT NULL,
  `status_update` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`delivery_id`),
  ADD KEY `origin_shop_id` (`origin_shop_id`),
  ADD KEY `destination_shop_id` (`destination_shop_id`),
  ADD KEY `assigned_driver` (`assigned_driver`);

--
-- Indexes for table `delivery_agents`
--
ALTER TABLE `delivery_agents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `delivery_updates`
--
ALTER TABLE `delivery_updates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `driver`
--
ALTER TABLE `driver`
  ADD PRIMARY KEY (`driver_id`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `delivery_id` (`delivery_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_id` (`order_id`);

--
-- Indexes for table `order_assignments`
--
ALTER TABLE `order_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `agent_id` (`agent_id`);

--
-- Indexes for table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`shop_id`);

--
-- Indexes for table `trackingupdate`
--
ALTER TABLE `trackingupdate`
  ADD PRIMARY KEY (`update_id`),
  ADD KEY `delivery_id` (`delivery_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `delivery`
--
ALTER TABLE `delivery`
  MODIFY `delivery_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `delivery_agents`
--
ALTER TABLE `delivery_agents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `delivery_updates`
--
ALTER TABLE `delivery_updates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `driver`
--
ALTER TABLE `driver`
  MODIFY `driver_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_assignments`
--
ALTER TABLE `order_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shop`
--
ALTER TABLE `shop`
  MODIFY `shop_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trackingupdate`
--
ALTER TABLE `trackingupdate`
  MODIFY `update_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `delivery`
--
ALTER TABLE `delivery`
  ADD CONSTRAINT `delivery_ibfk_1` FOREIGN KEY (`origin_shop_id`) REFERENCES `shop` (`shop_id`),
  ADD CONSTRAINT `delivery_ibfk_2` FOREIGN KEY (`destination_shop_id`) REFERENCES `shop` (`shop_id`),
  ADD CONSTRAINT `delivery_ibfk_3` FOREIGN KEY (`assigned_driver`) REFERENCES `driver` (`driver_id`);

--
-- Constraints for table `delivery_updates`
--
ALTER TABLE `delivery_updates`
  ADD CONSTRAINT `delivery_updates_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`delivery_id`) REFERENCES `delivery` (`delivery_id`);

--
-- Constraints for table `order_assignments`
--
ALTER TABLE `order_assignments`
  ADD CONSTRAINT `order_assignments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_assignments_ibfk_2` FOREIGN KEY (`agent_id`) REFERENCES `delivery_agents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `trackingupdate`
--
ALTER TABLE `trackingupdate`
  ADD CONSTRAINT `trackingupdate_ibfk_1` FOREIGN KEY (`delivery_id`) REFERENCES `delivery` (`delivery_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
