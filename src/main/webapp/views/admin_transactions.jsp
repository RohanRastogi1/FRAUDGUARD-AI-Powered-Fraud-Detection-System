<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.Transaction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    request.setAttribute("pageTitle", "Global Transaction Telemetry");
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String selectedRisk = (String) request.getAttribute("selectedRisk");
    String cp = request.getContextPath();
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">Global Transaction Monitor</h1>
        <p class="page-subtitle">Real-time inspection of incoming financial flows and behavioral risk scoring.</p>
    </div>
</div>

<!-- Filter Bar -->
<div class="card" style="margin-bottom: 1.5rem; padding: 1.25rem;">
    <form action="<%= cp %>/admin/transactions" method="get" style="display: flex; gap: 1rem; align-items: flex-end; flex-wrap: wrap;">
        <div style="flex: 1; min-width: 180px;">
            <label class="form-label">Transaction Status</label>
            <select name="status" class="form-control">
                <option value="ALL" <%= "ALL".equals(selectedStatus) ? "selected" : "" %>>All Statuses</option>
                <option value="APPROVED" <%= "APPROVED".equals(selectedStatus) ? "selected" : "" %>>Approved</option>
                <option value="FLAGGED" <%= "FLAGGED".equals(selectedStatus) ? "selected" : "" %>>Flagged for Review</option>
                <option value="REJECTED" <%= "REJECTED".equals(selectedStatus) ? "selected" : "" %>>Rejected</option>
            </select>
        </div>

        <div style="flex: 1; min-width: 180px;">
            <label class="form-label">Risk Level Band</label>
            <select name="riskLevel" class="form-control">
                <option value="ALL" <%= "ALL".equals(selectedRisk) ? "selected" : "" %>>All Risk Bands</option>
                <option value="LOW" <%= "LOW".equals(selectedRisk) ? "selected" : "" %>>Low Risk (0–29)</option>
                <option value="MEDIUM" <%= "MEDIUM".equals(selectedRisk) ? "selected" : "" %>>Medium Risk (30–59)</option>
                <option value="HIGH" <%= "HIGH".equals(selectedRisk) ? "selected" : "" %>>High Risk (60–84)</option>
                <option value="CRITICAL" <%= "CRITICAL".equals(selectedRisk) ? "selected" : "" %>>Critical Risk (85–100)</option>
            </select>
        </div>

        <div>
            <button type="submit" class="btn btn-primary btn-sm" style="padding: 0.75rem 1.5rem;">Apply Filter</button>
            <a href="<%= cp %>/admin/transactions" class="btn btn-secondary btn-sm" style="padding: 0.75rem 1rem;">Reset</a>
        </div>
    </form>
</div>

<!-- Transactions Table -->
<div class="card">
    <% if (transactions != null && !transactions.isEmpty()) { %>
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Tx ID / Ref</th>
                        <th>User ID</th>
                        <th>Date & Time</th>
                        <th>Amount</th>
                        <th>Recipient</th>
                        <th>Origin Context</th>
                        <th>Risk Score</th>
                        <th>Status</th>
                        <th>Notes / Explanations</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Transaction tx : transactions) { 
                        String badgeClass = "badge-info";
                        if (tx.getStatus().name().equals("APPROVED")) badgeClass = "badge-success";
                        else if (tx.getStatus().name().equals("FLAGGED")) badgeClass = "badge-warning";
                        else if (tx.getStatus().name().equals("REJECTED")) badgeClass = "badge-danger";
                    %>
                        <tr>
                            <td>
                                #<%= tx.getId() %><br>
                                <code><%= tx.getTransactionRef() %></code>
                            </td>
                            <td>User #<%= tx.getUserId() %></td>
                            <td><%= tx.getTimestamp() != null ? tx.getTimestamp().format(dtf) : "—" %></td>
                            <td style="font-weight: 700; color: #fff;">$<%= String.format("%,.2f", tx.getAmount()) %></td>
                            <td>
                                <strong><%= tx.getRecipientName() %></strong><br>
                                <small style="color: var(--text-muted);"><%= tx.getRecipientAccount() %></small>
                            </td>
                            <td>
                                <%= tx.getLocation() != null ? tx.getLocation() : "—" %><br>
                                <small style="color: var(--text-muted);">IP: <%= tx.getIpAddress() %></small>
                            </td>
                            <td>
                                <span class="badge <%= tx.getRiskScore() >= 85 ? "badge-critical" : (tx.getRiskScore() >= 60 ? "badge-danger" : (tx.getRiskScore() >= 30 ? "badge-warning" : "badge-success")) %>">
                                    <%= tx.getRiskScore() %> (<%= tx.getRiskLevel().name() %>)
                                </span>
                            </td>
                            <td><span class="badge <%= badgeClass %>"><%= tx.getStatus().name() %></span></td>
                            <td style="font-size: 0.8rem; color: var(--text-secondary); max-width: 280px; word-break: break-word;">
                                <%= tx.getNotes() != null ? tx.getNotes() : "—" %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div style="padding: 3rem; text-align: center; color: var(--text-muted);">
            No transactions matching selected filter criteria.
        </div>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp" />
