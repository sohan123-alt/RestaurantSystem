<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = "";
    String messageType = "";
    
    // Handle Add to Cart
    if(request.getParameter("addToCart") != null) {
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        String foodName = request.getParameter("foodName");
        double price = Double.parseDouble(request.getParameter("price"));
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            
            // Check if item already in cart
            String checkQuery = "SELECT * FROM cart WHERE user_email = ? AND menu_id = ?";
            ps = con.prepareStatement(checkQuery);
            ps.setString(1, userEmail);
            ps.setInt(2, menuId);
            rs = ps.executeQuery();
            
            if(rs.next()) {
                // Update quantity
                int currentQty = rs.getInt("quantity");
                double totalPrice = price * (currentQty + 1);
                
                String updateQuery = "UPDATE cart SET quantity = ?, total_price = ? WHERE user_email = ? AND menu_id = ?";
                ps = con.prepareStatement(updateQuery);
                ps.setInt(1, currentQty + 1);
                ps.setDouble(2, totalPrice);
                ps.setString(3, userEmail);
                ps.setInt(4, menuId);
                ps.executeUpdate();
            } else {
                // Insert new item
                String insertQuery = "INSERT INTO cart (user_email, menu_id, food_name, price, quantity, total_price) VALUES (?, ?, ?, ?, 1, ?)";
                ps = con.prepareStatement(insertQuery);
                ps.setString(1, userEmail);
                ps.setInt(2, menuId);
                ps.setString(3, foodName);
                ps.setDouble(4, price);
                ps.setDouble(5, price);
                ps.executeUpdate();
            }
            
            message = "Item added to cart successfully!";
            messageType = "success";
            
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
    <title>Menu - Delicious Bites</title>
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
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        
        .menu-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .menu-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }
        
        .menu-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .menu-content {
            padding: 20px;
        }
        
        .food-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }
        
        .category-badge {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            margin-bottom: 10px;
        }
        
        .price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #f5576c;
            margin: 15px 0;
        }
        
        .description {
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 15px;
        }
        
        .btn-add-cart {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-add-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(245, 87, 108, 0.4);
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="page-title">
        <h1><i class="fas fa-book-open"></i> Our Delicious Menu</h1>
        <p style="margin-top: 10px;">Order Your Favorite Dishes</p>
    </div>
    
    <div class="container">
        <% if(!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <div class="menu-grid">
            <%
                Connection con = null;
                Statement stmt = null;
                ResultSet rs = null;
                
                try {
                    con = getConnection();
                    stmt = con.createStatement();
                    String query = "SELECT * FROM menu WHERE available = 'Yes' ORDER BY menu_id";
                    rs = stmt.executeQuery(query);
                    
                    while(rs.next()) {
                        int menuId = rs.getInt("menu_id");
                        String foodName = rs.getString("food_name");
                        String category = rs.getString("category");
                        double price = rs.getDouble("price");
                        String description = rs.getString("description");
                        String imageUrl = rs.getString("image_url");
            %>
            
            <div class="menu-card">
                <img src="<%= imageUrl %>" alt="<%= foodName %>" class="menu-image">
                <div class="menu-content">
                    <span class="category-badge"><i class="fas fa-tag"></i> <%= category %></span>
                    <div class="food-name"><%= foodName %></div>
                    <div class="description"><%= description %></div>
<div class="price">BDT <%= String.format("%.2f", price) %></div>                    
                    <form method="POST" action="menu.jsp">
                        <input type="hidden" name="menuId" value="<%= menuId %>">
                        <input type="hidden" name="foodName" value="<%= foodName %>">
                        <input type="hidden" name="price" value="<%= price %>">
                        <button type="submit" name="addToCart" class="btn-add-cart">
                            <i class="fas fa-cart-plus"></i> Add to Cart
                        </button>
                    </form>
                </div>
            </div>
            
            <%
                    }
                } catch(Exception e) {
                    out.println("<div class='alert alert-danger'>Error loading menu: " + e.getMessage() + "</div>");
                } finally {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(con != null) closeConnection(con);
                }
            %>
        </div>
    </div>
    
    <%@ include file="footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>