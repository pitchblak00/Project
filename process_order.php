<?php
require_once "database.php";
session_start();

// Check if admin is logged in
if (!isset($_SESSION['admin_logged_in'])) {
    header('Location: login.php');
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Sanitize input
    $orderId = mysqli_real_escape_string($conn, $_POST['order_id']);
    $customerName = mysqli_real_escape_string($conn, $_POST['customer_name']);
    $customerEmail = mysqli_real_escape_string($conn, $_POST['customer_email']);
    $customerPhone = mysqli_real_escape_string($conn, $_POST['customer_phone']);
    $shippingAddress = mysqli_real_escape_string($conn, $_POST['shipping_address']);
    
    // Insert new order
    $insertQuery = "INSERT INTO orders (order_id, customer_name, customer_email, customer_phone, 
                    shipping_address, status, order_date) 
                    VALUES ('$orderId', '$customerName', '$customerEmail', '$customerPhone', 
                    '$shippingAddress', 'pending', NOW())";
    
    if (mysqli_query($conn, $insertQuery)) {
        header('Location: admin_orders.php?success=1');
    } else {
        header('Location: admin_orders.php?error=1');
    }
    exit();
}

// If not a POST request, redirect to orders page
header('Location: admin_orders.php');
exit(); 