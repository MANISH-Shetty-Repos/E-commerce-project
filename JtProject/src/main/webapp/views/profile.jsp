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
        .profile-container { max-width: 600px; margin: 48px auto; padding: 0 24px; }
        .profile-header { display: flex; align-items: center; gap: 24px; margin-bottom: 32px; }
        .profile-avatar {
            width: 100px; height: 100px; border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem; color: white; border: 4px solid white; box-shadow: var(--shadow);
        }
        .profile-info h1 { font-size: 1.75rem; font-weight: 800; margin: 0; }
        .profile-info p { color: var(--text-muted); margin: 4px 0 0; }

        .info-grid { display: grid; gap: 20px; }
        .info-item { display: flex; flex-direction: column; gap: 4px; }
        .info-label { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); }
        .info-value { font-size: 1.05rem; font-weight: 500; color: var(--text-main); }
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
        </div>
    </nav>

    <div class="profile-container">
        <div class="profile-header">
            <div class="profile-avatar">${username.substring(0,1).toUpperCase()}</div>
            <div class="profile-info">
                <h1>${username}</h1>
                <p>Member since 2026</p>
            </div>
        </div>

        <div class="card" style="padding: 32px;">
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Full Name / Username</span>
                    <span class="info-value">${username}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Email Address</span>
                    <span class="info-value">${email}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Current Address</span>
                    <span class="info-value">${not empty address ? address : 'No address provided'}</span>
                </div>
                <div class="info-item" style="margin-top: 16px;">
                    <a href="/user/profile/edit" class="btn btn-primary" style="text-align: center;">Update Profile</a>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer" style="margin-top: 64px;">
        <div class="footer-container">
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
