package com.fraudguard.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet presenting system architecture, data pipeline, and technical topology.
 * Accessible to both authenticated users and public evaluators.
 */
@WebServlet("/architecture")
public class ArchitectureServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Pipeline Architecture & Engineering");
        request.getRequestDispatcher("/views/architecture.jsp").forward(request, response);
    }
}
