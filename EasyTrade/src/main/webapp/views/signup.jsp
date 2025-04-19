<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>회원가입</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <jsp:include page="top.jsp" />

  <div class="container mt-5" style="max-width: 600px;">
    <h2 class="mb-4">회원가입</h2>
    <form action="signupProc.jsp" method="post">
      <div class="mb-3">
        <label class="form-label">아이디</label>
        <input type="text" name="userId" class="form-control" required>
      </div>
      
      <div class="mb-3">
        <label class="form-label">비밀번호</label>
        <div class="input-group">
          <input type="password" name="password" id="passwordField" class="form-control" required>
          <button type="button" class="btn btn-outline-secondary" onclick="togglePassword()">👁️‍🗨️</button>
        </div>
      </div>
      
      <div class="mb-3">
        <label class="form-label">이름</label>
        <input type="text" name="name" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label">이메일</label>
        <input type="email" name="email" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label">전화번호</label>
        <input type="text" name="phone" class="form-control" required>
      </div>
      <button type="submit" class="btn btn-primary">가입하기</button>
    </form>
  </div>

  <script>
    function togglePassword() {
      const input = document.getElementById("passwordField");
      input.type = input.type === "password" ? "text" : "password";
    }
  </script>
</body>
</html>
