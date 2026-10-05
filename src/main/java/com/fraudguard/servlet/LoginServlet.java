package com.fraudguard.servlet;

import com.fraudguard.exception.AuthenticationException;
import com.fraudguard.model.User;
import com.fraudguard.service.AuthenticationService;
import com.fraudguard.service.impl.AuthenticationServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet handling user login authentication and session creation.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private AuthenticationService authService;

    @Override
    public void init() {
        this.authService = new AuthenticationServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user.isAdmin() || user.isAnalyst()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
            return;
        }

        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String clientIp = request.getRemoteAddr();

        try {
            User authenticatedUser = authService.authenticate(username, password, clientIp);

            // Defend against session fixation: invalidate old session and create fresh
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", authenticatedUser);
            // Session timeout: 30 minutes
            session.setMaxInactiveInterval(30 * 60);

            if (authenticatedUser.isAdmin() || authenticatedUser.isAnalyst()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }

        } catch (AuthenticationException ae) {
            request.setAttribute("errorMessage", ae.getMessage());
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An internal error occurred during authentication.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}
