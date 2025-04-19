<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>EasyTrade - 상품 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        #recent-view-box {
            position: sticky;
            top: 100px;
            height: fit-content;
            width: 220px;
        }
        .carousel-item > .row {
            display: flex;
        }
    </style>
</head>
<body>
<div class="container my-5 d-flex">
    <div class="flex-grow-1 me-4">
        <h3 class="mb-4">인기 상품 목록</h3>
        <div id="popularCarousel" class="carousel slide mb-5" data-bs-ride="carousel" data-bs-interval="5000">
            <div class="carousel-inner">
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("oracle.jdbc.OracleDriver");
                        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");
                        String sql = "SELECT BOARD_ID, TITLE, VIEWS, LIKES, IMAGE_PATH, PRICE FROM (SELECT BOARD_ID, TITLE, VIEWS, LIKES, IMAGE_PATH, PRICE FROM BOARD ORDER BY VIEWS DESC) WHERE ROWNUM <= 6";
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();

                        int count = 0;
                %>
                <div class="carousel-item active">
                    <div class="row">
                <%
                        while (rs.next()) {
                            String imagePath = rs.getString("IMAGE_PATH");
                            if (count > 0 && count % 3 == 0) {
                %>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="row">
                <%
                            }
                %>
                        <div class="col-md-4">
                            <div class="card h-100">
                                <% if (imagePath != null && !imagePath.isEmpty()) { %>
                                    <img src="<%= request.getContextPath() + "/" + imagePath %>" class="card-img-top" style="max-height: 250px; object-fit: cover;">
                                <% } %>
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <a href="productDetail.jsp?boardId=<%= rs.getInt("BOARD_ID") %>" class="text-decoration-none text-dark">
                                            <%= rs.getString("TITLE") %>
                                        </a>
                                    </h5>
                                    <p class="card-text">가격: <%= rs.getInt("PRICE") %>원</p>
                                    <p class="card-text">조회수: <%= rs.getInt("VIEWS") %> | 좋아요: <%= rs.getInt("LIKES") %></p>
                                </div>
                            </div>
                        </div>
                <%
                            count++;
                        }

                        rs.close();
                        pstmt.close();
                %>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#popularCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#popularCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>

        <h3 class="mt-5 mb-4">최근 추가된 상품</h3>
        <div class="row row-cols-1 row-cols-md-3 g-4">
        <%
            sql = "SELECT BOARD_ID, TITLE, CREATED_AT, IMAGE_PATH, PRICE FROM (SELECT BOARD_ID, TITLE, CREATED_AT, IMAGE_PATH, PRICE FROM BOARD ORDER BY CREATED_AT DESC) WHERE ROWNUM <= 3";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            while (rs.next()) {
                String imagePath = rs.getString("IMAGE_PATH");
        %>
            <div class="col">
                <div class="card h-100">
                    <% if (imagePath != null && !imagePath.isEmpty()) { %>
                        <img src="<%= request.getContextPath() + "/" + imagePath %>" class="card-img-top" style="max-height: 300px; object-fit: cover;">
                    <% } %>
                    <div class="card-body">
                        <h5 class="card-title">
                            <a href="productDetail.jsp?boardId=<%= rs.getInt("BOARD_ID") %>" class="text-decoration-none text-dark">
                                <%= rs.getString("TITLE") %>
                            </a>
                        </h5>
                        <p class="card-text">가격: <%= rs.getInt("PRICE") %>원</p>
                        <p class="card-text">등록일: <%= sdf.format(rs.getDate("CREATED_AT")) %></p>
                    </div>
                </div>
            </div>
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

    <jsp:include page="recent.jsp" />
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
