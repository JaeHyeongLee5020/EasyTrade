<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알바 공고 작성</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="top.jsp" />
<jsp:include page="top2.jsp" />

<div class="container mt-5">
    <h2 class="mb-4">📝 알바 공고 작성</h2>
    <form action="${pageContext.request.contextPath}/jobUpload" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="userId" class="form-label">작성자</label>
            <input type="text" class="form-control" name="userId" required>
        </div>
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" name="title" required>
        </div>
        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea class="form-control" name="content" rows="5" required></textarea>
        </div>
        <div class="mb-3">
            <label for="imagePath" class="form-label">이미지</label>
            <input type="file" class="form-control" name="imagePath">
        </div>
        <button type="submit" class="btn btn-primary">작성 완료</button>
    </form>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>