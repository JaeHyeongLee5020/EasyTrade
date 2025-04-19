<%@ page import="com.market.dao.UserDAO, java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = request.getParameter("userId");

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@192.168.25.35:1521:xe",
            "team01", "team01"
        );
        UserDAO dao = new UserDAO(conn);
        int result = dao.deleteUser(userId);
        conn.close();

        if (result > 0) {
            session.invalidate();
            response.sendRedirect("main.jsp");  // 회원 탈퇴 성공 → 메인 페이지로 이동
        } else {
            out.println("<script>alert('회원 탈퇴 실패'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생'); history.back();</script>");
    }
%>
