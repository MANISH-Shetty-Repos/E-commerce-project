<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Access Denied - E-Store</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: linear-gradient(135deg, #fef2f2 0%, #f8fafc 100%);
        }
        .error-card {
            max-width: 480px;
            width: 100%;
            text-align: center;
        }
        .error-code {
            font-size: 7rem;
            font-weight: 900;
            line-height: 1;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }
        .error-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 12px;
        }
        .error-desc {
            color: var(--text-muted);
            margin-bottom: 32px;
            font-size: 0.95rem;
            line-height: 1.7;
        }
        .error-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="card error-card animate-fade-in">
            <div style="font-size: 3.5rem; margin-bottom: 8px;">🚫</div>
            <div class="error-code">403</div>
            <h1 class="error-title">Access Denied</h1>
            <p class="error-desc">
                You don't have permission to access this page.<br>
                Please log in with the correct account or go back to the home page.
            </p>
            <div class="error-actions">
                <a href="/" class="btn btn-primary">Go to Home</a>
                <a href="/login" class="btn btn-secondary">Login</a>
            </div>
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
