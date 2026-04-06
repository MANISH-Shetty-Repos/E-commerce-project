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
                <a href="/admin/Dashboard">E-Store</a>
                <small>Merchant Command Center</small>
            </div>
            <div class="sidebar-section">Main</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/Dashboard">Dashboard</a></li>
            </ul>
            <div class="sidebar-section">Catalog</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/categories" class="active">Category</a></li>
                <li><a href="/admin/products">Product</a></li>
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
                    <h1 style="margin: 0;">Categories</h1>
                    <p style="color: #64748b; margin: 4px 0 0;">Create and organize your product types.</p>
                </div>
            </div>

            <c:if test="${not empty successMsg}">
                <div class="alert alert-success" style="margin-bottom: 24px; padding: 16px; background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; border-radius: 8px; font-weight: 600;">
                    ${successMsg}
                </div>
            </c:if>

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
                            <th style="width: 80px;">S.No</th>
                            <th>Category Name</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="category" items="${categories}" varStatus="loop">
                            <tr>
                                <td style="font-weight: 600; color: var(--text-muted);">${loop.count}</td>
                                <td>
                                    <form action="/admin/categories/update" method="get"
                                          style="display: flex; gap: 8px; align-items: center;" id="updateForm${category.id}">
                                        <input type="hidden" name="categoryid" value="${category.id}">
                                        <input type="text" name="categoryname" value="${category.name}"
                                               style="padding: 10px 16px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem; flex: 1; max-width: 300px;">
                                        <button type="submit" class="btn-edit" style="padding: 10px 20px;">Update</button>
                                    </form>
                                </td>
                                <td>
                                    <a href="/admin/categories/delete?id=${category.id}" class="btn-delete"
                                       style="padding: 10px 20px;">Delete</a>
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