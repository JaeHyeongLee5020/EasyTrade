package com.market.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/EditServlet")
@MultipartConfig(
    maxFileSize = 40 * 1024 * 1024,
    maxRequestSize = 40 * 1024 * 1024
)
public class EditServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("loginForm.jsp");
            return;
        }

        int boardId;
        try {
            boardId = Integer.parseInt(request.getParameter("boardId"));
        } catch (NumberFormatException e) {
            response.getWriter().println("<script>alert('게시글 번호 오류'); history.back();</script>");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String priceParam = request.getParameter("price");

        int price = 0;
        try {
            price = Integer.parseInt(priceParam);
        } catch (NumberFormatException e) {
            response.getWriter().println("<script>alert('가격은 숫자여야 합니다.'); history.back();</script>");
            return;
        }

        Part filePart = request.getPart("image");
        String imagePath = null;

        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("/images");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            filePart.write(uploadPath + File.separator + fileName);
            imagePath = "images/" + fileName;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

            String sql;
            if (imagePath != null) {
                sql = "UPDATE BOARD SET TITLE = ?, CONTENT = ?, PRICE = ?, IMAGE_PATH = ? WHERE BOARD_ID = ? AND USER_ID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, title);
                pstmt.setString(2, content);
                pstmt.setInt(3, price);
                pstmt.setString(4, imagePath);
                pstmt.setInt(5, boardId);
                pstmt.setString(6, userId);
            } else {
                sql = "UPDATE BOARD SET TITLE = ?, CONTENT = ?, PRICE = ? WHERE BOARD_ID = ? AND USER_ID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, title);
                pstmt.setString(2, content);
                pstmt.setInt(3, price);
                pstmt.setInt(4, boardId);
                pstmt.setString(5, userId);
            }

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
            	response.sendRedirect(request.getContextPath() + "/views/mySell.jsp");

            } else {
                response.getWriter().println("<script>alert('수정 실패: 권한 없음'); history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("DB 오류: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }
}
