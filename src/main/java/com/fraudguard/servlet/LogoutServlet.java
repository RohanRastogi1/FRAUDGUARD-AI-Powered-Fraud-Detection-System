package com.fraudguard.servlet;

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
 * Servlet handling user logout, session invalidation, and audit logging.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private AuthenticationService authService;

    @Override
    public void init() {
        this.authService = new AuthenticationServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user != null) {
                authService.logout(user, request.getRemoteAddr());
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login?msg=logged_out");
    }
}
