package com.market.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.market.dto.BoardDTO;

public class BoardDAO {
    private Connection conn;

    public BoardDAO(Connection conn) {
        this.conn = conn;
    }

    // 1️⃣ 게시글 작성 (CREATE)
    public int insertBoard(BoardDTO board) throws SQLException {
        String sql = "INSERT INTO BOARD (board_id, title, content, user_id, created_at) VALUES (BOARD_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, board.getTitle());
            pstmt.setString(2, board.getContent());
            pstmt.setString(3, board.getUserId());
            return pstmt.executeUpdate();
        }
    }

    // 2️⃣ 게시글 목록 조회 (READ)
    public List<BoardDTO> getBoardList() throws SQLException {
        List<BoardDTO> boardList = new ArrayList<>();
        String sql = "SELECT * FROM BOARD ORDER BY created_at DESC";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                boardList.add(new BoardDTO(
                    rs.getInt("board_id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("user_id"),
                    rs.getDate("created_at")
                ));
            }
        }
        return boardList;
    }

    // 3️⃣ 특정 게시글 조회 (READ)
    public BoardDTO getBoardById(int boardId) throws SQLException {
        String sql = "SELECT * FROM BOARD WHERE board_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, boardId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return new BoardDTO(
                    rs.getInt("board_id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("user_id"),
                    rs.getDate("created_at")
                );
            }
        }
        return null;
    }

    // 4️⃣ 게시글 수정 (UPDATE)
    public int updateBoard(BoardDTO board) throws SQLException {
        String sql = "UPDATE BOARD SET title=?, content=? WHERE board_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, board.getTitle());
            pstmt.setString(2, board.getContent());
            pstmt.setInt(3, board.getBoardId());
            return pstmt.executeUpdate();
        }
    }

    // 5️⃣ 게시글 삭제 (DELETE)
    public int deleteBoard(int boardId) throws SQLException {
        String sql = "DELETE FROM BOARD WHERE board_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, boardId);
            return pstmt.executeUpdate();
        }
    }
}
