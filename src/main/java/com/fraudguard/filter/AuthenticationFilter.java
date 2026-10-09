package com.fraudguard.filter;

import com.fraudguard.model.Role;
import com.fraudguard.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Security filter enforcing authentication and role-based authorization across routes.
 *
 * Demonstrates:
 * - Jakarta Servlet Filter API (FilterChain, FilterConfig)
 * - Session Management (HttpSession validation)
 * - Server-Side Role-Based Access Control (RBAC)
 * - HTTP Security Headers injection
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    private final Set<String> publicPrefixes = new HashSet<>(Arrays.asList(
            "/css",
            "/js",
            "/images",
            "/hello",
            "/login",
            "/logout",
            "/docs",
            "/architecture"
    ));

    @Override
    public void init(FilterConfig filterConfig) {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Apply baseline security headers
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-XSS-Protection", "1; mode=block");

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        String path = uri.substring(contextPath.length());

        // Permit root or public asset paths
        if (path.isEmpty() || path.equals("/") || isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;

        // Check if user is authenticated
        if (currentUser == null) {
            response.sendRedirect(contextPath + "/login?error=auth_required");
            return;
        }

        // Check Admin / Analyst authorization for /admin/* paths
        if (path.startsWith("/admin")) {
            if (!currentUser.isAdmin() && !currentUser.isAnalyst()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Administrative or Analyst role required.");
                return;
            }

            // Stricter check for user administration operations (Admin only)
            if (path.startsWith("/admin/user-action") && !currentUser.isAdmin()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: System Administrator role required for account management.");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        if (path.equals("/login") || path.equals("/logout") || path.equals("/hello")) {
            return true;
        }
        for (String prefix : publicPrefixes) {
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
