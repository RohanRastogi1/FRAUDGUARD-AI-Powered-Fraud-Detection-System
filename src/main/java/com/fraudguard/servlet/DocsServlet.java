package com.fraudguard.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet handling documentation, integration guide, and system manuals.
 * Accessible to both authenticated users and public evaluators.
 */
@WebServlet("/docs")
public class DocsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "System Documentation & Manual");
        request.getRequestDispatcher("/views/docs.jsp").forward(request, response);
    }
}
