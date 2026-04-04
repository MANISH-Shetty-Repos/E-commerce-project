<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - Admin - E-Store</title>
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
                <li><a href="/admin/products" class="active">Product</a></li>
                <li><a href="/admin/customers">Customers</a></li>
                <li><a href="/admin/orders">Orders</a></li>
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
                <h1>Add New Product</h1>
                <a href="/admin/products" class="btn btn-secondary">← Back to Products</a>
            </div>

            <div class="admin-form-container" style="max-width: 1000px;">
                <form action="/admin/products/add" method="post">
                    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px; align-items: start;">
                        
                        <!-- Left Column: Basic Details -->
                        <div class="card" style="padding: 32px;">
                            <h3 style="margin-bottom: 24px; font-weight: 700; color: #1e293b; border-bottom: 1px solid #e2e8f0; padding-bottom: 12px;">Basic Details</h3>
                            
                            <div class="input-group">
                                <label for="name">Product Name</label>
                                <input type="text" id="name" name="name" placeholder="e.g. Wireless Headphones" required>
                            </div>

                            <div class="input-group">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" rows="6"
                                          placeholder="Describe the product features and details..."
                                          style="width:100%; padding:12px 16px; border-radius:8px; border:1px solid var(--border); font-family:inherit; font-size:1rem; resize:vertical;"></textarea>
                            </div>
                            
                            <div class="input-group" style="margin-bottom: 0;">
                                <label for="categoryid">Category</label>
                                <select id="categoryid" name="categoryid" required
                                        style="width:100%; padding:12px 16px; border-radius:8px; border:1px solid var(--border); font-family:inherit; font-size:1rem; background:white;">
                                    <option value="" disabled selected>Select a category</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.id}">${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Right Column: Pricing & Media -->
                        <div style="display: flex; flex-direction: column; gap: 24px;">
                            
                            <div class="card" style="padding: 32px;">
                                <h3 style="margin-bottom: 24px; font-weight: 700; color: #1e293b; border-bottom: 1px solid #e2e8f0; padding-bottom: 12px;">Pricing & Inventory</h3>
                                
                                <div class="input-group">
                                    <label for="price">Price (₹)</label>
                                    <input type="number" id="price" name="price" placeholder="499" required min="0">
                                </div>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                    <div class="input-group" style="margin-bottom: 0;">
                                        <label for="quantity">Stock</label>
                                        <input type="number" id="quantity" name="quantity" placeholder="50" required min="0">
                                    </div>
                                    <div class="input-group" style="margin-bottom: 0;">
                                        <label for="weight">Weight (g)</label>
                                        <input type="number" id="weight" name="weight" placeholder="250" required min="0">
                                    </div>
                                </div>
                            </div>

                            <div class="card" style="padding: 32px;">
                                <h3 style="margin-bottom: 24px; font-weight: 700; color: #1e293b; border-bottom: 1px solid #e2e8f0; padding-bottom: 12px;">Media</h3>
                                <div class="input-group" style="margin-bottom: 0;">
                                    <label for="productImage">Image URL</label>
                                    <input type="text" id="productImage" name="productImage"
                                           placeholder="https://example.com/image.jpg"
                                           oninput="previewImage(this.value)">
                                    <div id="imagePreview" style="margin-top: 16px; display: none; text-align: center; background: #f8fafc; border-radius: 8px; border: 1px dashed #cbd5e1; padding: 16px;">
                                        <img id="previewImg" src="" alt="Preview"
                                             style="max-width: 100%; max-height: 150px; object-fit: contain;">
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 16px; margin-top: 32px;">
                        <a href="/admin/products" class="btn btn-secondary" style="padding: 12px 32px;">Cancel</a>
                        <button type="submit" class="btn btn-primary" style="padding: 12px 48px; background: #4338ca;">Save Product</button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script>
        function previewImage(url) {
            const preview = document.getElementById('imagePreview');
            const img = document.getElementById('previewImg');
            if (url) {
                img.src = url;
                preview.style.display = 'block';
                img.onerror = function() { preview.style.display = 'none'; };
            } else {
                preview.style.display = 'none';
            }
        }
    </script>
</body>
</html>