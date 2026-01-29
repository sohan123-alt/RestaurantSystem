<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delicious Bites - Restaurant Food Ordering</title>
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
            overflow-x: hidden;
        }
        
        /* Animated Gradient Background */
        .hero-section {
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        /* Floating Food Icons */
        .floating-icon {
            position: absolute;
            font-size: 50px;
            opacity: 0.1;
            animation: float 20s infinite ease-in-out;
        }
        
        .icon-1 { top: 10%; left: 10%; animation-delay: 0s; }
        .icon-2 { top: 20%; right: 15%; animation-delay: 2s; }
        .icon-3 { bottom: 15%; left: 20%; animation-delay: 4s; }
        .icon-4 { bottom: 25%; right: 10%; animation-delay: 6s; }
        .icon-5 { top: 50%; left: 5%; animation-delay: 8s; }
        .icon-6 { top: 60%; right: 5%; animation-delay: 10s; }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(180deg); }
        }
        
        /* Hero Content */
        .hero-content {
            text-align: center;
            color: white;
            z-index: 10;
            padding: 20px;
        }
        
        .hero-content h1 {
            font-size: 4.5rem;
            font-weight: 800;
            margin-bottom: 20px;
            text-shadow: 3px 3px 6px rgba(0,0,0,0.3);
            animation: fadeInDown 1s ease;
        }
        
        .hero-content p {
            font-size: 1.5rem;
            margin-bottom: 40px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease;
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Premium Buttons */
        .btn-container {
            display: flex;
            gap: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .premium-btn {
            padding: 18px 50px;
            font-size: 1.2rem;
            font-weight: 600;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.4s ease;
            text-decoration: none;
            display: inline-block;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-menu {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        .btn-register {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        .premium-btn:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0,0,0,0.4);
        }
        
        .premium-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.3);
            transition: all 0.4s ease;
        }
        
        .premium-btn:hover::before {
            left: 100%;
        }
        
        /* Feature Cards Section */
        .features-section {
            padding: 80px 20px;
            background: #f8f9fa;
        }
        
        .section-title {
            text-align: center;
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 60px;
            color: #333;
        }
        
        .feature-card {
            background: white;
            border-radius: 20px;
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
        }
        
        .feature-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .feature-card h3 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #333;
        }
        
        .feature-card p {
            color: #666;
            line-height: 1.6;
        }
        
        /* Footer */
        .footer {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 20px;
            text-align: center;
        }
        
        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2.5rem;
            }
            .hero-content p {
                font-size: 1.2rem;
            }
            .btn-container {
                flex-direction: column;
                gap: 15px;
            }
            .premium-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <div class="hero-section">
        <!-- Floating Food Icons -->
        <i class="fas fa-pizza-slice floating-icon icon-1"></i>
        <i class="fas fa-hamburger floating-icon icon-2"></i>
        <i class="fas fa-ice-cream floating-icon icon-3"></i>
        <i class="fas fa-coffee floating-icon icon-4"></i>
        <i class="fas fa-drumstick-bite floating-icon icon-5"></i>
        <i class="fas fa-cookie-bite floating-icon icon-6"></i>
        
        <div class="hero-content">
            <h1><i class="fas fa-utensils"></i> Delicious Bites</h1>
            <p>Experience Premium Food Ordering at Your Fingertips</p>
            <p style="font-size: 1.2rem; margin-bottom: 50px;">
                <i class="fas fa-star" style="color: #ffd700;"></i>
                Authentic Flavors | Fast Delivery | Quality Guaranteed
                <i class="fas fa-star" style="color: #ffd700;"></i>
            </p>
            
            <div class="btn-container">
                <a href="login.jsp" class="premium-btn btn-login">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
                <a href="register.jsp" class="premium-btn btn-register">
                    <i class="fas fa-user-plus"></i> Register
                </a>
                <a href="menu.jsp" class="premium-btn btn-menu">
                    <i class="fas fa-book-open"></i> View Menu
                </a>
            </div>
        </div>
    </div>
    
    <!-- Features Section -->
    <div class="features-section">
        <h2 class="section-title">Why Choose Us?</h2>
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3>Fast Delivery</h3>
                        <p>Get your delicious food delivered hot and fresh within 30 minutes</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3>Quality Assured</h3>
                        <p>We use only the finest ingredients to prepare your meals</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-heart"></i>
                        </div>
                        <h3>Customer Satisfaction</h3>
                        <p>Your happiness is our priority with 24/7 customer support</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2024 Delicious Bites Restaurant. All Rights Reserved.</p>
        <p><i class="fas fa-phone"></i> +91 9876543210 | <i class="fas fa-envelope"></i> info@deliciousbites.com</p>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>