<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "System Architecture Flow");
    String cp = request.getContextPath();
%>
<jsp:include page="/views/common/header.jsp" />

<style>
    .arch-wrapper {
        min-height: calc(100vh - 80px);
        padding: 4rem 2rem;
        background-color: var(--bg-primary);
        font-family: 'Inter', sans-serif;
        color: var(--text-primary);
        display: flex;
        flex-direction: column;
        align-items: center;
        overflow: hidden;
        position: relative;
    }
    .arch-header {
        text-align: center;
        margin-bottom: 4rem;
        z-index: 2;
    }
    .arch-title {
        font-size: 3rem;
        font-weight: 800;
        background: linear-gradient(135deg, var(--primary, #ea580c), #f43f5e);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        margin-bottom: 1rem;
    }
    .arch-subtitle {
        color: var(--text-muted);
        font-size: 1.1rem;
        max-width: 600px;
        margin: 0 auto;
    }

    /* Architecture Grid */
    .flow-container {
        display: flex;
        flex-direction: column;
        gap: 3rem;
        width: 100%;
        max-width: 1000px;
        position: relative;
        z-index: 2;
    }
    
    .flow-row {
        display: flex;
        justify-content: center;
        gap: 4rem;
        position: relative;
    }
    
    .node {
        background: rgba(30, 41, 59, 0.6);
        border: 1px solid var(--border-color);
        border-radius: 16px;
        padding: 1.5rem;
        width: 250px;
        text-align: center;
        position: relative;
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        transition: transform 0.3s, border-color 0.3s;
    }
    [data-theme="light"] .node { background: rgba(255,255,255,0.7); }
    .node:hover {
        transform: translateY(-5px);
        border-color: var(--primary, #ea580c);
        box-shadow: 0 10px 40px rgba(234, 88, 12, 0.2);
    }
    .node-icon {
        width: 50px;
        height: 50px;
        background: rgba(234, 88, 12, 0.1);
        color: var(--primary, #ea580c);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1rem;
    }
    .node-title {
        font-weight: 700;
        font-size: 1.1rem;
        margin-bottom: 0.5rem;
    }
    .node-desc {
        font-size: 0.85rem;
        color: var(--text-secondary);
        line-height: 1.4;
    }

    /* SVG Lines & Animation */
    .flow-svg {
        position: absolute;
        top: 0; left: 0; width: 100%; height: 100%;
        pointer-events: none;
        z-index: 1; /* Fixed z-index so lines are visible above background */
    }
    .path-line {
        fill: none;
        stroke: var(--border-color);
        stroke-width: 3;
    }
    .path-animated {
        fill: none;
        stroke: var(--primary, #ea580c);
        stroke-width: 5;
        stroke-linecap: round;
        stroke-dasharray: 80, 400; /* Comet tail effect */
        animation: flow 2.5s linear infinite;
        filter: drop-shadow(0 0 15px var(--primary, #ea580c));
    }
    .path-safe { stroke: #10b981; filter: drop-shadow(0 0 15px #10b981); }
    .path-blocked { stroke: #ef4444; filter: drop-shadow(0 0 15px #ef4444); }

    @keyframes flow { 
        0% { stroke-dashoffset: 480; } 
        100% { stroke-dashoffset: 0; } 
    }
    /* Background grid */
    .bg-grid {
        position: absolute;
        inset: 0;
        background-image: 
            linear-gradient(to right, rgba(255,255,255,0.03) 1px, transparent 1px),
            linear-gradient(to bottom, rgba(255,255,255,0.03) 1px, transparent 1px);
        background-size: 40px 40px;
        mask-image: radial-gradient(circle at top center, black 20%, transparent 80%);
        -webkit-mask-image: radial-gradient(circle at top center, black 20%, transparent 80%);
        z-index: 0;
    }
    [data-theme="light"] .bg-grid {
        background-image: 
            linear-gradient(to right, rgba(0,0,0,0.04) 1px, transparent 1px),
            linear-gradient(to bottom, rgba(0,0,0,0.04) 1px, transparent 1px);
    }
</style>

<div class="arch-wrapper">
    <div class="bg-grid"></div>

    <div class="arch-header">
        <h1 class="arch-title">Architecture Flow</h1>
        <p class="arch-subtitle">Real-time data progression from client to database through our Strategy-Pattern Engine.</p>
    </div>

    <div class="flow-container" id="flow-container">
        <!-- Connecting SVG Layer -->
        <svg class="flow-svg" id="lines-svg"></svg>

        <!-- Tier 1: Client -->
        <div class="flow-row">
            <div class="node" id="node-client">
                <div class="node-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
                </div>
                <div class="node-title">JSP Frontend</div>
                <div class="node-desc">Client submits transaction. Input sanitization and CSRF validation.</div>
            </div>
        </div>

        <!-- Tier 2: Controller -->
        <div class="flow-row">
            <div class="node" id="node-controller">
                <div class="node-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                </div>
                <div class="node-title">Transaction Servlet</div>
                <div class="node-desc">Jakarta EE Servlet intercepts request. Maps data to DTOs.</div>
            </div>
        </div>

        <!-- Tier 3: Core Engine (Strategy Pattern) -->
        <div class="flow-row">
            <div class="node" id="node-engine" style="width: 350px; border-color: var(--primary); box-shadow: inset 0 0 20px rgba(234, 88, 12, 0.1);">
                <div class="node-icon" style="background: var(--primary); color: #fff;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                </div>
                <div class="node-title">Fraud Detection Engine</div>
                <div class="node-desc">Executes 7 composite heuristics using the Strategy Pattern.<br><i>(Velocity, Geolocation, Amount, etc.)</i></div>
            </div>
        </div>

        <!-- Tier 4: Output Paths -->
        <div class="flow-row" style="gap: 8rem;">
            <div class="node" id="node-blocked" style="border-color: #ef4444;">
                <div class="node-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                </div>
                <div class="node-title" style="color: #ef4444;">ACID Rollback (Blocked)</div>
                <div class="node-desc">Transaction aborted. Data isolated. Alert logged in Database.</div>
            </div>
            
            <div class="node" id="node-cleared" style="border-color: #10b981;">
                <div class="node-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                </div>
                <div class="node-title" style="color: #10b981;">Transaction Cleared</div>
                <div class="node-desc">Committed to Database. Funds transferred securely.</div>
            </div>
        </div>
        
        <!-- Tier 5: Persistence -->
        <div class="flow-row">
            <div class="node" id="node-db">
                <div class="node-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/></svg>
                </div>
                <div class="node-title">JDBC DAO & Persistence</div>
                <div class="node-desc">MySQL 8.0 Cluster (Production)<br>H2 In-Memory (Failover)</div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const svg = document.getElementById('lines-svg');
        const container = document.getElementById('flow-container');
        
        function drawLine(id1, id2, type = 'normal') {
            const el1 = document.getElementById(id1);
            const el2 = document.getElementById(id2);
            if (!el1 || !el2) return;
            
            const rect1 = el1.getBoundingClientRect();
            const rect2 = el2.getBoundingClientRect();
            const containerRect = container.getBoundingClientRect();
            
            const startX = rect1.left + (rect1.width / 2) - containerRect.left;
            const startY = rect1.bottom - containerRect.top;
            const endX = rect2.left + (rect2.width / 2) - containerRect.left;
            const endY = rect2.top - containerRect.top;
            
            // Smoother "pipe" routing that drops vertically before turning
            const verticalDrop = 60;
            const pathData = `M ${startX} ${startY} C ${startX} ${startY + verticalDrop}, ${endX} ${endY - verticalDrop}, ${endX} ${endY}`;
            
            // Base static line
            const pathBg = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            pathBg.setAttribute('d', pathData);
            pathBg.setAttribute('class', 'path-line');
            svg.appendChild(pathBg);
            
            // Animated overlay line
            const pathAnim = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            pathAnim.setAttribute('d', pathData);
            let cls = 'path-animated';
            if (type === 'safe') cls += ' path-safe';
            if (type === 'blocked') cls += ' path-blocked';
            pathAnim.setAttribute('class', cls);
            svg.appendChild(pathAnim);
        }

        function renderLines() {
            // Robustly clear SVG children
            while (svg.firstChild) {
                svg.removeChild(svg.firstChild);
            }
            
            // Draw all paths
            drawLine('node-client', 'node-controller');
            drawLine('node-controller', 'node-engine');
            drawLine('node-engine', 'node-blocked', 'blocked');
            drawLine('node-engine', 'node-cleared', 'safe');
            drawLine('node-blocked', 'node-db', 'blocked');
            drawLine('node-cleared', 'node-db', 'safe');
            
            // Force redraw trick for Safari/Chrome SVG bugs
            svg.style.display = 'none';
            svg.offsetHeight; 
            svg.style.display = 'block';
        }

        // Delay initial draw to ensure full DOM/Layout is ready
        setTimeout(renderLines, 100);
        
        // Redraw on window resize
        window.addEventListener('resize', () => {
            requestAnimationFrame(renderLines);
        });
    });
</script>

<jsp:include page="/views/common/footer.jsp" />
