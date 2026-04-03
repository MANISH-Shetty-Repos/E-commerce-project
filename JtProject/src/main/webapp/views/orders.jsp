<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/home.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #eff6ff;
            --success: #10b981;
            --danger: #ef4444;
            --border: #e2e8f0;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --radius: 12px;
        }

        .orders-container { max-width: 900px; margin: 48px auto; padding: 0 24px; }
        .orders-title { font-size: 2rem; font-weight: 800; color: var(--text-main); margin-bottom: 32px; letter-spacing: -0.025em; }

        /* Alert styles */
        .msg-alert { padding: 16px; border-radius: var(--radius); margin-bottom: 24px; font-weight: 600; display:flex; justify-content: space-between; align-items:center; }
        .msg-error { background: #fef2f2; color: #991b1b; border-left: 4px solid #ef4444; }
        .msg-success { background: #ecfdf5; color: #065f46; border-left: 4px solid #10b981; }

        .order-card {
            background: white; border-radius: var(--radius); border: 1px solid var(--border);
            margin-bottom: 24px; overflow: hidden; transition: all 0.3s ease;
        }
        .order-card:hover { box-shadow: var(--shadow); border-color: #cbd5e1; }

        .order-header {
            display: flex; justify-content: space-between; align-items: center;
            padding: 24px; background: #fff; cursor: pointer; user-select: none;
        }
        
        .order-total { font-weight: 800; font-size: 1.25rem; color: var(--primary); }
        .expand-icon { transition: transform 0.3s; color: var(--text-muted); font-size: 0.8rem; }
        .expanded .expand-icon { transform: rotate(180deg); }

        .order-details-pane { border-top: 1px dashed var(--border); background: #fcfcfd; }
        
        .details-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 24px; padding: 24px; }
        .section-label { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); margin-bottom: 8px; font-weight: 700; }
        .section-value { font-size: 0.95rem; color: var(--text-main); line-height: 1.5; font-weight: 500; }

        /* Stepper UI */
        .tracking-box { padding: 32px 24px; background: #fff; border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); }
        .stepper { display: flex; justify-content: space-between; position: relative; max-width: 600px; margin: 0 auto; }
        .stepper::before { content: ''; position: absolute; top: 15px; left: 0; width: 100%; height: 2px; background: #e2e8f0; z-index: 1; }
        
        .step { position: relative; z-index: 2; display: flex; flex-direction: column; align-items: center; width: 80px; }
        .step-circle { 
            width: 32px; height: 32px; border-radius: 50%; background: #fff; 
            border: 2px solid #e2e8f0; display: flex; align-items: center; 
            justify-content: center; font-weight: 700; font-size: 0.8rem; color: #94a3b8;
            transition: all 0.3s;
        }
        .step.active .step-circle { background: var(--primary); border-color: var(--primary); color: white; box-shadow: 0 0 0 4px var(--primary-light); }
        .step.active .step-text { color: var(--primary); font-weight: 700; }
        
        .step-text { font-size: 0.75rem; margin-top: 12px; color: var(--text-muted); text-align: center; }
        .step-date { font-size: 0.65rem; color: #94a3b8; margin-top: 4px; }

        /* Items list */
        .items-list { padding: 24px; }
        .mini-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f1f5f9; }
        .mini-item:last-child { border-bottom: none; }
        .mini-img { width: 48px; height: 48px; border-radius: 8px; object-fit: contain; background: #f8fafc; border: 1px solid var(--border); }

        .btn-cancel {
            background: #fff; color: var(--danger); border: 1px solid #fecaca;
            padding: 8px 16px; border-radius: 8px; font-size: 0.85rem; font-weight: 600;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-cancel:hover { background: #fee2e2; }

        /* Modal */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px);
            display: none; align-items: center; justify-content: center; z-index: 1000;
        }
        .modal {
            background: white; padding: 32px; border-radius: 20px; max-width: 400px;
            width: 90%; text-align: center; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">🛍️ E-Store</a>
            <ul class="nav-links">
                <li><a href="/">Home</a></li>
                <li><a href="/user/products">Products</a></li>
                <li><a href="/buy">Cart 🛒</a></li>
                <li><a href="/user/orders" style="color: var(--primary); font-weight: 700;">My Orders</a></li>
                <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="orders-container">
        <!-- Alerts -->
        <c:if test="${not empty msg}">
            <c:set var="isError" value="${msg.toLowerCase().contains('cancel') || msg.toLowerCase().contains('refund') || msg.toLowerCase().contains('error')}" />
            <div id="flash-msg" class="msg-alert ${isError ? 'msg-error' : 'msg-success'}">
                <span>${msg}</span>
                <button onclick="this.parentElement.remove()" style="background:none; border:none; color:inherit; cursor:pointer; font-size:1.2rem;">&times;</button>
            </div>
        </c:if>

        <h1 class="orders-title">📦 My Orders</h1>

        <c:choose>
            <c:when test="${not empty orders}">
                <c:forEach var="order" items="${orders}">
                    <div class="order-card" id="card-${order.id}">
                        <div class="order-header" onclick="toggleOrder('${order.id}')">
                            <div style="display: flex; align-items: center; gap: 20px;">
                                <div style="font-size: 1.5rem; background: var(--primary-light); padding: 12px; border-radius: 12px;">🚚</div>
                                <div>
                                    <div style="font-weight: 800; font-size: 1.1rem;">Order Details</div>
                                    <div style="font-size: 0.85rem; color: var(--text-muted);">
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
                                    </div>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 24px;">
                                <div style="text-align: right;">
                                    <div class="order-total">₹${order.totalAmount}</div>
                                    <div style="font-size: 0.7rem; color: var(--success); font-weight: 800; text-transform: uppercase;">Confirmed</div>
                                </div>
                                <div class="expand-icon" id="icon-${order.id}">▼</div>
                            </div>
                        </div>

                        <div id="details-${order.id}" class="order-details-pane" style="display: none;">
                            <div class="details-grid">
                                <div>
                                    <h4 class="section-label">Shipping Details</h4>
                                    <div class="section-value">${order.user.address}</div>
                                    <div class="section-value" style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">Recipient: ${order.user.username}</div>
                                </div>
                                <div>
                                    <h4 class="section-label">Order Insights</h4>
                                    <div class="section-value">Payment: <span style="font-weight: 700; color:var(--primary);">${order.paymentMethod}</span></div>
                                    <div class="section-value">Expected by: <strong>
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/> 
                                    </strong></div>
                                </div>
                            </div>

                            <!-- Tracking Section -->
                            <div class="tracking-box">
                                <h4 class="section-label" style="text-align: center; margin-bottom: 32px;">Real-time Status Tracker</h4>
                                <div class="stepper">
                                    <div class="step active">
                                        <div class="step-circle">✓</div>
                                        <div class="step-text">Ordered</div>
                                        <div class="step-date"><fmt:formatDate value="${order.orderDate}" pattern="dd MMM"/></div>
                                    </div>
                                    <div class="step active">
                                        <div class="step-circle">✓</div>
                                        <div class="step-text">Processed</div>
                                        <div class="step-date">Today</div>
                                    </div>
                                    <div class="step">
                                        <div class="step-circle">3</div>
                                        <div class="step-text">Shipping</div>
                                        <div class="step-date">Tomorrow</div>
                                    </div>
                                    <div class="step">
                                        <div class="step-circle">4</div>
                                        <div class="step-text">Delivery</div>
                                        <div class="step-date">In 3 Days</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Items Section -->
                            <div class="items-list">
                                <h4 class="section-label">Included Products</h4>
                                <c:forEach var="item" items="${order.orderItems}">
                                    <div class="mini-item">
                                        <div style="display: flex; align-items: center; gap: 16px;">
                                            <c:choose>
                                                <c:when test="${not empty item.product}">
                                                    <img src="${item.product.image}" class="mini-img" onerror="this.onerror=null; this.src='data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0OCIgaGVpZ2h0PSI0OCI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0iI2QyZDhlMCIvPjx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBmb250LXNpemU9IjEyIiBmaWxsPSIjNjQ3NDhiIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkb21pbmFudC1iYXNlbGluZT0iY2VudHJhbCIgZm9udC1mYW1pbHk9InNhbnMtc2VyaWYiPj88L3RleHQ+PC9zdmc+';">
                                                    <div>
                                                        <div style="font-weight: 600; font-size: 0.95rem;">${item.product.name}</div>
                                                        <div style="font-size: 0.75rem; color: var(--text-muted);">Quantity: ${item.quantity}</div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="mini-img" style="display:flex; align-items:center; justify-content:center;">❓</div>
                                                    <div style="font-weight: 600; font-size: 0.95rem;">Archived Product</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div style="font-weight: 700; color: var(--text-main);">₹${item.priceAtPurchase * item.quantity}</div>
                                    </div>
                                </c:forEach>
                            </div>

                            <div style="padding: 16px 24px; border-top: 1px solid var(--border); display: flex; justify-content: flex-end; gap: 12px; background: white;">
                                <button class="btn-cancel" onclick="showCancelModal('${order.id}')">Cancel This Order</button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 100px 24px; background: white; border-radius: 20px; border: 2px dashed var(--border);">
                    <div style="font-size: 5rem; margin-bottom: 24px;">📭</div>
                    <h2 style="margin-bottom: 8px;">No orders found</h2>
                    <p style="color: var(--text-muted); margin-bottom: 32px;">Start exploring our products and place your first order!</p>
                    <a href="/user/products" class="btn btn-primary" style="padding: 12px 32px;">Browse Store</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Cancellation Modal -->
    <div class="modal-overlay" id="cancelModal">
        <div class="modal">
            <div style="font-size: 4rem; margin-bottom: 16px;">⚠️</div>
            <h2 style="font-size: 1.5rem; margin-bottom: 12px;">Cancel Order?</h2>
            <p style="color: var(--text-muted); margin-bottom: 32px; line-height: 1.6;">Are you sure you want to cancel this order? This action cannot be undone.</p>
            <div style="display: flex; gap: 12px;">
                <button class="btn btn-secondary" style="flex: 1; padding: 14px;" onclick="hideCancelModal()">No, Keep it</button>
                <form id="cancelForm" action="/user/order/cancel" method="post" style="flex: 1;">
                    <input type="hidden" name="orderId" id="modalOrderId">
                    <button type="submit" class="btn btn-danger" style="width: 100%; padding: 14px; background: #ef4444; color: white; border: none; border-radius: 12px; font-weight: 700; cursor: pointer;">Yes, Cancel</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function toggleOrder(id) {
            const details = document.getElementById('details-' + id);
            const card = document.getElementById('card-' + id);
            const isExpanded = details.style.display === 'block';
            
            // Close others (optional)
            // document.querySelectorAll('.order-details-pane').forEach(el => el.style.display = 'none');
            // document.querySelectorAll('.order-card').forEach(el => el.classList.remove('expanded'));

            details.style.display = isExpanded ? 'none' : 'block';
            if (isExpanded) {
                card.classList.remove('expanded');
            } else {
                card.classList.add('expanded');
            }
        }

        function showCancelModal(orderId) {
            document.getElementById('modalOrderId').value = orderId;
            document.getElementById('cancelModal').style.display = 'flex';
        }

        function hideCancelModal() {
            document.getElementById('cancelModal').style.display = 'none';
        }
    </script>

    <footer class="footer" style="margin-top: 100px;">
        <div class="footer-container">
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
