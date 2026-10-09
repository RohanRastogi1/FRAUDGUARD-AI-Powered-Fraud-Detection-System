<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fraudguard.model.User" %>
<%
    request.setAttribute("pageTitle", "Initiate Financial Transfer");
    User user = (User) session.getAttribute("currentUser");
    String cp = request.getContextPath();
    String errorMsg = (String) request.getAttribute("errorMessage");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="transfer-page-container">
    <div class="page-header transfer-header">
        <div class="transfer-header-info">
            <h1 class="page-title">Initiate Transfer</h1>
            <p class="page-subtitle">Every outgoing transfer is analyzed in milliseconds by the FraudGuard AI Engine.</p>
        </div>
        <div class="transfer-balance-wrapper">
            <span class="badge badge-info transfer-balance-badge">
                Current Balance: ₹<%= String.format("%,.2f", user != null ? user.getBalance() : 0.0) %>
            </span>
        </div>
    </div>

    <div class="transfer-grid-layout">
        <!-- Transfer Form (Primary Section) -->
        <div class="transfer-form-section">
            <div class="card transfer-card">
                <% if (errorMsg != null) { %>
                    <div class="alert-box alert-danger">
                        <span><%= errorMsg %></span>
                    </div>
                <% } %>

                <form action="<%= cp %>/transaction/new" method="post" id="transfer-form" class="transfer-form">
                    <div class="form-row-grid">
                        <div class="form-group">
                            <label class="form-label" for="amount">Transfer Amount (₹ INR) *</label>
                            <input type="number" step="0.01" min="0.01" class="form-control" id="amount" name="amount"
                                   required placeholder="0.00" value="<%= request.getAttribute("amount") != null ? request.getAttribute("amount") : "2500.00" %>">
                            <span class="form-help">Enter the monetary amount in Indian Rupees (INR) to transfer.</span>
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

                    <div class="form-row-grid">
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

                    <div class="form-row-grid">
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

                    <div class="transfer-actions-row">
                        <button type="submit" class="btn btn-primary btn-submit-transfer" id="btn-submit-transfer">
                            Evaluate & Execute
                        </button>
                        <a href="<%= cp %>/dashboard" class="btn btn-secondary btn-cancel-transfer">Cancel</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Viva Scenario Tester Helper Card -->
        <div class="transfer-scenarios-section">
            <div class="card viva-scenarios-card">
                <div class="card-header">
                    <h3 class="card-title">
                        🧪 Live Fraud Scenarios (Viva)
                    </h3>
                </div>
                <p class="scenarios-intro">
                    Click any scenario below to automatically populate the form with parameters designed to test specific fraud engine rules:
                </p>

                <div class="scenarios-list">
                    <button type="button" class="btn btn-secondary viva-scenario-btn"
                            onclick="loadScenario('1450.00', 'ZOMATO-PAY-9812@icici', 'Zomato Online Delivery', 'PAYMENT', 'Bengaluru, KA', 'device-hardware-node-88')">
                        <span class="scenario-btn-title">🟢 <strong>Normal Safe UPI Payment</strong></span>
                        <span class="scenario-btn-desc">₹1,450 &bull; Low Risk &bull; Auto-Approved</span>
                    </button>

                    <button type="button" class="btn btn-secondary viva-scenario-btn"
                            onclick="loadScenario('150000.00', 'PATEL-BULLION@hdfcbank', 'Patel Bullion & Gems', 'TRANSFER', 'Mumbai, MH', 'device-hardware-node-88')">
                        <span class="scenario-btn-title">🟡 <strong>High Amount Anomaly</strong></span>
                        <span class="scenario-btn-desc">₹1,50,000 &bull; Triggers HighAmountRule</span>
                    </button>

                    <button type="button" class="btn btn-secondary viva-scenario-btn"
                            onclick="loadScenario('240000.00', 'OVERSEAS-EXCH-9941', 'CryptoVault International', 'TRANSFER', 'New Delhi, DL', 'device-hardware-node-88')">
                        <span class="scenario-btn-title">🟠 <strong>Rapid Balance Drain</strong></span>
                        <span class="scenario-btn-desc">₹2,40,000 &bull; Drains >90% of Balance</span>
                    </button>

                    <button type="button" class="btn btn-secondary viva-scenario-btn border-danger-subtle"
                            onclick="loadScenario('50000.00', 'MULE_HDFC_99182', 'Suspect Syndicated Mule Account', 'TRANSFER', 'Kolkata, WB', 'device-hardware-node-88')">
                        <span class="scenario-btn-title">🔴 <strong>Blacklist Mule Account Trigger</strong></span>
                        <span class="scenario-btn-desc text-danger">MULE_HDFC_99182 &bull; Auto-Rejected</span>
                    </button>

                    <button type="button" class="btn btn-secondary viva-scenario-btn"
                            onclick="loadScenario('45000.00', 'ACC-SHOP-TOKYO', 'Tokyo Electronics', 'PAYMENT', 'Tokyo, JP', 'device-hardware-node-88')">
                        <span class="scenario-btn-title">✈️ <strong>Impossible Travel Geolocation Jump</strong></span>
                        <span class="scenario-btn-desc">₹45,000 &bull; Sudden Jump to Tokyo, JP</span>
                    </button>
                </div>
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
