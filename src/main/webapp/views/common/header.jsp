<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.User" %>
<%
    User navUser = (User) session.getAttribute("currentUser");
    String cp = request.getContextPath();
    String currentUri = request.getRequestURI();
    String cleanName = "";
    String userInitial = "U";
    if (navUser != null) {
        String rawName = navUser.getFullName() != null && !navUser.getFullName().trim().isEmpty() 
                ? navUser.getFullName() 
                : navUser.getUsername();
        cleanName = rawName.replaceAll("\\s*\\([^)]*\\)", "").trim();
        if (cleanName.isEmpty()) cleanName = navUser.getUsername();
        userInitial = cleanName.substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") + " — " : "" %>FraudGuard AI</title>
    <script>
        (function() {
            var savedTheme = localStorage.getItem('fraudguard-theme') || 'light';
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
            <a href="<%= cp %>/" class="brand" title="FraudGuard — AI-Powered Fraud Detection System by TeamRootOps">
                <div class="brand-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        <path d="M9 12l2 2 4-4"/>
                    </svg>
                </div>
                <div class="brand-text-group">
                    <div class="brand-title-row">
                        <span class="brand-name">FRAUDGUARD</span>
                        <span class="brand-team-badge" onclick="event.preventDefault(); event.stopPropagation(); openTeamModal();" role="button" tabindex="0" title="Click to view TeamRootOps Engineers & Leadership">
                            by TeamRootOps
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" style="margin-left: 2px;"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        </span>
                    </div>
                    <span class="brand-subtext">AI-Powered Fraud Detection System</span>
                </div>
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
                        <li>
                            <a href="<%= cp %>/architecture" class="nav-link <%= currentUri.contains("/architecture") ? "active" : "" %>">
                                Architecture
                            </a>
                        </li>
                        <li>
                            <a href="<%= cp %>/docs" class="nav-link <%= currentUri.contains("/docs") ? "active" : "" %>">
                                Docs
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
                        <li>
                            <a href="<%= cp %>/architecture" class="nav-link <%= currentUri.contains("/architecture") ? "active" : "" %>">
                                Architecture
                            </a>
                        </li>
                        <li>
                            <a href="<%= cp %>/docs" class="nav-link <%= currentUri.contains("/docs") ? "active" : "" %>">
                                Docs
                            </a>
                        </li>
                    <% } %>
                </ul>

                <div class="nav-user">
                    <div class="nav-engine-status" title="Autonomous Anomaly Scoring Engine: Live">
                        <span class="pulse-dot pulse-dot-green"></span>
                        <span class="engine-status-text">Engine Live</span>
                    </div>

                    <!-- Luxury Fintech Theme Capsule Toggle (Concentric Slot Grid) -->
                    <button type="button" class="theme-toggle-btn" onclick="toggleTheme()" aria-label="Toggle Theme (Dark / Light)" title="Switch Theme (Dark / Light)">
                        <span class="theme-toggle-track">
                            <span class="theme-toggle-thumb"></span>
                            <span class="theme-toggle-slot slot-light">
                                <svg class="theme-icon sun-icon" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="4.5"></circle>
                                    <line x1="12" y1="2" x2="12" y2="4.5"></line>
                                    <line x1="12" y1="19.5" x2="12" y2="22"></line>
                                    <line x1="4.93" y1="4.93" x2="6.7" y2="6.7"></line>
                                    <line x1="17.3" y1="17.3" x2="19.07" y2="19.07"></line>
                                    <line x1="2" y1="12" x2="4.5" y2="12"></line>
                                    <line x1="19.5" y1="12" x2="22" y2="12"></line>
                                    <line x1="4.93" y1="19.07" x2="6.7" y2="17.3"></line>
                                    <line x1="17.3" y1="6.7" x2="19.07" y2="4.93"></line>
                                </svg>
                            </span>
                            <span class="theme-toggle-slot slot-dark">
                                <svg class="theme-icon moon-icon" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                                </svg>
                            </span>
                        </span>
                    </button>

                    <!-- Official GitHub Repository Link -->
                    <a href="https://github.com/RohanRastogi1/FRAUDGUARD-AI-Powered-Fraud-Detection-System" 
                       target="_blank" 
                       rel="noopener noreferrer" 
                       class="nav-github-link" 
                       title="View FraudGuard on GitHub (RohanRastogi1)">
                        <span class="nav-github-icon-wrap">
                            <svg class="github-logo-icon" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.53 1.032 1.53 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"/>
                            </svg>
                        </span>
                        <span class="nav-github-text">GitHub</span>
                        <span class="nav-github-star-pill">
                            <svg width="10" height="10" viewBox="0 0 24 24" fill="currentColor">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                            <span>Star</span>
                        </span>
                    </a>

                    <div class="user-pill" title="<%= cleanName %> (<%= navUser.getRole().name() %>)">
                        <div class="user-avatar"><%= userInitial %></div>
                        <span class="user-pill-name"><%= cleanName %></span>
                        <span class="badge <%= navUser.isAdmin() ? "badge-danger" : (navUser.isAnalyst() ? "badge-info" : "badge-success") %>">
                            <%= navUser.getRole().name() %>
                        </span>
                    </div>
                    <a href="<%= cp %>/logout" class="nav-logout-btn" id="logout-btn" title="Sign out of session">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                            <polyline points="16 17 21 12 16 7"></polyline>
                            <line x1="21" y1="12" x2="9" y2="12"></line>
                        </svg>
                        <span>Sign Out</span>
                    </a>
                </div>
            <% } else { %>
                <ul class="nav-links">
                    <li>
                        <a href="<%= cp %>/architecture" class="nav-link <%= currentUri.contains("/architecture") ? "active" : "" %>">
                            Architecture
                        </a>
                    </li>
                    <li>
                        <a href="<%= cp %>/docs" class="nav-link <%= currentUri.contains("/docs") ? "active" : "" %>">
                            Documentation
                        </a>
                    </li>
                </ul>

                <div class="nav-user">
                    <div class="nav-engine-status" title="Autonomous Anomaly Scoring Engine: Operational">
                        <span class="pulse-dot pulse-dot-green"></span>
                        <span class="engine-status-text">Engine Operational</span>
                    </div>

                    <!-- Luxury Fintech Theme Capsule Toggle (Concentric Slot Grid) -->
                    <button type="button" class="theme-toggle-btn" onclick="toggleTheme()" aria-label="Toggle Theme (Dark / Light)" title="Switch Theme (Dark / Light)">
                        <span class="theme-toggle-track">
                            <span class="theme-toggle-thumb"></span>
                            <span class="theme-toggle-slot slot-light">
                                <svg class="theme-icon sun-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="4.5"></circle>
                                    <line x1="12" y1="2" x2="12" y2="4.5"></line>
                                    <line x1="12" y1="19.5" x2="12" y2="22"></line>
                                    <line x1="4.93" y1="4.93" x2="6.7" y2="6.7"></line>
                                    <line x1="17.3" y1="17.3" x2="19.07" y2="19.07"></line>
                                    <line x1="2" y1="12" x2="4.5" y2="12"></line>
                                    <line x1="19.5" y1="12" x2="22" y2="12"></line>
                                    <line x1="4.93" y1="19.07" x2="6.7" y2="17.3"></line>
                                    <line x1="17.3" y1="6.7" x2="19.07" y2="4.93"></line>
                                </svg>
                            </span>
                            <span class="theme-toggle-slot slot-dark">
                                <svg class="theme-icon moon-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                                </svg>
                            </span>
                        </span>
                    </button>

                    <!-- Official GitHub Repository Link -->
                    <a href="https://github.com/RohanRastogi1/FRAUDGUARD-AI-Powered-Fraud-Detection-System" 
                       target="_blank" 
                       rel="noopener noreferrer" 
                       class="nav-github-link" 
                       title="View FraudGuard on GitHub (RohanRastogi1)">
                        <span class="nav-github-icon-wrap">
                            <svg class="github-logo-icon" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.53 1.032 1.53 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"/>
                            </svg>
                        </span>
                        <span class="nav-github-text">GitHub</span>
                        <span class="nav-github-star-pill">
                            <svg width="10" height="10" viewBox="0 0 24 24" fill="currentColor">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                            <span>Star</span>
                        </span>
                    </a>
                </div>
            <% } %>

            <!-- Mobile Hamburger Toggle -->
            <button type="button" class="nav-mobile-toggle" id="nav-mobile-toggle" aria-label="Toggle navigation menu" aria-expanded="false" onclick="toggleMobileNav()">
                <span class="hamburger-bar"></span>
                <span class="hamburger-bar"></span>
                <span class="hamburger-bar"></span>
            </button>
        </div>

        <!-- Mobile Navigation Drawer / Dropdown Panel -->
        <div class="mobile-nav-menu" id="mobileNavMenu">
            <div class="mobile-nav-inner">
                <% if (navUser != null) { %>
                    <div class="mobile-user-card">
                        <div class="user-avatar" style="width: 38px; height: 38px; font-size: 1rem;"><%= userInitial %></div>
                        <div style="flex: 1; min-width: 0;">
                            <div style="font-weight: 700; color: var(--text-primary); font-size: 0.95rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= cleanName %></div>
                            <div style="display: flex; align-items: center; gap: 0.45rem; margin-top: 0.2rem;">
                                <span class="badge <%= navUser.isAdmin() ? "badge-danger" : (navUser.isAnalyst() ? "badge-info" : "badge-success") %>">
                                    <%= navUser.getRole().name() %>
                                </span>
                                <span style="font-size: 0.72rem; color: #10b981; display: inline-flex; align-items: center; gap: 0.25rem;">
                                    <span class="pulse-dot pulse-dot-green"></span> Engine Live
                                </span>
                            </div>
                        </div>
                    </div>

                    <ul class="mobile-nav-list">
                        <% if (navUser.isAdmin() || navUser.isAnalyst()) { %>
                            <li>
                                <a href="<%= cp %>/admin/dashboard" class="mobile-nav-item <%= currentUri.contains("/admin/dashboard") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Executive Dashboard</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/admin/transactions" class="mobile-nav-item <%= currentUri.contains("/admin/transactions") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Transaction Monitor</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/admin/alerts" class="mobile-nav-item <%= currentUri.contains("/admin/alerts") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Fraud Alerts</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/architecture" class="mobile-nav-item <%= currentUri.contains("/architecture") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Architecture</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/docs" class="mobile-nav-item <%= currentUri.contains("/docs") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Documentation</span>
                                </a>
                            </li>
                        <% } else { %>
                            <li>
                                <a href="<%= cp %>/dashboard" class="mobile-nav-item <%= currentUri.endsWith("/dashboard") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Dashboard</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/transaction/new" class="mobile-nav-item <%= currentUri.contains("/transaction/new") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Send Funds</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/transactions" class="mobile-nav-item <%= currentUri.endsWith("/transactions") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Transaction History</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/alerts" class="mobile-nav-item <%= currentUri.endsWith("/alerts") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Security Alerts</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/architecture" class="mobile-nav-item <%= currentUri.contains("/architecture") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Architecture</span>
                                </a>
                            </li>
                            <li>
                                <a href="<%= cp %>/docs" class="mobile-nav-item <%= currentUri.contains("/docs") ? "active" : "" %>" onclick="closeMobileNav()">
                                    <span>Documentation</span>
                                </a>
                            </li>
                        <% } %>
                        <li>
                            <a href="https://github.com/RohanRastogi1/FRAUDGUARD-AI-Powered-Fraud-Detection-System" target="_blank" rel="noopener noreferrer" class="mobile-nav-item mobile-github-item" onclick="closeMobileNav()">
                                <div style="display: flex; align-items: center; gap: 0.75rem;">
                                    <span class="mobile-github-icon-wrap">
                                        <svg class="github-logo-icon" width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                                            <path fill-rule="evenodd" clip-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.53 1.032 1.53 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"/>
                                        </svg>
                                    </span>
                                    <span style="display: flex; flex-direction: column; text-align: left;">
                                        <span style="font-weight: 700; color: var(--text-primary); font-size: 0.9rem;">GitHub Repository</span>
                                        <span style="font-size: 0.72rem; color: var(--text-muted);">Source code & architecture</span>
                                    </span>
                                </div>
                                <span class="mobile-github-tag">
                                    <svg width="10" height="10" viewBox="0 0 24 24" fill="currentColor">
                                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                    </svg>
                                    Star
                                </span>
                            </a>
                        </li>
                    </ul>

                    <div class="mobile-nav-footer">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.85rem;">
                            <span style="font-size: 0.82rem; color: var(--text-muted); font-weight: 600;">Theme Appearance</span>
                            <button type="button" class="theme-toggle-btn" onclick="toggleTheme()" aria-label="Toggle Theme (Dark / Light)">
                                <span class="theme-toggle-track">
                                    <span class="theme-toggle-thumb"></span>
                                    <span class="theme-toggle-slot slot-light">
                                        <svg class="theme-icon sun-icon" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><circle cx="12" cy="12" r="4.5"></circle><line x1="12" y1="2" x2="12" y2="4.5"></line><line x1="12" y1="19.5" x2="12" y2="22"></line><line x1="4.93" y1="4.93" x2="6.7" y2="6.7"></line><line x1="17.3" y1="17.3" x2="19.07" y2="19.07"></line><line x1="2" y1="12" x2="4.5" y2="12"></line><line x1="19.5" y1="12" x2="22" y2="12"></line><line x1="4.93" y1="19.07" x2="6.7" y2="17.3"></line><line x1="17.3" y1="6.7" x2="19.07" y2="4.93"></line></svg>
                                    </span>
                                    <span class="theme-toggle-slot slot-dark">
                                        <svg class="theme-icon moon-icon" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
                                    </span>
                                </span>
                            </button>
                        </div>
                        <a href="<%= cp %>/logout" class="btn btn-secondary" style="width: 100%; justify-content: center; height: 42px; font-weight: 600; color: #ef4444; border-color: rgba(239, 68, 68, 0.3);">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                            <span>Sign Out</span>
                        </a>
                    </div>
                <% } else { %>
                    <ul class="mobile-nav-list">
                        <li>
                            <a href="<%= cp %>/architecture" class="mobile-nav-item <%= currentUri.contains("/architecture") ? "active" : "" %>" onclick="closeMobileNav()">
                                <span>Architecture</span>
                            </a>
                        </li>
                        <li>
                            <a href="<%= cp %>/docs" class="mobile-nav-item <%= currentUri.contains("/docs") ? "active" : "" %>" onclick="closeMobileNav()">
                                <span>Documentation</span>
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/RohanRastogi1/FRAUDGUARD-AI-Powered-Fraud-Detection-System" target="_blank" rel="noopener noreferrer" class="mobile-nav-item mobile-github-item" onclick="closeMobileNav()">
                                <div style="display: flex; align-items: center; gap: 0.75rem;">
                                    <span class="mobile-github-icon-wrap">
                                        <svg class="github-logo-icon" width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                                            <path fill-rule="evenodd" clip-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.53 1.032 1.53 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"/>
                                        </svg>
                                    </span>
                                    <span style="display: flex; flex-direction: column; text-align: left;">
                                        <span style="font-weight: 700; color: var(--text-primary); font-size: 0.9rem;">GitHub Repository</span>
                                        <span style="font-size: 0.72rem; color: var(--text-muted);">Source code & architecture</span>
                                    </span>
                                </div>
                                <span class="mobile-github-tag">
                                    <svg width="10" height="10" viewBox="0 0 24 24" fill="currentColor">
                                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                    </svg>
                                    Star
                                </span>
                            </a>
                        </li>
                    </ul>
                    <div class="mobile-nav-footer">
                        <div style="display: flex; align-items: center; justify-content: space-between;">
                            <span style="font-size: 0.82rem; color: var(--text-muted); font-weight: 600;">Theme Appearance</span>
                            <button type="button" class="theme-toggle-btn" onclick="toggleTheme()" aria-label="Toggle Theme (Dark / Light)">
                                <span class="theme-toggle-track">
                                    <span class="theme-toggle-thumb"></span>
                                    <span class="theme-toggle-slot slot-light">
                                        <svg class="theme-icon sun-icon" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><circle cx="12" cy="12" r="4.5"></circle><line x1="12" y1="2" x2="12" y2="4.5"></line><line x1="12" y1="19.5" x2="12" y2="22"></line><line x1="4.93" y1="4.93" x2="6.7" y2="6.7"></line><line x1="17.3" y1="17.3" x2="19.07" y2="19.07"></line><line x1="2" y1="12" x2="4.5" y2="12"></line><line x1="19.5" y1="12" x2="22" y2="12"></line><line x1="4.93" y1="19.07" x2="6.7" y2="17.3"></line><line x1="17.3" y1="6.7" x2="19.07" y2="4.93"></line></svg>
                                    </span>
                                    <span class="theme-toggle-slot slot-dark">
                                        <svg class="theme-icon moon-icon" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
                                    </span>
                                </span>
                            </button>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </nav>

    <script>
        /* Mobile Navigation Drawer Handlers */
        function toggleMobileNav() {
            var menu = document.getElementById('mobileNavMenu');
            var btn = document.getElementById('nav-mobile-toggle');
            if (!menu || !btn) return;
            var isOpen = menu.classList.toggle('is-open');
            btn.classList.toggle('is-active', isOpen);
            btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
            if (isOpen) {
                document.body.classList.add('mobile-nav-locked');
            } else {
                document.body.classList.remove('mobile-nav-locked');
            }
        }
        function closeMobileNav() {
            var menu = document.getElementById('mobileNavMenu');
            var btn = document.getElementById('nav-mobile-toggle');
            if (menu && btn) {
                menu.classList.remove('is-open');
                btn.classList.remove('is-active');
                btn.setAttribute('aria-expanded', 'false');
                document.body.classList.remove('mobile-nav-locked');
            }
        }
        window.addEventListener('resize', function() {
            if (window.innerWidth > 992) closeMobileNav();
        });

        function syncThemeSwitch() {
            var current = document.documentElement.getAttribute('data-theme') || 'light';
            var isDark = (current === 'dark');
            var buttons = document.querySelectorAll('.theme-toggle-btn');
            buttons.forEach(function(btn) {
                if (isDark) {
                    btn.classList.add('is-dark');
                    btn.classList.remove('is-light');
                    btn.setAttribute('title', 'Dark Mode Active • Click to switch to Light Mode');
                } else {
                    btn.classList.add('is-light');
                    btn.classList.remove('is-dark');
                    btn.setAttribute('title', 'Light Mode Active • Click to switch to Dark Mode');
                }
            });
        }
        function toggleTheme() {
            var current = document.documentElement.getAttribute('data-theme') || 'light';
            var next = (current === 'light') ? 'dark' : 'light';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('fraudguard-theme', next);
            syncThemeSwitch();
        }
        document.addEventListener('DOMContentLoaded', syncThemeSwitch);

        /* TeamRootOps Modal Handlers */
        function openTeamModal() {
            var modal = document.getElementById('teamRootOpsModal');
            if (modal) {
                modal.classList.add('open');
                document.body.style.overflow = 'hidden';
            }
        }
        function closeTeamModal() {
            var modal = document.getElementById('teamRootOpsModal');
            if (modal) {
                modal.classList.remove('open');
                document.body.style.overflow = '';
            }
        }
        function handleTeamBackdropClick(e) {
            if (e.target && e.target.id === 'teamRootOpsModal') {
                closeTeamModal();
            }
        }
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') closeTeamModal();
        });
    </script>

    <!-- Global Luxury Pop-Up Modal: TeamRootOps Engineering Roster (Zero Exposed Emails) -->
    <div id="teamRootOpsModal" class="team-modal-backdrop" onclick="handleTeamBackdropClick(event)" role="dialog" aria-modal="true" aria-labelledby="teamModalTitle">
        <div class="team-modal-card">
            <!-- Header with Radial Accent -->
            <div class="team-modal-header">
                <div>
                    <span class="team-modal-badge-chip">
                        <span class="pulse-dot pulse-dot-green"></span>
                        TeamRootOps &bull; Galgotias University
                    </span>
                    <h3 id="teamModalTitle" class="team-modal-title">
                        <span>FraudGuard Engineering Team</span>
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle;">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                            <path d="M9 12l2 2 4-4"/>
                        </svg>
                    </h3>
                    <p class="team-modal-subtitle">
                        TeamRootOps &bull; School of Computing Science and Engineering (SCSE).
                    </p>
                </div>
                <button type="button" class="team-modal-close-btn" onclick="closeTeamModal()" title="Close Pop-Up (Esc)" aria-label="Close Pop-Up">&times;</button>
            </div>

            <!-- Stats Ribbon -->
            <div class="team-modal-stats-bar">
                <span class="team-modal-stat-pill">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    <strong>4 Team Members</strong>
                </span>
                <span class="team-modal-stat-pill">
                    <span class="pulse-dot pulse-dot-green"></span>
                    <strong style="color: var(--accent-emerald);">Active Pipeline Status</strong>
                </span>
                <span class="team-modal-stat-pill">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M3 10h18M5 10v11M19 10v11M9 10v11M15 10v11M12 3l9 7H3z"/></svg>
                    <strong>Galgotias University (SCSE)</strong>
                </span>
            </div>

            <!-- Scrollable Member Cards (Zero Exposed Sensitive Data) -->
            <div class="team-modal-body">
                <!-- 1. Rohan Rastogi (Leader / Admin) -->
                <div class="team-member-item is-leader">
                    <div class="team-member-left">
                        <div class="team-avatar-frame">
                            <svg width="34" height="34" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <ellipse cx="24" cy="17" rx="8" ry="7" fill="#8b5cf6"/>
                                <path d="M16 17C16 17 19 19.5 28 18.5C30 18.2 32 17 32 17" stroke="#7c3aed" stroke-width="2.2" stroke-linecap="round"/>
                                <path d="M12 39C12 29 17 25 24 25C31 25 36 29 36 39Z" fill="#1e1e2d"/>
                                <path d="M20 25L24 30L28 25" stroke="#8b5cf6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                <circle cx="21" cy="34" r="1.5" fill="#10b981"/>
                                <circle cx="27" cy="34" r="1.5" fill="#10b981"/>
                            </svg>
                        </div>
                        <div class="team-item-info">
                            <div class="team-item-name-row">
                                <span class="team-item-name">Rohan Rastogi</span>
                                <span class="team-badge-tag leader">Team Leader</span>
                                <span class="badge badge-danger" style="font-size: 0.65rem; padding: 2px 7px;">Admin</span>
                            </div>
                        </div>
                    </div>
                    <div class="team-member-right">
                        <span class="team-status-cell">
                            <span class="pulse-dot pulse-dot-green"></span>
                            Active
                        </span>
                    </div>
                </div>

                <!-- 2. Anant Kumar (Member) -->
                <div class="team-member-item">
                    <div class="team-member-left">
                        <div class="team-avatar-frame">
                            <svg width="34" height="34" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <ellipse cx="24" cy="17" rx="8" ry="7" fill="#8b5cf6"/>
                                <path d="M16 17C16 17 19 19.5 28 18.5C30 18.2 32 17 32 17" stroke="#7c3aed" stroke-width="2.2" stroke-linecap="round"/>
                                <path d="M12 39C12 29 17 25 24 25C31 25 36 29 36 39Z" fill="#1e1e2d"/>
                                <path d="M20 25L24 30L28 25" stroke="#8b5cf6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                <circle cx="21" cy="34" r="1.5" fill="#10b981"/>
                                <circle cx="27" cy="34" r="1.5" fill="#10b981"/>
                            </svg>
                        </div>
                        <div class="team-item-info">
                            <div class="team-item-name-row">
                                <span class="team-item-name">Anant Kumar</span>
                                <span class="team-badge-tag member">Member</span>
                            </div>
                        </div>
                    </div>
                    <div class="team-member-right">
                        <span class="team-status-cell">
                            <span class="pulse-dot pulse-dot-green"></span>
                            Active
                        </span>
                    </div>
                </div>

                <!-- 3. Kumar Arya (Member) -->
                <div class="team-member-item">
                    <div class="team-member-left">
                        <div class="team-avatar-frame">
                            <svg width="34" height="34" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <ellipse cx="24" cy="17" rx="8" ry="7" fill="#8b5cf6"/>
                                <path d="M16 17C16 17 19 19.5 28 18.5C30 18.2 32 17 32 17" stroke="#7c3aed" stroke-width="2.2" stroke-linecap="round"/>
                                <path d="M12 39C12 29 17 25 24 25C31 25 36 29 36 39Z" fill="#1e1e2d"/>
                                <path d="M20 25L24 30L28 25" stroke="#8b5cf6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                <circle cx="21" cy="34" r="1.5" fill="#10b981"/>
                                <circle cx="27" cy="34" r="1.5" fill="#10b981"/>
                            </svg>
                        </div>
                        <div class="team-item-info">
                            <div class="team-item-name-row">
                                <span class="team-item-name">Kumar Arya</span>
                                <span class="team-badge-tag member">Member</span>
                            </div>
                        </div>
                    </div>
                    <div class="team-member-right">
                        <span class="team-status-cell">
                            <span class="pulse-dot pulse-dot-green"></span>
                            Active
                        </span>
                    </div>
                </div>

                <!-- 4. ROHAN TEVATIA (Member) -->
                <div class="team-member-item">
                    <div class="team-member-left">
                        <div class="team-avatar-frame">
                            <svg width="34" height="34" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <ellipse cx="24" cy="17" rx="8" ry="7" fill="#8b5cf6"/>
                                <path d="M16 17C16 17 19 19.5 28 18.5C30 18.2 32 17 32 17" stroke="#7c3aed" stroke-width="2.2" stroke-linecap="round"/>
                                <path d="M12 39C12 29 17 25 24 25C31 25 36 29 36 39Z" fill="#1e1e2d"/>
                                <path d="M20 25L24 30L28 25" stroke="#8b5cf6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                <circle cx="21" cy="34" r="1.5" fill="#10b981"/>
                                <circle cx="27" cy="34" r="1.5" fill="#10b981"/>
                            </svg>
                        </div>
                        <div class="team-item-info">
                            <div class="team-item-name-row">
                                <span class="team-item-name">ROHAN TEVATIA</span>
                                <span class="team-badge-tag member">Member</span>
                            </div>
                        </div>
                    </div>
                    <div class="team-member-right">
                        <span class="team-status-cell">
                            <span class="pulse-dot pulse-dot-green"></span>
                            Active
                        </span>
                    </div>
                </div>
            </div>

            <!-- Footer with University affiliation and Actions -->
            <div class="team-modal-footer">
                <div style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.78rem; color: var(--text-muted);">
                    <span style="font-weight: 700; color: var(--text-secondary);">Galgotias University</span>
                    <span>&bull;</span>
                    <span>School of Computing Science and Engineering &bull; TeamRootOps</span>
                </div>
                <div>
                    <button type="button" class="btn btn-primary btn-sm" onclick="closeTeamModal()" style="min-width: 90px;">Done</button>
                </div>
            </div>
        </div>
    </div>

    <main class="main-content">
