<%@ page import="java.sql.*" %>
<%
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    boolean liked = Boolean.parseBoolean(request.getParameter("liked"));

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        String sql = liked ?
            "UPDATE BOARD SET LIKES = LIKES - 1 WHERE BOARD_ID = ?" :
            "UPDATE BOARD SET LIKES = LIKES + 1 WHERE BOARD_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, boardId);
        pstmt.executeUpdate();
        pstmt.close();

        Cookie newCookie = new Cookie("liked_" + boardId, String.valueOf(!liked));
        newCookie.setPath("/");
        newCookie.setMaxAge(60 * 60 * 24);
        response.addCookie(newCookie);

        response.sendRedirect("productDetail.jsp?boardId=" + boardId + "&fromLike=true");

    } catch (Exception e) {
        out.println("오류 발생: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
