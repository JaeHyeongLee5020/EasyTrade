<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String savedId = "";
    String loginError = request.getParameter("error");
    javax.servlet.http.Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (javax.servlet.http.Cookie c : cookies) {
            if (c.getName().equals("savedUserId")) {
                savedId = c.getValue();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
  <title>로그인</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <jsp:include page="top.jsp" />

  <div class="container mt-5" style="max-width: 500px;">
    <h2 class="mb-4">로그인</h2>
    <form action="loginProc.jsp" method="post">
      <div class="mb-3">
        <label class="form-label">아이디</label>
        <input type="text" name="userId" class="form-control" value="<%= savedId %>" required>
      </div>
      <div class="mb-3">
        <label class="form-label">비밀번호</label>
        <input type="password" name="password" class="form-control" required>
        <% if ("true".equals(loginError)) { %>
          <div class="text-danger mt-1">아이디 또는 비밀번호가 잘못되었습니다.</div>
        <% } %>
      </div>
      <div class="form-check mb-3">
        <input class="form-check-input" type="checkbox" name="saveId" id="saveId"
               <%= savedId.isEmpty() ? "" : "checked" %>>
        <label class="form-check-label" for="saveId">
          아이디 저장
        </label>
      </div>
      <button type="submit" class="btn btn-primary">로그인</button>
    </form>
  </div>
</body>
</html>
