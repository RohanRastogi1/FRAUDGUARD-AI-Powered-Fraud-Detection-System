<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    com.fraudguard.model.User currentUser = (com.fraudguard.model.User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
    } else if (currentUser.isAdmin() || currentUser.isAnalyst()) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    } else {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
%>
