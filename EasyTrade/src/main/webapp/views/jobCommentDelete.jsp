<%@ page import="java.sql.*" %>
<%
    String commentId = request.getParameter("commentId");
    String jobId = request.getParameter("jobId");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        pstmt = conn.prepareStatement("DELETE FROM JOB_COMMENTS WHERE COMMENT_ID = ?");
        pstmt.setInt(1, Integer.parseInt(commentId));
        pstmt.executeUpdate();

    } catch (Exception e) {
        out.println("삭제 오류: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.sendRedirect("jobView.jsp?jobId=" + jobId);
%>
