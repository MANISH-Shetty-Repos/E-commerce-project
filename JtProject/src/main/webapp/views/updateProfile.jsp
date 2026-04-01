<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/home.css">
    <style>
        .profile-container { max-width: 560px; margin: 48px auto; padding: 0 24px; }
        .profile-title { font-size: 1.75rem; font-weight: 800; letter-spacing: -0.025em; margin-bottom: 8px; }
        .profile-subtitle { color: var(--text-muted); margin-bottom: 32px; font-size: 0.95rem; }
        .profile-avatar {
            width: 80px; height: 80px; border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; color: white; margin-bottom: 24px;
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">🛍️ E-Store</a>
            <ul class="nav-links">
                <li><a href="/">Home</a></li>
                <li><a href="/user/products">Products</a></li>
                <li><a href="/buy">Cart 🛒</a></li>
                <li><a href="/user/orders">My Orders</a></li>
                <li><a href="/user/profile" style="color: var(--primary); font-weight: 600;">👤 Profile</a></li>
                <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
            </ul>
            <button class="hamburger" onclick="document.querySelector('.nav-links').classList.toggle('open')">☰</button>
        </div>
    </nav>

    <div class="profile-container">
        <div class="profile-avatar">👤</div>
        <h1 class="profile-title">My Profile</h1>
        <p class="profile-subtitle">Update your personal information</p>

        <c:if test="${not empty msg}">
            <div class="alert alert-danger">${msg}</div>
        </c:if>

        <div class="card">
            <form action="/updateuser" method="post">
                <input type="hidden" name="userid" value="${userid}">

                <div class="input-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" value="${username}"
                           placeholder="Your username" required>
                </div>

                <div class="input-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" value="${email}"
                           placeholder="you@example.com" required>
                    <small style="color:var(--text-muted); font-size:0.8rem; margin-top:4px; display:block;">
                        We'll never share your email with anyone.
                    </small>
                </div>

                <div class="input-group">
                    <label for="password">New Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="Leave blank to keep current password">
                </div>

                <div class="input-group">
                    <label for="address">Delivery Address</label>
                    <textarea id="address" name="address" rows="3"
                              placeholder="Enter your delivery address"
                              style="width:100%; padding:12px 16px; border-radius:8px; border:1px solid var(--border); font-family:inherit; font-size:1rem; resize:vertical;">${address}</textarea>
                </div>

                <div style="display: flex; gap: 12px; margin-top: 8px;">
                    <button type="submit" class="btn btn-primary" style="flex:1;">Save Changes</button>
                    <a href="/user/profile" class="btn btn-secondary" style="flex:1; text-align:center;">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer" style="margin-top: 64px;">
        <div class="footer-container">
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>