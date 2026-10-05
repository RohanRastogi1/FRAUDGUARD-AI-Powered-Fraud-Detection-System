package com.fraudguard.servlet;

import com.fraudguard.model.FraudAlert;
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
import java.util.List;

/**
 * Servlet presenting customer security and fraud notifications.
 */
@WebServlet("/alerts")
public class FraudAlertServlet extends HttpServlet {

    private FraudAnalysisService fraudAnalysisService;

    @Override
    public void init() {
        this.fraudAnalysisService = new FraudAnalysisServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        List<FraudAlert> alerts = fraudAnalysisService.getAlertsByUserId(currentUser.getId());
        request.setAttribute("alerts", alerts);

        request.getRequestDispatcher("/views/user_alerts.jsp").forward(request, response);
    }
}
