<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>

<%
    request.setCharacterEncoding("UTF-8");

    String loginId = (String) session.getAttribute("userId");
    if (loginId == null) {
        response.sendRedirect("loginForm.jsp");
        return;
    }

    int boardId = Integer.parseInt(request.getParameter("boardId"));
    int commentId = Integer.parseInt(request.getParameter("commentId"));

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        // 작성자 확인
        pstmt = conn.prepareStatement("SELECT USER_ID FROM COMMENTS WHERE COMMENT_ID = ?");
        pstmt.setInt(1, commentId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String authorId = rs.getString("USER_ID");

            if (!loginId.equals(authorId)) {
                out.println("<script>alert('본인이 작성한 댓글만 삭제할 수 있습니다.'); history.back();</script>");
                return;
            }

            rs.close();
            pstmt.close();

            // 댓글 삭제
            pstmt = conn.prepareStatement("DELETE FROM COMMENTS WHERE COMMENT_ID = ?");
            pstmt.setInt(1, commentId);
            pstmt.executeUpdate();

            response.sendRedirect("productDetail.jsp?boardId=" + boardId);
        } else {
            out.println("<script>alert('해당 댓글이 존재하지 않습니다.'); history.back();</script>");
        }
    } catch (Exception e) {
        out.println("<p>DB 오류: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
