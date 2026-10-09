<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    </main>
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-brand-row">
                <div class="footer-logo-badge">
                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                </div>
                <div class="footer-brand-text">
                    <strong style="color: var(--text-primary);">FraudGuard</strong>
                    <span style="color: var(--text-muted);">&mdash;</span>
                    <span>AI-Powered Fraud Detection System</span>
                    <span class="footer-sep">&bull;</span>
                    <span class="footer-built-by">Built by <button type="button" class="footer-team-btn" onclick="openTeamModal()" title="View TeamRootOps Members & Leader">TeamRootOps</button></span>
                </div>
            </div>
            <div class="footer-meta-row">
                <a href="<%= request.getContextPath() %>/architecture" class="footer-meta-link">Architecture</a>
                <span class="footer-sep">&bull;</span>
                <a href="<%= request.getContextPath() %>/docs" class="footer-meta-link">Documentation</a>
                <span class="footer-sep">&bull;</span>
                <a href="https://github.com/RohanRastogi1/FRAUDGUARD-AI-Powered-Fraud-Detection-System" target="_blank" rel="noopener noreferrer" class="footer-github-badge" title="View FraudGuard on GitHub (RohanRastogi1)">
                    <span class="footer-github-icon-box">
                        <svg class="github-logo-icon" width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
                            <path fill-rule="evenodd" clip-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.53 1.032 1.53 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"/>
                        </svg>
                    </span>
                    <span class="footer-github-text">GitHub</span>
                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" class="footer-ext-icon">
                        <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                        <polyline points="15 3 21 3 21 9"></polyline>
                        <line x1="10" y1="14" x2="21" y2="3"></line>
                    </svg>
                </a>
                <span class="footer-sep">&bull;</span>
                <span class="footer-tech-item">Jakarta EE</span>
                <span class="footer-sep">&bull;</span>
                <span class="footer-tech-item">MySQL 8.0</span>
                <span class="footer-sep">&bull;</span>
                <span class="footer-tech-item">ACID Pools</span>
                <span class="footer-sep">&bull;</span>
                <span class="footer-live-badge">
                    <span class="pulse-dot pulse-dot-green"></span>
                    Protected
                </span>
            </div>
        </div>
    </footer>

    <!-- Scroll to Top Floating Action Button -->
    <button id="scrollToTopBtn" class="scroll-to-top-btn" type="button" aria-label="Scroll to top" title="Scroll to top" onclick="scrollToTop()">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M18 15l-6-6-6 6"/>
        </svg>
    </button>

    <script>
        (function() {
            var btn = document.getElementById('scrollToTopBtn');
            if (!btn) return;

            function checkScroll() {
                var scrollY = window.pageYOffset || document.documentElement.scrollTop || 0;
                var windowHeight = window.innerHeight || 0;
                var docHeight = Math.max(
                    document.body.scrollHeight || 0,
                    document.documentElement.scrollHeight || 0,
                    document.body.offsetHeight || 0,
                    document.documentElement.offsetHeight || 0,
                    document.body.clientHeight || 0,
                    document.documentElement.clientHeight || 0
                );
                var distToBottom = docHeight - (scrollY + windowHeight);

                // Show button if page is scrollable and user has scrolled down past 250px or is near bottom
                var isScrollable = (docHeight > windowHeight + 80);
                var isNearBottom = isScrollable && (distToBottom <= 400);
                var hasScrolledDown = (scrollY > 250);

                if (isScrollable && (hasScrolledDown || isNearBottom)) {
                    btn.classList.add('visible');
                    if (isNearBottom) {
                        btn.classList.add('at-bottom');
                    } else {
                        btn.classList.remove('at-bottom');
                    }
                } else {
                    btn.classList.remove('visible', 'at-bottom');
                }
            }

            var isScrolling = false;

            window.scrollToTop = function() {
                if (isScrolling) return;

                var startY = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
                if (startY <= 0) return;

                isScrolling = true;

                // Tactile visual feedback on the button
                btn.classList.add('is-launching');
                btn.classList.remove('at-bottom');

                // Dynamic duration based on scroll distance, between 450ms and 750ms
                var duration = Math.min(750, Math.max(450, startY * 0.22));
                var startTime = null;

                // Cubic ease-in-out easing function for silky smooth gliding
                function easeInOutCubic(t) {
                    return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
                }

                function animationStep(currentTime) {
                    if (!startTime) startTime = currentTime;
                    var elapsed = currentTime - startTime;
                    var progress = Math.min(elapsed / duration, 1);
                    var eased = easeInOutCubic(progress);

                    var newY = Math.round(startY * (1 - eased));
                    window.scrollTo(0, newY);

                    if (progress < 1) {
                        window.requestAnimationFrame(animationStep);
                    } else {
                        window.scrollTo(0, 0);
                        isScrolling = false;
                        setTimeout(function() {
                            btn.classList.remove('is-launching');
                            checkScroll();
                        }, 120);
                    }
                }

                window.requestAnimationFrame(animationStep);
            };

            window.addEventListener('scroll', checkScroll, { passive: true });
            window.addEventListener('resize', checkScroll, { passive: true });
            document.addEventListener('DOMContentLoaded', checkScroll);
            setTimeout(checkScroll, 400);
        })();
    </script>
</body>
</html>

