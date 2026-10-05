<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.service.TransactionService" %>
<%@ page import="com.fraudguard.model.Transaction" %>
<%@ page import="com.fraudguard.model.RiskScore" %>
<%@ page import="com.fraudguard.model.FraudAlert" %>
<%@ page import="java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Fraud Evaluation Result");
    TransactionService.TransactionProcessResult result = 
        (TransactionService.TransactionProcessResult) request.getAttribute("result");
    Transaction tx = result.getTransaction();
    RiskScore score = result.getRiskScore();
    FraudAlert alert = result.getFraudAlert();
    String cp = request.getContextPath();

    String meterColorClass = "low";
    if (score.getScore() >= 85) meterColorClass = "critical";
    else if (score.getScore() >= 60) meterColorClass = "high";
    else if (score.getScore() >= 30) meterColorClass = "medium";
%>
<jsp:include page="/views/common/header.jsp" />

<div style="max-width: 800px; margin: 0 auto;">
    <div class="card" style="margin-bottom: 2rem;">
        <div style="text-align: center; padding: 1.5rem 0 1rem 0;">
            <% if (result.isApproved()) { %>
                <div style="width: 64px; height: 64px; background: rgba(16, 185, 129, 0.2); border: 2px solid #10b981; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </div>
                <h1 style="color: #34d399; margin-bottom: 0.5rem;">Transaction Approved</h1>
                <p style="color: var(--text-secondary); max-width: 500px; margin: 0 auto;"><%= result.getMessage() %></p>
            <% } else if (result.isFlagged()) { %>
                <div style="width: 64px; height: 64px; background: rgba(245, 158, 11, 0.2); border: 2px solid #f59e0b; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                        <line x1="12" y1="9" x2="12" y2="13"></line>
                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                    </svg>
                </div>
                <h1 style="color: #fbbf24; margin-bottom: 0.5rem;">Flagged for Security Review</h1>
                <p style="color: var(--text-secondary); max-width: 500px; margin: 0 auto;"><%= result.getMessage() %></p>
            <% } else { %>
                <div style="width: 64px; height: 64px; background: rgba(239, 68, 68, 0.2); border: 2px solid #ef4444; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem; box-shadow: 0 0 20px rgba(239, 68, 68, 0.4);">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="15" y1="9" x2="9" y2="15"></line>
                        <line x1="9" y1="9" x2="15" y2="15"></line>
                    </svg>
                </div>
                <h1 style="color: #f87171; margin-bottom: 0.5rem;">Transaction Rejected</h1>
                <p style="color: var(--text-secondary); max-width: 500px; margin: 0 auto;"><%= result.getMessage() %></p>
            <% } %>
        </div>

        <!-- Risk Gauge & Scoring Breakdown -->
        <div style="background: var(--bg-tertiary); padding: 1.5rem; border-radius: var(--radius-md); margin: 1.5rem 0;">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 0.5rem;">
                <div>
                    <span style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); font-weight: 700;">Composite Risk Assessment</span>
                    <h3 style="font-size: 1.4rem;">Risk Score: <%= score.getScore() %> / 100</h3>
                </div>
                <div>
                    <span class="badge <%= score.getScore() >= 85 ? "badge-critical" : (score.getScore() >= 60 ? "badge-danger" : (score.getScore() >= 30 ? "badge-warning" : "badge-success")) %>" style="font-size: 0.85rem;">
                        <%= score.getLevel().name() %> RISK &bull; <%= score.getRecommendation() %>
                    </span>
                </div>
            </div>

            <div class="risk-meter">
                <div class="risk-meter-bar <%= meterColorClass %>" style="width: <%= Math.max(5, score.getScore()) %>%;"></div>
            </div>
        </div>

        <!-- Transaction Details -->
        <div class="grid grid-cols-2" style="margin-bottom: 1.5rem;">
            <div>
                <span class="stat-label">Transaction Reference</span>
                <p style="font-size: 1.1rem; font-weight: 700; color: #fff;"><code><%= tx.getTransactionRef() %></code></p>
            </div>
            <div>
                <span class="stat-label">Transferred Amount</span>
                <p style="font-size: 1.1rem; font-weight: 700; color: #fff;">$<%= String.format("%,.2f", tx.getAmount()) %> <%= tx.getCurrency() %></p>
            </div>
            <div>
                <span class="stat-label">Recipient Details</span>
                <p style="color: #fff;"><%= tx.getRecipientName() %> (<%= tx.getRecipientAccount() %>)</p>
            </div>
            <div>
                <span class="stat-label">Originating Node</span>
                <p style="color: var(--text-secondary);"><%= tx.getLocation() %> &bull; IP: <%= tx.getIpAddress() %></p>
            </div>
        </div>

        <!-- Evaluated Rules Details -->
        <div style="border-top: 1px solid var(--border-color); padding-top: 1.25rem;">
            <h4 style="margin-bottom: 0.75rem; font-size: 1rem;">Rule Triggers & Explanations</h4>
            <% if (!score.getTriggeredRules().isEmpty()) { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Triggered Rule</th>
                                <th>Points</th>
                                <th>Explanation</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map.Entry<String, Integer> entry : score.getRuleBreakdown().entrySet()) { %>
                                <tr>
                                    <td><code><%= entry.getKey() %></code></td>
                                    <td><span class="badge badge-danger">+<%= entry.getValue() %> pts</span></td>
                                    <td style="color: var(--text-secondary);"><%= score.getExplanation() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <p style="color: #34d399; font-size: 0.9rem;">
                    &#10004; Zero anomalous triggers detected. The transaction adheres to baseline account behavior.
                </p>
            <% } %>
        </div>

        <div style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: center;">
            <a href="<%= cp %>/dashboard" class="btn btn-primary" id="btn-return-dashboard">Return to Dashboard</a>
            <a href="<%= cp %>/transaction/new" class="btn btn-secondary">Submit Another Transaction</a>
        </div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp" />
