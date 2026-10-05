package com.fraudguard.servlet;

import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;
import com.fraudguard.service.TransactionService;
import com.fraudguard.service.impl.TransactionServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet providing user transaction history listing.
 */
@WebServlet("/transactions")
public class TransactionHistoryServlet extends HttpServlet {

    private TransactionService transactionService;

    @Override
    public void init() {
        this.transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        List<Transaction> transactions = transactionService.getUserTransactions(currentUser.getId(), 50, 0);
        request.setAttribute("transactions", transactions);

        request.getRequestDispatcher("/views/transaction_history.jsp").forward(request, response);
    }
}
