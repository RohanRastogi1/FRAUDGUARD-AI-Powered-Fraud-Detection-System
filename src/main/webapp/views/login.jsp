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

<div style="max-width: 440px; margin: 3rem auto;">
    <div class="card" style="padding: 2.25rem;">
        <div style="text-align: center; margin-bottom: 2rem;">
            <div style="width: 48px; height: 48px; background: linear-gradient(135deg, #4f46e5, #06b6d4); border-radius: var(--radius-md); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem; box-shadow: var(--shadow-glow);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
            </div>
            <h2>Sign In to FraudGuard</h2>
            <p style="color: var(--text-secondary); font-size: 0.88rem; margin-top: 0.35rem;">
                Enterprise Fraud Intelligence & Risk Decisioning
            </p>
        </div>

        <% if (errorMsg != null) { %>
            <div class="alert-box alert-danger">
                <span><%= errorMsg %></span>
            </div>
        <% } else if ("auth_required".equals(paramError)) { %>
            <div class="alert-box alert-warning">
                <span>Please sign in to access that protected portal.</span>
            </div>
        <% } else if ("logged_out".equals(paramMsg)) { %>
            <div class="alert-box alert-success">
                <span>You have successfully signed out of your session.</span>
            </div>
        <% } %>

        <form action="<%= cp %>/login" method="post" id="login-form">
            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <input type="text" class="form-control" id="username" name="username"
                       value="<%= enteredUser != null ? enteredUser : "" %>"
                       required placeholder="Enter your username" autocomplete="username">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password"
                       required placeholder="Enter your account password" autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-primary" id="btn-login" style="width: 100%; margin-top: 0.5rem;">
                Authenticate Session
            </button>
        </form>

        <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--border-color);">
            <div style="font-size: 0.76rem; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.05em; margin-bottom: 0.75rem; text-align: center;">
                Quick Demo Role Fill (Viva / Testing)
            </div>
            <div style="display: flex; gap: 0.5rem; justify-content: center; flex-wrap: wrap;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCreds('admin', 'Admin@123')">
                    👑 Admin
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCreds('analyst', 'Analyst@123')">
                    🛡️ Analyst
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCreds('john_doe', 'Customer@123')">
                    👤 Customer
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    function fillCreds(u, p) {
        document.getElementById('username').value = u;
        document.getElementById('password').value = p;
    }
</script>

<jsp:include page="/views/common/footer.jsp" />
