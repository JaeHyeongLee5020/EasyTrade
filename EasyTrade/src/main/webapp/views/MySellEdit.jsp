<%@ page import="java.sql.*, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>

<%
    String loginId = (String) session.getAttribute("userId");
    if (loginId == null || loginId.equals("")) {
        response.sendRedirect("loginForm.jsp");
        return;
    }

    int boardId = 0;
    try {
        boardId = Integer.parseInt(request.getParameter("boardId"));
    } catch (Exception e) {
        out.println("유효하지 않은 게시글 번호입니다.");
        return;
    }

    String title = "", content = "", imagePath = "";
    int price = 0;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");
        String sql = "SELECT TITLE, CONTENT, PRICE, IMAGE_PATH FROM BOARD WHERE BOARD_ID = ? AND USER_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, boardId);
        pstmt.setString(2, loginId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            title = rs.getString("TITLE");
            content = rs.getString("CONTENT");
            price = rs.getInt("PRICE");
            imagePath = rs.getString("IMAGE_PATH");
        } else {
            out.println("잘못된 접근입니다.");
            return;
        }
    } catch (Exception e) {
        out.println("DB 오류: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="top.jsp" />
<jsp:include page="top2.jsp" />

<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">게시글 수정</div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/EditServlet" method="post" enctype="multipart/form-data">

                <input type="hidden" name="boardId" value="<%= boardId %>">

                <div class="mb-3">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" class="form-control" id="title" name="title" value="<%= title.replaceAll("\"", "&quot;") %>" required>
                </div>

                <div class="mb-3">
                    <label for="price" class="form-label">가격 (원)</label>
                    <input type="number" class="form-control" id="price" name="price" value="<%= price %>" required>
                </div>

                <div class="mb-3">
                    <label for="content" class="form-label">내용</label>
                    <textarea class="form-control" id="content" name="content" rows="8" required><%= content %></textarea>
                </div>

                <div class="mb-3">
                    <label for="image" class="form-label">이미지 업로드</label>
                    <% if (imagePath != null && !imagePath.isEmpty()) { %>
                        <div class="mb-2">
                            <img src="<%= request.getContextPath() + "/" + imagePath %>" alt="현재 이미지" style="max-width: 200px;">
                        </div>
                    <% } %>
                    <input type="file" class="form-control" id="image" name="image" accept="image/*">
                </div>

                <button type="submit" class="btn btn-success">수정</button>
                <a href="<%= request.getContextPath() %>/views/mySell.jsp" class="btn btn-secondary">취소</a>
            </form>
        </div>
    </div>
</div>
</body>
</html>
