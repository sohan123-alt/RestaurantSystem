<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
String message = "";
String messageType = "";

if(request.getMethod().equalsIgnoreCase("POST")) {
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String password = request.getParameter("password");
    
    // Gmail validation
    if(email != null && !email.toLowerCase().endsWith("@gmail.com")) {
        message = "Only Gmail addresses are allowed!";
        messageType = "danger";
    } else {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            
            // Check if email already exists
            String checkQuery = "SELECT * FROM users1 WHERE email = ?";
            ps = con.prepareStatement(checkQuery);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if(rs.next()) {
                message = "Email already registered! Please login.";
                messageType = "warning";
            } else {
                // Insert new user
                String insertQuery = "INSERT INTO users1 (name, email, phone, password) VALUES (?, ?, ?, ?)";
                ps = con.prepareStatement(insertQuery);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, phone);
                ps.setString(4, password);
                
                int result = ps.executeUpdate();
                
                if(result > 0) {
                    message = "Registration successful! Please login.";
                    messageType = "success";
                } else {
                    message = "Registration failed! Please try again.";
                    messageType = "danger";
                }
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
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Delicious Bites</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        
        .register-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 500px;
            width: 100%;
            animation: slideUp 0.5s ease;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .register-header h2 {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
        }
        
        .register-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
        }
        
        .register-body {
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
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
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
        
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .login-link a:hover {
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
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <i class="fas fa-user-plus fa-3x"></i>
            <h2>Create Account</h2>
            <p>Join Delicious Bites Today!</p>
        </div>
        
        <div class="register-body">
            <% if(!message.isEmpty()) { %>
                <div class="alert alert-<%= messageType %>" role="alert">
                    <i class="fas fa-info-circle"></i> <%= message %>
                </div>
            <% } %>
            
            <form method="POST" action="register.jsp">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <div class="input-icon">
                        <i class="fas fa-user"></i>
                        <input type="text" name="name" class="form-control" placeholder="Enter your full name" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Email (Gmail Only)</label>
                    <div class="input-icon">
                        <i class="fas fa-envelope"></i>
                        <input type="email" name="email" class="form-control" placeholder="yourname@gmail.com" required pattern="[a-zA-Z0-9._%+-]+@gmail\.com">
                    </div>
                    <small class="text-muted">Only Gmail addresses are allowed</small>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <div class="input-icon">
                        <i class="fas fa-phone"></i>
                        <input type="tel" name="phone" class="form-control" placeholder="Enter your phone number" required pattern="[0-9]{10}">
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" class="form-control" placeholder="Create a strong password" required minlength="6">
                    </div>
                </div>
                
                <button type="submit" class="btn-register">
                    <i class="fas fa-user-plus"></i> Register Now
                </button>
            </form>
            
            <div class="login-link">
                Already have an account? <a href="login.jsp">Login here</a>
            </div>
            
            <div class="home-link">
                <a href="index.jsp"><i class="fas fa-home"></i> Back to Home</a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>