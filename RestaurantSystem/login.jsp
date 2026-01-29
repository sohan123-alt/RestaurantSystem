<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
String message = "";
String messageType = "";

if(request.getMethod().equalsIgnoreCase("POST")) {
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        con = getConnection();
        
        // FIRST: Check in ADMIN table
        String adminQuery = "SELECT * FROM admin WHERE email = ? AND password = ?";
        ps = con.prepareStatement(adminQuery);
        ps.setString(1, email);
        ps.setString(2, password);
        rs = ps.executeQuery();
        
        if(rs.next()) {
            // Admin login successful
            session.setAttribute("adminEmail", email);
            session.setAttribute("adminName", rs.getString("name"));
            session.setAttribute("role", "admin");
            response.sendRedirect("admin-dashboard.jsp");
            return;
        }
        
        // SECOND: Check in USERS table
        String userQuery = "SELECT * FROM users1 WHERE email = ? AND password = ?";
        ps = con.prepareStatement(userQuery);
        ps.setString(1, email);
        ps.setString(2, password);
        rs = ps.executeQuery();
        
        if(rs.next()) {
            // User login successful
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", rs.getString("name"));
            session.setAttribute("userPhone", rs.getString("phone"));
            session.setAttribute("role", "user");
            response.sendRedirect("menu.jsp");
            return;
        } else {
            message = "Invalid email or password!";
            messageType = "danger";
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
    <title>Login - Delicious Bites</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 450px;
            width: 100%;
            animation: fadeIn 0.5s ease;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        .login-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .login-header i {
            font-size: 4rem;
            margin-bottom: 15px;
        }
        
        .login-header h2 {
            margin: 0;
            font-size: 2.2rem;
            font-weight: 700;
        }
        
        .login-header p {
            margin: 10px 0 0 0;
            opacity: 0.95;
            font-size: 1rem;
        }
        
        .login-body {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #f5576c;
            box-shadow: 0 0 0 0.2rem rgba(245, 87, 108, 0.25);
            outline: none;
        }
        
        .input-icon {
            position: relative;
        }
        
        .input-icon i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }
        
        .input-icon .form-control {
            padding-left: 45px;
        }
        
        .btn-login {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border: none;
            padding: 15px;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(245, 87, 108, 0.4);
        }
        
        .register-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .register-link a {
            color: #f5576c;
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        .alert {
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .home-link {
            text-align: center;
            margin-top: 15px;
        }
        
        .home-link a {
            color: #f5576c;
            text-decoration: none;
            font-weight: 600;
        }
        
        .info-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #f5576c;
        }
        
        .info-box p {
            margin: 5px 0;
            font-size: 0.9rem;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <i class="fas fa-sign-in-alt"></i>
            <h2>Welcome Back!</h2>
            <p>Login to Your Account</p>
        </div>
        
        <div class="login-body">
            <% if(!message.isEmpty()) { %>
                <div class="alert alert-<%= messageType %>" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= message %>
                </div>
            <% } %>
            
            <form method="POST" action="login.jsp">
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <div class="input-icon">
                        <i class="fas fa-envelope"></i>
                        <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
                    </div>
                </div>
                
                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt"></i> Login Now
                </button>
            </form>
            
            <div class="register-link">
                Don't have an account? <a href="register.jsp">Register here</a>
            </div>
            
            <div class="home-link">
                <a href="index.jsp"><i class="fas fa-home"></i> Back to Home</a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>