<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Admin Profile - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body>
    <div class="admin-layout">

        <!-- SIDEBAR -->
        <aside class="admin-sidebar">
            <div class="sidebar-brand">
                <a href="/admin/Dashboard">E-Store</a>
                <small>Merchant Command Center</small>
            </div>
            <div class="sidebar-section">Main</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/Dashboard">Dashboard</a></li>
            </ul>
            <div class="sidebar-section">Catalog</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/categories">Category</a></li>
                <li><a href="/admin/products">Product</a></li>
                <li><a href="/admin/customers">Customers</a></li>
                <li><a href="/admin/orders">Orders</a></li>
            </ul>
            <div class="sidebar-section">System</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/profileDisplay" class="active">Admin Profile</a></li>
                <li><a href="/admin/logout" style="color: #f87171;">Logout</a></li>
            </ul>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="admin-main">
            <div class="admin-topbar">
                <div class="topbar-left">
                    <h1 style="margin: 0;">Edit Admin Profile</h1>
                    <p style="color: #64748b; margin: 4px 0 0;">Update your primary administrative account details.</p>
                </div>
                <a href="/admin/profileDisplay" class="btn btn-secondary">← Back to Profile</a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="margin-bottom: 24px;">${error}</div>
            </c:if>

            <div class="admin-form-container" style="max-width: 800px;">
                <div class="card" style="padding: 40px;">
                    <h3 style="margin-bottom: 24px; font-weight: 700;">Update Personal Information</h3>
                    <form action="/admin/profile/update" method="post">
                        <input type="hidden" name="userid" value="${userid}">

                        <div class="input-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" value="${username}" required>
                        </div>

                        <div class="input-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" value="${email}" required>
                        </div>

                        <div class="input-group">
                            <label for="password">New Password</label>
                            <input type="password" id="password" name="password" placeholder="Leave blank to keep current password">
                        </div>

                        <div class="input-group">
                            <label for="address">Address / Remarks</label>
                            <textarea id="address" name="address" rows="3" style="width:100%; border: 1px solid var(--border); border-radius: 8px; padding: 12px 16px; font-family: inherit; resize: vertical;">${address}</textarea>
                        </div>

                        <div style="display: flex; gap: 16px; margin-top: 32px; justify-content: flex-end;">
                            <a href="/admin/profileDisplay" class="btn btn-secondary" style="padding: 12px 32px;">Cancel</a>
                            <button type="submit" class="btn btn-primary" style="padding: 12px 32px; background: #4338ca;">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
