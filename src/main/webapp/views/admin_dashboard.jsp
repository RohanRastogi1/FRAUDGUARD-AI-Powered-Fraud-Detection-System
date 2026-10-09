<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.service.AdminService" %>
<%@ page import="com.fraudguard.model.User" %>
<%@ page import="com.fraudguard.model.Transaction" %>
<%@ page import="com.fraudguard.model.FraudAlert" %>
<%@ page import="com.fraudguard.model.AuditLog" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    request.setAttribute("pageTitle", "Executive Fraud Monitoring Dashboard");
    AdminService.DashboardStatistics stats = (AdminService.DashboardStatistics) request.getAttribute("stats");
    List<User> users = (List<User>) request.getAttribute("users");
    String cp = request.getContextPath();
    String msg = request.getParameter("msg");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd HH:mm");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">Fraud Operations Command Center</h1>
        <p class="page-subtitle">Real-time telemetry, transaction flows, and autonomous anomaly scoring.</p>
    </div>
    <div class="page-header-actions">
        <a href="<%= cp %>/admin/transactions" class="btn btn-secondary btn-dashboard-action">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="8" y1="6" x2="21" y2="6"></line>
                <line x1="8" y1="12" x2="21" y2="12"></line>
                <line x1="8" y1="18" x2="21" y2="18"></line>
                <line x1="3" y1="6" x2="3.01" y2="6"></line>
                <line x1="3" y1="12" x2="3.01" y2="12"></line>
                <line x1="3" y1="18" x2="3.01" y2="18"></line>
            </svg>
            <span>All Transactions</span>
        </a>
        <a href="<%= cp %>/admin/alerts" class="btn btn-primary btn-dashboard-action">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                <line x1="12" y1="9" x2="12" y2="13"></line>
                <line x1="12" y1="17" x2="12.01" y2="17"></line>
            </svg>
            <span>Alerts Triage (<%= stats.getOpenAlerts() %>)</span>
        </a>
    </div>
</div>

<% if ("user_status_updated".equals(msg)) { %>
    <div class="alert-box alert-success">
        <span>User account security status updated successfully.</span>
    </div>
<% } else if ("action_disabled_demo".equals(msg)) { %>
    <div class="alert-box alert-warning">
        <span>Account suspension and blocking actions are disabled for live demonstration stability.</span>
    </div>
<% } %>

<!-- High-Level KPI Stat Cards (Real Database Data) -->
<div class="grid grid-cols-4 stat-grid" style="margin-bottom: 2rem;">
    <div class="card stat-card stat-card-emerald">
        <span class="stat-label">
            <span>Processed Volume</span>
            <span class="stat-icon-badge stat-icon-emerald">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="6" y1="4" x2="18" y2="4"></line>
                    <line x1="6" y1="9" x2="18" y2="9"></line>
                    <path d="M6 4h6a4 4 0 0 1 0 8H6"></path>
                    <path d="M6 12l8 9"></path>
                </svg>
            </span>
        </span>
        <span class="stat-value" style="color: #10b981;">₹<%= String.format("%,.2f", stats.getTotalApprovedVolume()) %></span>
        <span class="stat-meta">
            <span><%= stats.getApprovedCount() %> Approved Transactions</span>
        </span>
    </div>

    <div class="card stat-card stat-card-cyan">
        <span class="stat-label">
            <span>Total Transactions</span>
            <span class="stat-icon-badge stat-icon-cyan">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                </svg>
            </span>
        </span>
        <span class="stat-value"><%= stats.getTotalTransactions() %></span>
        <span class="stat-meta">
            <span style="color: #fb7185;"><%= stats.getRejectedCount() %> Rejected</span> &bull; 
            <span style="color: #fbbf24;"><%= stats.getFlaggedCount() %> Flagged</span>
        </span>
    </div>

    <div class="card stat-card stat-card-purple">
        <span class="stat-label">
            <span>Fraud Intercept Rate</span>
            <span class="stat-icon-badge stat-icon-purple">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    <path d="M9 12l2 2 4-4"/>
                </svg>
            </span>
        </span>
        <span class="stat-value" style="color: #a78bfa;"><%= String.format("%.1f", stats.getFraudDetectionRate()) %>%</span>
        <span class="stat-meta">Anomalous / Intercepted transfers</span>
    </div>

    <div class="card stat-card stat-card-rose">
        <span class="stat-label">
            <span>Active Fraud Alerts</span>
            <span class="stat-icon-badge stat-icon-rose">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
            </span>
        </span>
        <span class="stat-value" style="<%= stats.getOpenAlerts() > 0 ? "color: #f43f5e;" : "color: var(--text-muted);" %>">
            <%= stats.getOpenAlerts() %>
        </span>
        <span class="stat-meta">
            <span>Total Logged: <%= stats.getTotalAlerts() %></span>
        </span>
    </div>
