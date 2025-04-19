package com.market.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<String> hotKeywords = new ArrayList<>();

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@192.168.25.35:1521:xe", "team01", "team01"
            );

            if (keyword != null && !keyword.trim().isEmpty()) {
                PreparedStatement upsert = conn.prepareStatement(
                    "MERGE INTO search_keyword s USING (SELECT ? AS keyword FROM dual) d " +
                    "ON (s.keyword = d.keyword) " +
                    "WHEN MATCHED THEN UPDATE SET s.count = s.count + 1 " +
                    "WHEN NOT MATCHED THEN INSERT (keyword, count) VALUES (?, 1)"
                );
                upsert.setString(1, keyword.trim());
                upsert.setString(2, keyword.trim());
                upsert.executeUpdate();
                upsert.close();
            }

            PreparedStatement stmt = conn.prepareStatement(
                "SELECT keyword FROM search_keyword ORDER BY count DESC FETCH FIRST 10 ROWS ONLY"
            );
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                hotKeywords.add(rs.getString("keyword"));
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("hotKeywords", hotKeywords);
        RequestDispatcher dispatcher = request.getRequestDispatcher("top2.jsp");
        dispatcher.forward(request, response);
    }
}
