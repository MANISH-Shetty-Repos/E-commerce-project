<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customers - Admin - E-Store</title>
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
                <li><a href="/admin/products"><span class="nav-icon">📦</span> Products</a></li>
                <li><a href="/admin/products/add"><span class="nav-icon">➕</span> Add Product</a></li>
            </ul>
            <div class="sidebar-section">Users</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/customers" class="active"><span class="nav-icon">👥</span> Customers</a></li>
            </ul>
            <div class="sidebar-section">Account</div>
            <ul class="sidebar-nav">
                <li><a href="/admin/logout"><span class="nav-icon">🚪</span> Logout</a></li>
            </ul>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="admin-main">
            <div class="admin-topbar">
                <h1>👥 Customers</h1>
                <div style="color: var(--text-muted); font-size: 0.9rem;">
                    ${customers.size()} registered users
                </div>
            </div>

            <!-- SEARCH -->
            <div style="margin-bottom: 20px;">
                <input type="text" id="customerSearch" placeholder="🔍  Search by name or email..."
                       onkeyup="filterCustomers()"
                       style="padding: 10px 16px; border-radius: 8px; border: 1px solid var(--border); font-family: inherit; font-size: 0.95rem; width: 100%; max-width: 400px;">
            </div>

            <div class="data-table-wrapper">
                <table class="data-table" id="customersTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th>Role</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="customer" items="${customers}">
                            <tr>
                                <td style="font-weight: 600; color: var(--text-muted);">#${customer.id}</td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <div style="width: 36px; height: 36px; border-radius: 50%;
                                                    background: linear-gradient(135deg, var(--primary), var(--secondary));
                                                    display: flex; align-items: center; justify-content: center;
                                                    color: white; font-weight: 700; font-size: 0.9rem; flex-shrink: 0;">
                                            ${customer.username.substring(0,1).toUpperCase()}
                                        </div>
                                        <span style="font-weight: 600;">${customer.username}</span>
                                    </div>
                                </td>
                                <td style="color: var(--text-muted);">${customer.email}</td>
                                <td style="color: var(--text-muted); max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    ${not empty customer.address ? customer.address : '—'}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${customer.role == 'ROLE_ADMIN'}">
                                            <span class="badge badge-admin">Admin</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-user">Customer</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty customers}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 48px; color: var(--text-muted);">
                                    No customers registered yet.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <script>
        function filterCustomers() {
            const query = document.getElementById('customerSearch').value.toLowerCase();
            const rows = document.querySelectorAll('#customersTable tbody tr');
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        }
    </script>
</body>
</html>