<?php
require_once "config/database.php";

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['order_id'])) {
    $order_id = mysqli_real_escape_string($conn, $_GET['order_id']);
    
    // Query to get order details with tracking information
    $query = "
        SELECT 
            o.order_id,
            o.item_description,
            o.quantity,
            o.order_status,
            d.delivery_id,
            d.status as delivery_status,
            d.dispatch_date,
            d.arrival_date,
            s1.shop_name as origin_shop,
            s2.shop_name as destination_shop,
            dr.name as driver_name,
            dr.contact_number as driver_contact
        FROM `Order` o
        JOIN Delivery d ON o.delivery_id = d.delivery_id
        JOIN Shop s1 ON d.origin_shop_id = s1.shop_id
        JOIN Shop s2 ON d.destination_shop_id = s2.shop_id
        LEFT JOIN Driver dr ON d.assigned_driver = dr.driver_id
        WHERE o.order_id = ?";
    
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "i", $order_id);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    if ($row = mysqli_fetch_assoc($result)) {
        // Get tracking updates
        $tracking_query = "
            SELECT 
                timestamp,
                location,
                status_update
            FROM TrackingUpdate
            WHERE delivery_id = ?
            ORDER BY timestamp DESC";
        
        $tracking_stmt = mysqli_prepare($conn, $tracking_query);
        mysqli_stmt_bind_param($tracking_stmt, "i", $row['delivery_id']);
        mysqli_stmt_execute($tracking_stmt);
        $tracking_result = mysqli_stmt_get_result($tracking_stmt);
        
        $tracking_updates = [];
        while ($update = mysqli_fetch_assoc($tracking_result)) {
            $tracking_updates[] = $update;
        }
        
        $response = [
            'success' => true,
            'order' => [
                'order_id' => $row['order_id'],
                'item_description' => $row['item_description'],
                'quantity' => $row['quantity'],
                'order_status' => $row['order_status'],
                'delivery' => [
                    'status' => $row['delivery_status'],
                    'dispatch_date' => $row['dispatch_date'],
                    'arrival_date' => $row['arrival_date'],
                    'origin_shop' => $row['origin_shop'],
                    'destination_shop' => $row['destination_shop'],
                    'driver' => [
                        'name' => $row['driver_name'],
                        'contact' => $row['driver_contact']
                    ]
                ],
                'tracking_updates' => $tracking_updates
            ]
        ];
    } else {
        $response = [
            'success' => false,
            'message' => 'Order not found'
        ];
    }
    
    echo json_encode($response);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request'
    ]);
}
?> 