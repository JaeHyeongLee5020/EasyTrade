<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String loginId = (String) session.getAttribute("userId");
    if (loginId == null || loginId.equals("")) {
        response.sendRedirect("loginForm.jsp"); // 로그인 페이지로 리다이렉트
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 판매 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

	<style>
		html, body {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        
        .container {
            flex: 1; /* 남은 공간을 채우도록 설정 */
        }
	</style>
</head>
<body>

    <jsp:include page="top.jsp" />
    <jsp:include page="top2.jsp" />
<div class="container mt-5">
    <h2>내가 올린 게시글</h2>
    <table class="table table-bordered">
        <thead>
            <tr><th>제목</th><th>작성일</th><th>조회수</th><th>수정</th><th>삭제</th></tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                Class.forName("oracle.jdbc.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");
                String sql = "SELECT BOARD_ID, TITLE, CREATED_AT, VIEWS FROM BOARD WHERE USER_ID = ? ORDER BY CREATED_AT DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, loginId);
                rs = pstmt.executeQuery();
                while (rs.next()) {
        %>
        <tr>
            <td><a href="productDetail.jsp?boardId=<%= rs.getInt("BOARD_ID") %>"><%= rs.getString("TITLE") %></a></td>
            <td><%= rs.getDate("CREATED_AT") %></td>
            <td><%= rs.getInt("VIEWS") %></td>
            <td><a href="MySellEdit.jsp?boardId=<%= rs.getInt("BOARD_ID") %>" class="btn btn-warning btn-sm">수정</a></td>
            <td><a href="MySellDelete.jsp?boardId=<%= rs.getInt("BOARD_ID") %>" class="btn btn-danger btn-sm">삭제</a></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("DB 오류: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
        </tbody>
    </table>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>