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
        min-height: 90vh;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 4rem 2rem;
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
        background: linear-gradient(135deg, var(--text-primary) 30%, var(--accent-orange));
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        animation: fade-up 1s ease-out forwards;
        opacity: 0;
        transform: translateY(30px);
    }
    .hero-subtitle {
        font-size: clamp(1rem, 2vw, 1.25rem);
        color: var(--text-secondary);
        max-width: 600px;
        margin-bottom: 3rem;
        line-height: 1.6;
        animation: fade-up 1s ease-out 0.2s forwards;
        opacity: 0;
        transform: translateY(30px);
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
        transition: all 0.3s ease;
        box-shadow: 0 4px 20px rgba(234, 88, 12, 0.4);
        animation: fade-up 1s ease-out 0.4s forwards;
        opacity: 0;
        transform: translateY(30px);
    }
    .hero-cta:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 25px rgba(234, 88, 12, 0.6);
        background: #f97316;
    }

    /* Animation Pipeline */
    .pipeline-container {
        position: relative;
        width: 100%;
        max-width: 900px;
        height: 300px;
        margin: 4rem auto;
        border-radius: 20px;
        background: rgba(30, 41, 59, 0.4);
        border: 1px solid var(--border-color);
        backdrop-filter: blur(10px);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 2rem;
        overflow: hidden;
        animation: fade-up 1s ease-out 0.6s forwards;
        opacity: 0;
    }
    [data-theme="light"] .pipeline-container {
        background: rgba(248, 250, 252, 0.6);
    }
    .tx-card {
        width: 180px;
        padding: 1rem;
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        box-shadow: var(--shadow-md);
        position: absolute;
        left: -200px;
        z-index: 2;
        font-family: 'JetBrains Mono', monospace;
        font-size: 0.85rem;
    }
    .tx-card-1 { animation: slide-tx-1 8s infinite cubic-bezier(0.4, 0, 0.2, 1); }
    .tx-card-2 { animation: slide-tx-2 8s infinite cubic-bezier(0.4, 0, 0.2, 1) 4s; }
    
    .tx-amount { font-size: 1.1rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
    .tx-details { color: var(--text-muted); }
    .tx-badge { 
        display: inline-block; padding: 0.2rem 0.5rem; border-radius: 4px; 
        font-size: 0.7rem; font-weight: 700; margin-top: 0.8rem;
        opacity: 0;
    }
    
    /* Engine Core (Center) */
    .engine-core {
        position: absolute;
        left: 50%;
        transform: translateX(-50%);
        width: 120px;
        height: 120px;
        border-radius: 50%;
        border: 2px dashed var(--accent-orange);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1;
        animation: spin-slow 10s linear infinite;
    }
    .engine-center {
        width: 60px;
        height: 60px;
        background: var(--card-bg);
        border-radius: 50%;
        border: 2px solid var(--accent-orange);
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 0 20px rgba(234, 88, 12, 0.4);
        animation: spin-reverse 10s linear infinite;
    }
    
    /* Scanner Beam */
    .scanner-beam {
        position: absolute;
        top: 0;
        bottom: 0;
        width: 4px;
        background: var(--accent-cyan, #38bdf8);
        box-shadow: 0 0 15px var(--accent-cyan, #38bdf8);
        left: 50%;
        opacity: 0;
        z-index: 3;
    }
    .beam-1 { animation: scan-beam 8s infinite 2.5s; }
    .beam-2 { animation: scan-beam 8s infinite 6.5s; }

    @keyframes spin-slow { 100% { transform: translateX(-50%) rotate(360deg); } }
    @keyframes spin-reverse { 100% { transform: rotate(-360deg); } }
    
    @keyframes slide-tx-1 {
        0% { left: -200px; transform: translateY(0); border-color: var(--border-color); }
        30% { left: 50%; transform: translateX(-50%); border-color: var(--border-color); }
        50% { left: 50%; transform: translateX(-50%); border-color: #ef4444; box-shadow: 0 0 15px rgba(239, 68, 68, 0.5); } /* Evaluated High Risk */
        55% { left: 50%; transform: translateX(-50%) rotate(-5deg) scale(0.95); } /* Rollback shake */
        60% { left: 50%; transform: translateX(-50%) rotate(5deg) scale(0.95); }
        65% { left: 50%; transform: translateX(-50%) rotate(0) scale(1); }
        85% { left: 120%; transform: translateY(100px) rotate(15deg); opacity: 0; } /* Rejected Path */
        100% { left: 120%; opacity: 0; }
    }
    
    @keyframes slide-tx-2 {
        0% { left: -200px; transform: translateY(0); border-color: var(--border-color); }
        30% { left: 50%; transform: translateX(-50%); border-color: var(--border-color); }
        50% { left: 50%; transform: translateX(-50%); border-color: #10b981; box-shadow: 0 0 15px rgba(16, 185, 129, 0.4); } /* Evaluated Low Risk */
        85% { left: 120%; transform: translateY(0); opacity: 1; } /* Cleared Path */
        100% { left: 120%; opacity: 0; }
    }

    @keyframes scan-beam {
        0% { left: 35%; opacity: 0; }
        10% { left: 40%; opacity: 1; }
        40% { left: 60%; opacity: 1; }
        50% { left: 65%; opacity: 0; }
        100% { left: 65%; opacity: 0; }
    }
    
    .tx-1-badge { animation: show-badge-1 8s infinite; background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid #ef4444; }
    .tx-2-badge { animation: show-badge-2 8s infinite 4s; background: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid #10b981; }
    
    @keyframes show-badge-1 { 0%, 45% { opacity: 0; } 50%, 100% { opacity: 1; } }
    @keyframes show-badge-2 { 0%, 45% { opacity: 0; } 50%, 100% { opacity: 1; } }

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
        <h1 class="hero-title">Autonomous Financial<br>Integrity & Security.</h1>
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
