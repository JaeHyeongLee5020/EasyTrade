<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Arrays" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        body::-webkit-scrollbar {
            display: none;
        }
        .container {
            flex: 1;
        }
        .like-btn {
            margin-left: 10px;
        }
    </style>
</head>
<body>

<jsp:include page="top.jsp" />
<jsp:include page="top2.jsp" />

<div class="container my-5">
<%
    int boardId = Integer.parseInt(request.getParameter("boardId"));
    boolean fromLike = "true".equals(request.getParameter("fromLike"));

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean userLiked = false;
    int likes = 0;

    Cookie[] allCookies = request.getCookies();
    if (allCookies != null) {
        for (Cookie c : allCookies) {
            if (c.getName().equals("liked_" + boardId)) {
                userLiked = Boolean.parseBoolean(c.getValue());
                break;
            }
        }
    }

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        if (!fromLike) {
            pstmt = conn.prepareStatement("UPDATE BOARD SET VIEWS = VIEWS + 1 WHERE BOARD_ID = ?");
            pstmt.setInt(1, boardId);
            pstmt.executeUpdate();
            pstmt.close();
        }

        String sql = "SELECT B.TITLE, B.CONTENT, B.PRICE, B.USER_ID, B.CREATED_AT, B.LIKES, B.VIEWS, B.IMAGE_PATH, U.PHONE " +
                     "FROM BOARD B JOIN USERS U ON B.USER_ID = U.USER_ID WHERE B.BOARD_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, boardId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String title = rs.getString("TITLE");
            String content = rs.getString("CONTENT");
            int price = rs.getInt("PRICE");
            String userId = rs.getString("USER_ID");
            Date createdAt = rs.getDate("CREATED_AT");
            likes = rs.getInt("LIKES");
            int views = rs.getInt("VIEWS");
            String phone = rs.getString("PHONE");
            String imagePath = rs.getString("IMAGE_PATH");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
    <h2 class="mb-3"><%= title %></h2>
    <div class="mb-3 text-muted">
        작성자: <strong><%= userId %></strong> |
        등록일: <%= sdf.format(createdAt) %> |
        조회수: <%= views %> |
        좋아요: <%= likes %> |
        연락처: <%= phone %>
    </div>
    <h5 class="text-danger mb-4">가격: <%= price %>원</h5>

    <div class="row">
        <% if (imagePath != null && !imagePath.isEmpty()) { %>
        <div class="col-md-6 text-center mb-4">
            <img src="<%= request.getContextPath() + "/" + imagePath %>" class="img-fluid rounded" alt="상품 이미지" style="max-width: 100%;">
        </div>
        <% } else { %>
        <div class="col-md-6 text-center mb-4">
            <div class="text-muted">이미지가 없습니다.</div>
        </div>
        <% } %>

        <div class="col-md-6">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <h4 class="mb-0">상품 설명</h4>
                <form method="post" action="like.jsp" class="mb-0">
                    <input type="hidden" name="boardId" value="<%= boardId %>">
                    <input type="hidden" name="liked" value="<%= userLiked %>">
                    <button type="submit" class="btn <%= userLiked ? "btn-primary" : "btn-outline-primary" %> btn-sm like-btn">좋아요</button>
                </form>
            </div>
            <div class="border p-3" style="min-height: 200px;">
                <%= content.replaceAll("\n", "<br>") %>
            </div>
        </div>
    </div>
<%
        } else {
%>
    <p class="text-danger">존재하지 않는 게시글입니다.</p>
<%
        }
    } catch (Exception e) {
        out.println("<p class='text-danger'>DB 오류: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
</div>

<jsp:include page="comment.jsp">
    <jsp:param name="boardId" value="<%= boardId %>" />
</jsp:include>

<jsp:include page="footer.jsp" />
</body>
</html>

<%-- 최근 본 상품 쿠키 저장 --%>
<%
    String recent = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().equals("recentView")) {
                recent = java.net.URLDecoder.decode(c.getValue(), "UTF-8");
                break;
            }
        }
    }

    String current = String.valueOf(boardId);
    List<String> recentList = new ArrayList<>(Arrays.asList(recent.split(",")));
    recentList.remove(current);
    recentList.add(0, current);

    if (recentList.size() > 5) {
        recentList = recentList.subList(0, 5);
    }

    String newRecent = String.join(",", recentList);
    String encodedRecent = java.net.URLEncoder.encode(newRecent, "UTF-8");

    Cookie recentCookie = new Cookie("recentView", encodedRecent);
    recentCookie.setPath("/");
    recentCookie.setMaxAge(60 * 60 * 24);
    response.addCookie(recentCookie);
%>
