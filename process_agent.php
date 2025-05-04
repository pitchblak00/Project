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
    $name = mysqli_real_escape_string($conn, $_POST['name']);
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $phone = mysqli_real_escape_string($conn, $_POST['phone']);
    $vehicleNumber = mysqli_real_escape_string($conn, $_POST['vehicle_number']);
    $status = mysqli_real_escape_string($conn, $_POST['status']);
    
    // Insert new delivery agent
    $insertQuery = "INSERT INTO delivery_agents (name, email, phone, vehicle_number, status, created_at) 
                    VALUES ('$name', '$email', '$phone', '$vehicleNumber', '$status', NOW())";
    
    if (mysqli_query($conn, $insertQuery)) {
        header('Location: admin_agents.php?success=1');
    } else {
        header('Location: admin_agents.php?error=1');
    }
    exit();
}

// If not a POST request, redirect to agents page
header('Location: admin_agents.php');
exit(); 