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
    <div style="display: flex; gap: 0.75rem;">
        <a href="<%= cp %>/admin/transactions" class="btn btn-secondary btn-sm">All Transactions</a>
        <a href="<%= cp %>/admin/alerts" class="btn btn-primary btn-sm">Alerts Triage (<%= stats.getOpenAlerts() %>)</a>
    </div>
</div>

<% if ("user_status_updated".equals(msg)) { %>
    <div class="alert-box alert-success">
        <span>User account security status updated successfully.</span>
    </div>
<% } %>

<!-- High-Level KPI Stat Cards (Real Database Data) -->
<div class="grid grid-cols-4" style="margin-bottom: 2rem;">
    <div class="card stat-card stat-card-emerald">
        <span class="stat-label">
            <span>Processed Volume</span>
            <span style="font-size: 1.1rem;">💰</span>
        </span>
        <span class="stat-value" style="color: #34d399;">$<%= String.format("%,.2f", stats.getTotalApprovedVolume()) %></span>
        <span class="stat-meta">
            <span><%= stats.getApprovedCount() %> Approved Transactions</span>
        </span>
    </div>

    <div class="card stat-card stat-card-cyan">
        <span class="stat-label">
            <span>Total Transactions</span>
            <span style="font-size: 1.1rem;">📊</span>
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
            <span style="font-size: 1.1rem;">🛡️</span>
        </span>
        <span class="stat-value" style="color: #a78bfa;"><%= String.format("%.1f", stats.getFraudDetectionRate()) %>%</span>
        <span class="stat-meta">Anomalous / Intercepted transfers</span>
    </div>

    <div class="card stat-card stat-card-rose">
        <span class="stat-label">
            <span>Active Fraud Alerts</span>
            <span style="font-size: 1.1rem;">🚨</span>
        </span>
        <span class="stat-value" style="<%= stats.getOpenAlerts() > 0 ? "color: #f43f5e;" : "color: #9ca3af;" %>">
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
            <h2 class="card-title" style="color: #fb7185;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                    <line x1="12" y1="9" x2="12" y2="13"></line>
                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                </svg>
                Recent Fraud Alerts
            </h2>
            <a href="<%= cp %>/admin/alerts" class="btn btn-secondary btn-sm">Triage Console &rarr;</a>
        </div>

        <% if (stats.getRecentAlerts() != null && !stats.getRecentAlerts().isEmpty()) { %>
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
                                <td style="font-weight: 700;">$<%= String.format("%,.2f", a.getAmount()) %></td>
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
        <% } else { %>
            <div style="text-align: center; padding: 2.75rem 1.5rem;">
                <div style="width: 48px; height: 48px; background: rgba(16, 185, 129, 0.1); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 0.85rem; border: 1px solid rgba(16, 185, 129, 0.25);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        <polyline points="9 12 11 14 15 10"></polyline>
                    </svg>
                </div>
                <h4 style="font-weight: 700; color: #fff; margin-bottom: 0.35rem; font-size: 1.05rem;">Zero Active Fraud Alerts</h4>
                <p style="color: var(--text-muted); font-size: 0.86rem; max-width: 320px; margin: 0 auto;">Live transactions are actively monitored. Zero policy violations or anomalies detected.</p>
            </div>
        <% } %>
    </div>

    <!-- Live Transactions Card -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">Live Transactions Stream</h2>
            <a href="<%= cp %>/admin/transactions" class="btn btn-secondary btn-sm">View All &rarr;</a>
        </div>

        <% if (stats.getRecentTransactions() != null && !stats.getRecentTransactions().isEmpty()) { %>
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
                                <td style="font-weight: 700;">$<%= String.format("%,.2f", tx.getAmount()) %></td>
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
        <% } else { %>
            <div style="text-align: center; padding: 2.75rem 1.5rem;">
                <div style="width: 48px; height: 48px; background: rgba(79, 70, 229, 0.1); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 0.85rem; border: 1px solid rgba(79, 70, 229, 0.25);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#818cf8" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="12" y1="1" x2="12" y2="23"></line>
                        <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                    </svg>
                </div>
                <h4 style="font-weight: 700; color: #fff; margin-bottom: 0.35rem; font-size: 1.05rem;">Awaiting Live Transactions</h4>
                <p style="color: var(--text-muted); font-size: 0.86rem; max-width: 320px; margin: 0 auto;">Initiate transfers from the customer portal to monitor pipeline scoring and real-time execution.</p>
            </div>
        <% } %>
    </div>
</div>

<!-- User Account Management (Admin Role) -->
<div class="card" style="margin-bottom: 2rem;">
    <div class="card-header">
        <h2 class="card-title">User Accounts & Access Control</h2>
        <span class="badge badge-info"><%= users != null ? users.size() : 0 %> Registered Accounts</span>
    </div>

    <% if (users != null && !users.isEmpty()) { %>
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
                            <td><strong><%= u.getUsername() %></strong></td>
                            <td><%= u.getFullName() %></td>
                            <td><%= u.getEmail() %></td>
                            <td>
                                <span class="badge <%= u.isAdmin() ? "badge-danger" : (u.isAnalyst() ? "badge-info" : "badge-success") %>">
                                    <%= u.getRole().name() %>
                                </span>
                            </td>
                            <td style="font-weight: 700;">$<%= String.format("%,.2f", u.getBalance()) %></td>
                            <td>
                                <span class="badge <%= u.getStatus().name().equals("ACTIVE") ? "badge-success" : (u.getStatus().name().equals("SUSPENDED") ? "badge-warning" : "badge-critical") %>">
                                    <%= u.getStatus().name() %>
                                </span>
                            </td>
                            <td>
                                <% if (!u.isAdmin()) { %>
                                    <form action="<%= cp %>/admin/user-action" method="post" style="display: inline-flex; gap: 0.35rem;">
                                        <input type="hidden" name="userId" value="<%= u.getId() %>">
                                        <% if (u.getStatus().name().equals("ACTIVE")) { %>
                                            <button type="submit" name="status" value="SUSPENDED" class="btn btn-secondary btn-sm" title="Suspend Account">Suspend</button>
                                            <button type="submit" name="status" value="BLOCKED" class="btn btn-danger btn-sm" title="Block Account">Block</button>
                                        <% } else { %>
                                            <button type="submit" name="status" value="ACTIVE" class="btn btn-primary btn-sm" title="Restore Active">Reactivate</button>
                                        <% } %>
                                    </form>
                                <% } else { %>
                                    <span style="font-size: 0.75rem; color: var(--text-muted);">Protected Root</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

<!-- System Audit Log Stream -->
<div class="card">
    <div class="card-header">
        <h2 class="card-title">System Audit Trail</h2>
        <span class="badge badge-secondary">Immutable Event Log</span>
    </div>

    <% if (stats.getRecentAuditLogs() != null && !stats.getRecentAuditLogs().isEmpty()) { %>
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
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp" />