</div>

<!-- Main Split Grid: Recent Alerts & Live Transactions -->
<div class="grid grid-cols-2" style="margin-bottom: 2rem;">
    <!-- Active Alerts Card -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">
                <span class="card-title-icon card-title-icon-rose">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                        <line x1="12" y1="9" x2="12" y2="13"></line>
                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                    </svg>
                </span>
                Recent Fraud Alerts
            </h2>
            <a href="<%= cp %>/admin/alerts" class="btn btn-card-action">
                <span>Triage Console</span>
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
            </a>
        </div>

        <% if (stats.getRecentAlerts() != null && !stats.getRecentAlerts().isEmpty()) { %>
            <div class="desktop-only-view">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ref</th>
                                <th>Amount</th>
                                <th>Score</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (FraudAlert a : stats.getRecentAlerts()) { %>
                                <tr>
                                    <td><code><%= a.getTransactionRef() %></code></td>
                                    <td style="font-weight: 700;">₹<%= String.format("%,.2f", a.getAmount()) %></td>
                                    <td>
                                        <span class="badge <%= a.getRiskScore() >= 85 ? "badge-critical" : (a.getRiskScore() >= 60 ? "badge-danger" : "badge-warning") %>">
                                            <%= a.getRiskScore() %>/100
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge <%= "RESOLVED".equals(a.getStatus().name()) ? "badge-success" : ("OPEN".equals(a.getStatus().name()) ? "badge-danger" : "badge-warning") %>">
                                            <%= a.getStatus().name() %>
                                        </span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="mobile-only-cards">
                <% for (FraudAlert a : stats.getRecentAlerts()) { %>
                    <div class="mobile-stream-card">
                        <div class="m-card-top">
                            <div class="m-card-ref">
                                <code><%= a.getTransactionRef() %></code>
                            </div>
                            <div class="m-card-amount">
                                ₹<%= String.format("%,.2f", a.getAmount()) %>
                            </div>
                        </div>
                        <div class="m-card-bottom">
                            <div class="m-card-badges">
                                <span class="badge <%= a.getRiskScore() >= 85 ? "badge-critical" : (a.getRiskScore() >= 60 ? "badge-danger" : "badge-warning") %>">
                                    Score: <%= a.getRiskScore() %>/100
                                </span>
                                <span class="badge <%= "RESOLVED".equals(a.getStatus().name()) ? "badge-success" : ("OPEN".equals(a.getStatus().name()) ? "badge-danger" : "badge-warning") %>">
                                    <%= a.getStatus().name() %>
                                </span>
                            </div>
                            <% if (a.getTriggeredRules() != null && !a.getTriggeredRules().isEmpty()) { %>
                                <span class="m-card-rule"><%= a.getTriggeredRules() %></span>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div style="text-align: center; padding: 2.75rem 1.5rem;">
                <div style="width: 52px; height: 52px; background: rgba(16, 185, 129, 0.12); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 0.85rem; border: 1px solid rgba(16, 185, 129, 0.28); box-shadow: 0 4px 16px rgba(16, 185, 129, 0.15);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        <polyline points="9 12 11 14 15 10"></polyline>
                    </svg>
                </div>
                <h4 style="font-weight: 700; color: var(--text-primary); margin-bottom: 0.35rem; font-size: 1.05rem;">Zero Active Fraud Alerts</h4>
                <p style="color: var(--text-muted); font-size: 0.86rem; max-width: 320px; margin: 0 auto;">Live transactions are actively monitored. Zero policy violations or anomalies detected.</p>
            </div>
        <% } %>
    </div>

    <!-- Live Transactions Card -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">
                <span class="card-title-icon card-title-icon-cyan">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                    </svg>
                </span>
                Live Transactions Stream
            </h2>
            <a href="<%= cp %>/admin/transactions" class="btn btn-card-action">
                <span>View All</span>
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
            </a>
        </div>

        <% if (stats.getRecentTransactions() != null && !stats.getRecentTransactions().isEmpty()) { %>
            <div class="desktop-only-view">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ref</th>
                                <th>Amount</th>
                                <th>Score</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Transaction tx : stats.getRecentTransactions()) { %>
                                <tr>
                                    <td><code><%= tx.getTransactionRef() %></code></td>
                                    <td style="font-weight: 700;">₹<%= String.format("%,.2f", tx.getAmount()) %></td>
                                    <td>
                                        <span class="badge <%= tx.getRiskScore() >= 85 ? "badge-critical" : (tx.getRiskScore() >= 60 ? "badge-danger" : (tx.getRiskScore() >= 30 ? "badge-warning" : "badge-success")) %>">
                                            <%= tx.getRiskScore() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge <%= tx.getStatus().name().equals("APPROVED") ? "badge-success" : (tx.getStatus().name().equals("FLAGGED") ? "badge-warning" : "badge-danger") %>">
                                            <%= tx.getStatus().name() %>
                                        </span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="mobile-only-cards">
                <% for (Transaction tx : stats.getRecentTransactions()) { %>
                    <div class="mobile-stream-card">
                        <div class="m-card-top">
                            <div class="m-card-ref">
                                <code><%= tx.getTransactionRef() %></code>
                            </div>
                            <div class="m-card-amount">
                                ₹<%= String.format("%,.2f", tx.getAmount()) %>
                            </div>
                        </div>
                        <div class="m-card-bottom">
                            <div class="m-card-badges">
                                <span class="badge <%= tx.getRiskScore() >= 85 ? "badge-critical" : (tx.getRiskScore() >= 60 ? "badge-danger" : (tx.getRiskScore() >= 30 ? "badge-warning" : "badge-success")) %>">
                                    Score: <%= tx.getRiskScore() %>/100
                                </span>
                                <span class="badge <%= tx.getStatus().name().equals("APPROVED") ? "badge-success" : (tx.getStatus().name().equals("FLAGGED") ? "badge-warning" : "badge-danger") %>">
                                    <%= tx.getStatus().name() %>
                                </span>
                            </div>
                            <% if (tx.getRecipientName() != null && !tx.getRecipientName().isEmpty()) { %>
                                <span class="m-card-meta"><%= tx.getRecipientName() %></span>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div style="text-align: center; padding: 2.75rem 1.5rem;">
                <div style="width: 52px; height: 52px; background: rgba(56, 189, 248, 0.12); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 0.85rem; border: 1px solid rgba(56, 189, 248, 0.28); box-shadow: 0 4px 16px rgba(56, 189, 248, 0.15);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--accent-sky)" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="6" y1="4" x2="18" y2="4"></line>
                        <line x1="6" y1="9" x2="18" y2="9"></line>
                        <path d="M6 4h6a4 4 0 0 1 0 8H6"></path>
                        <path d="M6 12l8 9"></path>
                    </svg>
                </div>
                <h4 style="font-weight: 700; color: var(--text-primary); margin-bottom: 0.35rem; font-size: 1.05rem;">Awaiting Live Transactions</h4>
                <p style="color: var(--text-muted); font-size: 0.86rem; max-width: 320px; margin: 0 auto;">Initiate transfers from the customer portal to monitor pipeline scoring and real-time execution.</p>
            </div>
        <% } %>
    </div>
</div>

<div class="team-card" id="team-members">
    <div class="card-header" style="border-bottom: 1px solid var(--border-subtle); padding-bottom: 1rem; margin-bottom: 1.25rem;">
        <h2 class="card-title">
            <span class="card-title-icon card-title-icon-amber">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
            </span>
            Team Members
        </h2>
        <span class="team-header-badge">
            <span class="pulse-dot pulse-dot-green"></span>
            TeamRootOps &bull; Galgotias University
        </span>
    </div>

    <div class="table-container">
        <table class="team-table">
            <thead>
                <tr>
                    <th style="width: 50%;">MEMBER</th>
                    <th style="width: 28%;">STATUS</th>
                    <th style="width: 22%;">ROLE</th>
                </tr>
            </thead>
            <tbody>
                <!-- 1. Rohan Rastogi (Leader / Admin) -->
                <tr>
                    <td>
                        <div class="team-member-cell">
                            <div class="team-avatar-box">
                                <svg width="34" height="34" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <ellipse cx="24" cy="17" rx="8" ry="7" fill="#8b5cf6"/>
                                    <path d="M16 17C16 17 19 19.5 28 18.5C30 18.2 32 17 32 17" stroke="#7c3aed" stroke-width="2.2" stroke-linecap="round"/>
                                    <path d="M12 39C12 29 17 25 24 25C31 25 36 29 36 39Z" fill="#1e1e2d"/>
                                    <path d="M20 25L24 30L28 25" stroke="#8b5cf6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <circle cx="21" cy="34" r="1.5" fill="#10b981"/>
                                    <circle cx="27" cy="34" r="1.5" fill="#10b981"/>
                                </svg>
                            </div>
                            <div class="team-member-info">
                                <div style="display: flex; align-items: center; gap: 0.45rem;">
                                    <span class="team-member-name">Rohan Rastogi</span>
                                    <span style="font-size: 0.65rem; background: rgba(194, 122, 46, 0.15); color: var(--primary); border: 1px solid rgba(194, 122, 46, 0.35); padding: 0.05rem 0.4rem; border-radius: 999px; font-weight: 700;">Leader</span>
                                </div>
                                <span class="team-member-email" style="font-family: inherit; font-size: 0.8rem; color: var(--text-muted);">TeamRootOps &bull; Galgotias University</span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <span class="team-status-cell">
                            <span class="pulse-dot pulse-dot-green"></span>
                            Active
                        </span>
                    </td>
                    <td>
                        <span class="team-role-cell admin">Admin</span>
                    </td>
                </tr>

                <!-- 2. Anant Kumar (Member) -->
                <tr>
                    <td>
                        <div class="team-member-cell">
                            <div class="team-avatar-box">
                                <svg width="34" height="34" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <ellipse cx="24" cy="17" rx="8" ry="7" fill="#8b5cf6"/>
                                    <path d="M16 17C16 17 19 19.5 28 18.5C30 18.2 32 17 32 17" stroke="#7c3aed" stroke-width="2.2" stroke-linecap="round"/>
                                    <path d="M12 39C12 29 17 25 24 25C31 25 36 29 36 39Z" fill="#1e1e2d"/>
                                    <path d="M20 25L24 30L28 25" stroke="#8b5cf6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <circle cx="21" cy="34" r="1.5" fill="#10b981"/>
                                    <circle cx="27" cy="34" r="1.5" fill="#10b981"/>
                                </svg>
                            </div>
                            <div class="team-member-info">
                                <span class="team-member-name">Anant Kumar</span>
                                <span class="team-member-email" style="font-family: inherit; font-size: 0.8rem; color: var(--text-muted);">TeamRootOps &bull; Galgotias University</span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <span class="team-status-cell">
                            <span class="pulse-dot pulse-dot-green"></span>
                            Active
                        </span>
                    </td>
                    <td>
                        <span class="team-role-cell">Member</span>
                    </td>
                </tr>

                <!-- 3. Kumar Arya (Member) -->
                <tr>
                    <td>
                        <div class="team-member-cell">
                            <div class="team-avatar-box">
                                <svg width="34" height="34" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <ellipse cx="24" cy="17" rx="8" ry="7" fill="#8b5cf6"/>
                                    <path d="M16 17C16 17 19 19.5 28 18.5C30 18.2 32 17 32 17" stroke="#7c3aed" stroke-width="2.2" stroke-linecap="round"/>
                                    <path d="M12 39C12 29 17 25 24 25C31 25 36 29 36 39Z" fill="#1e1e2d"/>
                                    <path d="M20 25L24 30L28 25" stroke="#8b5cf6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <circle cx="21" cy="34" r="1.5" fill="#10b981"/>
                                    <circle cx="27" cy="34" r="1.5" fill="#10b981"/>
                                </svg>
                            </div>
                            <div class="team-member-info">
                                <span class="team-member-name">Kumar Arya</span>
                                <span class="team-member-email" style="font-family: inherit; font-size: 0.8rem; color: var(--text-muted);">TeamRootOps &bull; Galgotias University</span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <span class="team-status-cell">
                            <span class="pulse-dot pulse-dot-green"></span>
                            Active
                        </span>
                    </td>
                    <td>
                        <span class="team-role-cell">Member</span>
                    </td>
                </tr>

                <!-- 4. ROHAN TEVATIA (Member) -->
                <tr>
                    <td>
                        <div class="team-member-cell">
                            <div class="team-avatar-box">
                                <svg width="34" height="34" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <ellipse cx="24" cy="17" rx="8" ry="7" fill="#8b5cf6"/>
                                    <path d="M16 17C16 17 19 19.5 28 18.5C30 18.2 32 17 32 17" stroke="#7c3aed" stroke-width="2.2" stroke-linecap="round"/>
                                    <path d="M12 39C12 29 17 25 24 25C31 25 36 29 36 39Z" fill="#1e1e2d"/>
                                    <path d="M20 25L24 30L28 25" stroke="#8b5cf6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <circle cx="21" cy="34" r="1.5" fill="#10b981"/>
                                    <circle cx="27" cy="34" r="1.5" fill="#10b981"/>
                                </svg>
                            </div>
                            <div class="team-member-info">
                                <span class="team-member-name">ROHAN TEVATIA</span>
                                <span class="team-member-email" style="font-family: inherit; font-size: 0.8rem; color: var(--text-muted);">TeamRootOps &bull; Galgotias University</span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <span class="team-status-cell">
                            <span class="pulse-dot pulse-dot-green"></span>
                            Active
                        </span>
                    </td>
                    <td>
                        <span class="team-role-cell">Member</span>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<!-- User Account Management (Admin Role) -->
<div class="card" style="margin-bottom: 2rem;">
    <div class="card-header">
        <h2 class="card-title">
            <span class="card-title-icon card-title-icon-amber">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
            </span>
            User Accounts &amp; Access Control
        </h2>
        <span class="badge badge-info"><%= users != null ? users.size() : 0 %> Registered Accounts</span>
    </div>

    <% if (users != null && !users.isEmpty()) { %>
        <div class="desktop-only-view">
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Balance</th>
                            <th>Status</th>
                            <th>Security Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User u : users) { %>
                            <tr>
                                <td>#<%= u.getId() %></td>
                                <td><strong><%= u.getUsername() != null && u.getUsername().contains("@galgotiasuniversity.ac.in") ? u.getUsername().substring(0, u.getUsername().indexOf("@")) : u.getUsername() %></strong></td>
                                <td><%= u.getFullName() %></td>
                                <td><code><%= u.getEmail() != null && u.getEmail().contains("@galgotiasuniversity.ac.in") ? (u.getUsername().replaceAll("[^a-zA-Z0-9_]", "") + "@fraudguard.local") : u.getEmail() %></code></td>
                                <td>
                                    <span class="badge <%= u.isAdmin() ? "badge-danger" : (u.isAnalyst() ? "badge-info" : "badge-success") %>">
                                        <%= u.getRole().name() %>
                                    </span>
                                </td>
                                <td style="font-weight: 700;">₹<%= String.format("%,.2f", u.getBalance()) %></td>
                                <td>
                                    <span class="badge <%= u.getStatus().name().equals("ACTIVE") ? "badge-success" : (u.getStatus().name().equals("SUSPENDED") ? "badge-warning" : "badge-critical") %>">
                                        <%= u.getStatus().name() %>
                                    </span>
                                </td>
                                <td>
                                    <% if (!u.isAdmin()) { %>
                                        <div style="display: inline-flex; gap: 0.35rem; align-items: center;">
                                            <% if (u.getStatus().name().equals("ACTIVE")) { %>
                                                <button type="button" class="btn btn-secondary btn-sm" disabled style="opacity: 0.55; cursor: not-allowed; pointer-events: none;" title="Account suspension disabled for demo mode">Suspend</button>
                                                <button type="button" class="btn btn-danger btn-sm" disabled style="opacity: 0.55; cursor: not-allowed; pointer-events: none;" title="Account blocking disabled for demo mode">Block</button>
                                            <% } else { %>
                                                <button type="button" class="btn btn-primary btn-sm" disabled style="opacity: 0.55; cursor: not-allowed; pointer-events: none;" title="Reactivation disabled for demo mode">Reactivate</button>
                                            <% } %>
                                        </div>
                                    <% } else { %>
                                        <span style="font-size: 0.75rem; color: var(--text-muted);">Protected Root</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="mobile-only-cards">
            <% for (User u : users) { 
                String cleanUsername = u.getUsername() != null && u.getUsername().contains("@galgotiasuniversity.ac.in") ? u.getUsername().substring(0, u.getUsername().indexOf("@")) : u.getUsername();
                String cleanEmail = u.getEmail() != null && u.getEmail().contains("@galgotiasuniversity.ac.in") ? (u.getUsername().replaceAll("[^a-zA-Z0-9_]", "") + "@fraudguard.local") : u.getEmail();
                String avatarLetter = (u.getFullName() != null && !u.getFullName().isEmpty()) ? u.getFullName().substring(0, 1).toUpperCase() : (cleanUsername != null ? cleanUsername.substring(0, 1).toUpperCase() : "U");
            %>
                <div class="user-account-card">
                    <div class="u-card-header">
                        <div class="u-card-avatar"><%= avatarLetter %></div>
                        <div class="u-card-user-info">
                            <div class="u-card-name-row">
                                <span class="u-card-fullname"><%= u.getFullName() %></span>
                                <span class="badge <%= u.isAdmin() ? "badge-danger" : (u.isAnalyst() ? "badge-info" : "badge-success") %>">
                                    <%= u.getRole().name() %>
                                </span>
                            </div>
                            <div class="u-card-meta-row">
                                <span class="u-card-username">@<%= cleanUsername %></span>
                                <span class="u-card-dot">&bull;</span>
                                <span class="u-card-id">ID #<%= u.getId() %></span>
                            </div>
                        </div>
                        <span class="badge <%= u.getStatus().name().equals("ACTIVE") ? "badge-success" : (u.getStatus().name().equals("SUSPENDED") ? "badge-warning" : "badge-critical") %>">
                            <%= u.getStatus().name() %>
                        </span>
                    </div>

                    <div class="u-card-body">
                        <div class="u-card-field">
                            <span class="u-field-label">Email</span>
                            <code class="u-field-code"><%= cleanEmail %></code>
                        </div>
                        <div class="u-card-field">
                            <span class="u-field-label">Balance</span>
                            <span class="u-field-balance">₹<%= String.format("%,.2f", u.getBalance()) %></span>
                        </div>
                    </div>

                    <div class="u-card-actions">
                        <% if (!u.isAdmin()) { %>
                            <div class="u-action-btn-group">
                                <% if (u.getStatus().name().equals("ACTIVE")) { %>
                                    <button type="button" class="btn btn-secondary btn-sm" disabled style="opacity: 0.55; cursor: not-allowed; pointer-events: none;" title="Account suspension disabled for demo mode">Suspend</button>
                                    <button type="button" class="btn btn-danger btn-sm" disabled style="opacity: 0.55; cursor: not-allowed; pointer-events: none;" title="Account blocking disabled for demo mode">Block</button>
                                <% } else { %>
                                    <button type="button" class="btn btn-primary btn-sm" disabled style="opacity: 0.55; cursor: not-allowed; pointer-events: none;" title="Reactivation disabled for demo mode">Reactivate</button>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="u-protected-badge">
                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                <span>Protected Root Administrator</span>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<!-- System Audit Log Stream -->
<div class="card">
    <div class="card-header">
        <h2 class="card-title">
            <span class="card-title-icon card-title-icon-purple">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                    <polyline points="10 9 9 9 8 9"></polyline>
                </svg>
            </span>
            System Audit Trail
        </h2>
        <span class="badge badge-secondary">Immutable Event Log</span>
    </div>

    <% if (stats.getRecentAuditLogs() != null && !stats.getRecentAuditLogs().isEmpty()) { %>
        <div class="desktop-only-view">
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Time</th>
                            <th>User</th>
                            <th>Action</th>
                            <th>Entity</th>
                            <th>Details</th>
                            <th>Client IP</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (AuditLog log : stats.getRecentAuditLogs()) { %>
                            <tr>
                                <td><%= log.getTimestamp() != null ? log.getTimestamp().format(dtf) : "—" %></td>
                                <td><strong><%= log.getUsername() != null ? log.getUsername() : "SYSTEM" %></strong></td>
                                <td><code><%= log.getAction() %></code></td>
                                <td><%= log.getEntityType() %></td>
                                <td style="font-size: 0.82rem; color: var(--text-secondary); max-width: 350px;"><%= log.getDetails() %></td>
                                <td><small style="color: var(--text-muted);"><%= log.getIpAddress() %></small></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="mobile-only-cards">
            <% for (AuditLog log : stats.getRecentAuditLogs()) { %>
                <div class="audit-log-card">
                    <div class="audit-card-top">
                        <div class="audit-card-user">
                            <strong><%= log.getUsername() != null ? log.getUsername() : "SYSTEM" %></strong>
                            <span class="badge <%= log.getAction().contains("BLOCK") ? "badge-critical" : (log.getAction().contains("SUSPEND") ? "badge-danger" : "badge-info") %>">
                                <%= log.getAction() %>
                            </span>
                        </div>
                        <span class="audit-card-time"><%= log.getTimestamp() != null ? log.getTimestamp().format(dtf) : "—" %></span>
                    </div>
                    <div class="audit-card-body">
                        <span class="audit-card-details"><%= log.getDetails() %></span>
                    </div>
                    <div class="audit-card-footer">
                        <code><%= log.getEntityType() %></code>
                        <small class="audit-card-ip">IP: <%= log.getIpAddress() %></small>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp" />
