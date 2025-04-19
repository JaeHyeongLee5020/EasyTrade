<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // 세션 종료
    session.invalidate();

    // 자동 로그인 쿠키 삭제
    javax.servlet.http.Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (javax.servlet.http.Cookie c : cookies) {
            if ("autoLoginId".equals(c.getName())) {
                c.setMaxAge(0);
                c.setPath("/");
                response.addCookie(c);
            }
        }
    }
%>

<script>
    alert("로그아웃 되었습니다.");
    location.href = "main.jsp";
</script>
