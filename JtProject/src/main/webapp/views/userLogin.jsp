<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon">
</head>
<body class="auth-container">
    <div class="card auth-card animate-fade-in">
        <div class="auth-header">
            <h1>Welcome Back</h1>
            <p>Enter your credentials to access your account</p>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-danger">
                ${msg}
            </div>
        </c:if>

        <form action="/userloginvalidate" method="post">
            <div class="input-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 24px;">Login to Account</button>
        </form>

        <div style="text-align: center; margin-top: 32px; font-size: 0.875rem; color: var(--text-muted);">
            Don't have an account? <a href="/register" style="color: var(--primary); font-weight: 600; text-decoration: none;">Create Account</a>
        </div>
        
        <div style="text-align: center; margin-top: 16px; font-size: 0.875rem;">
            <a href="/" style="color: var(--text-muted); text-decoration: none;">← Back to Home</a>
        </div>
    </div>

    <!-- Optional: Add fade-in animation -->
    <style>
        .animate-fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</body>
</html>
