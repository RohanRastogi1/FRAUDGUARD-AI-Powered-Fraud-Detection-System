package com.fraudguard.servlet;

import com.fraudguard.model.User;
import com.fraudguard.model.UserStatus;
import com.fraudguard.service.AdminService;
import com.fraudguard.service.impl.AdminServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet handling administrative modifications to user account status (suspend, block, activate).
 */
@WebServlet("/admin/user-action")
public class AdminUserActionServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() {
        this.adminService = new AdminServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String userIdStr = request.getParameter("userId");
        String statusStr = request.getParameter("status");

        if (userIdStr != null && statusStr != null) {
            try {
                Long userId = Long.parseLong(userIdStr.trim());
                UserStatus status = UserStatus.fromString(statusStr);
                String adminUsername = currentUser != null ? currentUser.getUsername() : "system_admin";

                adminService.updateUserStatus(userId, status, adminUsername);
            } catch (Exception ignored) {
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=user_status_updated");
    }
}
