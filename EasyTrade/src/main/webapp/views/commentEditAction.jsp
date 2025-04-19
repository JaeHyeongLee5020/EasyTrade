<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    request.setCharacterEncoding("UTF-8");
    String loginId = (String) session.getAttribute("userId");
    if (loginId == null) {
        response.sendRedirect("loginForm.jsp");
        return;
    }

    int commentId = Integer.parseInt(request.getParameter("commentId"));
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    String content = request.getParameter("content");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        // 작성자 확인
        String checkSql = "SELECT USER_ID FROM COMMENTS WHERE COMMENT_ID = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, commentId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String writerId = rs.getString("USER_ID");
            if (!loginId.equals(writerId)) {
                out.println("<script>alert('본인이 작성한 댓글만 수정할 수 있습니다.'); history.back();</script>");
                return;
            }
        } else {
            out.println("<script>alert('존재하지 않는 댓글입니다.'); history.back();</script>");
            return;
        }
        rs.close();
        pstmt.close();

        // 댓글 내용 수정
        String updateSql = "UPDATE COMMENTS SET CONTENT = ?, UPDATE_AT = SYSDATE WHERE COMMENT_ID = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, content);
        pstmt.setInt(2, commentId);
        pstmt.executeUpdate();

        response.sendRedirect("productDetail.jsp?boardId=" + boardId);
    } catch (Exception e) {
        out.println("DB 오류: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
