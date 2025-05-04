<?php
require_once "../config/database.php";
session_start();

// Simple authentication check
if (!isset($_SESSION['admin_logged_in']) || !$_SESSION['admin_logged_in']) {
    header('Location: login.php');
    exit();
}

// Fetch recent orders
$orders_query = "
    SELECT 
        o.order_id,
        o.item_description,
        o.quantity,
        o.order_status,
        d.status as delivery_status,
        s1.shop_name as origin_shop,
        s2.shop_name as destination_shop,
        dr.name as driver_name
    FROM `Order` o
    JOIN Delivery d ON o.delivery_id = d.delivery_id
    JOIN Shop s1 ON d.origin_shop_id = s1.shop_id
    JOIN Shop s2 ON d.destination_shop_id = s2.shop_id
    LEFT JOIN Driver dr ON d.assigned_driver = dr.driver_id
    ORDER BY o.order_id DESC
    LIMIT 10";

$orders_result = mysqli_query($conn, $orders_query);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSwift Admin - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #2c3e50;
            color: white;
        }
        
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
        }
        
        .sidebar .nav-link:hover {
            color: white;
        }
        
        .sidebar .nav-link.active {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .main-content {
            padding: 20px;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar p-3">
                <h4 class="mb-4">TrackSwift Admin</h4>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">
                            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="orders.php">
                            <i class="fas fa-shopping-cart me-2"></i> Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="deliveries.php">
                            <i class="fas fa-truck me-2"></i> Deliveries
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="drivers.php">
                            <i class="fas fa-user me-2"></i> Drivers
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="shops.php">
                            <i class="fas fa-store me-2"></i> Shops
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link text-danger" href="logout.php">
                            <i class="fas fa-sign-out-alt me-2"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Dashboard</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newOrderModal">
                        <i class="fas fa-plus me-2"></i> New Order
                    </button>
                </div>

                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <h5 class="card-title">Pending Orders</h5>
                                <h2 class="mb-0">12</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-white">
                            <div class="card-body">
                                <h5 class="card-title">In Transit</h5>
                                <h2 class="mb-0">8</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <h5 class="card-title">Delivered Today</h5>
                                <h2 class="mb-0">15</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-info text-white">
                            <div class="card-body">
                                <h5 class="card-title">Active Drivers</h5>
                                <h2 class="mb-0">6</h2>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Orders Table -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Recent Orders</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Items</th>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Driver</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php while ($order = mysqli_fetch_assoc($orders_result)): ?>
                                    <tr>
                                        <td>#<?php echo $order['order_id']; ?></td>
                                        <td><?php echo $order['item_description']; ?> (x<?php echo $order['quantity']; ?>)</td>
                                        <td><?php echo $order['origin_shop']; ?></td>
                                        <td><?php echo $order['destination_shop']; ?></td>
                                        <td><?php echo $order['driver_name'] ?: 'Not assigned'; ?></td>
                                        <td>
                                            <span class="status-badge bg-<?php echo getStatusClass($order['delivery_status']); ?>">
                                                <?php echo $order['delivery_status']; ?>
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" onclick="viewOrder(<?php echo $order['order_id']; ?>)">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" onclick="updateStatus(<?php echo $order['order_id']; ?>)">
                                                <i class="fas fa-sync-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <?php endwhile; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- New Order Modal -->
    <div class="modal fade" id="newOrderModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">New Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="newOrderForm">
                        <div class="mb-3">
                            <label class="form-label">Origin Shop</label>
                            <select class="form-select" name="origin_shop" required>
                                <option value="">Select Shop</option>
                                <!-- Add PHP to populate shops -->
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Destination Shop</label>
                            <select class="form-select" name="destination_shop" required>
                                <option value="">Select Shop</option>
                                <!-- Add PHP to populate shops -->
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Item Description</label>
                            <textarea class="form-control" name="item_description" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Quantity</label>
                            <input type="number" class="form-control" name="quantity" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitNewOrder()">Create Order</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function getStatusClass(status) {
            switch(status.toLowerCase()) {
                case 'pending':
                    return 'warning';
                case 'in transit':
                    return 'primary';
                case 'delivered':
                    return 'success';
                default:
                    return 'secondary';
            }
        }

        function viewOrder(orderId) {
            // Implement order view functionality
            window.location.href = `view_order.php?id=${orderId}`;
        }

        function updateStatus(orderId) {
            // Implement status update functionality
            window.location.href = `update_status.php?id=${orderId}`;
        }

        function submitNewOrder() {
            // Implement new order submission
            const formData = new FormData(document.getElementById('newOrderForm'));
            // Add AJAX submission logic
        }
    </script>
</body>
</html>

<?php
function getStatusClass($status) {
    switch(strtolower($status)) {
        case 'pending':
            return 'warning';
        case 'in transit':
            return 'primary';
        case 'delivered':
            return 'success';
        default:
            return 'secondary';
    }
}
?> 