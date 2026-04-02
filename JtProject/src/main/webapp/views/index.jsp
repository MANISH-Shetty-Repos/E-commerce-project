<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="E-Store — Shop the latest products at great prices.">
    <title>E-Store — Shop Now</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/home.css">
</head>
<body>

    <!-- ===== NAVBAR ===== -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">🛍️ E-Store</a>

            <ul class="nav-links">
                <li><a href="/">Home</a></li>
                <li><a href="/user/products">Products</a></li>
                <c:choose>
                    <c:when test="${not empty username}">
                        <li><a href="/buy">Cart 🛒</a></li>
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

            <!-- Mobile hamburger -->
            <button class="hamburger" onclick="toggleMenu()" id="hamburgerBtn">☰</button>
        </div>
    </nav>

    <!-- ===== HERO SECTION ===== -->
    <section class="hero">
        <div class="hero-content">
            <h1 class="hero-title">Premium Shopping,<br><span class="gradient-text">Delivered to You.</span></h1>
            <p class="hero-subtitle">Explore our curated collection of top products at unbeatable prices.</p>
            <c:if test="${empty username}">
                <div class="hero-actions">
                    <a href="/user/products" class="btn btn-primary">Browse Products</a>
                    <a href="/register" class="btn btn-secondary">Join for Free</a>
                </div>
            </c:if>
        </div>
    </section>

    <!-- ===== PRODUCT GRID ===== -->
    <section class="products-section">
        <div class="section-header">
            <h2>Featured Products</h2>
            <p>Hand-picked items just for you</p>
        </div>

        <div class="products-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <div class="product-img-wrap">
                        <img src="${product.image}" alt="${product.name}" class="product-img"
                             onerror="this.src='https://placehold.co/300x200/e2e8f0/94a3b8?text=No+Image'">
                        <span class="product-badge">${product.category.name}</span>
                    </div>
                    <div class="product-body">
                        <h3 class="product-name">${product.name}</h3>
                        <p class="product-desc">${product.description}</p>
                        <div class="product-footer">
                            <span class="product-price">₹${product.price}</span>
                            <a href="/user/addtocart?pid=${product.id}" class="btn btn-primary btn-sm">
                                🛒 Add to Cart
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <!-- Empty state -->
            <c:if test="${empty products}">
                <div class="empty-state">
                    <div style="font-size: 4rem;">🛍️</div>
                    <h3>No products yet</h3>
                    <p>Check back soon — new items are being added.</p>
                </div>
            </c:if>
        </div>
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
            const links = document.querySelector('.nav-links');
            links.classList.toggle('open');
        }
    </script>
</body>
</html>