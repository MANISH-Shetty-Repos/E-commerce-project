<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body>
    <div class="admin-layout">

        <!-- SIDEBAR -->
        <aside class="admin-sidebar">
            <div class="sidebar-brand">
                <a href="/admin/Dashboard">🛍️ E-Store</a>
                <small>Admin Panel</small>
            </div>
            <div class="sidebar-section">Main</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/Dashboard" class="active"><span class="nav-icon">📊</span> Dashboard</a></li>
            </ul>
            <div class="sidebar-section">Catalog</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/categories"><span class="nav-icon">📁</span> Categories</a></li>
                <li><a href="/admin/products"><span class="nav-icon">📦</span> Products</a></li>
                <li><a href="/admin/products/add"><span class="nav-icon">➕</span> Add Product</a></li>
            </ul>
            <div class="sidebar-section">Users</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/customers"><span class="nav-icon">👥</span> Customers</a></li>
                <li><a href="/admin/user/profile"><span class="nav-icon">👤</span> My Profile</a></li>
            </ul>
            <div class="sidebar-section">Account</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/logout"><span class="nav-icon">🚪</span> Logout</a></li>
            </ul>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="admin-main">
            <div class="admin-topbar">
                <h1>Dashboard</h1>
                <div class="admin-topbar-actions">
                    <span style="color: var(--text-muted); font-size: 0.9rem;">Welcome, <strong>${admin}</strong></span>
                </div>
            </div>

            <!-- QUICK STATS -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📦</div>
                    <div class="stat-value" id="productCount">—</div>
                    <div class="stat-label">Products</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📁</div>
                    <div class="stat-value" id="categoryCount">—</div>
                    <div class="stat-label">Categories</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-value" id="customerCount">—</div>
                    <div class="stat-label">Customers</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🛒</div>
                    <div class="stat-value" id="orderCount">—</div>
                    <div class="stat-label">Orders</div>
                </div>
            </div>

            <!-- QUICK ACTIONS -->
            <h2 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 20px;">Quick Actions</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px;">
                <a href="/admin/products/add" class="card" style="text-decoration: none; text-align: center; padding: 32px 16px; transition: transform 0.2s, box-shadow 0.2s;">
                    <div style="font-size: 2rem; margin-bottom: 8px;">➕</div>
                    <div style="font-weight: 600; color: var(--text-main);">Add Product</div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Create a new listing</div>
                </a>
                <a href="/admin/categories" class="card" style="text-decoration: none; text-align: center; padding: 32px 16px; transition: transform 0.2s, box-shadow 0.2s;">
                    <div style="font-size: 2rem; margin-bottom: 8px;">📁</div>
                    <div style="font-weight: 600; color: var(--text-main);">Categories</div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Manage categories</div>
                </a>
                <a href="/admin/customers" class="card" style="text-decoration: none; text-align: center; padding: 32px 16px; transition: transform 0.2s, box-shadow 0.2s;">
                    <div style="font-size: 2rem; margin-bottom: 8px;">👥</div>
                    <div style="font-weight: 600; color: var(--text-main);">Customers</div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">View all users</div>
                </a>
                <a href="/admin/products" class="card" style="text-decoration: none; text-align: center; padding: 32px 16px; transition: transform 0.2s, box-shadow 0.2s;">
                    <div style="font-size: 2rem; margin-bottom: 8px;">📊</div>
                    <div style="font-weight: 600; color: var(--text-main);">Inventory</div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Manage stock</div>
                </a>
            </div>
        </main>
    </div>

    <style>
        .card:hover { transform: translateY(-4px); box-shadow: var(--shadow); }
    </style>
</body>
</html>