<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Secure Authentication");
    String cp = request.getContextPath();
    String errorMsg = (String) request.getAttribute("errorMessage");
    String enteredUser = (String) request.getAttribute("enteredUsername");
    String paramError = request.getParameter("error");
%>
<jsp:include page="/views/common/header.jsp" />

<style>
    /* Desktop Fixed Footer; Mobile Relative Footer */
    @media (min-width: 769px) and (min-height: 600px) {
        .footer {
            position: fixed !important;
            bottom: 0 !important;
            left: 0 !important;
            right: 0 !important;
            width: 100% !important;
            z-index: 100 !important;
            box-shadow: 0 -4px 24px rgba(0, 0, 0, 0.3) !important;
        }
        .main-content {
            padding-bottom: 5.25rem;
        }
    }
    @media (max-width: 768px), (max-height: 599px) {
        .footer {
            position: relative !important;
            margin-top: 1.5rem !important;
        }
        .main-content {
            padding-bottom: 1rem !important;
        }
    }
    .main-content {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        padding-top: 1rem;
        box-sizing: border-box;
    }
    .auth-container {
        margin: auto !important;
        width: 100%;
        max-width: 450px;
        position: relative;
    }

    /* Ambient Outer Glow Aura around the Border */
    .auth-glow-backdrop {
        position: absolute;
        inset: -8px;
        border-radius: 28px;
        background: radial-gradient(circle at 50% 0%, rgba(234, 88, 12, 0.5), transparent 65%),
                    radial-gradient(circle at 50% 100%, rgba(245, 158, 11, 0.4), transparent 65%),
                    linear-gradient(135deg, rgba(234, 88, 12, 0.35), rgba(245, 158, 11, 0.22), rgba(234, 88, 12, 0.35));
        filter: blur(22px);
        opacity: 0.75;
        z-index: 0;
        pointer-events: none;
        animation: auth-glow-pulse 4.5s ease-in-out infinite alternate;
    }

    [data-theme="light"] .auth-glow-backdrop {
        background: radial-gradient(circle at 50% 0%, rgba(234, 88, 12, 0.45), transparent 65%),
                    radial-gradient(circle at 50% 100%, rgba(245, 158, 11, 0.38), transparent 65%),
                    linear-gradient(135deg, rgba(234, 88, 12, 0.3), rgba(245, 158, 11, 0.22), rgba(234, 88, 12, 0.3));
        filter: blur(22px);
        opacity: 0.72;
    }

    @keyframes auth-glow-pulse {
        0% {
            opacity: 0.55;
            transform: scale(0.99);
            filter: blur(18px);
        }
        100% {
            opacity: 0.9;
            transform: scale(1.02);
            filter: blur(26px);
        }
    }

    /* Circulating Radiant Border Light Beam */
    .auth-border-glow {
        position: absolute;
        inset: -2px;
        border-radius: 22px;
        overflow: hidden;
        z-index: 0;
        pointer-events: none;
    }

    .auth-border-glow::before {
        content: '';
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: conic-gradient(
            transparent 0deg,
            transparent 60deg,
            rgba(234, 88, 12, 0.4) 100deg,
            #ea580c 135deg,
            #f59e0b 165deg,
            #ea580c 195deg,
            rgba(234, 88, 12, 0.4) 230deg,
            transparent 270deg,
            transparent 360deg
        );
        animation: auth-border-spin 4s linear infinite;
    }

    @keyframes auth-border-spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }

    /* Form Card Luminous Border & Shadow */
    .form {
        position: relative;
        z-index: 1;
        border: 1.5px solid rgba(234, 88, 12, 0.45) !important;
        box-shadow: 
            0 0 0 1px rgba(234, 88, 12, 0.28),
            0 0 22px rgba(234, 88, 12, 0.25),
            0 0 48px rgba(234, 88, 12, 0.12),
            0 24px 50px -10px rgba(0, 0, 0, 0.22) !important;
        transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1) !important;
    }

    [data-theme="light"] .form {
        background-color: #ffffff;
        border: 1.5px solid rgba(234, 88, 12, 0.42) !important;
        box-shadow: 
            0 0 0 1px rgba(234, 88, 12, 0.25),
            0 0 24px rgba(234, 88, 12, 0.22),
            0 0 52px rgba(234, 88, 12, 0.12),
            0 24px 45px -10px rgba(80, 50, 20, 0.14) !important;
    }

    .form:hover,
    .form:focus-within {
        border-color: rgba(234, 88, 12, 0.75) !important;
        box-shadow: 
            0 0 0 1.5px rgba(234, 88, 12, 0.55),
            0 0 32px rgba(234, 88, 12, 0.38),
            0 0 68px rgba(234, 88, 12, 0.22),
            0 28px 55px -10px rgba(0, 0, 0, 0.22) !important;
    }

    [data-theme="light"] .form:hover,
    [data-theme="light"] .form:focus-within {
        border-color: #ea580c !important;
        box-shadow: 
            0 0 0 1.5px rgba(234, 88, 12, 0.48),
            0 0 35px rgba(234, 88, 12, 0.32),
            0 0 72px rgba(234, 88, 12, 0.18),
            0 28px 50px -10px rgba(80, 50, 20, 0.18) !important;
    }

    /* Top glowing accent border runner */
    .form::before {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0;
        height: 2px;
        background: linear-gradient(90deg, transparent, rgba(234, 88, 12, 0.85) 20%, #f59e0b 50%, rgba(234, 88, 12, 0.85) 80%, transparent);
        border-radius: 20px 20px 0 0;
        box-shadow: 0 0 12px rgba(234, 88, 12, 0.7);
    }

    /* Desktop default header / brand */
    .auth-brand-icon {
        width: 46px;
        height: 46px;
        border-radius: 12px;
        background: var(--premium-gradient);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 0.65rem;
        box-shadow: 0 0 20px var(--primary-glow);
        border: 1px solid rgba(255, 255, 255, 0.15);
    }
    .auth-title {
        font-size: 1.55rem;
        font-weight: 800;
        letter-spacing: -0.03em;
        margin-bottom: 0.2rem;
        color: var(--text-primary);
    }
    .auth-subtitle {
        color: var(--text-secondary);
        font-size: 0.84rem;
        margin-bottom: 0;
    }

    /* Compact & Perfectly Aligned on Mobile (<= 600px) */
    .auth-personas-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 0.45rem;
        width: 100%;
    }
    .auth-personas-grid .demo-pill {
        width: 100%;
        justify-content: center;
        box-sizing: border-box;
    }

    @media (max-width: 600px) {
        .main-content {
            padding: 0.65rem 0.85rem !important;
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box !important;
        }
        .auth-container {
            width: 100% !important;
            max-width: 375px !important;
            padding: 0 !important;
            margin: 0 auto !important;
            box-sizing: border-box !important;
        }
        .auth-border-glow {
            border-radius: 20px !important;
        }
        .auth-glow-backdrop {
            border-radius: 24px !important;
        }
        .form {
            width: 100% !important;
            max-width: 100% !important;
            padding: 1.35rem 1.15rem 1rem !important;
            border-radius: 18px !important;
            gap: 7px !important;
            box-sizing: border-box !important;
            border: 1.5px solid rgba(234, 88, 12, 0.42) !important;
            box-shadow: 
                0 0 0 1px rgba(234, 88, 12, 0.25),
                0 0 18px rgba(234, 88, 12, 0.22),
                0 0 38px rgba(234, 88, 12, 0.10),
                0 14px 38px rgba(0, 0, 0, 0.25) !important;
        }
        .auth-header {
            margin-bottom: 0.75rem !important;
        }
        .auth-brand-icon {
            width: 38px !important;
            height: 38px !important;
            border-radius: 10px !important;
            margin-bottom: 0.35rem !important;
            box-shadow: 0 0 12px var(--primary-glow) !important;
        }
        .auth-brand-icon svg {
            width: 18px !important;
            height: 18px !important;
        }
        .auth-title {
            font-size: 1.25rem !important;
            margin-bottom: 0.1rem !important;
        }
        .auth-subtitle {
            font-size: 0.76rem !important;
            line-height: 1.35 !important;
        }
        .flex-column > label {
            font-size: 0.78rem !important;
            margin-bottom: 2px !important;
            font-weight: 600 !important;
        }
        .inputForm {
            height: 40px !important;
            padding-left: 10px !important;
            padding-right: 10px !important;
            border-radius: 8px !important;
        }
        .inputForm svg {
            width: 16px !important;
            height: 16px !important;
        }
        .input {
            font-size: 0.85rem !important;
            margin-left: 6px !important;
        }
        .button-submit,
        .button-submit.type1 {
            height: 40px !important;
            margin: 9px 0 4px 0 !important;
            border-radius: 8px !important;
            box-shadow: 0 3px 14px var(--primary-glow) !important;
        }
        .button-submit::before,
        .button-submit.type1::before,
        .button-submit::after,
        .button-submit.type1::after {
            font-size: 0.86rem !important;
        }
        .auth-personas-section {
            margin-top: 0.85rem !important;
            padding-top: 0.75rem !important;
        }
        .auth-personas-title {
            font-size: 0.65rem !important;
            letter-spacing: 0.07em !important;
            margin-bottom: 0.45rem !important;
        }
        .demo-pill {
            padding: 0.32rem 0.5rem !important;
            font-size: 0.72rem !important;
            gap: 0.35rem !important;
            border-radius: 8px !important;
        }
        .auth-security-specs {
            margin-top: 0.75rem !important;
            font-size: 0.68rem !important;
            gap: 0.5rem !important;
        }
    }

    /* Smallest screens (<= 360px) */
    @media (max-width: 360px) {
        .auth-container {
            max-width: 320px !important;
        }
        .form {
            padding: 1.15rem 0.95rem 0.85rem !important;
        }
        .auth-title {
            font-size: 1.15rem !important;
        }
        .demo-pill {
            font-size: 0.66rem !important;
            padding: 0.28rem 0.4rem !important;
        }
    }
