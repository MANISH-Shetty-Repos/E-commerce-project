<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Admin - E-Store</title>
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
                <h1>📦 Products</h1>
                <div class="admin-topbar-actions">
                    <a href="/admin/products/add" class="btn btn-primary">+ Add Product</a>
                </div>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-danger" style="max-width: 600px;">${msg}</div>
            </c:if>

            <div class="data-table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Qty</th>
                            <th>Weight</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${products}">
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <img src="${product.image}" alt="${product.name}"
                                             style="width: 48px; height: 48px; object-fit: contain; border-radius: 8px; background: #f8fafc;"
                                             onerror="this.src='https://placehold.co/48x48/e2e8f0/94a3b8?text=?'">
                                        <div>
                                            <div style="font-weight: 600;">${product.name}</div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted); max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                ${product.description}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge badge-user">${product.category.name}</span>
                                </td>
                                <td style="font-weight: 700; color: var(--primary);">₹${product.price}</td>
                                <td>${product.quantity}</td>
                                <td>${product.weight}g</td>
                                <td>
                                    <div style="display: flex; gap: 6px;">
                                        <a href="/admin/products/update/${product.id}" class="btn-edit">Edit</a>
                                        <a href="/admin/products/delete?id=${product.id}" class="btn-delete"
                                           onclick="return confirm('Delete ${product.name}?')">Delete</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty products}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 48px; color: var(--text-muted);">
                                    No products found. <a href="/admin/products/add" style="color: var(--primary);">Add one now</a>.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- PAGINATION -->
            <c:if test="${totalPages > 1}">
                <div style="display: flex; justify-content: center; gap: 8px; margin-top: 24px;">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="/admin/products?page=${i}"
                           class="btn ${i == currentPage ? 'btn-primary' : 'btn-secondary'}"
                           style="padding: 8px 14px; font-size: 0.85rem;">
                            ${i}
                        </a>
                    </c:forEach>
                </div>
            </c:if>
        </main>
    </div>
</body>
</html>