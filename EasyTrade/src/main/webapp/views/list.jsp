<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
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
    <h2 class="mb-4">전체 거래 게시글</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>
        </thead>
        <tbody>
        <%
            int currentPage = 1;
            int pageLimit = 10;
            int blockLimit = 5;
            if (request.getParameter("page") != null) {
                currentPage = Integer.parseInt(request.getParameter("page"));
            }
            int startRow = (currentPage - 1) * pageLimit + 1;
            int endRow = currentPage * pageLimit;

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            int totalCount = 0;

            try {
                Class.forName("oracle.jdbc.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

                // 전체 게시글 수
                pstmt = conn.prepareStatement("SELECT COUNT(*) FROM BOARD");
                rs = pstmt.executeQuery();
                if (rs.next()) totalCount = rs.getInt(1);
                rs.close();
                pstmt.close();

                String sql =
                    "SELECT * FROM (" +
                    "SELECT ROWNUM rnum, BOARD_ID, TITLE, USER_ID, CREATED_AT, VIEWS FROM (" +
                    "SELECT * FROM BOARD ORDER BY CREATED_AT DESC)" +
                    ") WHERE rnum BETWEEN ? AND ?";

                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, startRow);
                pstmt.setInt(2, endRow);
                rs = pstmt.executeQuery();

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                while (rs.next()) {
        %>
        <tr>
            <td><a href="productDetail.jsp?boardId=<%= rs.getInt("BOARD_ID") %>"><%= rs.getString("TITLE") %></a></td>
            <td><%= rs.getString("USER_ID") %></td>
            <td><%= sdf.format(rs.getDate("CREATED_AT")) %></td>
            <td><%= rs.getInt("VIEWS") %></td>
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

            int maxPage = (int)Math.ceil((double)totalCount / pageLimit);
            int startPage = ((currentPage - 1) / blockLimit) * blockLimit + 1;
            int endPage = startPage + blockLimit - 1;
            if (endPage > maxPage) endPage = maxPage;
        %>
        </tbody>
    </table>

    <!-- 페이징 -->
    <nav>
      <ul class="pagination justify-content-center">
        <li class="page-item <%= (startPage == 1 ? "disabled" : "") %>">
          <a class="page-link" href="list.jsp?page=<%= startPage - 1 %>">이전</a>
        </li>

        <%
          for (int i = startPage; i <= endPage; i++) {
        %>
        <li class="page-item <%= (i == currentPage ? "active" : "") %>">
          <a class="page-link" href="list.jsp?page=<%= i %>"><%= i %></a>
        </li>
        <%
          }
        %>

        <li class="page-item <%= (endPage >= maxPage ? "disabled" : "") %>">
          <a class="page-link" href="list.jsp?page=<%= endPage + 1 %>">다음</a>
        </li>
      </ul>
    </nav>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>
