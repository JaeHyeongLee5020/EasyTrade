<%@ page import="java.sql.*" %>
<%
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");
        String sql = "DELETE FROM BOARD WHERE BOARD_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, boardId);
        pstmt.executeUpdate();
    } catch (Exception e) {
        out.println("DB 오류: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
    response.sendRedirect("mySell.jsp");
%>