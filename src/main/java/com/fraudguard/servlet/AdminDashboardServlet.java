package com.fraudguard.servlet;

import com.fraudguard.model.User;
import com.fraudguard.service.AdminService;
import com.fraudguard.service.impl.AdminServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet powering the executive and analyst monitoring dashboard.
 */
@WebServlet(urlPatterns = {"/admin", "/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() {
        this.adminService = new AdminServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminService.DashboardStatistics stats = adminService.getDashboardStatistics();
        List<User> users = adminService.getAllUsers(50, 0);

        request.setAttribute("stats", stats);
        request.setAttribute("users", users);

        request.getRequestDispatcher("/views/admin_dashboard.jsp").forward(request, response);
    }
}
