<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String jobId = request.getParameter("jobId");
    String userId = (String) session.getAttribute("userId");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알바 게시글 보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function toggleEditForm(commentId) {
            const form = document.getElementById("edit-form-" + commentId);
            form.style.display = (form.style.display === "none") ? "block" : "none";
        }
    </script>
</head>
<body>

<jsp:include page="top.jsp" />
<jsp:include page="top2.jsp" />

<div class="container mt-5">
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

        pstmt = conn.prepareStatement("UPDATE JOBLIST SET VIEW_COUNT = VIEW_COUNT + 1 WHERE JOB_ID = ?");
        pstmt.setInt(1, Integer.parseInt(jobId));
        pstmt.executeUpdate();
        pstmt.close();

        pstmt = conn.prepareStatement("SELECT * FROM JOBLIST WHERE JOB_ID = ?");
        pstmt.setInt(1, Integer.parseInt(jobId));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String imagePath = rs.getString("IMAGE_PATH"); 
            boolean hasImage = (imagePath != null && !imagePath.trim().isEmpty());
%>
    <h2><%= rs.getString("TITLE") %></h2>
    <div class="mb-3 text-muted">
        작성자: <strong><%= rs.getString("USER_ID") %></strong> |
        등록일: <%= sdf.format(rs.getTimestamp("CREATED_AT")) %> |
        조회수: <%= rs.getString("VIEW_COUNT") %>
    </div>

    <div class="row mt-4">
        <% if (hasImage) { %>
        <div class="col-md-6">
            <img src="<%= request.getContextPath() %>/<%= imagePath %>" alt="이미지" class="img-fluid">
        </div>
        <div class="col-md-6">
            <label class="form-label">상세 내용</label>
            <div class="border p-3" style="min-height: 200px;"><%= rs.getString("CONTENT") %></div>
        </div>
        <% } else { %>
        <div class="col-12">
            <label class="form-label">상세 내용</label>
            <div class="border p-3" style="min-height: 200px;"><%= rs.getString("CONTENT") %></div>
        </div>
        <% } %>
    </div>
<%
        } else {
%>
    <p>게시글을 찾을 수 없습니다.</p>
<%
        }
        rs.close();
        pstmt.close();
%>

    <!-- 댓글 작성 -->
    <form action="jobComment.jsp" method="post" class="mt-5">
        <input type="hidden" name="jobId" value="<%= jobId %>">
        <input type="hidden" name="userId" value="<%= userId %>">

        <div class="mb-3">
            <label for="content" class="form-label">댓글</label>
            <textarea name="content" class="form-control" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">등록</button>
    </form>

    <!-- 댓글 목록 -->
    <div class="mt-4">
        <h5>댓글 목록</h5>
        <%
            pstmt = conn.prepareStatement("SELECT * FROM JOB_COMMENTS WHERE JOB_ID = ? ORDER BY CREATED_AT DESC");
            pstmt.setInt(1, Integer.parseInt(jobId));
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int commentId = rs.getInt("COMMENT_ID");
                String commentUser = rs.getString("USER_ID");
                String commentContent = rs.getString("CONTENT");
        %>
            <div class="border rounded p-2 mb-2">
                <strong><%= commentUser %></strong>: <%= commentContent %><br>
                <small><%= sdf.format(rs.getTimestamp("CREATED_AT")) %></small>
                <% if (userId != null && userId.equals(commentUser)) { %>
                    <div class="mt-2">
                        <!-- 삭제 버튼 -->
                        <form action="jobCommentDelete.jsp" method="post" style="display:inline-block;">
                            <input type="hidden" name="commentId" value="<%= commentId %>">
                            <input type="hidden" name="jobId" value="<%= jobId %>">
                            <button type="submit" class="btn btn-sm btn-danger">삭제</button>
                        </form>

                        <!-- 수정 버튼 -->
                        <button class="btn btn-sm btn-warning" onclick="toggleEditForm('<%= commentId %>')">수정</button>
                    </div>

                    <!-- 수정 폼 -->
                    <form id="edit-form-<%= commentId %>" action="jobCommentEdit.jsp" method="post" class="mt-2" style="display:none;">
                        <input type="hidden" name="commentId" value="<%= commentId %>">
                        <input type="hidden" name="jobId" value="<%= jobId %>">
                        <textarea name="content" class="form-control mb-2" rows="2" required><%= commentContent %></textarea>
                        <button type="submit" class="btn btn-sm btn-primary">수정 완료</button>
                    </form>
                <% } %>
            </div>
        <%
            }

        } catch (Exception e) {
            out.println("<div class='text-danger'>오류 발생: " + e.getMessage() + "</div>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignore) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception ignore) {}
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }
        %>
    </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
