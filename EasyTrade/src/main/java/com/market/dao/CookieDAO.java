package com.market.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//import web.tag.dto.CookieDTO;
import com.market.dto.*;

public class CookieDAO {

	
	 
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    public Connection getConnection() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@192.168.25.35:1521:xe";  
            String user = "team01";
            String pwd = "team01";
            conn = DriverManager.getConnection(url, user, pwd);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    public void getClose() {
        try {
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            if (pstmt != null) pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            if (rs != null) rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public boolean loginCheck(CookieDTO dto) {
        boolean result = false;
        getConnection();

        String sql = "SELECT user_id FROM users WHERE user_id=? AND password=?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getId());
            pstmt.setString(2, dto.getPw());

            rs = pstmt.executeQuery();

            if (rs.next()) {
                result = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            getClose();
        }

        return result;
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
