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
    <div class="card stat-card">
        <span class="stat-label">Available Liquid Balance</span>
        <span class="stat-value" style="color: #34d399;">$<%= String.format("%,.2f", user.getBalance()) %></span>
        <span class="stat-meta">
            <span class="badge badge-success"><%= user.getStatus().name() %></span>
            Account FDIC Insured
        </span>
    </div>

    <div class="card stat-card">
        <span class="stat-label">Active Fraud Shield</span>
        <span class="stat-value" style="color: #38bdf8;">ACTIVE</span>
        <span class="stat-meta">
            7 Behavioral ML Rules Active
        </span>
    </div>

    <div class="card stat-card">
        <span class="stat-label">Pending Security Flags</span>
        <span class="stat-value" style="<%= userAlerts != null && !userAlerts.isEmpty() ? "color: #fbbf24;" : "color: #9ca3af;" %>">
            <%= userAlerts != null ? userAlerts.size() : 0 %>
        </span>
        <span class="stat-meta">
            <a href="<%= cp %>/alerts" style="text-decoration: underline;">View details &rarr;</a>
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
        <div style="padding: 2.5rem; text-align: center; color: var(--text-muted);">
            No transactions found on this account yet. Click "Send Money" to test the fraud engine.
        </div>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp" />
