package com.fraudguard.servlet;

import com.fraudguard.dao.UserDAO;
import com.fraudguard.dao.impl.UserDAOImpl;
import com.fraudguard.model.FraudAlert;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;
import com.fraudguard.service.FraudAnalysisService;
import com.fraudguard.service.TransactionService;
import com.fraudguard.service.impl.FraudAnalysisServiceImpl;
import com.fraudguard.service.impl.TransactionServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * Servlet presenting customer dashboard with live balance, recent transactions,
 * and security alerts.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private UserDAO userDAO;
    private TransactionService transactionService;
    private FraudAnalysisService fraudAnalysisService;

    @Override
    public void init() {
        this.userDAO = new UserDAOImpl();
        this.transactionService = new TransactionServiceImpl();
        this.fraudAnalysisService = new FraudAnalysisServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        // Fetch latest state from database
        Optional<User> freshUserOpt = userDAO.findById(currentUser.getId());
        User user = freshUserOpt.orElse(currentUser);
        session.setAttribute("currentUser", user);

        // Fetch customer data
        List<Transaction> recentTransactions = transactionService.getUserTransactions(user.getId(), 5, 0);
        List<FraudAlert> userAlerts = fraudAnalysisService.getAlertsByUserId(user.getId());

        request.setAttribute("user", user);
        request.setAttribute("recentTransactions", recentTransactions);
        request.setAttribute("userAlerts", userAlerts);

        request.getRequestDispatcher("/views/user_dashboard.jsp").forward(request, response);
    }
}
