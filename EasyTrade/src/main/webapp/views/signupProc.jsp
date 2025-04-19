<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.market.dto.UserDTO, com.market.dao.UserDAO" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    Connection conn = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@192.168.25.35:1521:xe",  
            "team01",  
            "team01"   
        );

        UserDTO user = new UserDTO(userId, password, name, email, phone);
        UserDAO dao = new UserDAO(conn);

        int result = dao.insertUser(user);

        if (result == 1) {
            out.println("<script>alert('회원가입 완료'); location.href='login.jsp';</script>");
        } else {
            out.println("<script>alert('회원가입 실패'); history.back();</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
