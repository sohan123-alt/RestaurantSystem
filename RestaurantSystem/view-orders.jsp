<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if(adminEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = "";
    String messageType = "";
    
    // Handle status update
    if(request.getParameter("updateStatus") != null) {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String newStatus = request.getParameter("status");
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = getConnection();
            String updateQuery = "UPDATE orders SET status = ? WHERE order_id = ?";
            ps = con.prepareStatement(updateQuery);
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            
            int result = ps.executeUpdate();
            if(result > 0) {
                message = "Order status updated successfully!";
                messageType = "success";
            }
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "danger";
        } finally {
            if(ps != null) ps.close();
            if(con != null) closeConnection(con);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Orders - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #0f0f1e;
            color: white;
        }
        
        .admin-sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 280px;
            height: 100vh;
            background: linear-gradient(180deg, #1a1a2e 0%, #16213e 100%);
            padding: 30px 0;
            box-shadow: 5px 0 20px rgba(0,0,0,0.5);
            z-index: 1000;
        }
        
        .sidebar-brand {
            text-align: center;
            padding: 0 20px 30px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 30px;
        }
        
        .sidebar-brand h3 {
            color: #ffd700;
            font-weight: 700;
            font-size: 1.5rem;
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            margin: 5px 0;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 25px;
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background: linear-gradient(90deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f1e;
            font-weight: 600;
        }
        
        .sidebar-menu i {
            font-size: 1.2rem;
            width: 25px;
        }
        
        .main-content {
            margin-left: 280px;
            padding: 30px;
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        }
        
        .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(90deg, #ffd700 0%, #ffed4e 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
        }
        
        .orders-container {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        }
        
        .orders-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .orders-table thead {
            background: linear-gradient(90deg, #ffd700 0%, #ffed4e 100%);
        }
        
        .orders-table th {
            padding: 15px;
            text-align: left;
            color: #0f0f1e;
            font-weight: 700;
        }
        
        .orders-table td {
            padding: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .orders-table tbody tr:hover {
            background: rgba(255, 215, 0, 0.1);
        }
        
        .status-select {
            background: #0f0f1e;
            color: white;
            border: 2px solid #ffd700;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .btn-update {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f1e;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .admin-sidebar {
                width: 70px;
            }
            
            .sidebar-brand h3, .sidebar-menu span {
                display: none;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .orders-table {
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="admin-sidebar">
        <div class="sidebar-brand">
            <i class="fas fa-crown" style="font-size: 2rem; color: #ffd700;"></i>
            <h3>Admin Panel</h3>
        </div>
        
        <ul class="sidebar-menu">
            <li>
                <a href="admin-dashboard.jsp">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li>
                <a href="view-orders.jsp" class="active">
                    <i class="fas fa-shopping-bag"></i>
                    <span>View Orders</span>
                </a>
            </li>
            <li>
                <a href="add-menu.jsp">
                    <i class="fas fa-plus-circle"></i>
                    <span>Add Menu Item</span>
                </a>
            </li>
            <li>
                <a href="edit-menu.jsp">
                    <i class="fas fa-edit"></i>
                    <span>Edit Menu</span>
                </a>
            </li>
            <li>
                <a href="logout.jsp">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="page-header">
            <h1><i class="fas fa-shopping-bag"></i> Manage Orders</h1>
            <p style="color: rgba(255,255,255,0.7); margin: 5px 0 0 0;">View and Update Order Status</p>
        </div>
        
        <% if(!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <div class="orders-container">
            <h3 style="color: #ffd700; margin-bottom: 20px;">
                <i class="fas fa-list"></i> All Orders
            </h3>
            
            <div style="overflow-x: auto;">
                <table class="orders-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>User Email</th>
                            <th>Total Amount</th>
                            <th>Order Date</th>
                            <th>Current Status</th>
                            <th>Update Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection con = null;
                            Statement stmt = null;
                            ResultSet rs = null;
                            
                            try {
                                con = getConnection();
                                stmt = con.createStatement();
                                String query = "SELECT * FROM orders ORDER BY order_date DESC";
                                rs = stmt.executeQuery(query);
                                
                                while(rs.next()) {
                                    int orderId = rs.getInt("order_id");
                                    String userEmail = rs.getString("user_email");
                                    double totalAmount = rs.getDouble("total_amount");
                                    String orderDate = rs.getString("order_date");
                                    String currentStatus = rs.getString("status");
                        %>
                        <tr>
                            <td><strong>#<%= orderId %></strong></td>
                            <td><%= userEmail %></td>
                            <td><strong style="color: #ffd700;"><i class="fa-solid fa-bangladeshi-taka-sign"></i> <%= String.format("%.2f", totalAmount) %></strong></td>
                            <td><%= orderDate %></td>
                            <td>
                                <span style="padding: 5px 15px; border-radius: 15px; 
                                    background: <%= currentStatus.equals("Pending") ? "#fff3cd" : currentStatus.equals("Preparing") ? "#cfe2ff" : "#d1e7dd" %>;
                                    color: <%= currentStatus.equals("Pending") ? "#856404" : currentStatus.equals("Preparing") ? "#084298" : "#0f5132" %>;">
                                    <%= currentStatus %>
                                </span>
                            </td>
                            <td>
                                <form method="POST" action="view-orders.jsp" style="display: inline;">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <select name="status" class="status-select">
                                        <option value="Pending" <%= currentStatus.equals("Pending") ? "selected" : "" %>>Pending</option>
                                        <option value="Preparing" <%= currentStatus.equals("Preparing") ? "selected" : "" %>>Preparing</option>
                                        <option value="Delivered" <%= currentStatus.equals("Delivered") ? "selected" : "" %>>Delivered</option>
                                    </select>
                            </td>
                            <td>
                                    <button type="submit" name="updateStatus" class="btn-update">
                                        <i class="fas fa-sync"></i> Update
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <%
                                }
                            } catch(Exception e) {
                                out.println("<tr><td colspan='7' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                if(rs != null) rs.close();
                                if(stmt != null) stmt.close();
                                if(con != null) closeConnection(con);
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>