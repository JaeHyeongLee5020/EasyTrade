<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String commentId = request.getParameter("commentId");
    String jobId = request.getParameter("jobId");
    String content = request.getParameter("content");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        pstmt = conn.prepareStatement("UPDATE JOB_COMMENTS SET CONTENT = ?, CREATED_AT = SYSDATE WHERE COMMENT_ID = ?");
        pstmt.setString(1, content);
        pstmt.setInt(2, Integer.parseInt(commentId));
        pstmt.executeUpdate();

    } catch (Exception e) {
        out.println("수정 오류: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.sendRedirect("jobView.jsp?jobId=" + jobId);
%>
