<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    request.setCharacterEncoding("UTF-8");
    String loginId = (String) session.getAttribute("userId");
    if (loginId == null) {
    	%>

		<script>
   		alert('로그인이 필요합니다.');
    	location.href = 'login.jsp';
		</script>
        <%
    	/* response.sendRedirect("login.jsp"); */
        
        return;
    }

    int boardId = Integer.parseInt(request.getParameter("boardId"));
    String comment = request.getParameter("comment");

    if (comment == null || comment.trim().isEmpty()) {
        out.println("<script>alert('댓글 내용을 입력해주세요.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        String sql = "INSERT INTO COMMENTS (COMMENT_ID, BOARD_ID, USER_ID, CONTENT, CREATED_AT) " +
                     "VALUES (COMMENT_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, boardId);
        pstmt.setString(2, loginId);
        pstmt.setString(3, comment);
        pstmt.executeUpdate();
    } catch (Exception e) {
        out.println("DB 오류: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.sendRedirect("productDetail.jsp?boardId=" + boardId);
%>
