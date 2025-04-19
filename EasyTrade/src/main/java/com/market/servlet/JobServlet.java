package com.market.servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/jobUpload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 1024 * 1024 * 5,    // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class JobServlet extends HttpServlet {
    private static final String SAVE_DIR = "images";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String userId = request.getParameter("userId");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        String imagePath = null; // 기본 이미지 제거
        Part filePart = request.getPart("imagePath");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = request.getServletContext().getRealPath("/images");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            File file = new File(uploadPath, fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath());
            }
            imagePath = "images/" + fileName;
        }

        try {
            Class.forName("oracle.jdbc.OracleDriver");
            Connection conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01"
            );

            String sql = "INSERT INTO JOBLIST (JOB_ID, TITLE, CONTENT, USER_ID, IMAGE_PATH, CREATED_AT) " +
                         "VALUES (JOBLIST_SEQ.NEXTVAL, ?, ?, ?, ?, SYSDATE)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setString(3, userId);
            pstmt.setString(4, imagePath); // null이면 null 저장됨
            pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            response.sendRedirect(request.getContextPath() + "/views/jobList.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<p>업로드 실패: " + e.getMessage() + "</p>");
        }
    }
}
