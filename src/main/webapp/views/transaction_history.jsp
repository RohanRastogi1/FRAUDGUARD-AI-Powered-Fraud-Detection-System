<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.Transaction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    request.setAttribute("pageTitle", "Transaction History");
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    String cp = request.getContextPath();
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm:ss");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">Transaction History</h1>
        <p class="page-subtitle">Complete ledger of outgoing transactions, fraud scores, and processing logs.</p>
    </div>
    <div>
        <a href="<%= cp %>/transaction/new" class="btn btn-primary btn-sm">+ New Transaction</a>
    </div>
</div>

<div class="card">
    <% if (transactions != null && !transactions.isEmpty()) { %>
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Reference</th>
                        <th>Timestamp</th>
                        <th>Type</th>
                        <th>Recipient</th>
                        <th>Location / IP</th>
                        <th>Amount</th>
                        <th>Risk Score</th>
                        <th>Status</th>
                        <th>Audit Notes</th>
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
                            <td><code><%= tx.getTransactionRef() %></code></td>
                            <td><%= tx.getTimestamp() != null ? tx.getTimestamp().format(dtf) : "—" %></td>
                            <td><%= tx.getType().getDisplayName() %></td>
                            <td>
                                <strong><%= tx.getRecipientName() %></strong><br>
                                <small style="color: var(--text-muted);"><%= tx.getRecipientAccount() %></small>
                            </td>
                            <td>
                                <%= tx.getLocation() != null ? tx.getLocation() : "—" %><br>
                                <small style="color: var(--text-muted);">IP: <%= tx.getIpAddress() %></small>
                            </td>
                            <td style="font-weight: 700; color: #fff;">$<%= String.format("%,.2f", tx.getAmount()) %></td>
                            <td>
                                <span class="badge <%= tx.getRiskScore() >= 85 ? "badge-critical" : (tx.getRiskScore() >= 60 ? "badge-danger" : (tx.getRiskScore() >= 30 ? "badge-warning" : "badge-success")) %>">
                                    <%= tx.getRiskScore() %>/100
                                </span>
                            </td>
                            <td><span class="badge <%= badgeClass %>"><%= tx.getStatus().name() %></span></td>
                            <td style="max-width: 240px; font-size: 0.8rem; color: var(--text-secondary); word-break: break-word;">
                                <%= tx.getNotes() != null ? tx.getNotes() : "—" %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div style="padding: 3rem; text-align: center; color: var(--text-muted);">
            No transactions found in history.
        </div>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp" />
