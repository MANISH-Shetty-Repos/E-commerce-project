<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="E-Store — Shop the latest products at great prices.">
    <title>E-Store — Premium Quality</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/home.css">
    <style>
        .product-card { cursor: pointer; transition: all 0.3s; }
        .product-card:hover { transform: translateY(-8px); }
        .popularity-tag { font-size: 0.65rem; color: #6366f1; background: #eef2ff; padding: 2px 8px; border-radius: 4px; font-weight: 700; }

        /* Modal Layout */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(8px);
            display: none; align-items: center; justify-content: center; z-index: 2000;
            animation: fadeIn 0.3s ease;
        }
        .product-modal {
            background: white; border-radius: 24px; max-width: 800px; width: 90%;
            max-height: 90vh; overflow-y: auto; position: relative;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            display: flex; flex-direction: column; animation: slideUp 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 40px;
        }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideUp { from { transform: translateY(40px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; }
        @media (max-width: 640px) { .modal-grid { grid-template-columns: 1fr; } .product-modal { padding: 20px; } }

        .modal-img-wrap { background: #f8fafc; border-radius: 20px; padding: 24px; border: 1px solid #e2e8f0; }
        .modal-img { width: 100%; max-height: 300px; object-fit: contain; }

        .stat-card { background: #f8fafc; border-radius: 12px; padding: 12px; border: 1px solid #e2e8f0; display: flex; flex-direction: column; }
        .stat-label { font-size: 0.6rem; color: #64748b; font-weight: 700; text-transform: uppercase; }
        .stat-value { font-size: 0.9rem; color: #1e293b; font-weight: 700; }

        .btn-close { 
            position: absolute; top: 20px; right: 20px;
            background: #f1f5f9; border: none; width: 36px; height: 36px; border-radius: 50%;
            font-size: 1.5rem; cursor: pointer; display: flex; align-items: center; justify-content: center;
        }
        .delivery-info { background: #f0fdf4; border-radius: 12px; padding: 16px; color: #166534; font-weight: 600; font-size: 0.85rem; margin: 24px 0; }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">🛍️ E-Store</a>
            <ul class="nav-links">
                <li><a href="/" style="color: var(--primary); font-weight: 700;">Home</a></li>
                <li><a href="/user/products">Products</a></li>
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

    <section class="hero">
        <div class="hero-content">
            <c:if test="${not empty msg}">
                <div class="alert alert-success" style="display: inline-block; margin-bottom: 24px;">${msg}</div>
            </c:if>
            <h1 class="hero-title">Premium Shopping,<br><span class="gradient-text">Delivered to You.</span></h1>
            <p class="hero-subtitle">Explore our curated collection of top products at unbeatable prices.</p>
            <c:if test="${empty username}">
                <div class="hero-actions" style="margin-top: 32px; display: flex; gap: 16px; justify-content: center;">
                    <a href="/user/products" class="btn btn-primary" style="padding: 14px 28px;">Browse Products</a>
                    <a href="/register" class="btn btn-secondary" style="padding: 14px 28px;">Join for Free</a>
                </div>
            </c:if>
        </div>
    </section>

    <section class="products-section">
        <div class="section-header">
            <h2>Featured Products</h2>
            <p>Hand-picked items just for you</p>
        </div>

        <div class="products-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card" 
                     onclick="openModal(this)"
                     data-id="${product.id}"
                     data-name="${fn:escapeXml(product.name)}"
                     data-image="${product.image}"
                     data-desc="${fn:escapeXml(product.description)}"
                     data-price="${product.price}"
                     data-qty="${product.quantity}"
                     data-cat="${fn:escapeXml(product.category.name)}"
                     data-weight="${product.weight}"
                     data-orders="${orderCounts[product.id] != null ? orderCounts[product.id] : 0}">
                    <div class="product-img-wrap">
                        <img src="${not empty product.image ? product.image : 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMDAiIGhlaWdodD0iMjAwIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZDJkOGUwIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtc2l6ZT0iMTgiIGZpbGw9IiM2NDc0OGIiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGRvbWluYW50LWJhc2VsaW5lPSJjZW50cmFsIiBmb250LWZhbWlseT0ic2Fucy1zZXJpZiI+Tm8gSW1hZ2U8L3RleHQ+PC9zdmc+'}" 
                             alt="${fn:escapeXml(product.name)}" 
                             class="product-img" 
                             onerror="this.onerror=null; this.src='data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMDAiIGhlaWdodD0iMjAwIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZDJkOGUwIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtc2l6ZT0iMTgiIGZpbGw9IiM2NDc0OGIiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGRvbWluYW50LWJhc2VsaW5lPSJjZW50cmFsIiBmb250LWZhbWlseT0ic2Fucy1zZXJpZiI+PzwvdGV4dD48L3N2Zz4=';">
                        <span class="product-badge">${product.category.name}</span>
                    </div>
                    <div class="product-body">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 4px;">
                            <h3 class="product-name">${product.name}</h3>
                            <span class="popularity-tag">🔥 ${orderCounts[product.id] != null ? orderCounts[product.id] : 0} Orders</span>
                        </div>
                        <span class="product-price">₹${product.price}</span>
                        <p style="font-size: 0.75rem; color: var(--text-muted); margin-top: 12px;">Click to view details</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- ===== PRODUCT MODAL ===== -->
    <div class="modal-overlay" id="productModalOverlay" onclick="closeModal()">
        <div class="product-modal" onclick="event.stopPropagation()">
            <button class="btn-close" onclick="closeModal()">×</button>
            <div class="modal-grid">
                <div class="modal-img-wrap">
                    <img id="modalImg" src="" class="modal-img">
                </div>
                <div class="modal-info">
                    <span id="modalCategory" style="color:var(--primary); font-weight:700; text-transform:uppercase; font-size:0.8rem;"></span>
                    <h2 id="modalName" style="font-size:1.8rem; font-weight:800; margin-top:4px;"></h2>
                    <p id="modalDesc" style="color:#64748b; line-height:1.6; margin:20px 0; font-size:0.95rem;"></p>
                    
                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                        <div class="stat-card">
                            <span class="stat-label">In Stock</span>
                            <span id="modalQty" class="stat-value"></span>
                        </div>
                        <div class="stat-card">
                            <span class="stat-label">Weight</span>
                            <span id="modalWeight" class="stat-value"></span>
                        </div>
                        <div class="stat-card">
                            <span class="stat-label">Popularity</span>
                            <span id="modalOrders" class="stat-value" style="color:var(--primary);"></span>
                        </div>
                        <div class="stat-card">
                            <span class="stat-label">Price</span>
                            <span id="modalPrice" class="stat-value" style="font-size:1.2rem;"></span>
                        </div>
                    </div>

                    <div class="delivery-info">
                        🚚 Estimated Delivery: Within 3-5 Business Days
                    </div>

                    <a id="modalCartLink" href="" class="btn btn-primary" style="width:100%; display:block; text-align:center; padding:16px; font-weight:800; border-radius:12px;">
                        🛒 Add To Cart
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openModal(el) {
            const data = el.dataset;
            document.getElementById('modalName').textContent = data.name;
            document.getElementById('modalImg').src = data.image;
            document.getElementById('modalDesc').textContent = data.desc;
            document.getElementById('modalPrice').textContent = '₹' + data.price;
            document.getElementById('modalQty').textContent = data.qty + ' Units';
            document.getElementById('modalCategory').textContent = data.cat;
            document.getElementById('modalWeight').textContent = data.weight + 'g';
            document.getElementById('modalOrders').textContent = '🔥 ' + data.orders + ' Orders';
            document.getElementById('modalCartLink').href = '/user/addtocart?pid=' + data.id;
            document.getElementById('productModalOverlay').style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }

        function closeModal() {
            document.getElementById('productModalOverlay').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function toggleMenu() {
            document.querySelector('.nav-links').classList.toggle('open');
        }
    </script>

    <footer class="footer">
        <div class="footer-container">
            <div class="footer-brand">
                <span style="font-size: 1.5rem; font-weight: 800; display: block;">🛍️ E-Store</span>
                <p>Experience premium shopping with unmatched quality and lighting-fast delivery.</p>
            </div>
            <div class="footer-links">
                <a href="/">Home</a>
                <a href="/user/products">Products</a>
                <c:if test="${empty username}">
                    <a href="/login">Login</a>
                    <a href="/register">Register</a>
                </c:if>
                <c:if test="${not empty username}">
                    <a href="/user/orders">My Orders</a>
                    <a href="/buy">Cart</a>
                </c:if>
            </div>
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>