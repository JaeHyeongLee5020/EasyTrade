package com.market.dto;

import java.util.Date;

public class BoardDTO {
    private int boardId;
    private String title;
    private String content;
    private String userId;
    private Date createdAt;

    public BoardDTO() {}

    public BoardDTO(int boardId, String title, String content, String userId, Date createdAt) {
        this.boardId = boardId;
        this.title = title;
        this.content = content;
        this.userId = userId;
        this.createdAt = createdAt;
    }

    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
