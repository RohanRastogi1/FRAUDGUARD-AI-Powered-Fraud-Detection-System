<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.FraudAlert" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    request.setAttribute("pageTitle", "Security Alerts");
    List<FraudAlert> alerts = (List<FraudAlert>) request.getAttribute("alerts");
    String cp = request.getContextPath();
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">Security & Fraud Notifications</h1>
        <p class="page-subtitle">Security anomalies flagged by automated behavioral rules for your account protection.</p>
    </div>
</div>

<div class="card">
    <% if (alerts != null && !alerts.isEmpty()) { %>
        <div class="table-container">
            <table class="data-table responsive-card-table">
                <thead>
                    <tr>
                        <th>Alert ID</th>
                        <th>Created</th>
                        <th>Tx Reference</th>
                        <th>Amount</th>
                        <th>Risk Score</th>
                        <th>Triggered Rules</th>
                        <th>Reason / Explanation</th>
                        <th>Status</th>
                        <th>Analyst Review Notes</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (FraudAlert a : alerts) { 
                        String statusBadge = "badge-info";
                        if ("RESOLVED".equals(a.getStatus().name())) statusBadge = "badge-success";
                        else if ("UNDER_REVIEW".equals(a.getStatus().name())) statusBadge = "badge-warning";
                        else if ("OPEN".equals(a.getStatus().name())) statusBadge = "badge-danger";
                    %>
                        <tr>
                            <td data-label="Alert ID">#<%= a.getId() %></td>
                            <td data-label="Created"><%= a.getCreatedAt() != null ? a.getCreatedAt().format(dtf) : "—" %></td>
                            <td data-label="Tx Reference"><code><%= a.getTransactionRef() %></code></td>
                            <td data-label="Amount" style="font-weight: 700;">₹<%= String.format("%,.2f", a.getAmount()) %></td>
                            <td data-label="Risk Score">
                                <span class="badge <%= a.getRiskScore() >= 85 ? "badge-critical" : (a.getRiskScore() >= 60 ? "badge-danger" : "badge-warning") %>">
                                    <%= a.getRiskScore() %>/100 (<%= a.getRiskLevel().name() %>)
                                </span>
                            </td>
                            <td data-label="Triggered Rules"><code><%= a.getTriggeredRules() %></code></td>
                            <td data-label="Reason / Details" style="font-size: 0.82rem; color: var(--text-secondary); word-break: normal; overflow-wrap: break-word;"><%= a.getReason() %></td>
                            <td data-label="Status"><span class="badge <%= statusBadge %>"><%= a.getStatus().name() %></span></td>
                            <td data-label="Analyst Notes" style="font-size: 0.82rem; color: #a5b4fc;"><%= a.getReviewNotes() != null ? a.getReviewNotes() : "Under routine monitoring" %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div style="padding: 3rem; text-align: center; color: var(--text-muted);">
            <div style="font-size: 2rem; margin-bottom: 0.5rem;">🛡️</div>
            <h3>No Active Security Alerts</h3>
            <p style="margin-top: 0.25rem;">Your account is completely clear. No abnormal activity detected.</p>
        </div>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp" />
