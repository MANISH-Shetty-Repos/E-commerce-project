<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - Admin - E-Store</title>
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
                <li><a href="/admin/categories" class="active"><span class="nav-icon">📁</span> Categories</a></li>
                <li><a href="/admin/products"><span class="nav-icon">📦</span> Products</a></li>
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
                <h1>📁 Categories</h1>
            </div>

            <!-- ADD CATEGORY FORM -->
            <div class="card" style="margin-bottom: 32px; max-width: 500px;">
                <h3 style="font-size: 1rem; font-weight: 700; margin-bottom: 16px;">Add New Category</h3>
                <form action="/admin/categories" method="post" style="display: flex; gap: 12px; align-items: flex-end;">
                    <div class="input-group" style="flex: 1; margin-bottom: 0;">
                        <label for="categoryname">Category Name</label>
                        <input type="text" id="categoryname" name="categoryname" placeholder="e.g. Electronics" required>
                    </div>
                    <button type="submit" class="btn btn-primary" style="height: 46px;">Add</button>
                </form>
            </div>

            <!-- CATEGORIES TABLE -->
            <div class="data-table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Category Name</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="category" items="${categories}">
                            <tr>
                                <td style="font-weight: 600; color: var(--text-muted);">#${category.id}</td>
                                <td>
                                    <form action="/admin/categories/update" method="get"
                                          style="display: flex; gap: 8px; align-items: center;" id="updateForm${category.id}">
                                        <input type="hidden" name="categoryid" value="${category.id}">
                                        <input type="text" name="categoryname" value="${category.name}"
                                               style="padding: 6px 12px; border: 1px solid var(--border); border-radius: 6px; font-family: inherit; font-size: 0.9rem; width: 200px;">
                                        <button type="submit" class="btn-edit">Update</button>
                                    </form>
                                </td>
                                <td>
                                    <a href="/admin/categories/delete?id=${category.id}" class="btn-delete"
                                       onclick="return confirm('Delete this category?')">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty categories}">
                            <tr>
                                <td colspan="3" style="text-align: center; padding: 48px; color: var(--text-muted);">
                                    No categories yet. Add one above.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>