package com.fraudguard.servlet;

import com.fraudguard.model.RiskLevel;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionStatus;
import com.fraudguard.service.TransactionService;
import com.fraudguard.service.impl.TransactionServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet for administrative monitoring and filtering of global transactions.
 */
@WebServlet("/admin/transactions")
public class AdminTransactionsServlet extends HttpServlet {

    private TransactionService transactionService;

    @Override
    public void init() {
        this.transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("status");
        String riskFilter = request.getParameter("riskLevel");

        List<Transaction> transactions;

        if (statusFilter != null && !statusFilter.isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            transactions = transactionService.getTransactionsByStatus(TransactionStatus.fromString(statusFilter), 100, 0);
        } else if (riskFilter != null && !riskFilter.isEmpty() && !"ALL".equalsIgnoreCase(riskFilter)) {
            transactions = transactionService.getTransactionsByRiskLevel(RiskLevel.fromString(riskFilter), 100, 0);
        } else {
            transactions = transactionService.getAllTransactions(100, 0);
        }

        request.setAttribute("transactions", transactions);
        request.setAttribute("selectedStatus", statusFilter != null ? statusFilter : "ALL");
        request.setAttribute("selectedRisk", riskFilter != null ? riskFilter : "ALL");

        request.getRequestDispatcher("/views/admin_transactions.jsp").forward(request, response);
    }
}
