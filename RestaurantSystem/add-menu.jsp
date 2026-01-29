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
    
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String foodName = request.getParameter("foodName");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = getConnection();
            String insertQuery = "INSERT INTO menu (food_name, category, price, description, image_url) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(insertQuery);
            ps.setString(1, foodName);
            ps.setString(2, category);
            ps.setDouble(3, price);
            ps.setString(4, description);
            ps.setString(5, imageUrl);
            
            int result = ps.executeUpdate();
            if(result > 0) {
                message = "Menu item added successfully!";
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
    <title>Add Menu Item - Admin Panel</title>
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
        
        .form-container {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
            max-width: 700px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            color: #ffd700;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control, .form-select {
            background: #0f0f1e;
            color: white;
            border: 2px solid rgba(255, 215, 0, 0.3);
            padding: 12px 15px;
            border-radius: 8px;
            width: 100%;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #ffd700;
            box-shadow: 0 0 0 0.2rem rgba(255, 215, 0, 0.25);
            outline: none;
            background: #0f0f1e;
            color: white;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f1e;
            border: none;
            padding: 15px 40px;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(255, 215, 0, 0.4);
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
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
                <a href="admin-dashboard.jsp">
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
                <a href="add-menu.jsp" class="active">
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
            <h1><i class="fas fa-plus-circle"></i> Add New Menu Item</h1>
            <p style="color: rgba(255,255,255,0.7); margin: 5px 0 0 0;">Create New Food Item</p>
        </div>
        
        <% if(!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <i class="fas fa-info-circle"></i> <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <div class="form-container">
            <form method="POST" action="add-menu.jsp">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-utensils"></i> Food Name
                    </label>
                    <input type="text" name="foodName" class="form-control" placeholder="Enter food name" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-list"></i> Category
                    </label>
                    <select name="category" class="form-select" required>
                        <option value="">Select Category</option>
                        <option value="Breakfast">Breakfast</option>
                        <option value="Starter">Starter</option>
                        <option value="Main Course">Main Course</option>
                        <option value="Rice">Rice</option>
                        <option value="Dessert">Dessert</option>
                        <option value="Beverages">Beverages</option>
                        <option value="Cool Drinks">Cool Drinks</option>
                        <option value = "FastFood">FastFood</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fa-solid fa-bangladeshi-taka-sign"></i>
                    </label>
                    <input type="number" step="0.01" name="price" class="form-control" placeholder="Enter price" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-align-left"></i> Description
                    </label>
                    <textarea name="description" class="form-control" placeholder="Enter food description" required></textarea>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-image"></i> Image URL
                    </label>
                    <input type="text" name="imageUrl" class="form-control" placeholder="https://example.com/image.jpg" value="https://via.placeholder.com/300x200?text=Food+Image">
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fas fa-plus-circle"></i> Add Menu Item
                </button>
            </form>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>