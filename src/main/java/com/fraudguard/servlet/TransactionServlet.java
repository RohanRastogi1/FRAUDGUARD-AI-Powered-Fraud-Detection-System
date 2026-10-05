package com.fraudguard.servlet;

import com.fraudguard.exception.InvalidTransactionException;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.TransactionType;
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
import java.math.BigDecimal;

/**
 * Servlet handling submission and real-time fraud scoring of new financial transactions.
 */
@WebServlet("/transaction/new")
public class TransactionServlet extends HttpServlet {

    private TransactionService transactionService;

    @Override
    public void init() {
        this.transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/transaction_submit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String amountStr = request.getParameter("amount");
        String recipientAccount = request.getParameter("recipientAccount");
        String recipientName = request.getParameter("recipientName");
        String typeStr = request.getParameter("type");
        String location = request.getParameter("location");
        String deviceFingerprint = request.getParameter("deviceFingerprint");

        // Derive IP
        String clientIp = request.getHeader("X-Forwarded-For");
        if (clientIp == null || clientIp.isEmpty() || "unknown".equalsIgnoreCase(clientIp)) {
            clientIp = request.getRemoteAddr();
        }

        try {
            if (amountStr == null || amountStr.trim().isEmpty()) {
                throw new InvalidTransactionException("Transaction amount is required.");
            }

            BigDecimal amount;
            try {
                amount = new BigDecimal(amountStr.trim());
            } catch (NumberFormatException nfe) {
                throw new InvalidTransactionException("Invalid amount format. Please enter a valid numerical value.");
            }

            TransactionType type = TransactionType.fromString(typeStr);
            if (location == null || location.trim().isEmpty()) {
                location = "Online / Mobile App";
            }
            if (deviceFingerprint == null || deviceFingerprint.trim().isEmpty()) {
                deviceFingerprint = "web-client-" + request.getHeader("User-Agent").hashCode();
            }

            Transaction tx = new Transaction(
                    currentUser.getId(),
                    amount,
                    recipientAccount != null ? recipientAccount.trim() : "",
                    recipientName != null ? recipientName.trim() : "",
                    type,
                    location.trim(),
                    clientIp,
                    deviceFingerprint.trim()
            );

            // Execute transaction pipeline
            TransactionService.TransactionProcessResult result = transactionService.processTransaction(tx, currentUser);

            request.setAttribute("result", result);
            request.setAttribute("transaction", result.getTransaction());
            request.setAttribute("riskScore", result.getRiskScore());
            request.setAttribute("alert", result.getFraudAlert());

            request.getRequestDispatcher("/views/transaction_result.jsp").forward(request, response);

        } catch (InvalidTransactionException ite) {
            request.setAttribute("errorMessage", ite.getMessage());
            request.setAttribute("amount", amountStr);
            request.setAttribute("recipientAccount", recipientAccount);
            request.setAttribute("recipientName", recipientName);
            request.setAttribute("type", typeStr);
            request.setAttribute("location", location);
            request.getRequestDispatcher("/views/transaction_submit.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Processing failed: " + e.getMessage());
            request.getRequestDispatcher("/views/transaction_submit.jsp").forward(request, response);
        }
    }
}
