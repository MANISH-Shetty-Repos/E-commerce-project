<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - E-Store</title>
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
                    <h1 style="margin: 0;">Admin Profile</h1>
                    <p style="color: #64748b; margin: 4px 0 0;">Manage your primary administrative account details.</p>
                </div>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-success" style="margin-bottom: 24px;">${msg}</div>
            </c:if>

            <div class="admin-form-container" style="max-width: 800px;">
                <div class="card" style="padding: 40px;">
                    <div style="display: flex; align-items: center; gap: 24px; margin-bottom: 32px; padding-bottom: 32px; border-bottom: 1px solid #e2e8f0;">
                        <div style="width: 80px; height: 80px; border-radius: 20px; background: #e0e7ff; color: #4338ca; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 800;">
                            ${username.substring(0,1).toUpperCase()}
                        </div>
                        <div>
                            <h2 style="font-size: 1.5rem; font-weight: 800; color: #1e293b; margin-bottom: 4px;">${username}</h2>
                            <span class="badge" style="background: #eef2ff; color: #4338ca;">Premium Administrator</span>
                        </div>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 24px; margin-bottom: 40px;">
                        <div style="display: grid; grid-template-columns: 150px 1fr; align-items: center;">
                            <span style="font-weight: 600; color: #64748b;">System ID</span>
                            <span style="font-weight: 700; color: #1e293b;">#${userid}</span>
                        </div>
                        <div style="display: grid; grid-template-columns: 150px 1fr; align-items: center;">
                            <span style="font-weight: 600; color: #64748b;">Email Address</span>
                            <span style="color: #1e293b;">${email}</span>
                        </div>
                        <div style="display: grid; grid-template-columns: 150px 1fr; align-items: start;">
                            <span style="font-weight: 600; color: #64748b; margin-top: 4px;">Role / Status</span>
                            <span style="color: #10b981; font-weight: 600; display: flex; align-items: center; gap: 6px;">
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: #10b981; display: inline-block;"></span> Active
                            </span>
                        </div>
                        <div style="display: grid; grid-template-columns: 150px 1fr; align-items: start;">
                            <span style="font-weight: 600; color: #64748b;">Physical Address</span>
                            <span style="color: #475569; line-height: 1.5;">${not empty address ? address : '—'}</span>
                        </div>
                    </div>

                    <div style="display: flex; justify-content: flex-end; padding-top: 24px; border-top: 1px solid #e2e8f0;">
                        <a href="/admin/profile/edit" class="btn btn-primary" style="padding: 12px 32px; background: #1e293b; color: white;">Update Profile Information</a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
