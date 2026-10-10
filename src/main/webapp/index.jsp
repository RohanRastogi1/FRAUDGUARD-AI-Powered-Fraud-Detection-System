<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Autonomous Financial Integrity");
    String cp = request.getContextPath();
    com.fraudguard.model.User currentUser = (com.fraudguard.model.User) session.getAttribute("currentUser");
    String dashLink = cp + "/login";
    String btnText = "Sign In / Access System";
    if (currentUser != null) {
        if (currentUser.isAdmin() || currentUser.isAnalyst()) {
            dashLink = cp + "/admin/dashboard";
        } else {
            dashLink = cp + "/dashboard";
        }
        btnText = "Go to Dashboard";
    }
%>
<jsp:include page="/views/common/header.jsp" />

<style>
    /* Landing Page Specific Styles */
    .landing-wrapper {
        width: 100%;
        overflow-x: hidden;
        background-color: var(--bg-primary);
        color: var(--text-primary);
        font-family: 'Inter', sans-serif;
    }

    /* Hero Section */
    .hero-section {
        position: relative;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 6rem 2rem 2rem;
        z-index: 1;
    }
    .hero-glow {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 600px;
        height: 600px;
        background: radial-gradient(circle, rgba(234, 88, 12, 0.15) 0%, rgba(56, 189, 248, 0.05) 50%, transparent 70%);
        filter: blur(60px);
        z-index: -1;
        animation: pulse-glow 6s infinite alternate ease-in-out;
    }
    @keyframes pulse-glow {
        0% { transform: translate(-50%, -50%) scale(0.9); opacity: 0.8; }
        100% { transform: translate(-50%, -50%) scale(1.1); opacity: 1; }
    }
    .hero-title {
        font-size: clamp(2.5rem, 6vw, 4.5rem);
        font-weight: 800;
        letter-spacing: -0.03em;
        line-height: 1.1;
        margin-bottom: 1.5rem;
        color: var(--text-primary);
        text-shadow: 0 4px 24px rgba(234, 88, 12, 0.15);
        animation: fade-up 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
        opacity: 0;
        transform: translateY(40px);
    }
    .hero-title span {
        background: linear-gradient(135deg, var(--accent-orange), #f43f5e);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        display: inline-block;
    }
    .hero-subtitle {
        font-size: clamp(1rem, 2vw, 1.25rem);
        color: var(--text-secondary);
        max-width: 600px;
        margin-bottom: 2rem;
        line-height: 1.6;
        animation: fade-up 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) 0.15s forwards;
        opacity: 0;
        transform: translateY(40px);
    }
    @keyframes fade-up {
        to { opacity: 1; transform: translateY(0); }
    }
    .hero-cta {
        padding: 1rem 2.5rem;
        font-size: 1.1rem;
        font-weight: 600;
        border-radius: 50px;
        background: var(--accent-orange);
        color: #fff;
        text-decoration: none;
        transition: all 0.4s cubic-bezier(0.2, 0.8, 0.2, 1);
        box-shadow: 0 4px 20px rgba(234, 88, 12, 0.3);
        animation: fade-up 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) 0.3s forwards;
        opacity: 0;
        transform: translateY(40px);
    }
    .hero-cta:hover {
        transform: translateY(-4px) scale(1.02);
        box-shadow: 0 8px 30px rgba(234, 88, 12, 0.5);
        background: #f97316;
    }

    /* Animation Pipeline */
    .pipeline-container {
        position: relative;
        width: 100%;
        max-width: 900px;
        height: 320px;
        margin: 3rem auto;
        border-radius: 24px;
        background: rgba(30, 41, 59, 0.3);
        border: 1px solid var(--border-color);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        animation: fade-up 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) 0.5s forwards;
        opacity: 0;
        box-shadow: inset 0 0 40px rgba(0,0,0,0.1);
    }
    /* Grid background effect */
    .pipeline-container::before {
        content: '';
        position: absolute;
        inset: 0;
        background-image: 
            linear-gradient(to right, rgba(255,255,255,0.03) 1px, transparent 1px),
            linear-gradient(to bottom, rgba(255,255,255,0.03) 1px, transparent 1px);
        background-size: 30px 30px;
        mask-image: radial-gradient(circle at center, black 40%, transparent 80%);
        -webkit-mask-image: radial-gradient(circle at center, black 40%, transparent 80%);
        pointer-events: none;
    }
    [data-theme="light"] .pipeline-container {
        background: rgba(248, 250, 252, 0.5);
    }
    [data-theme="light"] .pipeline-container::before {
        background-image: 
            linear-gradient(to right, rgba(0,0,0,0.04) 1px, transparent 1px),
            linear-gradient(to bottom, rgba(0,0,0,0.04) 1px, transparent 1px);
    }

    .tx-card {
        width: 200px;
        padding: 1.25rem;
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        position: absolute;
        left: 0;
        z-index: 2;
        font-family: 'JetBrains Mono', monospace;
        font-size: 0.85rem;
        will-change: transform, border-color, box-shadow, opacity;
        opacity: 0;
    }
    .tx-card-1 { animation: slide-tx-1 9s infinite cubic-bezier(0.25, 1, 0.5, 1); }
    .tx-card-2 { animation: slide-tx-2 9s infinite cubic-bezier(0.25, 1, 0.5, 1) 4.5s; }
    
    .tx-amount { font-size: 1.25rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem; letter-spacing: -0.05em; }
    .tx-details { color: var(--text-muted); line-height: 1.4; }
    .tx-badge { 
        display: inline-flex; align-items: center; justify-content: center;
        padding: 0.3rem 0.6rem; border-radius: 6px; 
        font-size: 0.7rem; font-weight: 700; margin-top: 1rem;
        opacity: 0;
        width: 100%;
        box-sizing: border-box;
        letter-spacing: 0.05em;
    }
    
    /* Advanced Engine Core */
    .engine-core {
        position: absolute;
        left: 50%;
        margin-left: -75px;
        width: 150px;
        height: 150px;
        border-radius: 50%;
        border: 2px dashed rgba(234, 88, 12, 0.4);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1;
        animation: spin-slow 15s linear infinite;
    }
    .engine-core::before {
        content: '';
        position: absolute;
        inset: -15px;
        border-radius: 50%;
        border: 1px solid rgba(56, 189, 248, 0.3);
        animation: spin-reverse 20s linear infinite;
    }
    .engine-center {
        width: 70px;
        height: 70px;
        background: var(--card-bg);
        border-radius: 50%;
        border: 2px solid var(--accent-orange);
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 0 30px rgba(234, 88, 12, 0.3);
        animation: spin-reverse 10s cubic-bezier(0.4, 0, 0.2, 1) infinite;
    }
    
    /* Smooth Scanner Beam with Gradient Tail */
    .scanner-beam {
        position: absolute;
        top: 0;
        bottom: 0;
        width: 100px;
        background: linear-gradient(to right, transparent, rgba(56, 189, 248, 0.05) 50%, rgba(56, 189, 248, 0.8) 100%);
        left: 0;
        opacity: 0;
        z-index: 3;
        will-change: transform, opacity;
        pointer-events: none;
    }
    .scanner-beam::after {
        content: '';
        position: absolute;
        top: 0;
        bottom: 0;
        right: 0;
        width: 2px;
        background: #38bdf8;
        box-shadow: 0 0 20px #38bdf8, 0 0 40px #38bdf8;
    }
    .beam-1 { animation: scan-beam 9s infinite 2s; }
    .beam-2 { animation: scan-beam 9s infinite 6.5s; }

    @keyframes spin-slow { 100% { transform: rotate(360deg); } }
    @keyframes spin-reverse { 100% { transform: rotate(-360deg); } }
    
    /* Hardware Accelerated Translations */
    @keyframes slide-tx-1 {
        0% { transform: translate3d(-250px, 0, 0) scale(0.9); opacity: 0; border-color: var(--border-color); }
        10% { opacity: 1; transform: translate3d(-100px, 0, 0) scale(1); }
        30% { transform: translate3d(calc(450px - 100px), 0, 0) scale(1); border-color: var(--border-color); } /* Center */
        45% { transform: translate3d(calc(450px - 100px), 0, 0) scale(1); border-color: #ef4444; box-shadow: 0 0 30px rgba(239, 68, 68, 0.4); } /* Evaluated High Risk */
        50% { transform: translate3d(calc(450px - 100px), 0, 0) rotate(-4deg) scale(0.96); } /* Rollback shake left */
        53% { transform: translate3d(calc(450px - 100px), 0, 0) rotate(4deg) scale(0.96); } /* Rollback shake right */
        58% { transform: translate3d(calc(450px - 100px), 0, 0) rotate(0) scale(1); }
        80% { transform: translate3d(calc(450px - 100px), 120px, 0) rotate(10deg); opacity: 0; } /* Rejected Drop */
        100% { transform: translate3d(calc(450px - 100px), 120px, 0); opacity: 0; }
    }
    
    @keyframes slide-tx-2 {
        0% { transform: translate3d(-250px, 0, 0) scale(0.9); opacity: 0; border-color: var(--border-color); }
        10% { opacity: 1; transform: translate3d(-100px, 0, 0) scale(1); }
        30% { transform: translate3d(calc(450px - 100px), 0, 0) scale(1); border-color: var(--border-color); } /* Center */
        45% { transform: translate3d(calc(450px - 100px), 0, 0) scale(1); border-color: #10b981; box-shadow: 0 0 30px rgba(16, 185, 129, 0.3); } /* Evaluated Safe */
        80% { transform: translate3d(1000px, 0, 0) scale(1); opacity: 1; } /* Cleared Path Slide Right */
        90% { transform: translate3d(1100px, 0, 0); opacity: 0; }
        100% { transform: translate3d(1100px, 0, 0); opacity: 0; }
    }

    @keyframes scan-beam {
        0% { transform: translate3d(200px, 0, 0); opacity: 0; }
        10% { opacity: 1; }
        30% { transform: translate3d(600px, 0, 0); opacity: 1; }
        45% { transform: translate3d(650px, 0, 0); opacity: 0; }
        100% { transform: translate3d(650px, 0, 0); opacity: 0; }
    }
    
    .tx-1-badge { animation: show-badge-1 9s infinite; background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }
    .tx-2-badge { animation: show-badge-2 9s infinite 4.5s; background: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); }
    
    @keyframes show-badge-1 { 0%, 40% { opacity: 0; transform: scale(0.8); } 45%, 100% { opacity: 1; transform: scale(1); } }
    @keyframes show-badge-2 { 0%, 40% { opacity: 0; transform: scale(0.8); } 45%, 100% { opacity: 1; transform: scale(1); } }

    /* Bento Grid Features */
    .bento-section {
        max-width: 1200px;
        margin: 5rem auto;
        padding: 0 2rem;
    }
    .bento-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 1.5rem;
    }
    .bento-card {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 24px;
        padding: 2rem;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        position: relative;
        overflow: hidden;
    }
    .bento-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-lg);
        border-color: var(--accent-orange);
    }
    .bento-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        background: rgba(234, 88, 12, 0.1);
        color: var(--accent-orange);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 1.5rem;
    }
    .bento-title {
        font-size: 1.25rem;
        font-weight: 700;
        margin-bottom: 0.75rem;
    }
    .bento-desc {
        color: var(--text-secondary);
        font-size: 0.95rem;
        line-height: 1.6;
    }

    /* Infinite Marquee */
    .marquee-container {
        width: 100%;
        overflow: hidden;
        background: var(--card-bg);
        border-top: 1px solid var(--border-color);
        border-bottom: 1px solid var(--border-color);
        padding: 1.5rem 0;
        margin-top: 5rem;
        display: flex;
        white-space: nowrap;
    }
    .marquee-content {
        display: inline-flex;
        animation: scroll-marquee 20s linear infinite;
    }
    .marquee-item {
        font-family: 'JetBrains Mono', monospace;
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--text-muted);
        margin: 0 2rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .marquee-dot {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        background: var(--accent-orange);
    }
    @keyframes scroll-marquee {
        0% { transform: translateX(0); }
        100% { transform: translateX(-50%); }
    }

    /* Intersection Observer Fades */
    .reveal {
        opacity: 0;
        transform: translateY(40px);
        transition: all 0.8s cubic-bezier(0.5, 0, 0, 1);
    }
    .reveal.active {
        opacity: 1;
        transform: translateY(0);
    }
