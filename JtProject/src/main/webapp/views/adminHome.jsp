<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Merchant Dashboard - E-Store</title>
                <link rel="stylesheet" href="/css/style.css">
                <link rel="stylesheet" href="/css/admin.css">
                <!-- Chart.js CDN -->
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                            <li><a href="/admin/Dashboard" class="active">Dashboard</a></li>
                        </ul>
                        <div class="sidebar-section">Catalog</div>
                        <ul class="sidebar-nav">
                            <li><a href="/admin/categories">Category</a></li>
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
                                <h1 style="margin: 0;">Dashboard</h1>
                                <p style="color: #64748b; margin: 4px 0 0;">Welcome back, ${admin}</p>
                            </div>
                        </div>

                        <!-- STATS GRID -->
                        <div class="stats-grid">
                            <!-- Revenue Card -->
                            <div class="stat-card">
                                <div class="stat-card-top">
                                    <div class="stat-info">
                                        <div class="stat-label">Total Revenue</div>
                                        <div class="stat-value">₹${totalRevenue}</div>
                                    </div>
                                </div>
                            </div>
                            <!-- Orders Card -->
                            <div class="stat-card">
                                <div class="stat-card-top">
                                    <div class="stat-info">
                                        <div class="stat-label">Total Orders</div>
                                        <div class="stat-value">${orderCount}</div>
                                    </div>
                                </div>
                            </div>
                            <!-- Products Card -->
                            <div class="stat-card">
                                <div class="stat-card-top">
                                    <div class="stat-info">
                                        <div class="stat-label">Inventory</div>
                                        <div class="stat-value">${productCount}</div>
                                    </div>
                                </div>
                            </div>
                            <!-- Users Card -->
                            <div class="stat-card">
                                <div class="stat-card-top">
                                    <div class="stat-info">
                                        <div class="stat-label">Active Users</div>
                                        <div class="stat-value">${userCount}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ANALYTICS GRID -->
                        <div class="analytics-grid">
                            <!-- Chart 1: Sales Performance -->
                            <div class="chart-container">
                                <h3>Sales Trend (Last Orders)</h3>
                                <canvas id="salesChart"></canvas>
                            </div>
                            <!-- Chart 2: Category Distribution -->
                            <div class="chart-container">
                                <h3>Inventory by Category</h3>
                                <canvas id="categoryChart"></canvas>
                            </div>
                            <!-- Chart 3: Payment Methods -->
                            <div class="chart-container" style="min-height: auto;">
                                <h3>Payment Methods</h3>
                                <canvas id="paymentChart"></canvas>
                            </div>
                        </div>

                        <h2 style="margin-bottom: 24px; font-weight: 800; font-size: 1.5rem;">Data Explorer</h2>

                        <!-- EXPANDABLE LISTS -->
                        <!-- Products Accordion -->
                        <div class="dash-accordion">
                            <button class="accordion-header" onclick="this.parentElement.classList.toggle('active')">
                                <h3>Product Inventory <small
                                        style="font-weight: 400; color: #94a3b8; font-size: 0.8rem; margin-left: 8px;">(${productCount}
                                        items)</small></h3>
                                <span class="chevron">▼</span>
                            </button>
                            <div class="accordion-content">
                                <ul class="accordion-list">
                                    <c:forEach items="${products}" var="product">
                                        <li class="accordion-list-item">
                                            <span><strong>${product.name}</strong> <small style="color: #64748b;">(Qty:
                                                    ${product.quantity})</small></span>
                                            <span style="font-weight: 600; color: #059669;">₹${product.price}</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>

                        <!-- Categories Accordion -->
                        <div class="dash-accordion">
                            <button class="accordion-header" onclick="this.parentElement.classList.toggle('active')">
                                <h3>Product Categories <small
                                        style="font-weight: 400; color: #94a3b8; font-size: 0.8rem; margin-left: 8px;">(${categoryCount}
                                        types)</small></h3>
                                <span class="chevron">▼</span>
                            </button>
                            <div class="accordion-content">
                                <ul class="accordion-list">
                                    <c:forEach items="${categories}" var="category">
                                        <li class="accordion-list-item">
                                            <span>${category.name}</span>
                                            <a href="/admin/categories" class="btn-edit">Manage</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>

                        <!-- Orders Accordion -->
                        <div class="dash-accordion" id="orders-section">
                            <button class="accordion-header" onclick="this.parentElement.classList.toggle('active')">
                                <h3>Recent Orders <small
                                        style="font-weight: 400; color: #94a3b8; font-size: 0.8rem; margin-left: 8px;">(${orderCount}
                                        total)</small></h3>
                                <span class="chevron">▼</span>
                            </button>
                            <div class="accordion-content">
                                <ul class="accordion-list">
                                    <c:forEach items="${orders}" var="order" varStatus="loop">
                                        <li class="accordion-list-item">
                                            <div>
                                                <strong>${loop.count}</strong> by ${order.user.username} <small
                                                    style="color: #64748b;">(User ID: ${order.user.id})</small><br>
                                                <small style="color: #64748b;">${order.paymentMethod} •
                                                    ${order.orderDate}</small>
                                            </div>
                                            <span style="font-weight: 700; color: #1e1b4b;">₹${order.totalAmount}</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>

                        <!-- Users Accordion -->
                        <div class="dash-accordion">
                            <button class="accordion-header" onclick="this.parentElement.classList.toggle('active')">
                                <h3>Registered Customers <small
                                        style="font-weight: 400; color: #94a3b8; font-size: 0.8rem; margin-left: 8px;">(${userCount}
                                        total)</small></h3>
                                <span class="chevron">▼</span>
                            </button>
                            <div class="accordion-content">
                                <ul class="accordion-list">
                                    <c:forEach items="${users}" var="user">
                                        <li class="accordion-list-item">
                                            <span><strong>${user.username}</strong> <small
                                                    style="color: #64748b;">(${user.email})</small></span>
                                            <span
                                                class="badge ${user.role == 'ROLE_ADMIN' ? 'badge-admin' : 'badge-user'}">${user.role}</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>

                    </main>
                </div>

                <script>
                    // Data Preparation for Charts
                    // Sales chart (last 7 orders) - Using Dates
                    const salesData = {
                        labels: [<c:forEach items="${orders}" var="order" end="6" varStatus="loop">
                            '<fmt:formatDate value="${order.orderDate}" pattern="MMM dd" />'${!loop.last ? ',' : ''}
                        </c:forEach>],
                        values: [<c:forEach items="${orders}" var="order" end="6" varStatus="loop">${order.totalAmount}${!loop.last ? ',' : ''}</c:forEach>]
                    };

                    // Category chart data
                    const catLabels = [];
                    const catCounts = {};
                    <c:forEach items="${products}" var="p">
                        catCounts['${p.category.name}'] = (catCounts['${p.category.name}'] || 0) + 1;
                    </c:forEach>
                    Object.keys(catCounts).forEach(key => catLabels.push(key));
                    const catValues = Object.values(catCounts);

                    // Payment data
                    const payCounts = {};
                    <c:forEach items="${orders}" var="o">
                        payCounts['${o.paymentMethod}'] = (payCounts['${o.paymentMethod}'] || 0) + 1;
                    </c:forEach>
                    const payLabels = Object.keys(payCounts);
                    const payValues = Object.values(payCounts);

                    // Role data
                    const roleCounts = {};
                    <c:forEach items="${users}" var="u">
                        roleCounts['${u.role}'] = (roleCounts['${u.role}'] || 0) + 1;
                    </c:forEach>
                    const roleLabels = Object.keys(roleCounts);
                    const roleValues = Object.values(roleCounts);

                    // Render Charts
                    new Chart(document.getElementById('salesChart'), {
                        type: 'line',
                        data: {
                            labels: salesData.labels.reverse(),
                            datasets: [{
                                label: 'Order Value (₹)',
                                data: salesData.values.reverse(),
                                borderColor: '#2563eb',
                                backgroundColor: 'rgba(37, 99, 235, 0.1)',
                                fill: true,
                                tension: 0.4
                            }]
                        }
                    });

                    new Chart(document.getElementById('categoryChart'), {
                        type: 'bar',
                        data: {
                            labels: catLabels,
                            datasets: [{
                                label: 'Product Count',
                                data: catValues,
                                backgroundColor: '#7c3aed'
                            }]
                        }
                    });

                    new Chart(document.getElementById('paymentChart'), {
                        type: 'doughnut',
                        data: {
                            labels: payLabels,
                            datasets: [{
                                data: payValues,
                                backgroundColor: ['#059669', '#3b82f6', '#f59e0b', '#ef4444']
                            }]
                        }
                    });
                </script>
            </body>

            </html>