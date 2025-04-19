package com.market.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.market.dao.BoardDAO;
import com.market.dto.BoardDTO;

@WebServlet("/board")
public class BoardServlet extends HttpServlet {
    private Connection conn;

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@192.168.25.35:1521:xe";
            String user = "team01";
            String pwd = "team01";
            conn = DriverManager.getConnection(url, user, pwd);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BoardDAO dao = new BoardDAO(conn);
        try {
            List<BoardDTO> boardList = dao.getBoardList();
            request.setAttribute("boardList", boardList);
            request.getRequestDispatcher("boardList.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BoardDAO dao = new BoardDAO(conn);
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String userId = "admin"; // 세션에서 가져와야 함

        BoardDTO board = new BoardDTO(0, title, content, userId, null);
        try {
            dao.insertBoard(board);
            response.sendRedirect("board");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void destroy() {
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
