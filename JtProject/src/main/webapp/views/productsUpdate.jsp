<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - Admin - E-Store</title>
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
                <li><a href="/admin/Dashboard"><span class="nav-icon">📊</span> Dashboard</a></li>
            </ul>
            <div class="sidebar-section">Catalog</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/categories"><span class="nav-icon">📁</span> Categories</a></li>
                <li><a href="/admin/products" class="active"><span class="nav-icon">📦</span> Products</a></li>
                <li><a href="/admin/products/add"><span class="nav-icon">➕</span> Add Product</a></li>
            </ul>
            <div class="sidebar-section">Users</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/customers"><span class="nav-icon">👥</span> Customers</a></li>
            </ul>
            <div class="sidebar-section">Account</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/logout"><span class="nav-icon">🚪</span> Logout</a></li>
            </ul>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="admin-main">
            <div class="admin-topbar">
                <h1>✏️ Edit Product</h1>
                <a href="/admin/products" class="btn btn-secondary">← Back to Products</a>
            </div>

            <div class="admin-form-container">
                <div class="card" style="padding: 32px;">
                    <form action="/admin/products/update/${product.id}" method="post">

                        <div class="input-group">
                            <label for="name">Product Name</label>
                            <input type="text" id="name" name="name"
                                   value="${product.name}" placeholder="Product name" required>
                        </div>

                        <div class="input-group">
                            <label for="categoryid">Category</label>
                            <select id="categoryid" name="categoryid" required
                                    style="width:100%; padding:12px 16px; border-radius:8px; border:1px solid var(--border); font-family:inherit; font-size:1rem; background:white;">
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}"
                                        ${category.id == product.category.id ? 'selected' : ''}>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                            <div class="input-group">
                                <label for="price">Price (₹)</label>
                                <input type="number" id="price" name="price"
                                       value="${product.price}" required min="0">
                            </div>
                            <div class="input-group">
                                <label for="quantity">Quantity</label>
                                <input type="number" id="quantity" name="quantity"
                                       value="${product.quantity}" required min="0">
                            </div>
                            <div class="input-group">
                                <label for="weight">Weight (g)</label>
                                <input type="number" id="weight" name="weight"
                                       value="${product.weight}" required min="0">
                            </div>
                        </div>

                        <div class="input-group">
                            <label for="productImage">Image URL</label>
                            <input type="text" id="productImage" name="productImage"
                                   value="${product.image}"
                                   placeholder="https://example.com/image.jpg"
                                   oninput="previewImage(this.value)">
                            <div id="imagePreview" style="margin-top: 12px;">
                                <img id="previewImg" src="${product.image}" alt="Preview"
                                     style="max-width: 200px; max-height: 150px; border-radius: 8px; border: 1px solid var(--border); object-fit: contain; background: #f8fafc; padding: 8px;"
                                     onerror="this.style.display='none'">
                            </div>
                        </div>

                        <div class="input-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="3"
                                      style="width:100%; padding:12px 16px; border-radius:8px; border:1px solid var(--border); font-family:inherit; font-size:1rem; resize:vertical;">${product.description}</textarea>
                        </div>

                        <div style="display: flex; gap: 12px; margin-top: 8px;">
                            <button type="submit" class="btn btn-primary" style="flex: 1;">Save Changes</button>
                            <a href="/admin/products" class="btn btn-secondary" style="flex: 1; text-align: center;">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        function previewImage(url) {
            const img = document.getElementById('previewImg');
            img.style.display = url ? 'block' : 'none';
            img.src = url;
            img.onerror = function() { this.style.display = 'none'; };
        }
    </script>
</body>
</html>