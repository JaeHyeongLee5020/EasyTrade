<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	

    String loginId = (String) session.getAttribute("userId");
    int boardId = Integer.parseInt(request.getParameter("boardId"));

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        pstmt = conn.prepareStatement("SELECT * FROM COMMENTS WHERE BOARD_ID = ? ORDER BY CREATED_AT DESC");
        pstmt.setInt(1, boardId);
        rs = pstmt.executeQuery();
%>

<div class="mt-4 mx-auto w-75">
    <h5>댓글</h5>
    <form action="commentAction.jsp" method="post">
    <input type="hidden" name="boardId" value="<%= boardId %>">
    
    <div class="mb-2">
        <textarea name="comment" class="form-control" rows="3" required></textarea>
    </div>
    
    <div class="d-flex justify-content-end">
        <button type="submit" class="btn btn-sm btn-primary">등록</button>
    </div>
</form>


    <ul class="list-group mt-3">
    <% while (rs.next()) {
        int commentId = rs.getInt("COMMENT_ID");
        String userId = rs.getString("USER_ID");
        String content = rs.getString("CONTENT");
        Timestamp createdAt = rs.getTimestamp("CREATED_AT");
        Timestamp updateAt = rs.getTimestamp("UPDATE_AT");
    %>
        <li class="list-group-item">
            <div class="d-flex justify-content-between">
                <div>
                    <strong><%= userId %></strong> : <%= content %>
                </div>
                <div class="text-end">
                    <small class="text-muted">
                    	<%= sdf.format(createdAt) %>
                    	<% if (updateAt != null) { %>
                    		(수정됨 : <%= sdf.format(updateAt) %>)
                    	<% } %>
                    </small><br>
                    <% if (loginId != null && loginId.equals(userId)) { %>
                        <form action="commentDelete.jsp" method="post" style="display:inline-block;">
                            <input type="hidden" name="commentId" value="<%= commentId %>">
                            <input type="hidden" name="boardId" value="<%= boardId %>">
                            <button type="submit" class="btn btn-sm btn-danger btn-sm ms-1">삭제</button>
                        </form>
                        <button class="btn btn-sm btn-warning ms-1"
                                onclick="toggleEditForm('<%= commentId %>')">수정</button>
                    <% } %>
                </div>
            </div>

            <% if (loginId != null && loginId.equals(userId)) { %>
                <form id="edit-form-<%= commentId %>" action="commentEditAction.jsp" method="post"
                      style="display:none; margin-top:10px;" class="w-100">
                    <input type="hidden" name="commentId" value="<%= commentId %>">
                    <input type="hidden" name="boardId" value="<%= boardId %>">
                    <textarea name="content" class="form-control mb-2" rows="2" required><%= content %></textarea>
                    <button type="submit" class="btn btn-sm btn-primary">수정 완료</button>
                </form>
            <% } %>
        </li>
    <% } %>
    </ul>
</div>

<script>
function toggleEditForm(commentId) {
    const form = document.getElementById("edit-form-" + commentId);
    form.style.display = (form.style.display === "none") ? "block" : "none";
}
</script>

<%
    } catch (Exception e) {
        out.println("<div class='text-danger'>댓글 로딩 오류: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
