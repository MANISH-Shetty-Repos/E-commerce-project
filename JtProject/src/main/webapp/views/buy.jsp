<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/home.css">
    <style>
        .cart-container { max-width: 900px; margin: 48px auto; padding: 0 24px; }
        .cart-title { font-size: 1.75rem; font-weight: 800; letter-spacing: -0.025em; margin-bottom: 32px; }

        .cart-table { width: 100%; border-collapse: collapse; }
        .cart-table th {
            text-align: left; padding: 12px 16px;
            font-size: 0.8rem; font-weight: 600; color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 0.05em;
            border-bottom: 2px solid var(--border);
        }
        .cart-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid var(--border); }
        .cart-table tr:last-child td { border-bottom: none; }

        .product-thumb { width: 64px; height: 64px; object-fit: contain; border-radius: 8px; background: #f8fafc; }
        .product-info-name { font-weight: 600; color: var(--text-main); }
        .product-info-cat { font-size: 0.8rem; color: var(--text-muted); }
        .item-price { font-weight: 700; color: var(--primary); }

        .cart-summary {
            margin-top: 32px; padding: 24px; background: white;
            border-radius: var(--radius); border: 1px solid var(--border);
            display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;
        }
        .cart-total { font-size: 1.5rem; font-weight: 800; color: var(--text-main); }
        .cart-total span { color: var(--primary); }

        .cart-actions { display: flex; gap: 12px; flex-wrap: wrap; }

        .btn-danger-outline {
            background: white; color: var(--danger);
            border: 1px solid var(--danger);
            padding: 10px 20px; border-radius: var(--radius); font-weight: 600;
            cursor: pointer; text-decoration: none; font-size: 0.9rem; transition: all 0.2s;
        }
        .btn-danger-outline:hover { background: var(--danger); color: white; }
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
                <li><a href="/buy" style="color: var(--primary); font-weight: 600;">Cart 🛒</a></li>
                <li><a href="/user/orders">My Orders</a></li>
                <li><a href="/user/profile" class="nav-profile">👤 ${username}</a></li>
                <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
            </ul>
            <button class="hamburger" onclick="document.querySelector('.nav-links').classList.toggle('open')">☰</button>
        </div>
    </nav>

    <div class="cart-container">
        <h1 class="cart-title">🛒 Shopping Cart</h1>

        <c:choose>
            <c:when test="${not empty cartProducts}">
                <div class="card" style="padding: 0; overflow: hidden;">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="total" value="0"/>
                            <c:forEach var="product" items="${cartProducts}">
                                <c:set var="total" value="${total + product.price}"/>
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 12px;">
                                            <img src="${product.image}" alt="${product.name}" class="product-thumb"
                                                 onerror="this.src='https://placehold.co/64x64/e2e8f0/94a3b8?text=?'">
                                            <div>
                                                <div class="product-info-name">${product.name}</div>
                                                <div class="product-info-cat">${product.description}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span style="background:#f1f5f9; padding:3px 10px; border-radius:20px; font-size:0.8rem; color:var(--text-muted);">${product.category.name}</span></td>
                                    <td class="item-price">₹${product.price}</td>
                                    <td>
                                        <a href="/removeFromCart?pid=${product.id}" class="btn-danger-outline">Remove</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="cart-summary">
                    <div>
                        <div style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 4px;">${fn:length(cartProducts)} item(s) in cart</div>
                        <div class="cart-total">Total: <span>₹${total}</span></div>
                    </div>
                    <div class="cart-actions">
                        <a href="/user/products" class="btn btn-secondary">← Continue Shopping</a>
                        <form action="/user/checkout" method="post">
                            <button type="submit" class="btn btn-primary">Place Order →</button>
                        </form>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card" style="text-align: center; padding: 80px 24px;">
                    <div style="font-size: 4rem; margin-bottom: 16px;">🛒</div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 8px;">Your cart is empty</h3>
                    <p style="color: var(--text-muted); margin-bottom: 28px;">Browse our products and add items to get started.</p>
                    <a href="/user/products" class="btn btn-primary">Browse Products</a>
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