</style>

<div class="auth-container">
    <div class="auth-glow-backdrop"></div>
    <div class="auth-border-glow"></div>
    <form class="form" action="<%= cp %>/login" method="post" id="login-form">
        <div class="auth-header" style="text-align: center; margin-bottom: 1.25rem;">
            <div class="auth-brand-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    <path d="M9 12l2 2 4-4"/>
                </svg>
            </div>
            <h1 class="auth-title">Sign In to FraudGuard</h1>
            <p class="auth-subtitle">
                Enterprise Fraud Intelligence &amp; Risk Decisioning
            </p>
        </div>

        <% if (errorMsg != null) { %>
            <div class="alert-box alert-danger" style="margin-bottom: 0.5rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <span><%= errorMsg %></span>
            </div>
        <% } else if ("auth_required".equals(paramError)) { %>
            <div class="alert-box alert-warning" style="margin-bottom: 0.5rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                    <line x1="12" y1="9" x2="12" y2="13"></line>
                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                </svg>
                <span>Please sign in to access that protected portal.</span>
            </div>
        <% } %>

        <div class="flex-column">
            <label for="username">Email </label>
        </div>
        <div class="inputForm" id="wrap-username">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" viewBox="0 0 32 32" height="20"><g data-name="Layer 3" id="Layer_3"><path d="m30.853 13.87a15 15 0 0 0 -29.729 4.082 15.1 15.1 0 0 0 12.876 12.918 15.6 15.6 0 0 0 2.016.13 14.85 14.85 0 0 0 7.715-2.145 1 1 0 1 0 -1.031-1.711 13.007 13.007 0 1 1 5.458-6.529 2.149 2.149 0 0 1 -4.158-.759v-10.856a1 1 0 0 0 -2 0v1.726a8 8 0 1 0 .2 10.325 4.135 4.135 0 0 0 7.83.274 15.2 15.2 0 0 0 .823-7.455zm-14.853 8.13a6 6 0 1 1 6-6 6.006 6.006 0 0 1 -6 6z"></path></g></svg>
            <input placeholder="Enter your Email" class="input" type="text" id="username" name="username" value="<%= enteredUser != null ? enteredUser : "" %>" required autocomplete="username">
        </div>

        <div class="flex-column">
            <label for="password">Password </label>
        </div>
        <div class="inputForm" id="wrap-password">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" viewBox="-64 0 512 512" height="20"><path d="m336 512h-288c-26.453125 0-48-21.523438-48-48v-224c0-26.476562 21.546875-48 48-48h288c26.453125 0 48 21.523438 48 48v224c0 26.476562-21.546875 48-48 48zm-288-288c-8.8125 0-16 7.167969-16 16v224c0 8.832031 7.1875 16 16 16h288c8.8125 0 16-7.167969 16-16v-224c0-8.832031-7.1875-16-16-16zm0 0"></path><path d="m304 224c-8.832031 0-16-7.167969-16-16v-80c0-52.929688-43.070312-96-96-96s-96 43.070312-96 96v80c0 8.832031-7.167969 16-16 16s-16-7.167969-16-16v-80c0-70.59375 57.40625-128 128-128s128 57.40625 128 128v80c0 8.832031-7.167969 16-16 16zm0 0"></path></svg>
            <input placeholder="Enter your Password" class="input" type="password" id="password" name="password" required autocomplete="current-password">
        </div>

        <button class="button-submit type1" type="submit" id="btn-login" aria-label="Sign In"></button>

        <div class="auth-personas-section" style="margin-top: 1.25rem; padding-top: 1rem; border-top: 1px solid var(--border-color);">
            <div class="auth-personas-title" style="font-size: 0.7rem; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.08em; margin-bottom: 0.65rem; text-align: center;">
                Quick Demo Persona Fill
            </div>
            <div class="auth-personas-grid">
                <button type="button" class="demo-pill" onclick="fillCreds('superadmin', 'Admin@123')">
                    <span style="width:6px;height:6px;border-radius:50%;background:var(--accent-rose);box-shadow:0 0 8px var(--accent-rose);"></span>
                    SuperAdmin
                </button>
                <button type="button" class="demo-pill" onclick="fillCreds('admin', 'Admin@123')">
                    <span style="width:6px;height:6px;border-radius:50%;background:var(--accent-amber);box-shadow:0 0 8px var(--accent-amber);"></span>
                    Admin
                </button>
                <button type="button" class="demo-pill" onclick="fillCreds('analyst', 'Analyst@123')">
                    <span style="width:6px;height:6px;border-radius:50%;background:var(--accent-sky);box-shadow:0 0 8px var(--accent-sky);"></span>
                    Analyst
                </button>
                <button type="button" class="demo-pill" onclick="fillCreds('john_doe', 'Customer@123')">
                    <span style="width:6px;height:6px;border-radius:50%;background:var(--primary);box-shadow:0 0 8px var(--primary-glow);"></span>
                    Customer
                </button>
            </div>
        </div>

        <div class="auth-security-specs" style="margin-top: 1.15rem; display: flex; justify-content: center; align-items: center; gap: 0.85rem; color: var(--text-muted); font-size: 0.72rem;">
            <span>256-Bit TLS</span>
            <span>&bull;</span>
            <span>Sub-10ms Engine</span>
            <span>&bull;</span>
            <span>ACID Protected</span>
        </div>
    </form>
