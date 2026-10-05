<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.User" %>
<%
    request.setAttribute("pageTitle", "Initiate Financial Transfer");
    User user = (User) session.getAttribute("currentUser");
    String cp = request.getContextPath();
    String errorMsg = (String) request.getAttribute("errorMessage");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">Initiate Transfer</h1>
        <p class="page-subtitle">Every outgoing transfer is analyzed in milliseconds by the FraudGuard AI Engine.</p>
    </div>
    <div>
        <span class="badge badge-info" style="font-size: 0.85rem; padding: 0.4rem 0.8rem;">
            Current Balance: $<%= String.format("%,.2f", user.getBalance()) %>
        </span>
    </div>
</div>

<div class="grid grid-cols-3">
    <!-- Transfer Form (2 cols) -->
    <div style="grid-column: span 2;">
        <div class="card">
            <% if (errorMsg != null) { %>
                <div class="alert-box alert-danger">
                    <span><%= errorMsg %></span>
                </div>
            <% } %>

            <form action="<%= cp %>/transaction/new" method="post" id="transfer-form">
                <div class="grid grid-cols-2">
                    <div class="form-group">
                        <label class="form-label" for="amount">Transfer Amount ($ USD) *</label>
                        <input type="number" step="0.01" min="0.01" class="form-control" id="amount" name="amount"
                               required placeholder="0.00" value="<%= request.getAttribute("amount") != null ? request.getAttribute("amount") : "150.00" %>">
                        <span class="form-help">Enter the monetary amount to transfer.</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="type">Transaction Type *</label>
                        <select class="form-control" id="type" name="type">
                            <option value="TRANSFER">Fund Transfer (P2P / Wire)</option>
                            <option value="PAYMENT">Merchant Payment</option>
                            <option value="WITHDRAWAL">ATM / Cash Withdrawal</option>
                        </select>
                    </div>
                </div>

                <div class="grid grid-cols-2">
                    <div class="form-group">
                        <label class="form-label" for="recipientAccount">Recipient Account / IBAN *</label>
                        <input type="text" class="form-control" id="recipientAccount" name="recipientAccount"
                               required placeholder="e.g. ACC-109284" value="<%= request.getAttribute("recipientAccount") != null ? request.getAttribute("recipientAccount") : "ACC-VERIFIED-100" %>">
                        <span class="form-help">Unique account identifier of the recipient.</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="recipientName">Recipient Legal Name *</label>
                        <input type="text" class="form-control" id="recipientName" name="recipientName"
                               required placeholder="e.g. Acme Corp or Jane Doe" value="<%= request.getAttribute("recipientName") != null ? request.getAttribute("recipientName") : "Acme Digital Services" %>">
                    </div>
                </div>

                <div class="grid grid-cols-2">
                    <div class="form-group">
                        <label class="form-label" for="location">Geographic Location</label>
                        <input type="text" class="form-control" id="location" name="location"
                               placeholder="e.g. New York, US" value="<%= request.getAttribute("location") != null ? request.getAttribute("location") : "New York, US" %>">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="deviceFingerprint">Device Identifier</label>
                        <input type="text" class="form-control" id="deviceFingerprint" name="deviceFingerprint"
                               value="browser-primary-hardware-node-88">
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; align-items: center; margin-top: 1rem;">
                    <button type="submit" class="btn btn-primary" id="btn-submit-transfer" style="min-width: 200px;">
                        Evaluate & Execute
                    </button>
                    <a href="<%= cp %>/dashboard" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Viva Scenario Tester Helper Card -->
    <div>
        <div class="card" style="border-color: rgba(99, 102, 241, 0.3);">
            <div class="card-header">
                <h3 class="card-title" style="font-size: 1rem; color: #a5b4fc;">
                    🧪 Live Fraud Scenarios (Viva)
                </h3>
            </div>
            <p style="font-size: 0.82rem; color: var(--text-secondary); margin-bottom: 1.25rem;">
                Click any scenario below to automatically populate the form with parameters designed to test specific fraud engine rules:
            </p>

            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                <button type="button" class="btn btn-secondary btn-sm" style="text-align: left; justify-content: flex-start;"
                        onclick="loadScenario('120.00', 'ACC-VERIFIED-100', 'Apple Store Online', 'TRANSFER', 'New York, US', 'browser-primary-hardware-node-88')">
                    🟢 <strong>Normal Safe Transfer</strong><br>
                    <small style="color: var(--text-muted);">$120 &bull; Low Risk &bull; Auto-Approved</small>
                </button>

                <button type="button" class="btn btn-secondary btn-sm" style="text-align: left; justify-content: flex-start;"
                        onclick="loadScenario('15000.00', 'ACC-HOLDINGS-55', 'Apex Capital Global', 'TRANSFER', 'New York, US', 'browser-primary-hardware-node-88')">
                    🟡 <strong>High Amount Anomaly</strong><br>
                    <small style="color: var(--text-muted);">$15,000 &bull; Triggers HighAmountRule</small>
                </button>

                <button type="button" class="btn btn-secondary btn-sm" style="text-align: left; justify-content: flex-start;"
                        onclick="loadScenario('24000.00', 'ACC-OFFSHORE-11', 'Cayman Assets', 'TRANSFER', 'New York, US', 'browser-primary-hardware-node-88')">
                    🟠 <strong>Rapid Balance Drain</strong><br>
                    <small style="color: var(--text-muted);">$24,000 &bull; Drains >90% of Balance</small>
                </button>

                <button type="button" class="btn btn-secondary btn-sm" style="text-align: left; justify-content: flex-start; border-color: rgba(239, 68, 68, 0.4);"
                        onclick="loadScenario('500.00', 'ACC-SANCTIONED-999', 'DarkWeb Node 999', 'TRANSFER', 'Unknown', 'browser-primary-hardware-node-88')">
                    🔴 <strong>Blacklist Sanctions Trigger</strong><br>
                    <small style="color: #fca5a5;">ACC-SANCTIONED-999 &bull; Auto-Rejected</small>
                </button>

                <button type="button" class="btn btn-secondary btn-sm" style="text-align: left; justify-content: flex-start;"
                        onclick="loadScenario('450.00', 'ACC-SHOP-TOKYO', 'Tokyo Electronics', 'PAYMENT', 'Tokyo, JP', 'browser-primary-hardware-node-88')">
                    ✈️ <strong>Impossible Travel</strong><br>
                    <small style="color: var(--text-muted);">Location jump to Tokyo, JP</small>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    function loadScenario(amount, account, name, type, location, device) {
        document.getElementById('amount').value = amount;
        document.getElementById('recipientAccount').value = account;
        document.getElementById('recipientName').value = name;
        document.getElementById('type').value = type;
        document.getElementById('location').value = location;
        document.getElementById('deviceFingerprint').value = device;
    }
</script>

<jsp:include page="/views/common/footer.jsp" />
