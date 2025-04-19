<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>검색 결과</title>
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

<div class="container my-5 d-flex">
    <!-- 메인 검색 결과 영역 -->
    <div class="flex-grow-1 me-4">
        <h2 class="mb-4">검색 결과</h2>
        <div class="list-group">
            <%
                String keyword = request.getParameter("keyword");
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("oracle.jdbc.OracleDriver");
                    conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

                    String sql = "SELECT BOARD_ID, TITLE, USER_ID, VIEWS, LIKES, CREATED_AT FROM BOARD WHERE TITLE LIKE ? ORDER BY CREATED_AT DESC";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, "%" + keyword + "%");
                    rs = pstmt.executeQuery();

                    boolean hasResult = false;
                    while (rs.next()) {
                        hasResult = true;
                        int boardId = rs.getInt("BOARD_ID");
                        String title = rs.getString("TITLE");
                        String userId = rs.getString("USER_ID");
                        int views = rs.getInt("VIEWS");
                        int likes = rs.getInt("LIKES");
                        Date createdAt = rs.getDate("CREATED_AT");
            %>
            <a href="productDetail.jsp?boardId=<%= boardId %>" class="list-group-item list-group-item-action">
                <div class="d-flex justify-content-between">
                    <strong><%= title %></strong>
                    <small><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(createdAt) %></small>
                </div>
                <div class="d-flex justify-content-between">
                    <span>작성자: <%= userId %></span>
                    <span>조회수: <%= views %> | 좋아요: <%= likes %></span>
                </div>
            </a>
            <%
                    }
                    if (!hasResult) {
            %>
            <div class="alert alert-warning">검색 결과가 없습니다.</div>
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
        </div>
    </div>

    <!-- 우측 최근 본 상품 -->
    <div style="width: 220px;">
        <jsp:include page="recent.jsp" />
    </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
