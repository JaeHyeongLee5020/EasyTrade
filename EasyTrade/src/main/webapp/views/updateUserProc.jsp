<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.market.dao.UserDAO, com.market.dto.UserDTO, java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@192.168.25.35:1521:xe",
            "team01", "team01"
        );
        UserDAO dao = new UserDAO(conn);
        UserDTO user = new UserDTO(userId, password, name, email, phone);
        int result = dao.updateUser(user);
        conn.close();

        if (result == 1) {
            out.println("<script>alert('정보가 수정되었습니다.'); location.href='main.jsp';</script>");
        } else {
            out.println("<script>alert('수정 실패'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생'); history.back();</script>");
    }
%>
