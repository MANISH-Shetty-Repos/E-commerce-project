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
        body { background-color: #f8fafc; }
        .profile-container { max-width: 800px; margin: 48px auto; padding: 0 24px; min-height: 60vh; }
        .profile-header-title { font-size: 2rem; font-weight: 800; color: #1e293b; margin-bottom: 8px; }
        .profile-header-desc { color: #64748b; margin-bottom: 32px; font-size: 1rem; }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">E-Store</a>
            <ul class="nav-links">
                <li><a href="/">Home</a></li>
                <li><a href="/user/products">Products</a></li>
                <li><a href="/buy">Cart <c:if test="${cartCount > 0}"><span class="cart-badge">${cartCount}</span></c:if></a></li>
                <li><a href="/user/orders">My Orders</a></li>
                <li><a href="/user/profile" style="color: var(--primary); font-weight: 600;">Profile</a></li>
                <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="profile-container">
        
        <h1 class="profile-header-title">My Profile</h1>
        <p class="profile-header-desc">Manage your personal account details.</p>

        <c:if test="${not empty msg}">
            <div class="alert alert-success" style="margin-bottom: 24px; padding: 16px; background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; border-radius: 8px; font-weight: 600;">${msg}</div>
        </c:if>

        <div class="card" style="padding: 40px; border-radius: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; background: white;">
            <div style="display: flex; align-items: center; gap: 24px; margin-bottom: 32px; padding-bottom: 32px; border-bottom: 1px solid #e2e8f0;">
                <div style="width: 80px; height: 80px; border-radius: 20px; background: #e0e7ff; color: #4338ca; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 800;">
                    ${username.substring(0,1).toUpperCase()}
                </div>
                <div>
                    <h2 style="font-size: 1.5rem; font-weight: 800; color: #1e293b; margin-bottom: 4px;">${username}</h2>
                    <span class="badge" style="background: #eef2ff; color: #4338ca; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">Customer Account</span>
                </div>
            </div>

            <div style="display: flex; flex-direction: column; gap: 24px; margin-bottom: 40px;">
                <div style="display: grid; grid-template-columns: 150px 1fr; align-items: center;">
                    <span style="font-weight: 600; color: #64748b;">Email Address</span>
                    <span style="color: #1e293b; font-weight: 500;">${email}</span>
                </div>
                <div style="display: grid; grid-template-columns: 150px 1fr; align-items: start;">
                    <span style="font-weight: 600; color: #64748b; margin-top: 4px;">Account Status</span>
                    <span style="color: #10b981; font-weight: 600; display: flex; align-items: center; gap: 6px;">
                        <span style="width: 8px; height: 8px; border-radius: 50%; background: #10b981; display: inline-block;"></span> Active
                    </span>
                </div>
                <div style="display: grid; grid-template-columns: 150px 1fr; align-items: start;">
                    <span style="font-weight: 600; color: #64748b;">Physical Address</span>
                    <span style="color: #475569; line-height: 1.5; font-weight: 500;">${not empty address ? address : '—'}</span>
                </div>
            </div>

            <div style="display: flex; justify-content: flex-end; padding-top: 24px; border-top: 1px solid #e2e8f0;">
                <a href="/user/profile/edit" class="btn btn-primary" style="padding: 12px 32px; background: #1e293b; color: white;">Update Profile Information</a>
            </div>
        </div>
    </div>

    <footer class="footer" style="margin-top: auto;">
        <div class="footer-container">
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
