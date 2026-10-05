<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Secure Authentication");
    String cp = request.getContextPath();
    String errorMsg = (String) request.getAttribute("errorMessage");
    String enteredUser = (String) request.getAttribute("enteredUsername");
    String paramMsg = request.getParameter("msg");
    String paramError = request.getParameter("error");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="auth-container">
    <div class="auth-glow-backdrop"></div>
    <div class="auth-card">
        <div style="text-align: center; margin-bottom: 2.25rem;">
            <div style="width: 56px; height: 56px; background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%); border-radius: var(--radius-md); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1.25rem; box-shadow: 0 0 24px rgba(79, 70, 229, 0.55); border: 1px solid rgba(255, 255, 255, 0.2);">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    <path d="M9 12l2 2 4-4"/>
                </svg>
            </div>
            <h1 style="font-size: 1.75rem; font-weight: 800; letter-spacing: -0.03em;">Sign In to FraudGuard</h1>
            <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.35rem;">
                Enterprise Fraud Intelligence &amp; Risk Decisioning
            </p>
        </div>

        <% if (errorMsg != null) { %>
            <div class="alert-box alert-danger">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <span><%= errorMsg %></span>
            </div>
        <% } else if ("auth_required".equals(paramError)) { %>
            <div class="alert-box alert-warning">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                    <line x1="12" y1="9" x2="12" y2="13"></line>
                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                </svg>
                <span>Please sign in to access that protected portal.</span>
            </div>
        <% } else if ("logged_out".equals(paramMsg)) { %>
            <div class="alert-box alert-success">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
                <span>You have successfully signed out of your session.</span>
            </div>
        <% } %>

        <form action="<%= cp %>/login" method="post" id="login-form">
            <div class="form-group">
                <label class="form-label" for="username">Username or Corporate Email</label>
                <div class="input-wrapper">
                    <span class="input-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </span>
                    <input type="text" class="form-control" id="username" name="username"
                           value="<%= enteredUser != null ? enteredUser : "" %>"
                           required placeholder="admin or superadmin@rohanrastogi.in" autocomplete="username">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Account Password</label>
                <div class="input-wrapper">
                    <span class="input-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </span>
                    <input type="password" class="form-control" id="password" name="password"
                           required placeholder="Enter your account password" autocomplete="current-password">
                </div>
            </div>

            <button type="submit" class="btn btn-primary" id="btn-login" style="width: 100%; margin-top: 0.75rem; padding: 0.95rem; font-size: 0.98rem; font-weight: 700;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                    <polyline points="10 17 15 12 10 7"></polyline>
                    <line x1="15" y1="12" x2="3" y2="12"></line>
                </svg>
                Authenticate Session
            </button>
        </form>

        <div style="margin-top: 2.25rem; padding-top: 1.75rem; border-top: 1px solid var(--border-color);">
            <div style="font-size: 0.74rem; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.08em; margin-bottom: 0.95rem; text-align: center;">
                ⚡ Quick Demo Persona Fill (1-Click)
            </div>
            <div style="display: flex; gap: 0.5rem; justify-content: center; flex-wrap: wrap;">
                <button type="button" class="demo-pill" onclick="fillCreds('superadmin@rohanrastogi.in', 'Admin@123')">
                    👑 SuperAdmin
                </button>
                <button type="button" class="demo-pill" onclick="fillCreds('admin', 'Admin@123')">
                    ⚡ Admin
                </button>
                <button type="button" class="demo-pill" onclick="fillCreds('analyst', 'Analyst@123')">
                    🛡️ Analyst
                </button>
                <button type="button" class="demo-pill" onclick="fillCreds('john_doe', 'Customer@123')">
                    👤 Customer
                </button>
            </div>
        </div>

        <div style="margin-top: 1.75rem; display: flex; justify-content: center; align-items: center; gap: 1rem; color: var(--text-muted); font-size: 0.75rem;">
            <span>🔒 256-Bit TLS</span>
            <span>&bull;</span>
            <span>⚡ Sub-10ms Engine</span>
            <span>&bull;</span>
            <span>🛡️ ACID Protected</span>
        </div>
    </div>
</div>

<script>
    function fillCreds(u, p) {
        var userField = document.getElementById('username');
        var passField = document.getElementById('password');
        userField.value = u;
        passField.value = p;
        userField.style.borderColor = 'var(--accent-cyan)';
        passField.style.borderColor = 'var(--accent-cyan)';
        setTimeout(function() {
            userField.style.borderColor = '';
            passField.style.borderColor = '';
        }, 600);
    }
</script>

<jsp:include page="/views/common/footer.jsp" />
