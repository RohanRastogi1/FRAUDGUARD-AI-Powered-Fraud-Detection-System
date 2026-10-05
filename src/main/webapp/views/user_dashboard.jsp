<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.User" %>
<%@ page import="com.fraudguard.model.Transaction" %>
<%@ page import="com.fraudguard.model.FraudAlert" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    request.setAttribute("pageTitle", "Customer Portal");
    User user = (User) request.getAttribute("user");
    List<Transaction> recentTransactions = (List<Transaction>) request.getAttribute("recentTransactions");
    List<FraudAlert> userAlerts = (List<FraudAlert>) request.getAttribute("userAlerts");
    String cp = request.getContextPath();
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">Welcome back, <%= user.getFullName() %></h1>
        <p class="page-subtitle">Your banking transactions are monitored in real time by FraudGuard AI Engine.</p>
    </div>
    <div>
        <a href="<%= cp %>/transaction/new" class="btn btn-primary" id="new-tx-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            Send Money
        </a>
    </div>
</div>

<div class="grid grid-cols-3" style="margin-bottom: 2rem;">
    <div class="card stat-card stat-card-emerald">
        <span class="stat-label">
            <span>Available Liquid Balance</span>
            <span style="font-size: 1.1rem;">💳</span>
        </span>
        <span class="stat-value" style="color: #34d399;">$<%= String.format("%,.2f", user.getBalance()) %></span>
        <span class="stat-meta">
            <span class="badge badge-success"><%= user.getStatus().name() %></span>
            <span>Account FDIC Insured</span>
        </span>
    </div>

    <div class="card stat-card stat-card-cyan">
        <span class="stat-label">
            <span>Autonomous Fraud Shield</span>
            <span style="font-size: 1.1rem;">🛡️</span>
        </span>
        <span class="stat-value" style="color: #38bdf8;">ACTIVE</span>
        <span class="stat-meta">
            <span>7 Behavioral Rules Online</span>
        </span>
    </div>

    <div class="card stat-card stat-card-purple">
        <span class="stat-label">
            <span>Pending Security Flags</span>
            <span style="font-size: 1.1rem;">⚠️</span>
        </span>
        <span class="stat-value" style="<%= userAlerts != null && !userAlerts.isEmpty() ? "color: #fbbf24;" : "color: #9ca3af;" %>">
            <%= userAlerts != null ? userAlerts.size() : 0 %>
        </span>
        <span class="stat-meta">
            <a href="<%= cp %>/alerts" style="text-decoration: underline; font-weight: 600;">View flagged alerts &rarr;</a>
        </span>
    </div>
</div>

<div class="card" style="margin-bottom: 2rem;">
    <div class="card-header">
        <h2 class="card-title">Recent Transactions</h2>
        <a href="<%= cp %>/transactions" class="btn btn-secondary btn-sm">View Full History</a>
    </div>

    <% if (recentTransactions != null && !recentTransactions.isEmpty()) { %>
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Reference</th>
                        <th>Date & Time</th>
                        <th>Type</th>
                        <th>Recipient</th>
                        <th>Amount</th>
                        <th>Risk Score</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Transaction tx : recentTransactions) { 
                        String badgeClass = "badge-info";
                        if (tx.getStatus().name().equals("APPROVED")) badgeClass = "badge-success";
                        else if (tx.getStatus().name().equals("FLAGGED")) badgeClass = "badge-warning";
                        else if (tx.getStatus().name().equals("REJECTED")) badgeClass = "badge-danger";
                    %>
                        <tr>
                            <td><code><%= tx.getTransactionRef() %></code></td>
                            <td><%= tx.getTimestamp() != null ? tx.getTimestamp().format(dtf) : "—" %></td>
                            <td><%= tx.getType().getDisplayName() %></td>
                            <td><strong><%= tx.getRecipientName() %></strong><br><small style="color: var(--text-muted);"><%= tx.getRecipientAccount() %></small></td>
                            <td style="font-weight: 700; color: #fff;">$<%= String.format("%,.2f", tx.getAmount()) %></td>
                            <td>
                                <span class="badge <%= tx.getRiskScore() >= 85 ? "badge-critical" : (tx.getRiskScore() >= 60 ? "badge-danger" : (tx.getRiskScore() >= 30 ? "badge-warning" : "badge-success")) %>">
                                    <%= tx.getRiskScore() %>/100 (<%= tx.getRiskLevel().name() %>)
                                </span>
                            </td>
                            <td><span class="badge <%= badgeClass %>"><%= tx.getStatus().name() %></span></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div style="text-align: center; padding: 3rem 1.5rem;">
            <div style="width: 48px; height: 48px; background: rgba(79, 70, 229, 0.1); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 0.85rem; border: 1px solid rgba(79, 70, 229, 0.25);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#818cf8" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
            </div>
            <h4 style="font-weight: 700; color: #fff; margin-bottom: 0.35rem; font-size: 1.05rem;">No Transactions Yet</h4>
            <p style="color: var(--text-muted); font-size: 0.86rem; max-width: 320px; margin: 0 auto 1.25rem;">Your account is active and protected. Send funds to initiate your first live transfer.</p>
            <a href="<%= cp %>/transaction/new" class="btn btn-primary btn-sm">
                Initiate Transfer
            </a>
        </div>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp" />
