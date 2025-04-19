<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.market.dto.CookieDTO, com.market.dao.CookieDAO, com.market.dao.UserDAO, com.market.dto.UserDTO" %>

<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("userId");
    String pw = request.getParameter("password");
    String saveId = request.getParameter("saveId");

    CookieDTO dto = new CookieDTO();
    dto.setId(id);
    dto.setPw(pw);

    CookieDAO cookieDao = new CookieDAO();
    boolean isValid = cookieDao.loginCheck(dto);

    if (isValid) {
        session.setAttribute("userId", id);
        session.setMaxInactiveInterval(1800);

        UserDAO userDao = new UserDAO(cookieDao.getConnection());
        UserDTO userInfo = userDao.getUserById(id);
        if (userInfo != null) {
            session.setAttribute("userName", userInfo.getName());
        }

        if ("on".equals(saveId)) {
            javax.servlet.http.Cookie c = new javax.servlet.http.Cookie("savedUserId", id);
            c.setMaxAge(60 * 60 * 24 * 7);
            c.setPath("/");
            response.addCookie(c);
        } else {
            javax.servlet.http.Cookie c = new javax.servlet.http.Cookie("savedUserId", "");
            c.setMaxAge(0);
            c.setPath("/");
            response.addCookie(c);
        }

%>
<script>
    alert('로그인 성공');
    location.href = 'main.jsp';
</script>
<%
    } else {
        response.sendRedirect("login.jsp?error=true");
    }
%>
