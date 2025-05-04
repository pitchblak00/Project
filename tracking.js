$(document).ready(function() {
    $('#trackForm').on('submit', function(e) {
        e.preventDefault();
        const orderId = $('#orderInput').val().trim();
        
        if (!orderId) {
            showError('Please enter an order ID');
            return;
        }
        
        // Show loading state
        $('#trackingResult').html('<div class="text-center"><div class="spinner-border text-primary" role="status"></div></div>');
        
        // Fetch tracking information
        $.get('track.php', { order_id: orderId })
            .done(function(response) {
                if (response.success) {
                    displayTrackingInfo(response.order);
                } else {
                    showError(response.message || 'Failed to fetch tracking information');
                }
            })
            .fail(function() {
                showError('An error occurred while fetching tracking information');
            });
    });
    
    function displayTrackingInfo(order) {
        const statusClass = getStatusClass(order.delivery.status);
        const driverInfo = order.delivery.driver.name ? 
            `<p><strong>Driver:</strong> ${order.delivery.driver.name} (${order.delivery.driver.contact})</p>` : 
            '<p><strong>Driver:</strong> Not yet assigned</p>';
            
        let html = `
            <div class="card tracking-card mb-4">
                <div class="card-body">
                    <h3 class="card-title">Order #${order.order_id}</h3>
                    <div class="status-badge ${statusClass} mb-3">${order.delivery.status}</div>
                    
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5>Order Details</h5>
                            <p><strong>Items:</strong> ${order.item_description}</p>
                            <p><strong>Quantity:</strong> ${order.quantity}</p>
                            <p><strong>Status:</strong> ${order.order_status}</p>
                        </div>
                        <div class="col-md-6">
                            <h5>Delivery Details</h5>
                            <p><strong>From:</strong> ${order.delivery.origin_shop}</p>
                            <p><strong>To:</strong> ${order.delivery.destination_shop}</p>
                            ${driverInfo}
                        </div>
                    </div>
                    
                    <h5>Tracking Timeline</h5>
                    <div class="timeline">
                        ${generateTimeline(order.tracking_updates)}
                    </div>
                </div>
            </div>
        `;
        
        $('#trackingResult').html(html);
    }
    
    function generateTimeline(updates) {
        if (!updates.length) {
            return '<p>No tracking updates available</p>';
        }
        
        return updates.map(update => `
            <div class="timeline-item mb-3">
                <div class="timeline-date">${formatDate(update.timestamp)}</div>
                <div class="timeline-content">
                    <h6>${update.status_update}</h6>
                    <p class="text-muted">${update.location}</p>
                </div>
            </div>
        `).join('');
    }
    
    function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleString();
    }
    
    function getStatusClass(status) {
        switch(status.toLowerCase()) {
            case 'pending':
                return 'status-pending';
            case 'in transit':
                return 'status-in-transit';
            case 'delivered':
                return 'status-delivered';
            default:
                return '';
        }
    }
    
    function showError(message) {
        $('#trackingResult').html(`
            <div class="alert alert-danger" role="alert">
                ${message}
            </div>
        `);
    }
}); 