</style>

<div class="landing-wrapper">
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-glow"></div>
        <h1 class="hero-title"><span>Autonomous Financial<br>Integrity & Security.</span></h1>
        <p class="hero-subtitle">Enterprise-grade fraud detection intercepting digital transactions in real-time. Driven by composite heuristics, ACID rollbacks, and Core Java.</p>
        <a href="<%= dashLink %>" class="hero-cta"><%= btnText %></a>

        <!-- Animated Data Pipeline -->
        <div class="pipeline-container">
            <!-- Transaction 1: High Risk -->
            <div class="tx-card tx-card-1">
                <div class="tx-amount">₹ 4,50,000</div>
                <div class="tx-details">UPI &rarr; VPA: suspect@ybl</div>
                <div class="tx-badge tx-1-badge">BLOCKED (Score: 85)</div>
            </div>
            
            <!-- Transaction 2: Safe -->
            <div class="tx-card tx-card-2">
                <div class="tx-amount">₹ 1,250</div>
                <div class="tx-details">IMPS &rarr; Swiggy Instamart</div>
                <div class="tx-badge tx-2-badge">CLEARED (Score: 12)</div>
            </div>

            <div class="engine-core">
                <div class="engine-center">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--accent-orange)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                    </svg>
                </div>
            </div>
            
            <div class="scanner-beam beam-1"></div>
            <div class="scanner-beam beam-2"></div>
        </div>
    </section>

    <!-- Features Bento Grid -->
    <section class="bento-section reveal">
        <div class="bento-grid">
            <div class="bento-card">
                <div class="bento-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                </div>
                <h3 class="bento-title">&lt;10ms Scoring Latency</h3>
                <p class="bento-desc">Parallel multithreaded evaluation ensures transactions are scored and triaged before payment gateway timeouts occur.</p>
            </div>
            <div class="bento-card">
                <div class="bento-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                </div>
                <h3 class="bento-title">7 Composite Heuristics</h3>
                <p class="bento-desc">Strategy Pattern engine evaluating velocity bursts, geolocation, unusual hours, and high-amount deviations instantly.</p>
            </div>
            <div class="bento-card">
                <div class="bento-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                </div>
                <h3 class="bento-title">ACID Transaction Rollback</h3>
                <p class="bento-desc">Strict JDBC boundary checks. High-risk profiles trigger immediate connection rollbacks, guaranteeing absolute financial atomicity.</p>
            </div>
            <div class="bento-card">
                <div class="bento-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="8" rx="2" ry="2"/><rect x="2" y="14" width="20" height="8" rx="2" ry="2"/><line x1="6" y1="6" x2="6.01" y2="6"/><line x1="6" y1="18" x2="6.01" y2="18"/></svg>
                </div>
                <h3 class="bento-title">Dual-Mode Resilience</h3>
                <p class="bento-desc">Production MySQL 8.0 cluster with a seamless, zero-downtime automatic failover to an in-memory H2 database engine.</p>
            </div>
        </div>
    </section>

    <!-- Infinite Tech Marquee -->
    <div class="marquee-container reveal">
        <div class="marquee-content">
            <!-- Original Set -->
            <span class="marquee-item"><span class="marquee-dot"></span> Core Java 25</span>
            <span class="marquee-item"><span class="marquee-dot"></span> Jakarta Servlets 6.0</span>
            <span class="marquee-item"><span class="marquee-dot"></span> MySQL 8.0</span>
            <span class="marquee-item"><span class="marquee-dot"></span> In-Memory H2</span>
            <span class="marquee-item"><span class="marquee-dot"></span> Pure Vanilla CSS</span>
            <span class="marquee-item"><span class="marquee-dot"></span> JDBC DAO</span>
            <span class="marquee-item"><span class="marquee-dot"></span> Tomcat 10.1</span>
            <!-- Duplicated Set for infinite loop -->
            <span class="marquee-item"><span class="marquee-dot"></span> Core Java 25</span>
            <span class="marquee-item"><span class="marquee-dot"></span> Jakarta Servlets 6.0</span>
            <span class="marquee-item"><span class="marquee-dot"></span> MySQL 8.0</span>
            <span class="marquee-item"><span class="marquee-dot"></span> In-Memory H2</span>
            <span class="marquee-item"><span class="marquee-dot"></span> Pure Vanilla CSS</span>
            <span class="marquee-item"><span class="marquee-dot"></span> JDBC DAO</span>
            <span class="marquee-item"><span class="marquee-dot"></span> Tomcat 10.1</span>
        </div>
    </div>
</div>

<script>
    // Intersection Observer for scroll animations
    document.addEventListener("DOMContentLoaded", function() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.reveal').forEach(el => {
            observer.observe(el);
        });
    });
</script>

<jsp:include page="/views/common/footer.jsp" />
