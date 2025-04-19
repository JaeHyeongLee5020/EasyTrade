<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>

<%
    String loginId = (String) session.getAttribute("userId");
    if (loginId == null || loginId.equals("")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>판매 글 등록</title>
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
    <h2>판매 글 작성</h2>
    <form action="<%= request.getContextPath() %>/SellServlet" method="post" enctype="multipart/form-data">

        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>
        <div class="mb-3">
 		   <label for="price" class="form-label">가격</label>
 		   <input type="number" class="form-control" id="price" name="price" min="0" required>
		</div>
        
        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea class="form-control" id="content" name="content" rows="8" required></textarea>
        </div>
        <div class="mb-3">
            <label for="image" class="form-label">이미지 업로드 (최대 40MB)</label>
            <input type="file" class="form-control" id="image" name="image" accept="image/*">
        </div>
        <input type="hidden" name="userId" value="<%= loginId %>">
        <button type="submit" class="btn btn-primary">등록</button>
    </form>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>
