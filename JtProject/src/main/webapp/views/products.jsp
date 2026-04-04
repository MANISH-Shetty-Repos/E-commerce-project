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
                <div class="topbar-left">
                    <h1 style="margin: 0;">Products</h1>
                    <p style="color: #64748b; margin: 4px 0 0;">Manage your store's inventory and stock levels.</p>
                </div>
                <div class="admin-topbar-actions">
                    <a href="/admin/products/add" class="btn btn-primary" style="padding: 10px 24px; font-weight: 700; background: #4338ca; border-radius: 10px;">Add New Product</a>
                </div>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-danger" style="margin-bottom: 24px;">${msg}</div>
            </c:if>

            <div class="data-table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width: 60px; padding-left: 24px;">S.No</th>
                            <th style="padding-left: 12px;">Product Details</th>
                            <th style="padding-left: 20px;">Category</th>
                            <th style="padding-left: 20px;">Price</th>
                            <th style="padding-left: 20px;">Stock</th>
                            <th style="text-align: right; padding-right: 24px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${products}" varStatus="loop">
                            <tr>
                                <td style="font-weight: 600; color: #94a3b8; padding-left: 24px;">${loop.count}</td>
                                <td style="padding-left: 12px;">
                                    <div style="display: flex; align-items: center; gap: 16px;">
                                        <img src="${product.image}" alt="${product.name}"
                                             style="width: 56px; height: 56px; object-fit: contain; border-radius: 12px; background: #f1f5f9; border: 1px solid #e2e8f0;"
                                             onerror="this.src='https://placehold.co/56x56/f1f5f9/94a3b8?text=?'">
                                        <div>
                                            <div style="font-weight: 700; color: #1e293b; font-size: 1rem;">${product.name}</div>
                                            <div style="font-size: 0.8rem; color: #64748b; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                ${product.description}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td style="padding-left: 20px;">
                                    <span class="badge badge-user" style="padding: 6px 12px; background: #e0e7ff; color: #4338ca;">${product.category.name}</span>
                                </td>
                                <td style="padding-left: 20px; font-weight: 800; color: #0f172a; font-size: 1.05rem;">₹${product.price}</td>
                                <td style="padding-left: 20px;">
                                    <c:choose>
                                        <c:when test="${product.quantity <= 0}">
                                            <span style="color: #ef4444; font-weight: 700;">Out of Stock</span>
                                        </c:when>
                                        <c:when test="${product.quantity < 10}">
                                            <span style="color: #f59e0b; font-weight: 700;">Low Stock (${product.quantity})</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #059669; font-weight: 600;">${product.quantity} units</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <div style="font-size: 0.75rem; color: #94a3b8;">${product.weight}g</div>
                                </td>
                                <td style="text-align: right; padding-right: 24px;">
                                    <div style="display: flex; gap: 8px; justify-content: flex-end;">
                                        <a href="/admin/products/update/${product.id}" class="btn-edit" style="padding: 8px 16px;">Edit</a>
                                        <a href="/admin/products/delete?id=${product.id}" class="btn-delete"
                                           onclick="return confirm('Delete ${product.name}?')" style="padding: 8px 16px;">Delete</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty products}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 64px; color: #94a3b8;">
                                    <div style="font-size: 3rem; margin-bottom: 16px;">📦</div>
                                    <div style="font-weight: 600; font-size: 1.1rem;">No products found</div>
                                    <p style="margin-top: 8px;">Start by adding some items to your inventory.</p>
                                    <a href="/admin/products/add" class="btn btn-primary" style="margin-top: 20px;">+ Add Product</a>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- PAGINATION -->
            <c:if test="${totalPages > 1}">
                <div style="display: flex; justify-content: center; gap: 10px; margin-top: 32px;">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="/admin/products?page=${i}"
                           class="btn ${i == currentPage ? 'btn-primary' : 'btn-secondary'}"
                           style="padding: 10px 18px; font-weight: 600; border-radius: 8px;">
                            ${i}
                        </a>
                    </c:forEach>
                </div>
            </c:if>
        </main>
    </div>
</body>
</html>