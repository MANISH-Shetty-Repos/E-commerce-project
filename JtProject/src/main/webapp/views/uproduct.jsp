<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Browse all available products on E-Store.">
    <title>All Products - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/home.css">
    <style>
        /* Page-specific styles for product listing */
        .page-header {
            background: linear-gradient(135deg, #e0e7ff 0%, #f5f3ff 100%);
            padding: 48px 24px;
            text-align: center;
            border-bottom: 1px solid var(--border);
        }
        .page-header h1 {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-main);
            letter-spacing: -0.025em;
        }
        .page-header p { color: var(--text-muted); margin-top: 8px; }

        .filter-bar {
            max-width: 1200px;
            margin: 32px auto 0;
            padding: 0 24px;
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-bar input[type="text"] {
            flex: 1;
            min-width: 200px;
            padding: 10px 16px;
            border-radius: 8px;
            border: 1px solid var(--border);
            font-family: inherit;
            font-size: 0.95rem;
        }
        .filter-bar input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99,102,241,0.1);
        }
        .product-count {
            color: var(--text-muted);
            font-size: 0.875rem;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <!-- ===== NAVBAR ===== -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">🛍️ E-Store</a>
            <ul class="nav-links">
                <li><a href="/">Home</a></li>
                <li><a href="/user/products" style="color: var(--primary); font-weight: 600;">Products</a></li>
                <c:choose>
                    <c:when test="${not empty username}">
                        <li><a href="/buy">Cart 🛒 <c:if test="${cartCount > 0}"><span class="cart-badge">${cartCount}</span></c:if></a></li>
                        <li><a href="/user/orders">My Orders</a></li>
                        <li><a href="/user/profile" class="nav-profile">👤 ${username}</a></li>
                        <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="/login" class="btn btn-nav-login">Login</a></li>
                        <li><a href="/register" class="btn btn-nav-register">Sign Up</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
            <button class="hamburger" onclick="toggleMenu()">☰</button>
        </div>
    </nav>

    <!-- ===== PAGE HEADER ===== -->
    <div class="page-header">
        <c:if test="${not empty msg}">
            <div class="alert alert-success" style="display: inline-block; margin: 0 auto 24px; max-width: 600px; text-align: center;">${msg}</div>
        </c:if>
        <h1>All Products</h1>
        <p>Find everything you need in one place</p>
    </div>

    <!-- ===== FILTER BAR ===== -->
    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="🔍  Search products by name..." onkeyup="filterProducts()">
        <span class="product-count" id="productCount"></span>
    </div>

    <!-- ===== PRODUCT GRID ===== -->
    <section class="products-section" style="padding-top: 32px;">
        <div class="products-grid" id="productGrid">
            <c:forEach var="product" items="${products}">
                <div class="product-card" data-name="${product.name}" data-category="${product.category.name}">
                    <div class="product-img-wrap">
                        <img src="${product.image}" alt="${product.name}" class="product-img"
                             onerror="this.src='https://placehold.co/300x200/e2e8f0/94a3b8?text=${product.name}'">
                        <span class="product-badge">${product.category.name}</span>
                    </div>
                    <div class="product-body">
                        <h3 class="product-name">${product.name}</h3>
                        <p class="product-desc">${product.description}</p>

                        <div style="display: flex; gap: 8px; margin-bottom: 16px; flex-wrap: wrap;">
                            <span style="font-size: 0.78rem; background: #f1f5f9; color: var(--text-muted); padding: 3px 10px; border-radius: 20px; font-weight: 500;">
                                Qty: ${product.quantity}
                            </span>
                            <span style="font-size: 0.78rem; background: #f1f5f9; color: var(--text-muted); padding: 3px 10px; border-radius: 20px; font-weight: 500;">
                                Weight: ${product.weight}g
                            </span>
                        </div>

                        <div class="product-footer">
                            <span class="product-price">₹${product.price}</span>
                            <a href="/user/addtocart?pid=${product.id}" class="btn btn-primary btn-sm">
                                🛒 Add to Cart
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty products}">
                <div class="empty-state">
                    <div style="font-size: 4rem;">📦</div>
                    <h3>No products available</h3>
                    <p>New products are being added — check back soon!</p>
                </div>
            </c:if>
        </div>

        <!-- ===== PAGINATION ===== -->
        <c:if test="${totalPages > 1}">
            <div style="display: flex; justify-content: center; align-items: center; gap: 16px; margin-top: 48px;">
                <c:if test="${currentPage > 1}">
                    <a href="/user/products?page=${currentPage - 1}" class="btn btn-secondary btn-sm">← Previous</a>
                </c:if>
                
                <span class="product-count">Page ${currentPage} of ${totalPages}</span>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="/user/products?page=${currentPage + 1}" class="btn btn-secondary btn-sm">Next →</a>
                </c:if>
            </div>
        </c:if>
    </section>

    <!-- ===== FOOTER ===== -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-brand">
                <span style="font-size: 1.5rem; font-weight: 800;">🛍️ E-Store</span>
                <p>Your trusted online marketplace.</p>
            </div>
            <div class="footer-links">
                <a href="/">Home</a>
                <a href="/user/products">Products</a>
                <c:if test="${empty username}">
                    <a href="/login">Login</a>
                    <a href="/register">Register</a>
                </c:if>
            </div>
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>

    <script>
        function toggleMenu() {
            document.querySelector('.nav-links').classList.toggle('open');
        }

        function filterProducts() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            const cards = document.querySelectorAll('.product-card');
            let visible = 0;
            cards.forEach(card => {
                const name = card.dataset.name.toLowerCase();
                const category = card.dataset.category.toLowerCase();
                const match = name.includes(query) || category.includes(query);
                card.style.display = match ? '' : 'none';
                if (match) visible++;
            });
            document.getElementById('productCount').textContent =
                visible + ' product' + (visible !== 1 ? 's' : '') + ' found';
        }

        // Run on load to show total count
        window.onload = () => {
            const total = document.querySelectorAll('.product-card').length;
            document.getElementById('productCount').textContent =
                total + ' product' + (total !== 1 ? 's' : '') + ' available';
        };
    </script>
</body>
</html>