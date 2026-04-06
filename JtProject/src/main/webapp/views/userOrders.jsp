<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/home.css">
    <style>
        .orders-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
            min-height: 60vh;
        }
        .orders-header {
            margin-bottom: 32px;
        }
        .orders-header h1 {
            font-size: 2rem;
            font-weight: 800;
            color: #1e293b;
            margin: 0;
        }
        .orders-header p {
            color: #64748b;
            margin-top: 8px;
            font-size: 1rem;
        }
        
        .data-table-wrapper {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            border: 1px solid #f1f5f9;
            overflow: hidden;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .data-table th {
            background: #f8fafc;
            padding: 16px 24px;
            font-size: 0.85rem;
            font-weight: 700;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 2px solid #e2e8f0;
        }

        .data-table td {
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        .data-table tr:hover {
            background: #f8fafc;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
        }

        .btn-cancel {
            background: #fef2f2;
            color: #ef4444;
            border: 1px solid #fee2e2;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-cancel:hover {
            background: #ef4444;
            color: white;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">E-Store</a>
            <ul class="nav-links">
                <li><a href="/">Home</a></li>
                <li><a href="/user/products">Products</a></li>
                <c:choose>
                    <c:when test="${not empty username}">
                        <li><a href="/buy">Cart <c:if test="${cartCount > 0}"><span class="cart-badge">${cartCount}</span></c:if></a></li>
                        <li><a href="/user/orders" style="color: var(--primary); font-weight: 700;">My Orders</a></li>
                        <li><a href="/user/profile" class="nav-profile">${username}</a></li>
                        <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="/login" class="btn btn-nav-login">Login</a></li>
                        <li><a href="/register" class="btn btn-nav-register">Sign Up</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>

    <div class="orders-container">
        <div class="orders-header">
            <h1>My Orders</h1>
            <p>Track, review, and manage your recent purchases.</p>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success" style="margin-bottom: 24px; padding: 16px; background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; border-radius: 8px; font-weight: 600;">
                ${msg}
            </div>
        </c:if>

        <div class="data-table-wrapper">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 60px;">S.No</th>
                        <th>Date</th>
                        <th>Product Details</th>
                        <th>Total Amount</th>
                        <th>Payment Method</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}" varStatus="loop">
                        <tr>
                            <td style="font-weight: 700; color: #64748b;">${loop.count}</td>
                            <td style="font-size: 0.9rem; color: #475569;">
                                <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy"/>
                            </td>
                            <td>
                                <div style="display: flex; flex-direction: column; gap: 8px;">
                                    <c:forEach var="item" items="${order.orderItems}">
                                        <div style="display: flex; align-items: center; gap: 12px;">
                                            <img src="${item.product.image}" alt="Product" style="width: 40px; height: 40px; border-radius: 8px; object-fit: contain; border: 1px solid #e2e8f0;">
                                            <div>
                                                <div style="font-weight: 600; color: #1e293b; font-size: 0.9rem;">${item.product.name}</div>
                                                <div style="font-size: 0.8rem; color: #94a3b8;">Qty: ${item.quantity} × ₹${item.priceAtPurchase}</div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </td>
                            <td style="font-weight: 800; color: #0f172a; font-size: 1.1rem;">
                                ₹${order.totalAmount}
                            </td>
                            <td>
                                <span class="badge" style="background: #eef2ff; color: #4338ca;">
                                    ${order.paymentMethod}
                                </span>
                            </td>
                            <td style="text-align: right;">
                                <form action="/user/order/cancel" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to cancel this order? This cannot be undone.');">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <button type="submit" class="btn-cancel">Cancel Order</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 64px; color: #94a3b8;">
                                <div style="font-size: 3rem; margin-bottom: 16px; color:#cbd5e1;">📋</div>
                                <div style="font-weight: 600; font-size: 1.1rem;">No orders found</div>
                                <p style="margin-top: 8px;">Looks like you haven't bought anything yet.</p>
                                <a href="/user/products" class="btn btn-primary" style="margin-top: 20px; display: inline-block;">Start Shopping</a>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="footer" style="margin-top: auto;">
        <div class="footer-container">
            <div class="footer-brand">
                <span style="font-size: 1.5rem; font-weight: 800; display: block;">E-Store</span>
                <p>Experience premium shopping with unmatched quality and lighting-fast delivery.</p>
            </div>
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
