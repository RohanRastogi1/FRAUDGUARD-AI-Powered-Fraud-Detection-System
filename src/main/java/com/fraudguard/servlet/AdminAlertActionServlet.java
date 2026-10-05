package com.fraudguard.servlet;

import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.User;
import com.fraudguard.service.FraudAnalysisService;
import com.fraudguard.service.impl.FraudAnalysisServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet handling analyst lifecycle actions on fraud alerts (resolve, review, dismiss).
 */
@WebServlet("/admin/alert-action")
public class AdminAlertActionServlet extends HttpServlet {

    private FraudAnalysisService fraudAnalysisService;

    @Override
    public void init() {
        this.fraudAnalysisService = new FraudAnalysisServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String alertIdStr = request.getParameter("alertId");
        String statusStr = request.getParameter("status");
        String reviewNotes = request.getParameter("reviewNotes");

        if (alertIdStr != null && statusStr != null) {
            try {
                Long alertId = Long.parseLong(alertIdStr.trim());
                AlertStatus newStatus = AlertStatus.fromString(statusStr);
                String analystName = currentUser != null ? currentUser.getUsername() : "system_analyst";

                fraudAnalysisService.updateAlertStatus(alertId, newStatus, analystName, reviewNotes);
            } catch (Exception ignored) {
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/alerts?msg=status_updated");
    }
}