</div>

<script>
    function fillCreds(u, p) {
        var userField = document.getElementById('username');
        var passField = document.getElementById('password');
        var wrapU = document.getElementById('wrap-username');
        var wrapP = document.getElementById('wrap-password');
        userField.value = u;
        passField.value = p;
        if (wrapU) wrapU.style.borderColor = 'var(--primary)';
        if (wrapP) wrapP.style.borderColor = 'var(--primary)';
        setTimeout(function() {
            if (wrapU) wrapU.style.borderColor = '';
            if (wrapP) wrapP.style.borderColor = '';
        }, 700);
    }

    function showTip(msg) {
        var toast = document.getElementById('auth-toast');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = 'auth-toast';
            toast.style.cssText = 'position: fixed; top: 75px; left: 50%; transform: translateX(-50%) translateY(-10px); background: var(--bg-card); color: var(--text-primary); border: 1px solid var(--primary); padding: 0.65rem 1.25rem; border-radius: 9999px; font-size: 0.82rem; font-weight: 600; box-shadow: 0 10px 30px rgba(0,0,0,0.5), 0 0 16px var(--primary-glow); z-index: 1000; transition: all 0.25s ease-out; opacity: 0; pointer-events: none;';
            document.body.appendChild(toast);
        }
        toast.textContent = msg;
        toast.style.opacity = '1';
        toast.style.transform = 'translateX(-50%) translateY(0)';
        setTimeout(function() {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(-50%) translateY(-10px)';
        }, 2600);
    }

    if (window.history.replaceState && window.location.search) {
        window.history.replaceState(null, '', window.location.pathname);
    }
</script>

<jsp:include page="/views/common/footer.jsp" />

