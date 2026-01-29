<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if(adminEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get live counts
    int totalOrders = 0;
    int pendingOrders = 0;
    int preparingOrders = 0;
    int deliveredOrders = 0;
    int totalMenuItems = 0;
    
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        con = getConnection();
        stmt = con.createStatement();
        
        // Total orders
        rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM orders");
        if(rs.next()) totalOrders = rs.getInt("cnt");
        
        // Pending orders
        rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM orders WHERE status='Pending'");
        if(rs.next()) pendingOrders = rs.getInt("cnt");
        
        // Preparing orders
        rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM orders WHERE status='Preparing'");
        if(rs.next()) preparingOrders = rs.getInt("cnt");
        
        // Delivered orders
        rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM orders WHERE status='Delivered'");
        if(rs.next()) deliveredOrders = rs.getInt("cnt");
        
        // Total menu items
        rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM menu");
        if(rs.next()) totalMenuItems = rs.getInt("cnt");
        
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(rs != null) rs.close();
        if(stmt != null) stmt.close();
        if(con != null) closeConnection(con);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Delicious Bites</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #0f0f1e;
            color: white;
        }
        
        /* Luxury Sidebar */
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
        
        /* Main Content */
        .main-content {
            margin-left: 280px;
            padding: 30px;
            min-height: 100vh;
        }
        
        .top-bar {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 20px 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        }
        
        .welcome-text h1 {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(90deg, #ffd700 0%, #ffed4e 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .admin-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .admin-avatar {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f1e;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.3rem;
        }
        
        /* Dashboard Cards */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #ffd700 0%, #ffed4e 100%);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(255, 215, 0, 0.2);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 15px;
        }
        
        .icon-yellow { background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%); color: #0f0f1e; }
        .icon-orange { background: linear-gradient(135deg, #ff9a3c 0%, #ffc93c 100%); color: white; }
        .icon-blue { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; }
        .icon-green { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); color: white; }
        .icon-purple { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); color: white; }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: #ffd700;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: rgba(255,255,255,0.7);
            font-size: 1rem;
        }
        
        /* Quick Actions */
        .quick-actions {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: #ffd700;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f1e;
            padding: 15px 25px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: block;
            text-align: center;
        }
        
        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(255, 215, 0, 0.4);
            color: #0f0f1e;
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
                <a href="admin-dashboard.jsp" class="active">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li>
                <a href="view-orders.jsp">
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
        <div class="top-bar">
            <div class="welcome-text">
                <h1><i class="fas fa-chart-line"></i> Dashboard Overview</h1>
                <p style="color: rgba(255,255,255,0.7); margin: 5px 0 0 0;">Real-time Restaurant Statistics</p>
            </div>
            <div class="admin-info">
                <div class="admin-avatar">A</div>
                <div>
                    <div style="font-weight: 600;">Admin</div>
                    <div style="font-size: 0.9rem; color: rgba(255,255,255,0.6);"><%= adminEmail %></div>
                </div>
            </div>
        </div>
        
        <!-- Dashboard Cards -->
        <div class="dashboard-cards">
            <div class="stat-card">
                <div class="stat-icon icon-yellow">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <div class="stat-value"><%= totalOrders %></div>
                <div class="stat-label">Total Orders</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon icon-orange">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-value"><%= pendingOrders %></div>
                <div class="stat-label">Pending Orders</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon icon-blue">
                    <i class="fas fa-fire"></i>
                </div>
                <div class="stat-value"><%= preparingOrders %></div>
                <div class="stat-label">Preparing Orders</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon icon-green">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-value"><%= deliveredOrders %></div>
                <div class="stat-label">Delivered Orders</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon icon-purple">
                    <i class="fas fa-utensils"></i>
                </div>
                <div class="stat-value"><%= totalMenuItems %></div>
                <div class="stat-label">Menu Items</div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="quick-actions">
            <div class="section-title">
                <i class="fas fa-bolt"></i> Quick Actions
            </div>
            <div class="action-buttons">
                <a href="view-orders.jsp" class="action-btn">
                    <i class="fas fa-list"></i> Manage Orders
                </a>
                <a href="add-menu.jsp" class="action-btn">
                    <i class="fas fa-plus"></i> Add New Item
                </a>
                <a href="edit-menu.jsp" class="action-btn">
                    <i class="fas fa-edit"></i> Edit Menu
                </a>
                <a href="admin-dashboard.jsp" class="action-btn">
                    <i class="fas fa-sync"></i> Refresh Stats
                </a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>