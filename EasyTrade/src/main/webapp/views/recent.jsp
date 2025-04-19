<%@ page import="java.sql.*, java.util.*, java.net.URLDecoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String recent = null;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("recentView".equals(c.getName())) {
                recent = URLDecoder.decode(c.getValue(), "UTF-8");
                break;
            }
        }
    }

    List<Map<String, Object>> recentList = new ArrayList<>();

    if (recent != null && !recent.isEmpty()) {
        String[] boardIds = recent.split(",");

        Class.forName("oracle.jdbc.OracleDriver");
        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        for (String id : boardIds) {
            PreparedStatement pstmt = conn.prepareStatement("SELECT BOARD_ID, TITLE FROM BOARD WHERE BOARD_ID = ?");
            pstmt.setInt(1, Integer.parseInt(id));
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getInt("BOARD_ID"));
                item.put("title", rs.getString("TITLE"));
                recentList.add(item);
            }
            rs.close();
            pstmt.close();
        }
        conn.close();
    }
%>
<div class="border rounded shadow-sm bg-white px-2 py-2" style="width: 190px; height: 200px ;">
    <h6 class="fw-bold text-center mb-2" style="font-size: 0.95rem;">최근 본 상품</h6>
    <% if (recentList.isEmpty()) { %>
        <div class="text-muted text-center" style="font-size: 0.85rem;">상품 없음</div>
    <% } else {
        for (int i = 0; i < recentList.size(); i++) {
            Map<String, Object> item = recentList.get(i);
    %>
        <div class="text-truncate text-center mb-1" style="font-size: 0.9rem;">
            <a href="productDetail.jsp?boardId=<%= item.get("id") %>" class="text-decoration-none text-dark">
                <%= item.get("title") %>
            </a>
        </div>
        <% if (i < recentList.size() - 1) { %>
            <hr class="my-1">
        <% } %>
    <% }} %>
</div>
