<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.HttpSession" %>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (session != null && session.getAttribute("userId") != null) {
            session.setMaxInactiveInterval(1800); // 30분
        }
        response.sendRedirect("main.jsp");
    }
%>
