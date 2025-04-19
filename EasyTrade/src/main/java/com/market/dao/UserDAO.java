package com.market.dao;

import java.sql.*;
import com.market.dto.UserDTO;

public class UserDAO {
    private Connection conn;

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    public int insertUser(UserDTO user) throws SQLException {
        String sql = "INSERT INTO USERS (user_id, password, name, email, phone) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            return pstmt.executeUpdate();
        }
    }

    public boolean validateLogin(String userId, String password) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USERS WHERE user_id=? AND password=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 1;
            }
        }
        return false;
    }

    public UserDTO getUserById(String userId) throws SQLException {
        String sql = "SELECT * FROM USERS WHERE user_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return new UserDTO(
                    rs.getString("user_id"),
                    rs.getString("password"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone")
                );
            }
        }
        return null;
    }
    
    
    
    
    public int updateUser(UserDTO user) throws SQLException {
        String sql = "UPDATE USERS SET password=?, name=?, email=?, phone=? WHERE user_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getPassword());
            pstmt.setString(2, user.getName());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getUserId());
            return pstmt.executeUpdate();
        }
    }
    
    
    
    
    public int deleteUser(String userId) throws SQLException {
        String sql = "DELETE FROM USERS WHERE user_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            return pstmt.executeUpdate();
        }
    }

    
    
    
    
    
    
    
    
    

}
