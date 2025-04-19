<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<String> hotKeywords = new ArrayList<>();

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        pstmt = conn.prepareStatement(
            "SELECT keyword FROM search_keyword ORDER BY count DESC FETCH FIRST 5 ROWS ONLY"
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

<!-- 인기 검색어 상위 5개 고정 출력 -->
<div style="background-color: white;" class="py-2">
  <div class="d-flex justify-content-center align-items-center gap-3">
    <% for (int i = 0; i < hotKeywords.size(); i++) {
         String k = hotKeywords.get(i);
    %>
      <div style="font-size: 1rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
        <a href="searchResult.jsp?keyword=<%= java.net.URLEncoder.encode(k, "UTF-8") %>" class="text-decoration-none text-dark">
  <%= (i + 1) + ". " + k %>
</a>

      </div>
    <% } %>
  </div>
</div>
