<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
        :root {
            --primary: #6366f1;
            --primary-light: #eef2ff;
            --border: #e2e8f0;
            --shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05);
            --radius: 16px;
            --text-main: #1e293b;
            --text-muted: #64748b;
        }

        .page-header {
            background: linear-gradient(135deg, #e0e7ff 0%, #f5f3ff 100%);
            padding: 64px 24px; text-align: center; border-bottom: 1px solid var(--border);
        }
        .filter-bar {
            max-width: 1200px; margin: -32px auto 64px; padding: 0 24px;
            display: flex; gap: 16px; align-items: center; position: relative; z-index: 10;
        }
        .filter-bar input[type="text"] {
            flex: 1; padding: 16px 24px; border-radius: 16px; border: 1px solid var(--border);
            font-size: 1rem; background: white; box-shadow: var(--shadow);
            transition: all 0.3s ease;
        }
        .filter-bar input:focus { outline: none; border-color: var(--primary); transform: translateY(-2px); }

        .product-card {
            background: white; border-radius: var(--radius); border: 1px solid var(--border);
            overflow: hidden; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer; position: relative; display: flex; flex-direction: column;
        }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); }

        .product-img-wrap { height: 200px; position: relative; background: #f8fafc; border-bottom: 1px solid var(--border); }
        .product-img { width: 100%; height: 100%; object-fit: contain; padding: 24px; }
        .product-badge {
            position: absolute; top: 12px; left: 12px; background: rgba(255,255,255,0.9);
            padding: 4px 12px; border-radius: 20px; font-size: 0.7rem; font-weight: 800;
            color: var(--primary); backdrop-filter: blur(4px); border: 1px solid var(--border);
        }

        .product-body { padding: 20px; flex: 1; display: flex; flex-direction: column; }
        .product-name { font-size: 1.1rem; font-weight: 700; color: var(--text-main); margin-bottom: 4px; }
        .product-price { font-size: 1.4rem; font-weight: 800; color: var(--primary); }
        .popularity-tag { font-size: 0.65rem; color: #6366f1; background: #eef2ff; padding: 2px 8px; border-radius: 4px; font-weight: 700; }

        /* Modal Overlay */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(8px);
            display: none; align-items: center; justify-content: center; z-index: 2000;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        .product-modal {
            background: white; border-radius: 24px; max-width: 800px; width: 90%;
            max-height: 90vh; overflow-y: auto; position: relative;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            display: flex; flex-direction: column; animation: slideUp 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        @keyframes slideUp { from { transform: translateY(40px) scale(0.95); opacity: 0; } to { transform: translateY(0) scale(1); opacity: 1; } }

        .modal-header { position: sticky; top: 0; right: 0; padding: 24px; display: flex; justify-content: flex-end; z-index: 10; }
        .btn-close { 
            background: #f1f5f9; border: none; width: 40px; height: 40px; border-radius: 50%;
            font-size: 1.5rem; cursor: pointer; display: flex; align-items: center; justify-content: center;
            transition: all 0.2s; color: var(--text-muted);
        }
        .btn-close:hover { background: #e2e8f0; color: #ef4444; transform: rotate(90deg); }

        .modal-content { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; padding: 0 40px 40px; }
        @media (max-width: 640px) { .modal-content { grid-template-columns: 1fr; gap: 24px; padding: 0 20px 20px; } }

        .modal-img-wrap { background: #f8fafc; border-radius: 20px; padding: 32px; display: flex; align-items: center; justify-content: center; border: 1px solid var(--border); }
        .modal-img { width: 100%; max-height: 300px; object-fit: contain; }

        .modal-info h2 { font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin-bottom: 8px; }
        .modal-category { color: var(--primary); font-weight: 700; font-size: 0.9rem; text-transform: uppercase; margin-bottom: 24px; display: block; }
        .modal-desc { color: var(--text-muted); line-height: 1.6; margin-bottom: 32px; font-size: 1rem; }

        .detail-card { 
            background: #f8fafc; border: 1px solid var(--border); border-radius: 12px;
            padding: 16px; margin-bottom: 24px; display: grid; grid-template-columns: 1fr 1fr; gap: 20px;
        }
        .modal-stat { display: flex; flex-direction: column; gap: 4px; }
        .stat-label { font-size: 0.7rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase; }
        .stat-value { font-size: 1rem; color: var(--text-main); font-weight: 700; }

        .delivery-info {
            background: #f0fdf4; border-radius: 12px; padding: 16px; 
            display: flex; align-items: center; gap: 12px; color: #166534; font-weight: 600; font-size: 0.9rem;
            margin-bottom: 32px;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">🛍️ E-Store</a>
            <ul class="nav-links">
                <li><a href="/">Home</a></li>
                <li><a href="/user/products" style="color: var(--primary); font-weight: 700;">Products</a></li>
                <c:choose>
                    <c:when test="${not empty username}">
                        <li><a href="/buy">Cart 🛒 <c:if test="${cartCount > 0}"><span class="cart-badge">${cartCount}</span></c:if></a></li>
                        <li><a href="/user/orders">My Orders</a></li>
                        <li><a href="/user/profile" class="nav-profile">👤 ${username}</a></li>
                        <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="/login" class="btn btn-nav-login">Login</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>

    <div class="page-header">
        <c:if test="${not empty msg}">
            <div class="alert alert-success" style="position: absolute; top: 100px; left: 50%; transform: translateX(-50%); z-index: 100;">${msg}</div>
        </c:if>
        <h1>Our Collection</h1>
        <p>Premium items selected just for you</p>
    </div>

    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="🔍 Search products..." onkeyup="filterProducts()">
    </div>

    <section class="products-section" style="padding: 0 24px 100px;">
        <div class="products-grid" id="productGrid" style="max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 32px;">
            <c:forEach var="product" items="${products}">
                <div class="product-card" id="card-${product.id}" 
                     onclick="openModal(this)"
                     data-id="${product.id}"
                     data-name="${fn:escapeXml(product.name)}"
                     data-image="${product.image}"
                     data-desc="${fn:escapeXml(product.description)}"
                     data-price="${product.price}"
                     data-qty="${product.quantity}"
                     data-cat="${fn:escapeXml(product.category.name)}"
                     data-weight="${product.weight}"
                     data-orders="${orderCounts[product.id] != null ? orderCounts[product.id] : 0}"
                     data-category="${fn:escapeXml(product.category.name)}">
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
                        <div class="product-price">₹${product.price}</div>
                        <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: auto; padding-top: 12px;">Click for details &rarr;</p>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination remains same -->
        <c:if test="${totalPages > 1}">
            <div style="display: flex; justify-content: center; align-items: center; gap: 24px; margin-top: 64px;">
                <c:if test="${currentPage > 1}">
                    <a href="/user/products?page=${currentPage - 1}" class="btn btn-secondary">← Previous</a>
                </c:if>
                <div style="font-weight: 700; color: var(--text-muted); font-size: 0.9rem;">Page ${currentPage} / ${totalPages}</div>
                <c:if test="${currentPage < totalPages}">
                    <a href="/user/products?page=${currentPage + 1}" class="btn btn-secondary">Next →</a>
                </c:if>
            </div>
        </c:if>
    </section>

    <!-- ===== PRODUCT MODAL ===== -->
    <div class="modal-overlay" id="productModalOverlay" onclick="closeModal(event)">
        <div class="product-modal" onclick="event.stopPropagation()">
            <div class="modal-header">
                <button class="btn-close" onclick="closeModal()">×</button>
            </div>
            <div class="modal-content">
                <div class="modal-img-wrap">
                    <img id="modalImg" src="" class="modal-img" onerror="this.src='/img/placeholder.jpg'">
                </div>
                <div class="modal-info">
                    <span id="modalCategory" class="modal-category"></span>
                    <h2 id="modalName"></h2>
                    <p id="modalDesc" class="modal-desc"></p>
                    
                    <div class="detail-card">
                        <div class="modal-stat">
                            <span class="stat-label">In Stock</span>
                            <span id="modalQty" class="stat-value"></span>
                        </div>
                        <div class="modal-stat">
                            <span class="stat-label">Weight</span>
                            <span id="modalWeight" class="stat-value"></span>
                        </div>
                        <div class="modal-stat">
                            <span class="stat-label">Popularity</span>
                            <span id="modalOrders" class="stat-value" style="color:var(--primary);"></span>
                        </div>
                        <div class="modal-stat">
                            <span class="stat-label">Price</span>
                            <span id="modalPrice" class="stat-value"></span>
                        </div>
                    </div>

                    <div class="delivery-info">
                        🚚 Expected Delivery: Within 3-5 Business Days
                    </div>

                    <div style="display: flex; gap: 16px;">
                        <a id="modalCartLink" href="" class="btn btn-primary" style="flex: 2; padding: 18px; font-weight: 800; border-radius: 12px; text-align: center;">
                            🛒 Add To Cart
                        </a>
                    </div>
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
            document.getElementById('modalQty').textContent = data.qty + ' items';
            document.getElementById('modalCategory').textContent = data.cat;
            document.getElementById('modalWeight').textContent = data.weight + 'g';
            document.getElementById('modalOrders').textContent = '🔥 ' + data.orders + ' Orders';
            document.getElementById('modalCartLink').href = '/user/addtocart?pid=' + data.id;
            
            document.getElementById('productModalOverlay').style.display = 'flex';
            document.body.style.overflow = 'hidden'; // Prevents background scrolling
        }

        function closeModal(e) {
            document.getElementById('productModalOverlay').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function filterProducts() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            const cards = document.querySelectorAll('.product-card');
            cards.forEach(card => {
                const name = card.dataset.name.toLowerCase();
                const category = card.dataset.category.toLowerCase();
                card.style.display = (name.includes(query) || category.includes(query)) ? '' : 'none';
            });
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
                <c:choose>
                    <c:when test="${empty username}">
                        <a href="/login">Login</a>
                        <a href="/register">Register</a>
                    </c:when>
                    <c:otherwise>
                        <a href="/user/orders">My Orders</a>
                        <a href="/buy">Cart</a>
                    </c:otherwise>
                </c:choose>
            </div>
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>