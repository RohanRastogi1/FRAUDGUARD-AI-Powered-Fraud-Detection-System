package com.fraudguard.servlet;

import com.fraudguard.model.AlertStatus;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.service.FraudAnalysisService;
import com.fraudguard.service.impl.FraudAnalysisServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet for administrative triage and management of fraud alerts.
 */
@WebServlet("/admin/alerts")
public class AdminAlertsServlet extends HttpServlet {

    private FraudAnalysisService fraudAnalysisService;

    @Override
    public void init() {
        this.fraudAnalysisService = new FraudAnalysisServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusParam = request.getParameter("status");
        List<FraudAlert> alerts;

        if (statusParam != null && !statusParam.isEmpty() && !"ALL".equalsIgnoreCase(statusParam)) {
            alerts = fraudAnalysisService.getAlertsByStatus(AlertStatus.fromString(statusParam), 100, 0);
        } else {
            alerts = fraudAnalysisService.getAllAlerts(100, 0);
        }

        request.setAttribute("alerts", alerts);
        request.setAttribute("selectedStatus", statusParam != null ? statusParam : "ALL");

        request.getRequestDispatcher("/views/admin_alerts.jsp").forward(request, response);
    }
}
