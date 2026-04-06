<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/home.css">
    <style>
        .cart-container { max-width: 900px; margin: 48px auto; padding: 0 24px; }
        .cart-title { font-size: 1.75rem; font-weight: 800; letter-spacing: -0.025em; margin-bottom: 32px; }

        .cart-table { width: 100%; border-collapse: collapse; }
        .cart-table th {
            text-align: left; padding: 12px 16px;
            font-size: 0.8rem; font-weight: 600; color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 0.05em;
            border-bottom: 2px solid var(--border);
        }
        .cart-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid var(--border); }
        
        .cart-row { cursor: pointer; transition: background 0.2s; }
        .cart-row:hover { background-color: #f8fafc; }
        .cart-row.selected { background-color: #f1f5f9; }

        .product-thumb { width: 56px; height: 56px; object-fit: contain; border-radius: 8px; background: #f8fafc; }
        
        /* Expandable Details */
        .expand-content { max-height: 0; overflow: hidden; transition: max-height 0.3s ease-out; background: #f8fafc; }
        .expand-content.open { max-height: 200px; padding: 16px; }

        .qty-control { display: flex; align-items: center; gap: 10px; background: white; padding: 4px 8px; border-radius: 20px; border: 1px solid var(--border); width: fit-content; }
        .qty-btn { width: 24px; height: 24px; border-radius: 50%; border: none; background: var(--bg-main); cursor: pointer; display: flex; align-items: center; justify-content: center; font-weight: 700; transition: all 0.2s; }
        .qty-btn:hover { background: var(--border); color: var(--primary); }

        .cart-summary {
            margin-top: 32px; padding: 24px; background: white;
            border-radius: var(--radius); border: 1px solid var(--border);
            display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;
        }
        .cart-total { font-size: 1.5rem; font-weight: 800; color: var(--text-main); }
        .cart-total span { color: var(--primary); }

        .checkbox-container { width: 20px; height: 20px; cursor: pointer; }

        .btn-remove { color: var(--danger); font-size: 0.8rem; font-weight: 600; text-decoration: none; }
        .btn-remove:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">E-Store</a>
            <ul class="nav-links">
                <li><a href="/">Home</a></li>
                <li><a href="/user/products">Products</a></li>
                <li><a href="/buy" style="color: var(--primary); font-weight: 600;">Cart <c:if test="${cartCount > 0}"><span class="cart-badge">${cartCount}</span></c:if></a></li>
                <li><a href="/user/orders">My Orders</a></li>
                <li><a href="/user/profile" class="nav-profile">${username}</a></li>
                <li><a href="/logout" class="btn btn-nav-logout">Logout</a></li>
            </ul>
            <button class="hamburger" onclick="document.querySelector('.nav-links').classList.toggle('open')">☰</button>
        </div>
    </nav>

    <div class="cart-container">
        <h1 class="cart-title">Shopping Cart</h1>

        <c:choose>
            <c:when test="${not empty cartProducts}">
                <form id="checkoutForm" action="/user/checkout" method="post">
                <!-- Success/Error Alerts -->
                <c:if test="${not empty msg}">
                    <div style="background: #ecfdf5; border-left: 4px solid #10b981; padding: 16px; border-radius: 8px; margin-bottom: 24px; color: #065f46; font-weight: 600;">
                        ${msg}
                    </div>
                </c:if>

                <div class="card" style="padding: 0; overflow: hidden;">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="selectAll" checked onchange="toggleAll()"></th>
                                <th>Product</th>
                                <th style="text-align: center;">Qty</th>
                                <th>Subtotal</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cp" items="${cartProducts}">
                                <tr class="cart-row" id="row-${cp.product.id}" onclick="toggleExpand('${cp.product.id}', event)">
                                    <td onclick="event.stopPropagation()">
                                        <input type="checkbox" name="selectedProducts" value="${cp.product.id}" 
                                               class="item-checkbox" checked onchange="calculateTotal()">
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 12px;">
                                            <img src="${cp.product.image}" alt="${cp.product.name}" class="product-thumb"
                                                 onerror="this.src='https://placehold.co/56x56/e2e8f0/94a3b8?text=?'">
                                            <div>
                                                <div class="product-info-name">${cp.product.name}</div>
                                                <div style="font-size: 0.75rem; color: var(--text-muted);">₹${cp.product.price} / unit</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td onclick="event.stopPropagation()">
                                        <div class="qty-control" style="margin: 0 auto;">
                                            <a href="/user/cart/decrease?pid=${cp.product.id}" class="qty-btn" style="text-decoration: none; color: inherit;">-</a>
                                            <span style="font-weight: 700; min-width: 20px; text-align: center;">${cp.quantity}</span>
                                            <a href="/user/cart/increase?pid=${cp.product.id}" class="qty-btn" style="text-decoration: none; color: inherit;">+</a>
                                        </div>
                                    </td>
                                    <td class="item-price" data-price="${cp.product.price}" data-qty="${cp.quantity}">
                                        <div style="font-weight: 700; color: var(--text-main);">₹${cp.product.price * cp.quantity}</div>
                                    </td>
                                    <td style="text-align: right;" onclick="event.stopPropagation()">
                                        <a href="/removeFromCart?pid=${cp.product.id}" class="btn-remove">Remove</a>
                                    </td>
                                </tr>
                                <!-- Expandable row -->
                                <tr id="expand-${cp.product.id}" class="expand-row" style="display: none;">
                                    <td colspan="5" style="padding: 0;">
                                        <div class="expand-content" id="content-${cp.product.id}">
                                            <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 20px;">
                                                <img src="${cp.product.image}" alt="${cp.product.name}" style="width: 100%; border-radius: 8px; border: 1px solid var(--border);">
                                                <div>
                                                    <h4 style="margin-bottom: 8px;">Product Details</h4>
                                                    <p style="font-size: 0.9rem; color: var(--text-muted); margin-bottom: 12px;">${cp.product.description}</p>
                                                    <div style="font-size: 0.8rem;"><span style="font-weight: 600;">Category:</span> ${cp.product.category.name}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Payment Method Section -->
                <div class="card" style="margin-top: 24px; padding: 24px;">
                    <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                        Select Payment Method
                    </h3>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
                        <label style="display: block;">
                            <input type="radio" name="paymentMethod" value="UPI" style="display: none;" onchange="updateSelectedPayment(this)">
                            <div class="payment-option" style="padding: 16px; border: 1px solid var(--border); border-radius: 12px; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 12px;">
                                <div style="font-size: 1.5rem; color:#94a3b8; font-weight:800;">UPI</div>
                                <div>
                                    <div style="font-weight: 700;">UPI Payment</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">Gpay, PhonePe, Paytm</div>
                                </div>
                            </div>
                        </label>
                        <label style="display: block;">
                            <input type="radio" name="paymentMethod" value="Card" style="display: none;" onchange="updateSelectedPayment(this)">
                            <div class="payment-option" style="padding: 16px; border: 1px solid var(--border); border-radius: 12px; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 12px;">
                                <div style="font-size: 1.5rem; color:#94a3b8; font-weight:800;">CRD</div>
                                <div>
                                    <div style="font-weight: 700;">Credit/Debit Card</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">All major cards accepted</div>
                                </div>
                            </div>
                        </label>
                        <label style="display: block;">
                            <input type="radio" name="paymentMethod" value="Cash on Delivery" checked style="display: none;" onchange="updateSelectedPayment(this)">
                            <div class="payment-option selected-payment" style="padding: 16px; border: 1px solid var(--border); border-radius: 12px; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 12px; border-color: var(--primary); background: #f0f9ff;">
                                <div style="font-size: 1.5rem; color:#94a3b8; font-weight:800;">COD</div>
                                <div>
                                    <div style="font-weight: 700;">Cash on Delivery</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">Pay when you receive</div>
                                </div>
                            </div>
                        </label>
                    </div>
                </div>

                <style>
                    .payment-option:hover { border-color: var(--primary); background: #f8fafc; }
                    .selected-payment { border-color: var(--primary) !important; background: #eff6ff !important; box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.1); }
                </style>

                <script>
                    function updateSelectedPayment(input) {
                        document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected-payment'));
                        document.querySelectorAll('.payment-option').forEach(el => el.style.borderColor = '');
                        document.querySelectorAll('.payment-option').forEach(el => el.style.background = '');
                        
                        const option = input.nextElementSibling;
                        option.classList.add('selected-payment');
                        option.style.borderColor = 'var(--primary)';
                        option.style.background = '#eff6ff';
                    }
                </script>

                <div class="cart-summary">
                    <div>
                        <div style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 4px;" id="selectedCount">Loading summary...</div>
                        <div class="cart-total">Total: <span>₹<span id="grandTotal">0</span></span></div>
                    </div>
                    <div class="cart-actions">
                        <a href="/user/products" class="btn btn-secondary">← Continue Shopping</a>
                        <button type="submit" class="btn btn-primary">Place Order →</button>
                    </div>
                </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="card" style="text-align: center; padding: 80px 24px;">
                    <div style="font-size: 4rem; margin-bottom: 16px; color:#cbd5e1;">📋</div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 8px;">Your cart is empty</h3>
                    <p style="color: var(--text-muted); margin-bottom: 28px;">Browse our products and add items to get started.</p>
                    <a href="/user/products" class="btn btn-primary">Browse Products</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function toggleExpand(id, event) {
            const expandRow = document.getElementById('expand-' + id);
            const content = document.getElementById('content-' + id);
            const isClosing = content.classList.contains('open');

            // Close all others
            document.querySelectorAll('.expand-content').forEach(el => el.classList.remove('open'));
            document.querySelectorAll('.expand-row').forEach(el => el.style.display = 'none');
            document.querySelectorAll('.cart-row').forEach(el => el.style.backgroundColor = '');

            if (!isClosing) {
                expandRow.style.display = 'table-row';
                setTimeout(() => {
                    content.classList.add('open');
                    document.getElementById('row-' + id).style.backgroundColor = '#f1f5f9';
                }, 10);
            }
        }

        function toggleAll() {
            const selectAll = document.getElementById('selectAll');
            document.querySelectorAll('.item-checkbox').forEach(cb => {
                cb.checked = selectAll.checked;
            });
            saveSelectionState();
            calculateTotal();
        }

        function calculateTotal() {
            let total = 0;
            let count = 0;
            const checkboxes = document.querySelectorAll('.item-checkbox');
            
            checkboxes.forEach(cb => {
                if (cb.checked) {
                    const row = cb.closest('tr');
                    const subtotalCell = row.querySelector('.item-price');
                    const price = parseInt(subtotalCell.getAttribute('data-price'));
                    const qty = parseInt(subtotalCell.getAttribute('data-qty'));
                    total += (price * qty);
                    count++;
                }
            });

            document.getElementById('grandTotal').innerText = total.toLocaleString();
            document.getElementById('selectedCount').innerText = count + ' item(s) selected for checkout';
            
            // Update Select All state without triggering change event
            const selectAll = document.getElementById('selectAll');
            selectAll.checked = (count === checkboxes.length && checkboxes.length > 0);
        }

        // --- Selection Persistence Logic ---
        const USER_ID = '${userid}'; // Use the userid from model to scope storage

        function saveSelectionState() {
            const selectedIds = [];
            document.querySelectorAll('.item-checkbox:checked').forEach(cb => {
                selectedIds.push(cb.value);
            });
            localStorage.setItem('cart_selection_' + USER_ID, JSON.stringify(selectedIds));
        }

        function loadSelectionState() {
            const saved = localStorage.getItem('cart_selection_' + USER_ID);
            if (saved) {
                const selectedIds = JSON.parse(saved);
                document.querySelectorAll('.item-checkbox').forEach(cb => {
                    cb.checked = selectedIds.includes(cb.value);
                });
            }
            calculateTotal();
        }

        // Attach listeners to save on change
        document.querySelectorAll('.item-checkbox').forEach(cb => {
            cb.addEventListener('change', saveSelectionState);
        });

        // Run on load
        window.addEventListener('DOMContentLoaded', loadSelectionState);

        // Form submission validation
        document.getElementById('checkoutForm')?.addEventListener('submit', function(e) {
            const count = document.querySelectorAll('.item-checkbox:checked').length;
            if (count === 0) {
                e.preventDefault();
                alert('Please select at least one product to place an order.');
            } else {
                // Clear state after successful order placement
                localStorage.removeItem('cart_selection_' + USER_ID);
            }
        });
    </script>

    <footer class="footer" style="margin-top: 64px;">
        <div class="footer-container">
            <p class="footer-copy">&copy; 2026 E-Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
