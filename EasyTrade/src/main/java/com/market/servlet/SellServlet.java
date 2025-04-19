package com.market.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/SellServlet")
@MultipartConfig(
    maxFileSize = 40 * 1024 * 1024, // 40MB
    maxRequestSize = 40 * 1024 * 1024
)
public class SellServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String priceParam = request.getParameter("price");
        int price = 0;
        try {
            price = Integer.parseInt(priceParam);
        } catch (NumberFormatException e) {
            response.getWriter().println("<script>alert('가격은 숫자로 입력해주세요.'); history.back();</script>");
            return;
        }

        Part filePart = request.getPart("image");

        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            response.getWriter().println("<script>alert('제목과 내용을 입력해주세요.'); history.back();</script>");
            return;
        }

        String fileName = null;
        String relativePath = null;

        if (filePart != null && filePart.getSize() > 0) {
            long maxSize = 40L * 1024 * 1024;
            if (filePart.getSize() > maxSize) {
                response.getWriter().println("<script>alert('파일 크기는 40MB 이하로 제한됩니다.'); history.back();</script>");
                return;
            }

            String uploadPath = getServletContext().getRealPath("/images");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            filePart.write(uploadPath + File.separator + fileName);

            relativePath = "images/" + fileName;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01");

            String sql = "INSERT INTO BOARD (BOARD_ID, TITLE, CONTENT, USER_ID, PRICE, CREATED_AT, VIEWS, LIKES, IMAGE_PATH) " +
                         "VALUES (BOARD_SEQ.NEXTVAL, ?, ?, ?, ?, SYSDATE, 0, 0, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setString(3, userId);
            pstmt.setInt(4, price);
            pstmt.setString(5, relativePath);
            pstmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/list.jsp");

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
