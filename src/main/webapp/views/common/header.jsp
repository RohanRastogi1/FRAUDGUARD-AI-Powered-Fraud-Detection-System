<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.User" %>
<%
    User navUser = (User) session.getAttribute("currentUser");
    String cp = request.getContextPath();
    String currentUri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") + " — " : "" %>FraudGuard AI</title>
    <script>
        (function() {
            var savedTheme = localStorage.getItem('fraudguard-theme') || 'dark';
            document.documentElement.setAttribute('data-theme', savedTheme);
        })();
    </script>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= cp %>/" class="brand">
                <div class="brand-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        <path d="M9 12l2 2 4-4"/>
                    </svg>
                </div>
                <span>FRAUDGUARD</span>
                <span class="brand-badge">AI Engine</span>
            </a>

            <% if (navUser != null) { %>
                <ul class="nav-links">
                    <% if (navUser.isAdmin() || navUser.isAnalyst()) { %>
                        <li>
                            <a href="<%= cp %>/admin/dashboard" class="nav-link <%= currentUri.contains("/admin/dashboard") ? "active" : "" %>">
                                Executive Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="<%= cp %>/admin/transactions" class="nav-link <%= currentUri.contains("/admin/transactions") ? "active" : "" %>">
                                Transaction Monitor
                            </a>
                        </li>
                        <li>
                            <a href="<%= cp %>/admin/alerts" class="nav-link <%= currentUri.contains("/admin/alerts") ? "active" : "" %>">
                                Fraud Alerts
                            </a>
                        </li>
                    <% } else { %>
                        <li>
                            <a href="<%= cp %>/dashboard" class="nav-link <%= currentUri.endsWith("/dashboard") ? "active" : "" %>">
                                Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="<%= cp %>/transaction/new" class="nav-link <%= currentUri.contains("/transaction/new") ? "active" : "" %>">
                                Send Funds
                            </a>
                        </li>
                        <li>
                            <a href="<%= cp %>/transactions" class="nav-link <%= currentUri.endsWith("/transactions") ? "active" : "" %>">
                                History
                            </a>
                        </li>
                        <li>
                            <a href="<%= cp %>/alerts" class="nav-link <%= currentUri.endsWith("/alerts") ? "active" : "" %>">
                                Security Alerts
                            </a>
                        </li>
                    <% } %>
                </ul>

                <div class="nav-user">
                    <div style="display: flex; align-items: center; gap: 0.45rem; font-size: 0.78rem; color: #10b981; font-weight: 600; padding: 0.3rem 0.65rem; background: rgba(16, 185, 129, 0.1); border-radius: var(--radius-full); border: 1px solid rgba(16, 185, 129, 0.25);">
                        <span class="pulse-dot pulse-dot-green"></span>
                        <span>Engine Live</span>
                    </div>

                    <!-- Theme Toggle Button -->
                    <button type="button" class="theme-toggle-btn" id="theme-toggle" onclick="toggleTheme()" aria-label="Toggle Theme" title="Switch Theme (Very Dark Orange / Warm Beige)">
                        <svg class="theme-icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="5"></circle>
                            <line x1="12" y1="1" x2="12" y2="3"></line>
                            <line x1="12" y1="21" x2="12" y2="23"></line>
                            <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                            <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                            <line x1="1" y1="12" x2="3" y2="12"></line>
                            <line x1="21" y1="12" x2="23" y2="12"></line>
                            <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                            <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                        </svg>
                        <svg class="theme-icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                        </svg>
                        <span id="theme-toggle-text">Dark Mode</span>
                    </button>

                    <div class="user-pill">
                        <div class="user-avatar"><%= navUser.getUsername().substring(0, 1).toUpperCase() %></div>
                        <span style="font-weight: 600;"><%= navUser.getFullName() != null ? navUser.getFullName() : navUser.getUsername() %></span>
                        <span class="badge <%= navUser.isAdmin() ? "badge-danger" : (navUser.isAnalyst() ? "badge-info" : "badge-success") %>">
                            <%= navUser.getRole().name() %>
                        </span>
                    </div>
                    <a href="<%= cp %>/logout" class="btn btn-secondary btn-sm" id="logout-btn">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                            <polyline points="16 17 21 12 16 7"></polyline>
                            <line x1="21" y1="12" x2="9" y2="12"></line>
                        </svg>
                        Sign Out
                    </a>
                </div>
            <% } else { %>
                <div class="nav-user">
                    <div style="display: flex; align-items: center; gap: 0.45rem; font-size: 0.78rem; color: #10b981; font-weight: 600; padding: 0.3rem 0.65rem; background: rgba(16, 185, 129, 0.1); border-radius: var(--radius-full); border: 1px solid rgba(16, 185, 129, 0.25);">
                        <span class="pulse-dot pulse-dot-green"></span>
                        <span>Engine Operational</span>
                    </div>

                    <!-- Theme Toggle Button (Guest / Login) -->
                    <button type="button" class="theme-toggle-btn" id="theme-toggle" onclick="toggleTheme()" aria-label="Toggle Theme" title="Switch Theme (Very Dark Orange / Warm Beige)">
                        <svg class="theme-icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="5"></circle>
                            <line x1="12" y1="1" x2="12" y2="3"></line>
                            <line x1="12" y1="21" x2="12" y2="23"></line>
                            <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                            <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                            <line x1="1" y1="12" x2="3" y2="12"></line>
                            <line x1="21" y1="12" x2="23" y2="12"></line>
                            <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                            <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                        </svg>
                        <svg class="theme-icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                        </svg>
                        <span id="theme-toggle-text">Dark Mode</span>
                    </button>

                    <a href="<%= cp %>/login" class="btn btn-primary btn-sm" id="login-nav-btn">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                            <polyline points="10 17 15 12 10 7"></polyline>
                            <line x1="15" y1="12" x2="3" y2="12"></line>
                        </svg>
                        Sign In
                    </a>
                </div>
            <% } %>
        </div>
    </nav>

    <script>
        function updateThemeText() {
            var current = document.documentElement.getAttribute('data-theme') || 'dark';
            var elements = document.querySelectorAll('#theme-toggle-text');
            elements.forEach(function(el) {
                el.textContent = current === 'dark' ? 'Dark Mode' : 'Light (Beige)';
            });
        }
        function toggleTheme() {
            var current = document.documentElement.getAttribute('data-theme') || 'dark';
            var next = current === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('fraudguard-theme', next);
            updateThemeText();
        }
        document.addEventListener('DOMContentLoaded', updateThemeText);
    </script>
    <main class="main-content">
