<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");

    String content = request.getParameter("content");
    String jobId = request.getParameter("jobId");
    String userId = (String) session.getAttribute("userId");
    
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        String sql = "INSERT INTO JOB_COMMENTS (COMMENT_ID, JOB_ID, USER_ID, CONTENT, CREATED_AT) " +
                     "VALUES (JOB_COMMENTS_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(jobId));
        pstmt.setString(2, userId);
        pstmt.setString(3, content);
        pstmt.executeUpdate();

        response.sendRedirect("jobView.jsp?jobId=" + jobId);
    } catch (Exception e) {
        out.println("댓글 등록 실패: " + e.getMessage());
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>