<!-- ============================================ -->
<!-- edit-menu.jsp - Admin Edit Menu Page -->
<!-- ============================================ -->
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
    
    // Handle Edit Submit
    if(request.getParameter("editSubmit") != null) {
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        String foodName = request.getParameter("foodName");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = getConnection();
            String updateQuery = "UPDATE menu SET food_name=?, category=?, price=?, description=?, image_url=? WHERE menu_id=?";
            ps = con.prepareStatement(updateQuery);
            ps.setString(1, foodName);
            ps.setString(2, category);
            ps.setDouble(3, price);
            ps.setString(4, description);
            ps.setString(5, imageUrl);
            ps.setInt(6, menuId);
            
            int result = ps.executeUpdate();
            if(result > 0) {
                message = "Menu item updated successfully!";
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
    
    // Handle Delete
    if(request.getParameter("deleteItem") != null) {
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = getConnection();
            String deleteQuery = "DELETE FROM menu WHERE menu_id = ?";
            ps = con.prepareStatement(deleteQuery);
            ps.setInt(1, menuId);
            
            int result = ps.executeUpdate();
            if(result > 0) {
                message = "Menu item deleted successfully!";
                messageType = "warning";
            }
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "danger";
        } finally {
            if(ps != null) ps.close();
            if(con != null) closeConnection(con);
        }
    }
    
    // Load item for editing if edit button clicked
    int editMenuId = 0;
    String editFoodName = "";
    String editCategory = "";
    double editPrice = 0;
    String editDescription = "";
    String editImageUrl = "";
    
    if(request.getParameter("edit") != null) {
        editMenuId = Integer.parseInt(request.getParameter("menuId"));
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            String query = "SELECT * FROM menu WHERE menu_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, editMenuId);
            rs = ps.executeQuery();
            
            if(rs.next()) {
                editFoodName = rs.getString("food_name");
                editCategory = rs.getString("category");
                editPrice = rs.getDouble("price");
                editDescription = rs.getString("description");
                editImageUrl = rs.getString("image_url");
            }
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "danger";
        } finally {
            if(rs != null) rs.close();
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
    <title>Edit Menu - Admin Panel</title>
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
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .menu-card {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        
        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(255, 215, 0, 0.2);
        }
        
        .menu-card h4 {
            color: #ffd700;
            margin-bottom: 15px;
        }
        
        .menu-card p {
            color: rgba(255,255,255,0.7);
            margin: 8px 0;
        }
        
        .menu-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-edit, .btn-delete {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-edit {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f1e;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
            color: white;
        }
        
        .btn-edit:hover, .btn-delete:hover {
            transform: translateY(-2px);
        }
        
        .edit-form {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
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
            padding: 10px 15px;
            border-radius: 8px;
            width: 100%;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #ffd700;
            outline: none;
            background: #0f0f1e;
            color: white;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f1e;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
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
                <a href="add-menu.jsp">
                    <i class="fas fa-plus-circle"></i>
                    <span>Add Menu Item</span>
                </a>
            </li>
            <li>
                <a href="edit-menu.jsp" class="active">
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
            <h1><i class="fas fa-edit"></i> Edit Menu Items</h1>
            <p style="color: rgba(255,255,255,0.7); margin: 5px 0 0 0;">Modify or Delete Food Items</p>
        </div>
        
        <% if(!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Edit Form -->
        <% if(editMenuId > 0) { %>
        <div class="edit-form">
            <h3 style="color: #ffd700; margin-bottom: 20px;">Edit Item #<%= editMenuId %></h3>
            <form method="POST" action="edit-menu.jsp">
                <input type="hidden" name="menuId" value="<%= editMenuId %>">
                
                <div class="form-group">
                    <label class="form-label">Food Name</label>
                    <input type="text" name="foodName" class="form-control" value="<%= editFoodName %>" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select name="category" class="form-select" required>
                        <option value="Breakfast" <%= editCategory.equals("Breakfast") ? "selected" : "" %>>Breakfast</option>
                        <option value="Starter" <%= editCategory.equals("Starter") ? "selected" : "" %>>Starter</option>
                        <option value="Main Course" <%= editCategory.equals("Main Course") ? "selected" : "" %>>Main Course</option>
                        <option value="Rice" <%= editCategory.equals("Rice") ? "selected" : "" %>>Rice</option>
                        <option value="Dessert" <%= editCategory.equals("Dessert") ? "selected" : "" %>>Dessert</option>
                        <option value="Beverages" <%= editCategory.equals("Beverages") ? "selected" : "" %>>Beverages</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Price</label>
                    <input type="number" step="0.01" name="price" class="form-control" value="<%= editPrice %>" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" style="min-height: 80px;" required><%= editDescription %></textarea>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Image URL</label>
                    <input type="text" name="imageUrl" class="form-control" value="<%= editImageUrl %>">
                </div>
                
                <button type="submit" name="editSubmit" class="btn-submit">
                    <i class="fas fa-save"></i> Update Item
                </button>
            </form>
        </div>
        <% } %>
        
        <!-- Menu List -->
        <div class="menu-grid">
            <%
                Connection con = null;
                Statement stmt = null;
                ResultSet rs = null;
                
                try {
                    con = getConnection();
                    stmt = con.createStatement();
                    String query = "SELECT * FROM menu ORDER BY menu_id";
                    rs = stmt.executeQuery(query);
                    
                    while(rs.next()) {
                        int menuId = rs.getInt("menu_id");
                        String foodName = rs.getString("food_name");
                        String category = rs.getString("category");
                        double price = rs.getDouble("price");
            %>
            <div class="menu-card">
                <h4><%= foodName %></h4>
                <p><strong>Category:</strong> <%= category %></p>
                <p><strong>Price:</strong> <i class="fa-solid fa-bangladeshi-taka-sign"></i> <%= String.format("%.2f", price) %></p>
                
                <div class="menu-actions">
                    <form method="GET" action="edit-menu.jsp" style="flex: 1;">
                        <input type="hidden" name="menuId" value="<%= menuId %>">
                        <button type="submit" name="edit" class="btn-edit">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                    </form>
                    
                    <form method="POST" action="edit-menu.jsp" style="flex: 1;">
                        <input type="hidden" name="menuId" value="<%= menuId %>">
                        <button type="submit" name="deleteItem" class="btn-delete" onclick="return confirm('Are you sure?')">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                </div>
            </div>
            <%
                    }
                } catch(Exception e) {
                    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                } finally {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(con != null) closeConnection(con);
                }
            %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>