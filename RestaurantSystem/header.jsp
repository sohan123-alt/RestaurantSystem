
<%
    String userName = (String) session.getAttribute("userName");
    String usersEmail = (String) session.getAttribute("usersEmail");
    
    if(userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<style>
    .top-navbar {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 15px 0;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }
    
    .navbar-brand {
        color: white !important;
        font-size: 1.5rem;
        font-weight: 700;
    }
    
    .nav-link {
        color: white !important;
        font-weight: 500;
        margin: 0 10px;
        transition: all 0.3s ease;
        padding: 8px 15px !important;
        border-radius: 5px;
    }
    
    .nav-link:hover {
        background: rgba(255,255,255,0.2);
        transform: translateY(-2px);
    }
    
    .user-info {
        color: white;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .user-avatar {
        width: 35px;
        height: 35px;
        background: white;
        color: #667eea;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
    }
</style>

<nav class="navbar navbar-expand-lg top-navbar">
    <div class="container">
        <a class="navbar-brand" href="menu.jsp">
            <i class="fas fa-utensils"></i> Delicious Bites
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" style="background: white;">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="menu.jsp">
                        <i class="fas fa-book-open"></i> Menu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="cart.jsp">
                        <i class="fas fa-shopping-cart"></i> Cart
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="orders.jsp">
                        <i class="fas fa-receipt"></i> My Orders
                    </a>
                </li>
                <li class="nav-item">
                    <div class="user-info">
                        <div class="user-avatar">
                            <%= userName.substring(0,1).toUpperCase() %>
                        </div>
                        <span><%= userName %></span>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>


<!-- ============================================ -->
<!-- footer.jsp - Simple Modern Footer -->
<!-- ============================================ -->

<style>
    .main-footer {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 30px 0;
        margin-top: 50px;
    }
    
    .footer-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 20px;
    }
    
    .footer-links a {
        color: white;
        text-decoration: none;
        margin: 0 15px;
        transition: all 0.3s ease;
    }
    
    .footer-links a:hover {
        text-decoration: underline;
    }
    
    @media (max-width: 768px) {
        .footer-content {
            flex-direction: column;
            text-align: center;
        }
    }
</style>

<footer class="main-footer">
    <div class="container">
        
        </div>
    </div>
</footer>