<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.market.dto.BoardDTO" %>
<jsp:useBean id="boardList" scope="request" type="List<BoardDTO>" />

<table border="1">
    <tr><th>번호</th><th>제목</th><th>작성자</th><th>작성일</th></tr>
    <% for (BoardDTO board : boardList) { %>
        <tr>
            <td><%= board.getBoardId() %></td>
            <td><a href="viewBoard.jsp?id=<%= board.getBoardId() %>"><%= board.getTitle() %></a></td>
            <td><%= board.getUserId() %></td>
            <td><%= board.getCreatedAt() %></td>
        </tr>
    <% } %>
</table>
