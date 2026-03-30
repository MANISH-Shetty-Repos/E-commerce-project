<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .auth-container {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #4338ca 100%);
        }
        .admin-badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            font-size: 0.7rem;
            font-weight: 700;
            padding: 3px 12px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 16px;
        }
    </style>
</head>
<body class="auth-container">

    <div class="card auth-card animate-fade-in">
        <div class="auth-header">
            <span class="admin-badge">Admin Portal</span>
            <h1>Admin Login</h1>
            <p>Sign in to manage your store</p>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-danger">${msg}</div>
        </c:if>

        <form action="/admin/loginvalidate" method="post">
            <div class="input-group">
                <label for="username">Admin Username</label>
                <input type="text" id="username" name="username" placeholder="Enter admin username" required>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 24px;">Access Dashboard</button>
        </form>

        <div style="text-align: center; margin-top: 28px;">
            <a href="/" style="color: var(--text-muted); font-size: 0.85rem; text-decoration: none;">← Back to Store</a>
        </div>
    </div>

    <style>
        .animate-fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</body>
</html>
