<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" session="true" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    List<String> hotKeywords = new ArrayList<>();

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.trim().isEmpty()) {
            pstmt = conn.prepareStatement(
                "MERGE INTO search_keyword s USING (SELECT ? AS keyword FROM dual) d " +
                "ON (s.keyword = d.keyword) " +
                "WHEN MATCHED THEN UPDATE SET s.count = s.count + 1 " +
                "WHEN NOT MATCHED THEN INSERT (keyword, count) VALUES (?, 1)"
            );
            pstmt.setString(1, keyword.trim());
            pstmt.setString(2, keyword.trim());
            pstmt.executeUpdate();
            pstmt.close();
        }

        pstmt = conn.prepareStatement(
            "SELECT keyword FROM search_keyword ORDER BY count DESC FETCH FIRST 15 ROWS ONLY"
        );
        rs = pstmt.executeQuery();
        while (rs.next()) {
            hotKeywords.add(rs.getString("keyword"));
        }

    } catch (Exception e) {
        out.println("DB 오류: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<script>
  const isLoggedIn = <%= session.getAttribute("userId") != null %>;

  function goPage(url) {
    if (!isLoggedIn) {
      alert("로그인이 필요합니다.");
      location.href = 'login.jsp';
    } else {
      location.href = url;
    }
  }
</script>

<style>
  .bg-white.py-3 {
    border-bottom: 3px solid #007bff;
    font-family: 'DoHyeon';
  }

  @font-face {
	  font-family: 'DoHyeon';
	  src: url('<%= request.getContextPath() %>/fonts/DoHyeon-Regular.ttf') format('truetype');
  }
  
</style>

<!-- 상단 검색 영역 -->
<div class="bg-white py-3">
  <div class="container-fluid d-flex justify-content-center align-items-center gap-5 flex-wrap">
    <form action="searchResult.jsp" method="get" class="input-group" style="max-width: 500px;">
	  <input type="text" name="keyword" class="form-control" placeholder="어떤 상품을 찾으시나요?" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
	  <button class="btn btn-outline-secondary" type="submit">검색</button>
	</form>

    <div class="d-flex align-items-center gap-4">
       <a href="#" onclick="goPage('list.jsp')" class="text-decoration-none text-dark d-flex align-items-center">
        <span class="me-1">💬</span>거래 게시판
      </a>
      <a>|</a> 
      <a href="#" onclick="goPage('sell.jsp')" class="text-decoration-none text-dark d-flex align-items-center">
        <span class="me-1">👜</span>내 거 팔기
      </a>
      <a>|</a>
      <a href="#" onclick="goPage('mySell.jsp')" class="text-decoration-none text-dark d-flex align-items-center">
        <span class="me-1">👤</span>내 판매 목록
      </a>
      <a>|</a>
      <a href="#" onclick="goPage('jobList.jsp')" class="text-decoration-none text-dark d-flex align-items-center">
        <span class="me-1">📋</span>알바 게시판
      </a>
    </div>
  </div>
</div>
