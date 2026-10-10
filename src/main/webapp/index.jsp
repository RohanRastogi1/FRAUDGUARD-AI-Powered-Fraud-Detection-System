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
        padding: 2rem 2rem 0;
        z-index: 1;
    }
    .hero-glow {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 800px;
        height: 800px;
        background: radial-gradient(circle, rgba(234, 88, 12, 0.12) 0%, rgba(56, 189, 248, 0.05) 40%, transparent 60%);
        filter: blur(60px);
        z-index: -1;
        transition: top 0.4s cubic-bezier(0.2, 0.8, 0.2, 1), left 0.4s cubic-bezier(0.2, 0.8, 0.2, 1);
        pointer-events: none;
    }
    .hero-title {
        font-size: clamp(2.5rem, 6vw, 4.5rem);
        font-weight: 800;
        letter-spacing: -0.03em;
        line-height: 1.1;
        margin-bottom: 1.5rem;
        color: var(--text-primary);
        text-shadow: 0 4px 24px rgba(234, 88, 12, 0.15);
        opacity: 1;
        transform: none; /* Let JS handle reveal */
    }
    .hero-title span {
        background: linear-gradient(135deg, var(--primary, #ea580c), #f43f5e);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        display: inline-block;
        opacity: 0; /* Hidden until JS types it out */
    }
    .hero-subtitle {
        font-size: clamp(1rem, 2vw, 1.25rem);
        color: var(--text-secondary);
        max-width: 600px;
        margin-bottom: 2rem;
        line-height: 1.6;
        animation: fade-up 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) 0.8s forwards;
        opacity: 0;
        transform: translateY(40px);
    }
    @keyframes fade-up {
        to { opacity: 1; transform: translateY(0); }
    }
    .hero-cta {
        position: relative;
        padding: 1rem 2.5rem;
        font-size: 1.1rem;
        font-weight: 600;
        border-radius: 50px;
        color: #fff;
        text-decoration: none;
        transition: all 0.4s cubic-bezier(0.2, 0.8, 0.2, 1);
        box-shadow: 0 4px 20px rgba(234, 88, 12, 0.3);
        animation: fade-up 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) 1s forwards;
        opacity: 0;
        transform: translateY(40px);
        background: var(--bg-primary); /* Base color behind text */
        z-index: 1;
        overflow: hidden;
    }
    .hero-cta::before {
        content: '';
        position: absolute;
        inset: -2px;
        z-index: -2;
        background: conic-gradient(from 0deg, var(--primary, #ea580c), #f43f5e, #38bdf8, var(--primary, #ea580c));
        animation: spin-gradient 4s linear infinite;
    }
    .hero-cta::after {
        content: '';
        position: absolute;
        inset: 2px;
        background: var(--primary, #ea580c);
        border-radius: 50px;
        z-index: -1;
        transition: background 0.3s;
    }
    .hero-cta:hover::after {
        background: #f97316;
    }
    .hero-cta:hover {
        transform: translateY(-4px) scale(1.05);
        box-shadow: 0 8px 30px rgba(234, 88, 12, 0.5);
    }
    .hero-cta-secondary {
        padding: 1rem 2rem;
        font-size: 1.1rem;
        font-weight: 600;
        border-radius: 50px;
        color: var(--text-primary);
        text-decoration: none;
        transition: all 0.4s cubic-bezier(0.2, 0.8, 0.2, 1);
        border: 1px solid rgba(56, 189, 248, 0.3);
        background: rgba(15, 23, 42, 0.5);
        backdrop-filter: blur(10px);
        box-shadow: inset 0 0 10px rgba(56, 189, 248, 0.1), 0 0 15px rgba(56, 189, 248, 0.15);
        animation: fade-up 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) 1.1s forwards;
        opacity: 0;
        transform: translateY(40px);
    }
    .hero-cta-secondary:hover {
        background: rgba(15, 23, 42, 0.8);
        border-color: #38bdf8;
        transform: translateY(-4px) scale(1.05);
        box-shadow: inset 0 0 20px rgba(56, 189, 248, 0.2), 0 8px 30px rgba(56, 189, 248, 0.4);
        color: #38bdf8;
    }
    @keyframes spin-gradient {
        100% { transform: rotate(360deg); }
    }

    /* Animation Pipeline & 3D Glass Tilt */
    .pipeline-wrapper {
        perspective: 1200px;
        width: 100%;
        max-width: 900px;
        margin: 2rem auto 4rem;
        animation: fade-up 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) 1.2s forwards;
        opacity: 0;
        transform: translateY(40px);
    }
    .pipeline-container {
        position: relative;
        width: 100%;
        height: 320px;
        border-radius: 24px;
        background: rgba(30, 41, 59, 0.3);
        border: 1px solid var(--border-color);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        box-shadow: inset 0 0 40px rgba(0,0,0,0.1), 0 20px 50px rgba(0,0,0,0.15);
        transform-style: preserve-3d;
        transition: transform 0.1s ease-out; /* JS handles dynamic tilt */
    }
    .pipeline-glare {
        position: absolute;
        top: 0; left: 0; right: 0; bottom: 0;
        background: radial-gradient(circle at 50% 50%, rgba(255,255,255,0.1) 0%, transparent 50%);
        opacity: 0;
        pointer-events: none;
        z-index: 20;
        transition: opacity 0.3s;
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
        transform: translateZ(-20px);
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
        background: var(--bg-elevated); /* Solid contrast */
        border: 1px solid var(--border-color);
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        position: absolute;
        left: 0;
        z-index: 10; /* Above engine core */
        font-family: 'JetBrains Mono', monospace;
        font-size: 0.85rem;
        will-change: transform, border-color, box-shadow, opacity;
        opacity: 0;
        transform: translateZ(30px); /* Popping out in 3D */
        overflow: hidden;
    }
    .tx-card-1 { animation: slide-tx-1 9s infinite cubic-bezier(0.25, 1, 0.5, 1); }
    .tx-card-2 { animation: slide-tx-2 9s infinite cubic-bezier(0.25, 1, 0.5, 1) 4.5s; }
    
    .matrix-bg {
        position: absolute;
        inset: 0;
        background: rgba(56, 189, 248, 0.05);
        color: rgba(56, 189, 248, 0.3);
        font-size: 8px;
        word-wrap: break-word;
        line-height: 8px;
        pointer-events: none;
        z-index: -1;
        opacity: 0;
    }
    .tx-card-1 .matrix-bg { animation: matrix-flicker 9s infinite; }
    .tx-card-2 .matrix-bg { animation: matrix-flicker 9s infinite 4.5s; }
    
    @keyframes matrix-flicker {
        0%, 30% { opacity: 0; }
        35%, 45% { opacity: 1; }
        50%, 100% { opacity: 0; }
    }

    .tx-amount { font-size: 1.25rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem; letter-spacing: -0.05em; }
    .tx-details { color: var(--text-muted); line-height: 1.4; }
    .tx-badge { 
        display: inline-flex; align-items: center; justify-content: center;
        padding: 0.3rem 0.6rem; border-radius: 6px; 
        font-size: 0.7rem; font-weight: 800; margin-top: 1rem;
        opacity: 0;
        width: 100%;
        box-sizing: border-box;
        letter-spacing: 0.05em;
        text-transform: uppercase;
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
        z-index: 5; /* Below cards */
        animation: spin-slow 15s linear infinite;
        transform: translateZ(10px);
    }
    .engine-core::before {
        content: '';
        position: absolute;
        inset: -20px;
        border-radius: 50%;
        border: 1px solid rgba(56, 189, 248, 0.2);
        border-left: 2px solid rgba(56, 189, 248, 0.8);
        animation: spin-reverse 8s linear infinite;
    }
    .engine-core::after {
        content: '';
        position: absolute;
        inset: 10px;
        border-radius: 50%;
        border: 1px dotted var(--primary, #ea580c);
        animation: spin-slow 10s linear infinite;
    }
    .engine-center {
        width: 60px;
        height: 60px;
        background: var(--bg-card);
        border-radius: 50%;
        border: 2px solid var(--primary, #ea580c);
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
        width: 150px;
        background: linear-gradient(to right, transparent, rgba(56, 189, 248, 0.05) 50%, rgba(56, 189, 248, 0.9) 100%);
        left: 0;
        opacity: 0;
        z-index: 15; /* Above cards */
        will-change: transform, opacity;
        pointer-events: none;
        transform: translateZ(40px); /* Popping out highly */
    }
    .scanner-beam::after {
        content: '';
        position: absolute;
        top: 0; bottom: 0; right: 0;
        width: 3px;
        background: #38bdf8;
        box-shadow: 0 0 25px #38bdf8, 0 0 50px #38bdf8;
    }
    .beam-1 { animation: scan-beam 9s infinite 2s; }
    .beam-2 { animation: scan-beam 9s infinite 6.5s; }

    /* SVG Connectors */
    .connector-line {
        fill: none;
        stroke: rgba(234, 88, 12, 0.2);
        stroke-width: 2;
        stroke-dasharray: 10, 10;
        animation: dash-flow 2s linear infinite;
    }
    .pulse-line-1 { animation: dash-flow 2s linear infinite, line-flash-1 9s infinite cubic-bezier(0.25, 1, 0.5, 1); }
    .pulse-line-2 { animation: dash-flow-reverse 2s linear infinite, line-flash-2 9s infinite cubic-bezier(0.25, 1, 0.5, 1) 4.5s; }
    
    @keyframes dash-flow { to { stroke-dashoffset: -20; } }
    @keyframes dash-flow-reverse { to { stroke-dashoffset: 20; } }
    @keyframes line-flash-1 { 
        0%, 25% { stroke: rgba(234,88,12,0.2); stroke-width: 2; filter: none; } 
        28%, 45% { stroke: #ea580c; stroke-width: 4; filter: drop-shadow(0 0 8px #ea580c); } 
        55%, 100% { stroke: rgba(234,88,12,0.2); stroke-width: 2; filter: none; } 
    }
    @keyframes line-flash-2 { 
        0%, 25% { stroke: rgba(234,88,12,0.2); stroke-width: 2; filter: none; } 
        28%, 45% { stroke: #10b981; stroke-width: 4; filter: drop-shadow(0 0 8px #10b981); } 
        55%, 100% { stroke: rgba(234,88,12,0.2); stroke-width: 2; filter: none; } 
    }

    @keyframes spin-slow { 100% { transform: rotate(360deg); } }
    @keyframes spin-reverse { 100% { transform: rotate(-360deg); } }
    
    /* Hardware Accelerated Translations with Heavy Shake */
    @keyframes slide-tx-1 {
        0% { transform: translate3d(-250px, 0, 30px) scale(0.9); opacity: 0; border-color: var(--border-color); }
        10% { opacity: 1; transform: translate3d(-100px, 0, 30px) scale(1); }
        30% { transform: translate3d(calc(450px - 100px), 0, 30px) scale(1); border-color: var(--border-color); } /* Center */
        45% { transform: translate3d(calc(450px - 100px), 0, 30px) scale(1); border-color: #ef4444; box-shadow: 0 0 40px rgba(239, 68, 68, 0.6); } /* High Risk Flash */
        46% { transform: translate3d(calc(450px - 110px), 10px, 30px) rotate(-8deg) scale(0.95); } /* Violent shake start */
        48% { transform: translate3d(calc(450px - 90px), -10px, 30px) rotate(8deg) scale(1.05); } 
        50% { transform: translate3d(calc(450px - 105px), 5px, 30px) rotate(-5deg) scale(0.98); } 
        52% { transform: translate3d(calc(450px - 95px), -5px, 30px) rotate(5deg) scale(1.02); } 
        55% { transform: translate3d(calc(450px - 100px), 0, 30px) rotate(0) scale(1); } /* Shake end */
        80% { transform: translate3d(calc(450px - 100px), 200px, 30px) rotate(15deg) scale(0.8); opacity: 0; } /* Rejected Drop */
        100% { transform: translate3d(calc(450px - 100px), 200px, 30px); opacity: 0; }
    }
    
    @keyframes slide-tx-2 {
        0% { transform: translate3d(-250px, 0, 30px) scale(0.9); opacity: 0; border-color: var(--border-color); }
        10% { opacity: 1; transform: translate3d(-100px, 0, 30px) scale(1); }
        30% { transform: translate3d(calc(450px - 100px), 0, 30px) scale(1); border-color: var(--border-color); } /* Center */
        45% { transform: translate3d(calc(450px - 100px), 0, 30px) scale(1); border-color: #10b981; box-shadow: 0 0 40px rgba(16, 185, 129, 0.4); } /* Safe Flash */
        80% { transform: translate3d(1000px, 0, 30px) scale(1); opacity: 1; } /* Cleared Path Slide Right */
        90% { transform: translate3d(1200px, 0, 30px); opacity: 0; }
        100% { transform: translate3d(1200px, 0, 30px); opacity: 0; }
    }

    @keyframes scan-beam {
        0% { transform: translate3d(150px, 0, 40px); opacity: 0; }
        10% { opacity: 1; }
        30% { transform: translate3d(600px, 0, 40px); opacity: 1; }
        45% { transform: translate3d(700px, 0, 40px); opacity: 0; }
        100% { transform: translate3d(700px, 0, 40px); opacity: 0; }
    }
    
    .tx-1-badge { animation: show-badge-1 9s infinite; background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.5); }
    .tx-2-badge { animation: show-badge-2 9s infinite 4.5s; background: rgba(16, 185, 129, 0.15); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.5); }
    
    /* Stamp effect for Blocked */
    @keyframes show-badge-1 { 
        0%, 45% { opacity: 0; transform: scale(3); } 
        48% { opacity: 1; transform: scale(0.9); }
        50%, 100% { opacity: 1; transform: scale(1); } 
    }
    @keyframes show-badge-2 { 
        0%, 45% { opacity: 0; transform: scale(0.8); } 
        48%, 100% { opacity: 1; transform: scale(1); } 
    }

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
        position: relative;
        overflow: hidden;
        opacity: 0;
        transform: perspective(1000px) rotateX(20deg) translateY(60px);
        transition: opacity 0.8s cubic-bezier(0.2, 0.8, 0.2, 1), transform 0.8s cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 0.3s ease, border-color 0.3s ease;
    }
    .bento-card.active {
        opacity: 1;
        transform: perspective(1000px) rotateX(0deg) translateY(0);
    }
    .bento-card:hover {
        transform: perspective(1000px) rotateX(0deg) translateY(-5px);
        box-shadow: var(--shadow-lg);
        border-color: var(--primary, #ea580c);
    }
    /* Staggered delays for children */
    .bento-card:nth-child(1) { transition-delay: 0s, 0s, 0s, 0s; }
    .bento-card:nth-child(2) { transition-delay: 0.15s, 0.15s, 0s, 0s; }
    .bento-card:nth-child(3) { transition-delay: 0.3s, 0.3s, 0s, 0s; }
    .bento-card:nth-child(4) { transition-delay: 0.45s, 0.45s, 0s, 0s; }
    .bento-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        background: rgba(234, 88, 12, 0.1);
        color: var(--primary, #ea580c);
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
        background: var(--primary, #ea580c);
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
    <!-- Neural Particles Canvas -->
    <canvas id="neural-canvas" style="position:absolute; top:0; left:0; width:100%; height:90vh; pointer-events:none; z-index:0;"></canvas>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-glow"></div>
        <h1 class="hero-title"><span id="glitch-title">Autonomous Financial<br>Integrity & Security.</span></h1>
        <p class="hero-subtitle">Enterprise-grade fraud detection intercepting digital transactions in real-time. Driven by composite heuristics, ACID rollbacks, and Core Java.</p>
        
        <div class="hero-actions" style="display: flex; gap: 1rem; align-items: center; justify-content: center; z-index: 10;">
            <a href="<%= dashLink %>" class="hero-cta"><%= btnText %></a>
            <a href="architecture.jsp" class="hero-cta-secondary">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:8px; vertical-align:middle;"><polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/></svg>
                View Architecture
            </a>
        </div>

        <!-- Animated Data Pipeline -->
        <div class="pipeline-wrapper">
            <div class="pipeline-container" id="pipeline-box">
                <div class="pipeline-glare" id="pipeline-glare"></div>
                
                <svg class="data-connector" viewBox="0 0 900 320" style="position:absolute; inset:0; z-index:4; pointer-events:none;">
                    <path d="M -50 160 C 200 160, 200 160, 450 160" class="connector-line pulse-line-1"></path>
                    <path d="M 950 160 C 700 160, 700 160, 450 160" class="connector-line pulse-line-2"></path>
                </svg>

                <!-- Transaction 1: High Risk -->
                <div class="tx-card tx-card-1">
                    <div class="matrix-bg">1001011010110110010101010100110001011010101110101001010101001010101101010101101100101010101001100010110101011101010010101010010101</div>
                    <div class="tx-amount">₹ 4,50,000</div>
                    <div class="tx-details">UPI &rarr; VPA: suspect@ybl</div>
                    <div class="tx-badge tx-1-badge">BLOCKED (Score: 85)</div>
                </div>
                
                <!-- Transaction 2: Safe -->
                <div class="tx-card tx-card-2">
                    <div class="matrix-bg">001010100010101010001101010101001001010101000101011101010100101010100010101010001101010101001001010101000101011101010100101</div>
                    <div class="tx-amount">₹ 1,250</div>
                    <div class="tx-details">IMPS &rarr; Swiggy Instamart</div>
                    <div class="tx-badge tx-2-badge">CLEARED (Score: 12)</div>
                </div>

                <div class="engine-core">
                    <div class="engine-center">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--primary, #ea580c)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M6 3h12"/><path d="M6 8h12"/><path d="M6 13h3c3.314 0 6-2.686 6-6s-2.686-6-6-6H6"/><path d="M6 13l8.5 8"/>
                        </svg>
                    </div>
                </div>
                
                <div class="scanner-beam beam-1"></div>
                <div class="scanner-beam beam-2"></div>
            </div>
        </div>
    </section>

    <!-- Features Bento Grid -->
    <section class="bento-section">
        <div class="bento-grid">
            <div class="bento-card reveal">
                <div class="bento-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                </div>
                <h3 class="bento-title">&lt;10ms Scoring Latency</h3>
                <p class="bento-desc">Parallel multithreaded evaluation ensures transactions are scored and triaged before payment gateway timeouts occur.</p>
            </div>
            <div class="bento-card reveal">
                <div class="bento-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                </div>
                <h3 class="bento-title">7 Composite Heuristics</h3>
                <p class="bento-desc">Strategy Pattern engine evaluating velocity bursts, geolocation, unusual hours, and high-amount deviations instantly.</p>
            </div>
            <div class="bento-card reveal">
                <div class="bento-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                </div>
                <h3 class="bento-title">ACID Transaction Rollback</h3>
                <p class="bento-desc">Strict JDBC boundary checks. High-risk profiles trigger immediate connection rollbacks, guaranteeing absolute financial atomicity.</p>
            </div>
            <div class="bento-card reveal">
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
    document.addEventListener("DOMContentLoaded", function() {
        // --- 1. Scrambled Text Glitch Reveal ---
        const titleSpan = document.getElementById('glitch-title');
        const originalText = titleSpan.innerHTML; // Contains <br>
        const textParts = originalText.split('<br>');
        
        let chars = '!<>-_\\\\/[]{}—=+*^?#_';
        let iterations = 0;
        let revealed1 = "";
        let revealed2 = "";
        
        // Show span
        titleSpan.style.opacity = 1;
        titleSpan.innerHTML = "";
        
        const scrambleInterval = setInterval(() => {
            let p1 = textParts[0].split('').map((c, i) => i < iterations/2 ? c : chars[Math.floor(Math.random() * chars.length)]).join('');
            let p2 = textParts[1].split('').map((c, i) => i < (iterations-textParts[0].length)/2 ? c : chars[Math.floor(Math.random() * chars.length)]).join('');
            
            titleSpan.innerHTML = p1 + "<br>" + (iterations > textParts[0].length ? p2 : "");
            
            if (iterations >= (textParts[0].length + textParts[1].length) * 2) {
                clearInterval(scrambleInterval);
                titleSpan.innerHTML = originalText;
                titleSpan.style.textShadow = "0 0 20px rgba(234, 88, 12, 0.4)";
                setTimeout(() => titleSpan.style.textShadow = "none", 500);
            }
            iterations++;
        }, 30);

        // --- 2. Interactive 3D Glass Tilt ---
        const box = document.getElementById('pipeline-box');
        const glare = document.getElementById('pipeline-glare');
        
        box.addEventListener('mousemove', (e) => {
            const rect = box.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            
            // Calculate rotation (max 10 degrees)
            const rotateX = ((y - centerY) / centerY) * -10;
            const rotateY = ((x - centerX) / centerX) * 10;
            
            box.style.transform = `rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
            
            // Glare effect
            glare.style.opacity = 1;
            glare.style.background = `radial-gradient(circle at ${x}px ${y}px, rgba(255,255,255,0.15) 0%, transparent 60%)`;
        });
        
        box.addEventListener('mouseleave', () => {
            box.style.transform = `rotateX(0) rotateY(0)`;
            glare.style.opacity = 0;
        });

        // --- 5. Dynamic Spotlight Glow ---
        const heroSection = document.querySelector('.hero-section');
        const heroGlow = document.querySelector('.hero-glow');
        heroSection.addEventListener('mousemove', (e) => {
            const rect = heroSection.getBoundingClientRect();
            // Smoothly move the glow to cursor
            heroGlow.style.left = (e.clientX - rect.left) + 'px';
            heroGlow.style.top = (e.clientY - rect.top) + 'px';
        });

        // --- 3. Neural Particles Background ---
        const canvas = document.getElementById('neural-canvas');
        const ctx = canvas.getContext('2d');
        let width, height;
        let particles = [];
        
        function resize() {
            width = canvas.width = window.innerWidth;
            height = canvas.height = document.querySelector('.hero-section').offsetHeight || window.innerHeight * 0.9;
        }
        window.addEventListener('resize', resize);
        resize();
        
        class Particle {
            constructor() {
                this.x = Math.random() * width;
                this.y = Math.random() * height;
                this.vx = (Math.random() - 0.5) * 0.5;
                this.vy = (Math.random() - 0.5) * 0.5;
                this.radius = Math.random() * 1.5 + 0.5;
            }
            update() {
                this.x += this.vx;
                this.y += this.vy;
                if (this.x < 0 || this.x > width) this.vx = -this.vx;
                if (this.y < 0 || this.y > height) this.vy = -this.vy;
            }
            draw() {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
                ctx.fillStyle = getComputedStyle(document.body).getPropertyValue('--primary') || '#ea580c';
                ctx.globalAlpha = 0.4;
                ctx.fill();
            }
        }
        
        for (let i = 0; i < (window.innerWidth < 768 ? 20 : 50); i++) {
            particles.push(new Particle());
        }
        
        function animate() {
            ctx.clearRect(0, 0, width, height);
            for (let i = 0; i < particles.length; i++) {
                particles[i].update();
                particles[i].draw();
                for (let j = i + 1; j < particles.length; j++) {
                    const dx = particles[i].x - particles[j].x;
                    const dy = particles[i].y - particles[j].y;
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist < 100) {
                        ctx.beginPath();
                        ctx.moveTo(particles[i].x, particles[i].y);
                        ctx.lineTo(particles[j].x, particles[j].y);
                        ctx.strokeStyle = getComputedStyle(document.body).getPropertyValue('--primary') || '#ea580c';
                        ctx.globalAlpha = 1 - (dist / 100);
                        ctx.lineWidth = 0.5;
                        ctx.stroke();
                    }
                }
            }
            requestAnimationFrame(animate);
        }
        animate();

        // --- 4. Intersection Observer for Scroll Fades ---
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
