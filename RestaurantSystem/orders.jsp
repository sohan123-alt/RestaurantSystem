<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Delicious Bites</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
        }
        
        .page-title {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
            text-align: center;
        }
        
        .page-title h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
        }
        
        .orders-container {
            margin-bottom: 50px;
        }
        
        .order-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .order-id {
            font-size: 1.2rem;
            font-weight: 700;
            color: #333;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-preparing {
            background: #cfe2ff;
            color: #084298;
        }
        
        .status-delivered {
            background: #d1e7dd;
            color: #0f5132;
        }
        
        .order-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .detail-item i {
            color: #667eea;
            font-size: 1.2rem;
        }
        
        .detail-label {
            font-weight: 600;
            color: #666;
            font-size: 0.9rem;
        }
        
        .detail-value {
            color: #333;
            font-weight: 500;
        }
        
        .amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: #f5576c;
        }
        
        .no-orders {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .no-orders i {
            font-size: 5rem;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="page-title">
        <h1><i class="fas fa-receipt"></i> My Orders</h1>
        <p style="margin-top: 10px;">Track Your Order Status</p>
    </div>
    
    <div class="container">
        <div class="orders-container">
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    con = getConnection();
                    String query = "SELECT * FROM orders WHERE user_email = ? ORDER BY order_date DESC";
                    ps = con.prepareStatement(query);
                    ps.setString(1, userEmail);
                    rs = ps.executeQuery();
                    
                    if(!rs.isBeforeFirst()) {
            %>
                        <div class="no-orders">
                            <i class="fas fa-receipt"></i>
                            <h3>No orders yet!</h3>
                            <p>Start ordering delicious food from our menu</p>
                            <a href="menu.jsp" class="btn btn-primary mt-3">
                                <i class="fas fa-book-open"></i> Browse Menu
                            </a>
                        </div>
            <%
                    } else {
                        while(rs.next()) {
                            int orderId = rs.getInt("order_id");
                            double totalAmount = rs.getDouble("total_amount");
                            String orderDate = rs.getString("order_date");
                            String status = rs.getString("status");
                            
                            String statusClass = "";
                            if(status.equals("Pending")) statusClass = "status-pending";
                            else if(status.equals("Preparing")) statusClass = "status-preparing";
                            else if(status.equals("Delivered")) statusClass = "status-delivered";
            %>
                        <div class="order-card">
                            <div class="order-header">
                                <div class="order-id">
                                    <i class="fas fa-hashtag"></i> Order ID: <%= orderId %>
                                </div>
                                <span class="status-badge <%= statusClass %>">
                                    <%= status %>
                                </span>
                            </div>
                            
                            <div class="order-details">
                                <div class="detail-item">
                                    <i class="fas fa-calendar-alt"></i>
                                    <div>
                                        <div class="detail-label">Order Date</div>
                                        <div class="detail-value"><%= orderDate %></div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
    <div style="font-size: 1.5rem; color: #f5576c; margin-right: 15px; font-weight: bold;">BDT</div>
    <div>
        <div class="detail-label">Total Amount</div>
        <div class="amount"><%= String.format("%.2f", totalAmount) %></div>
    </div>
</div>
                                
                                <div class="detail-item">
                                    <i class="fas fa-envelope"></i>
                                    <div>
                                        <div class="detail-label">Email</div>
                                        <div class="detail-value"><%= userEmail %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
            <%
                        }
                    }
                } catch(Exception e) {
                    out.println("<div class='alert alert-danger'>Error loading orders: " + e.getMessage() + "</div>");
                } finally {
                    if(rs != null) rs.close();
                    if(ps != null) ps.close();
                    if(con != null) closeConnection(con);
                }
            %>
        </div>
    </div>
    
    <%@ include file="footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>