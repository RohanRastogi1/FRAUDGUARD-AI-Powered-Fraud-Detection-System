<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.User" %>
<%
    User navUser = (User) session.getAttribute("currentUser");
    String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") + " — " : "" %>FraudGuard AI</title>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= cp %>/" class="brand">
                <div class="brand-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                </div>
                <span>FRAUDGUARD</span>
                <span class="brand-badge">AI Engine</span>
            </a>

            <% if (navUser != null) { %>
                <ul class="nav-links">
                    <% if (navUser.isAdmin() || navUser.isAnalyst()) { %>
                        <li><a href="<%= cp %>/admin/dashboard" class="nav-link">Executive Dashboard</a></li>
                        <li><a href="<%= cp %>/admin/transactions" class="nav-link">Transaction Monitor</a></li>
                        <li><a href="<%= cp %>/admin/alerts" class="nav-link">Fraud Alerts</a></li>
                    <% } else { %>
                        <li><a href="<%= cp %>/dashboard" class="nav-link">Dashboard</a></li>
                        <li><a href="<%= cp %>/transaction/new" class="nav-link">Send Funds</a></li>
                        <li><a href="<%= cp %>/transactions" class="nav-link">History</a></li>
                        <li><a href="<%= cp %>/alerts" class="nav-link">Security Alerts</a></li>
                    <% } %>
                </ul>

                <div class="nav-user">
                    <div class="user-pill">
                        <div class="user-avatar"><%= navUser.getUsername().substring(0, 1).toUpperCase() %></div>
                        <span><%= navUser.getFullName() != null ? navUser.getFullName() : navUser.getUsername() %></span>
                        <span class="badge <%= navUser.isAdmin() ? "badge-danger" : (navUser.isAnalyst() ? "badge-info" : "badge-success") %>">
                            <%= navUser.getRole().name() %>
                        </span>
                    </div>
                    <a href="<%= cp %>/logout" class="btn btn-secondary btn-sm" id="logout-btn">Sign Out</a>
                </div>
            <% } else { %>
                <div class="nav-user">
                    <a href="<%= cp %>/login" class="btn btn-primary btn-sm" id="login-nav-btn">Sign In</a>
                </div>
            <% } %>
        </div>
    </nav>
    <main class="main-content">
