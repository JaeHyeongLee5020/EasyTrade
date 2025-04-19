<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.market.dao.UserDAO, com.market.dto.UserDTO, java.sql.*" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDTO user = null;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@192.168.25.35:1521:xe",
            "team01", "team01"
        );
        UserDAO dao = new UserDAO(conn);
        user = dao.getUserById(userId);
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
  <title>회원정보 수정</title>
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

<div class="container mt-5" style="max-width: 600px;">
  <h3 class="mb-4">회원정보 수정</h3>
  <form action="updateUserProc.jsp" method="post">
    <div class="mb-3">
      <label class="form-label">아이디 (수정 불가)</label>
      <input type="text" class="form-control" name="userId" value="<%= user.getUserId() %>" readonly>
    </div>
    <div class="mb-3">
  <label class="form-label">비밀번호</label>
  <div class="input-group">
    <input type="password" class="form-control" name="password" id="passwordField" value="<%= user.getPassword() %>" required>
    <button type="button" class="btn btn-outline-secondary" onclick="togglePassword()">
      👁️‍🗨️
    </button>
  </div>
</div>

<script>
  function togglePassword() {
    const input = document.getElementById("passwordField");
    input.type = input.type === "password" ? "text" : "password";
  }
</script>
    
   
    
    <div class="mb-3">
      <label class="form-label">이름</label>
      <input type="text" class="form-control" name="name" value="<%= user.getName() %>" required>
    </div>
    <div class="mb-3">
      <label class="form-label">이메일</label>
      <input type="email" class="form-control" name="email" value="<%= user.getEmail() %>" required>
    </div>
    <div class="mb-3">
      <label class="form-label">전화번호</label>
      <input type="text" class="form-control" name="phone" value="<%= user.getPhone() %>" required>
    </div>
  
  <div class="d-flex justify-content-end gap-2">
  <button type="submit" class="btn btn-primary">수정하기</button>
  <button type="button" class="btn btn-danger" onclick="confirmDelete()">회원 탈퇴</button>
</div>

  </form>
  

<script>
  function confirmDelete() {
    if (confirm("회원 탈퇴하시겠습니까?")) {
      document.getElementById("deleteForm").submit();
    }
  }
</script>

<form id="deleteForm" action="deletePro.jsp" method="post">
  <input type="hidden" name="userId" value="<%= user.getUserId() %>">
</form>
  
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
