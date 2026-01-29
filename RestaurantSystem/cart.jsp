<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    
    if(userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = "";
    String messageType = "";
    
    Connection con = null;
    PreparedStatement ps = null;
    
    // Handle quantity update
    if(request.getParameter("updateQty") != null) {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));
            
            con = getConnection();
            String updateQuery = "UPDATE cart SET quantity = ?, total_price = ? WHERE cart_id = ?";
            ps = con.prepareStatement(updateQuery);
            ps.setInt(1, quantity);
            ps.setDouble(2, price * quantity);
            ps.setInt(3, cartId);
            ps.executeUpdate();
            
            message = "Quantity updated!";
            messageType = "success";
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "danger";
        } finally {
            if(ps != null) ps.close();
            if(con != null) closeConnection(con);
        }
    }
    
    // Handle remove item
    if(request.getParameter("removeItem") != null) {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            
            con = getConnection();
            String deleteQuery = "DELETE FROM cart WHERE cart_id = ?";
            ps = con.prepareStatement(deleteQuery);
            ps.setInt(1, cartId);
            ps.executeUpdate();
            
            message = "Item removed from cart!";
            messageType = "warning";
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "danger";
        } finally {
            if(ps != null) ps.close();
            if(con != null) closeConnection(con);
        }
    }
    
    // Handle place order
    if(request.getParameter("placeOrder") != null) {
        try {
            con = getConnection();
            
            // Calculate total amount
            String totalQuery = "SELECT SUM(total_price) as total FROM cart WHERE user_email = ?";
            ps = con.prepareStatement(totalQuery);
            ps.setString(1, userEmail);
            ResultSet rs = ps.executeQuery();
            
            double totalAmount = 0;
            if(rs.next()) {
                totalAmount = rs.getDouble("total");
            }
            
            if(totalAmount > 0) {
                // Insert order with default status 'Pending'
                String insertOrder = "INSERT INTO orders (user_email, total_amount, status, phone) VALUES (?, ?, 'Pending', ?)";
                ps = con.prepareStatement(insertOrder);
                ps.setString(1, userEmail);
                ps.setDouble(2, totalAmount);
                ps.setString(3, userPhone);
                ps.executeUpdate();
                
                // Clear cart
                String clearCart = "DELETE FROM cart WHERE user_email = ?";
                ps = con.prepareStatement(clearCart);
                ps.setString(1, userEmail);
                ps.executeUpdate();
                
                message = "Order placed successfully! Check My Orders page.";
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
    <title>Cart - Delicious Bites</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
        }
        
        .page-title {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        
        .cart-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 50px;
        }
        
        .cart-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .cart-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .cart-table td {
            padding: 20px 15px;
            border-bottom: 1px solid #e0e0e0;
            vertical-align: middle;
        }
        
        .cart-table tr:hover {
            background: #f8f9fa;
        }
        
        .qty-input {
            width: 70px;
            padding: 8px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            text-align: center;
            font-weight: 600;
        }
        
        .btn-update {
            background: #667eea;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-update:hover {
            background: #5568d3;
        }
        
        .btn-remove {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-remove:hover {
            background: #c82333;
        }
        
        .total-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin-top: 30px;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1.5rem;
            font-weight: 700;
            color: #333;
        }
        
        .btn-place-order {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 25px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            width: 100%;
            transition: all 0.3s ease;
        }
        
        .btn-place-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(245, 87, 108, 0.4);
        }
        
        .empty-cart {
            text-align: center;
            padding: 50px;
            color: #999;
        }
        
        .empty-cart i {
            font-size: 5rem;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .cart-table {
                font-size: 0.9rem;
            }
            
            .cart-table th, .cart-table td {
                padding: 10px 5px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="page-title">
        <h1><i class="fas fa-shopping-cart"></i> Your Cart</h1>
        <p style="margin-top: 10px;">Review Your Items</p>
    </div>
    
    <div class="container">
        <% if(!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <i class="fas fa-info-circle"></i> <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <div class="cart-container">
            <%
                Statement stmt = null;
                ResultSet rs = null;
                double grandTotal = 0;
                int itemCount = 0;
                
                try {
                    con = getConnection();
                    stmt = con.createStatement();
                    String query = "SELECT * FROM cart WHERE user_email = '" + userEmail + "'";
                    rs = stmt.executeQuery(query);
                    
                    if(!rs.isBeforeFirst()) {
            %>
                        <div class="empty-cart">
                            <i class="fas fa-shopping-cart"></i>
                            <h3>Your cart is empty!</h3>
                            <p>Add some delicious items from our menu</p>
                            <a href="menu.jsp" class="btn btn-primary mt-3">Browse Menu</a>
                        </div>
            <%
                    } else {
            %>
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th>Food Item</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Total</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
            <%
                        while(rs.next()) {
                            itemCount++;
                            int cartId = rs.getInt("cart_id");
                            String foodName = rs.getString("food_name");
                            double price = rs.getDouble("price");
                            int quantity = rs.getInt("quantity");
                            double totalPrice = rs.getDouble("total_price");
                            grandTotal += totalPrice;
            %>
                                <tr>
                                    <td><strong><%= foodName %></strong></td>
                                    <td>
    <i class="fa-solid fa-bangladeshi-taka-sign"></i> 
    <%= String.format("%.2f", price) %>
</td>
                                    <td>
                                        <form method="POST" action="cart.jsp" style="display: inline;">
                                            <input type="hidden" name="cartId" value="<%= cartId %>">
                                            <input type="hidden" name="price" value="<%= price %>">
                                            <input type="number" name="quantity" value="<%= quantity %>" min="1" max="10" class="qty-input">
                                            <button type="submit" name="updateQty" class="btn-update">
                                                <i class="fas fa-sync"></i>
                                            </button>
                                        </form>
                                    </td>
                                    <td><strong><i class="fa-solid fa-bangladeshi-taka-sign"></i> <%= String.format("%.2f", totalPrice) %></strong></td>
                                    <td>
                                        <form method="POST" action="cart.jsp" style="display: inline;">
                                            <input type="hidden" name="cartId" value="<%= cartId %>">
                                            <button type="submit" name="removeItem" class="btn-remove">
                                                <i class="fas fa-trash"></i> Remove
                                            </button>
                                        </form>
                                    </td>
                                </tr>
            <%
                        }
            %>
                            </tbody>
                        </table>
                        
                        <div class="total-section">
                            <div class="total-row">
                                <span>Grand Total:</span>
                                <span style="color: #f5576c;">
    BDT <%= String.format("%.2f", grandTotal) %>
</span>
                            </div>
                            
                            <form method="POST" action="cart.jsp">
                                <button type="submit" name="placeOrder" class="btn-place-order">
                                    <i class="fas fa-check-circle"></i> Place Order Now
                                </button>
                            </form>
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
    
    <%@ include file="footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>