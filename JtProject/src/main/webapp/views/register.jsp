<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="auth-container">

    <div class="card auth-card animate-fade-in" style="max-width: 480px;">
        <div class="auth-header">
            <div style="font-size: 2.5rem; margin-bottom: 8px;">🛍️</div>
            <h1>Create Account</h1>
            <p>Join us and start shopping today</p>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-danger">${msg}</div>
        </c:if>

        <form action="/newuserregister" method="post" onsubmit="return validateForm()">
            <div class="input-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username"
                       placeholder="Choose a username" required minlength="3">
            </div>

            <div class="input-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       placeholder="you@example.com" required>
                <small style="color: var(--text-muted); font-size: 0.8rem; margin-top: 4px; display:block;">
                    We'll never share your email with anyone.
                </small>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Min. 6 characters" required minlength="6">
            </div>

            <div class="input-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword"
                       placeholder="Re-enter your password" required>
                <small id="passwordError" style="color: var(--danger); font-size: 0.8rem; display: none; margin-top: 4px;">
                    Passwords do not match.
                </small>
            </div>

            <div class="input-group">
                <label for="address">Delivery Address</label>
                <textarea id="address" name="address" rows="3"
                          placeholder="Enter your full delivery address"
                          style="width:100%; padding: 12px 16px; border-radius: 8px; border: 1px solid var(--border); font-family: inherit; font-size: 1rem; resize: vertical; transition: border-color 0.2s, box-shadow 0.2s;"
                          onfocus="this.style.borderColor='var(--primary)'; this.style.boxShadow='0 0 0 4px rgba(99,102,241,0.1)'"
                          onblur="this.style.borderColor='var(--border)'; this.style.boxShadow='none'"></textarea>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 8px;">
                Create My Account
            </button>
        </form>

        <div style="text-align: center; margin-top: 28px; font-size: 0.875rem; color: var(--text-muted);">
            Already have an account?
            <a href="/login" style="color: var(--primary); font-weight: 600; text-decoration: none;">Sign In</a>
        </div>

        <div style="text-align: center; margin-top: 12px;">
            <a href="/" style="color: var(--text-muted); font-size: 0.85rem; text-decoration: none;">← Back to Home</a>
        </div>
    </div>

    <style>
        .animate-fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        textarea:focus {
            outline: none;
        }
    </style>

    <script>
        function validateForm() {
            const pwd = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            const errorEl = document.getElementById('passwordError');
            if (pwd !== confirm) {
                errorEl.style.display = 'block';
                document.getElementById('confirmPassword').style.borderColor = 'var(--danger)';
                return false;
            }
            errorEl.style.display = 'none';
            return true;
        }

        // Real-time password match feedback
        document.getElementById('confirmPassword').addEventListener('input', function () {
            const pwd = document.getElementById('password').value;
            const errorEl = document.getElementById('passwordError');
            if (this.value && this.value !== pwd) {
                errorEl.style.display = 'block';
                this.style.borderColor = 'var(--danger)';
            } else {
                errorEl.style.display = 'none';
                this.style.borderColor = this.value ? 'var(--success)' : 'var(--border)';
            }
        });
    </script>
</body>
</html>