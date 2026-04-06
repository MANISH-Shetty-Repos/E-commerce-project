<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Login - E-Store</title>
    <link rel="stylesheet" href="/css/admin.css">
    <style>
        body {
            background-color: #f8fafc;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            color: #0f172a;
        }

        .login-card {
            background: #ffffff;
            width: 100%;
            max-width: 440px;
            padding: 48px;
            border-radius: 20px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
            border: 1px solid #e2e8f0;
        }

        .login-header {
            text-align: center;
            margin-bottom: 36px;
        }

        .login-brand {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.05em;
            color: #1e293b;
            margin: 0;
            line-height: 1.2;
        }

        .login-subtitle {
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: #64748b;
            margin-top: 4px;
        }

        .input-group {
            margin-bottom: 24px;
            display: flex;
            flex-direction: column;
            text-align: left;
        }

        .input-group label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 8px;
        }

        .input-group input {
            padding: 14px 16px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.2s ease;
            outline: none;
            color: #1e293b;
            background: #f8fafc;
        }

        .input-group input:focus {
            background: #ffffff;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .btn-login {
            background: #4338ca;
            color: #ffffff;
            font-weight: 600;
            font-size: 1rem;
            padding: 14px;
            border-radius: 10px;
            border: none;
            width: 100%;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 12px;
        }

        .btn-login:hover {
            background: #3730a3;
            transform: translateY(-1px);
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 0.9rem;
            font-weight: 500;
            text-align: center;
        }

        .footer-links {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            margin-top: 32px;
        }

        .footer-links a {
            color: #64748b;
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 500;
            transition: color 0.2s;
        }

        .footer-links a:hover {
            color: #4338ca;
        }

        .animate-fade-in { animation: fadeIn 0.5s cubic-bezier(0.16, 1, 0.3, 1); }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="login-card animate-fade-in">
        <div class="login-header">
            <h1 class="login-brand">E-Store</h1>
            <div class="login-subtitle">Customer Portal</div>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert-error">${msg}</div>
        </c:if>

        <form action="/userloginvalidate" method="post">
            <div class="input-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required autofocus>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn-login">Sign In Securely</button>
        </form>

        <div class="footer-links">
            <a href="/register">Create a new account</a>
            <a href="/">← Return to Storefront</a>
        </div>
    </div>

</body>
</html>
