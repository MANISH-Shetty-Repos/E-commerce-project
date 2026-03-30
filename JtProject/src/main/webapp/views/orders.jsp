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
        .orders-container { max-width: 960px; margin: 48px auto; padding: 0 24px; }
        .orders-title { font-size: 1.75rem; font-weight: 800; letter-spacing: -0.025em; margin-bottom: 32px; }

        .order-card {
            background: white; border-radius: var(--radius); border: 1px solid var(--border);
            margin-bottom: 24px; overflow: hidden;
            transition: box-shadow 0.3s;
        }
        .order-card:hover { box-shadow: var(--shadow); }

        .order-header {
            display: flex; justify-content: space-between; align-items: center;
            padding: 20px 24px; background: #f8fafc; border-bottom: 1px solid var(--border);
            flex-wrap: wrap; gap: 12px;
        }
        .order-id { font-weight: 700; color: var(--text-main); font-size: 1rem; }
        .order-date { font-size: 0.85rem; color: var(--text-muted); }
        .order-total {
            font-weight: 800; font-size: 1.1rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
        }

        .order-items { padding: 0; }
        .order-item {
            display: flex; align-items: center; padding: 16px 24px;
            border-bottom: 1px solid var(--border); gap: 16px;
        }
        .order-item:last-child { border-bottom: none; }
        .order-item-img {
            width: 56px; height: 56px; object-fit: contain;
            border-radius: 8px; background: #f1f5f9; flex-shrink: 0;
        }
        .order-item-name { font-weight: 600; color: var(--text-main); font-size: 0.95rem; }
        .order-item-meta { font-size: 0.8rem; color: var(--text-muted); }
        .order-item-price { margin-left: auto; font-weight: 700; color: var(--primary); white-space: nowrap; }
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
                <li><a href="/user/orders" style="color: var(--primary); font-weight: 600;">My Orders</a></li>
                <li><a href="/user/profile" class="nav-profile">👤 Profile</a></li>
                <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
            </ul>
            <button class="hamburger" onclick="document.querySelector('.nav-links').classList.toggle('open')">☰</button>
        </div>
    </nav>

    <div class="orders-container">
        <h1 class="orders-title">📦 My Orders</h1>

        <c:choose>
            <c:when test="${not empty orders}">
                <c:forEach var="order" items="${orders}">
                    <div class="order-card">
                        <div class="order-header">
                            <div>
                                <div class="order-id">Order #${order.id}</div>
                                <div class="order-date">
                                    <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
                                </div>
                            </div>
                            <div class="order-total">₹${order.totalAmount}</div>
                        </div>

                        <div class="order-items">
                            <c:forEach var="item" items="${order.orderItems}">
                                <div class="order-item">
                                    <img src="${item.product.image}" alt="${item.product.name}" class="order-item-img"
                                         onerror="this.src='https://placehold.co/56x56/e2e8f0/94a3b8?text=?'">
                                    <div>
                                        <div class="order-item-name">${item.product.name}</div>
                                        <div class="order-item-meta">Qty: ${item.quantity}</div>
                                    </div>
                                    <div class="order-item-price">₹${item.priceAtPurchase}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="card" style="text-align: center; padding: 80px 24px;">
                    <div style="font-size: 4rem; margin-bottom: 16px;">📦</div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 8px;">No orders yet</h3>
                    <p style="color: var(--text-muted); margin-bottom: 28px;">Once you place an order, it will appear here.</p>
                    <a href="/user/products" class="btn btn-primary">Start Shopping</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <footer class="footer">
        <div class="footer-container">
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
