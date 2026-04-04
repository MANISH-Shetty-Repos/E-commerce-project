<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>User Directory - Admin - E-Store</title>
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
                        <li><a href="/admin/products">Product</a></li>
                        <li><a href="/admin/customers" class="active">Customers</a></li>
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
                            <h1 style="margin: 0;">User Directory</h1>
                            <p style="color: #64748b; margin: 4px 0 0;">View and manage platform administrators and
                                customers.</p>
                        </div>
                    </div>

                    <!-- SEARCH -->
                    <div style="margin-bottom: 32px;">
                        <input type="text" id="customerSearch" placeholder="Quick search by username or email..."
                            onkeyup="filterCustomers()"
                            style="padding: 12px 20px; border-radius: 12px; border: 1px solid #e2e8f0; font-family: inherit; font-size: 1rem; width: 100%; max-width: 500px; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">
                    </div>

                    <!-- ADMINS SECTION -->
                    <h2
                        style="font-size: 1.25rem; font-weight: 800; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        Administrators
                    </h2>
                    <div class="data-table-wrapper" style="margin-bottom: 48px; border-left: 4px solid #6366f1;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">S.No</th>
                                    <th>Admin Details</th>
                                    <th>Email Address</th>
                                    <th>Permission Level</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="adminSno" value="0" />
                                <c:forEach var="customer" items="${customers}">
                                    <c:if test="${customer.role == 'ROLE_ADMIN'}">
                                        <c:set var="adminSno" value="${adminSno + 1}" />
                                        <tr class="admin-row">
                                            <td style="font-weight: 600; color: #94a3b8;">${adminSno}</td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 12px;">
                                                    <div
                                                        style="width: 40px; height: 40px; border-radius: 12px; background: #e0e7ff; color: #4338ca; display: flex; align-items: center; justify-content: center; font-weight: 800;">
                                                        ${customer.username.substring(0,1).toUpperCase()}
                                                    </div>
                                                    <span
                                                        style="font-weight: 700; color: #1e293b;">${customer.username}</span>
                                                </div>
                                            </td>
                                            <td style="color: #64748b;">${customer.email}</td>
                                            <td><span class="badge badge-admin">Privileged Account</span></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- CUSTOMERS SECTION -->
                    <h2
                        style="font-size: 1.25rem; font-weight: 800; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        Registered Customers
                    </h2>
                    <div class="data-table-wrapper">
                        <table class="data-table" id="customersTable">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">S.No</th>
                                    <th>Customer Name</th>
                                    <th>Contact Info</th>
                                    <th>Primary Address</th>
                                    <th>Account Type</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="customerSno" value="0" />
                                <c:forEach var="customer" items="${customers}">
                                    <c:if test="${customer.role != 'ROLE_ADMIN'}">
                                        <c:set var="customerSno" value="${customerSno + 1}" />
                                        <tr class="customer-row">
                                            <td style="font-weight: 600; color: #94a3b8;">${customerSno}</td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 12px;">
                                                    <div
                                                        style="width: 40px; height: 40px; border-radius: 12px; background: #fce7f3; color: #be185d; display: flex; align-items: center; justify-content: center; font-weight: 800;">
                                                        ${customer.username.substring(0,1).toUpperCase()}
                                                    </div>
                                                    <span
                                                        style="font-weight: 600; color: #1e293b;">${customer.username}</span>
                                                </div>
                                            </td>
                                            <td style="color: #64748b;">${customer.email}</td>
                                            <td
                                                style="color: #64748b; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                ${not empty customer.address ? customer.address : '—'}
                                            </td>
                                            <td><span class="badge badge-user">Standard User</span></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>

            <script>
                function filterCustomers() {
                    const query = document.getElementById('customerSearch').value.toLowerCase();
                    const rows = document.querySelectorAll('.customer-row, .admin-row');
                    rows.forEach(row => {
                        const text = row.innerText.toLowerCase();
                        row.style.display = text.includes(query) ? '' : 'none';
                    });
                }
            </script>
        </body>

        </html>