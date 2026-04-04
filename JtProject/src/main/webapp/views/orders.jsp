<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - Admin - E-Store</title>
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
                <li><a href="/admin/orders" class="active">Orders</a></li>
            </ul>
            <div class="sidebar-section">System</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/profileDisplay">Admin Profile</a></li>
                <li><a href="/admin/logout" style="color: #f87171;">Logout</a></li>
            </ul>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="admin-main">
            <div class="admin-topbar">
                <div class="topbar-left">
                    <h1 style="margin: 0;">Customer Orders</h1>
                    <p style="color: #64748b; margin: 4px 0 0;">Review and manage all store transactions.</p>
                </div>
            </div>

            <!-- SEARCH / FILTER -->
            <div style="margin-bottom: 32px; display: flex; gap: 16px;">
                <input type="text" id="orderSearch" placeholder="Search by Customer Name..." 
                       onkeyup="filterOrders()"
                       style="padding: 12px 20px; border-radius: 12px; border: 1px solid #e2e8f0; font-family: inherit; font-size: 1rem; width: 100%; max-width: 400px; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">
            </div>

            <div class="data-table-wrapper">
                <table class="data-table" id="ordersTable">
                    <thead>
                        <tr>
                            <th style="width: 80px;">S.No</th>
                            <th>Date</th>
                            <th>Customer Name</th>
                            <th>Product(s)</th>
                            <th>Total Amount</th>
                            <th>Payment Method</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}" varStatus="loop">
                            <tr class="order-row">
                                <td style="font-weight: 600; color: #94a3b8;">${loop.count}</td>
                                <td style="font-size: 0.9rem; color: #64748b;">
                                    <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm"/>
                                </td>
                                <td>
                                    <div style="font-weight: 700; color: #1e293b;">${order.user.username}</div>
                                    <div style="font-size: 0.8rem; color: #94a3b8;">#${order.user.id}</div>
                                </td>
                                <td>
                                    <div class="product-names">
                                        <c:forEach var="item" items="${order.orderItems}">
                                            <div style="font-size: 0.9rem; color: #475569; display: flex; align-items: center; gap: 6px;">
                                                <span style="color: #94a3b8;">•</span> ${item.product.name} 
                                                <small style="color: #94a3b8;">(x${item.quantity})</small>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </td>
                                <td style="font-weight: 800; color: #0f172a; font-size: 1rem;">
                                    ₹${order.totalAmount}
                                </td>
                                <td>
                                    <span class="badge" style="background: #f1f5f9; color: #475569;">
                                        ${order.paymentMethod}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orders}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 64px; color: #94a3b8;">
                                    <div style="font-weight: 600; font-size: 1.1rem;">No orders found</div>
                                    <p style="margin-top: 8px;">Orders will appear here once customers start purchasing.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <script>
        function filterOrders() {
            const query = document.getElementById('orderSearch').value.toLowerCase();
            const rows = document.querySelectorAll('.order-row');
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        }
    </script>
</body>
</html>
