# EasyTrade

중고거래 플랫폼 **EasyTrade**는 사용자 간의 중고 물품 거래를 돕는 웹 애플리케이션입니다. Java, JSP, Servlet, Oracle DB, Bootstrap 기반으로 개발되었습니다.

---

## 📌 주요 기능

- 회원가입 및 로그인 (세션 기반 인증)
- 게시글 등록, 조회, 수정, 삭제 (CRUD)
- 게시판 기능 (목록, 페이징, 인기 상품 슬라이드)
- 댓글 기능 (등록/수정/삭제)
- 좋아요 버튼 구현
- 최근 본 상품 표시
- 세션 유지 및 자동 로그아웃
- Bootstrap 기반 반응형 UI

---

## 🗂️ 기술 스택

| 항목            | 기술                                   |
|----------------|----------------------------------------|
| 언어           | Java (Servlet, JSP)                    |
| 프레임워크     | 없음 (Custom MVC 패턴)                |
| DB             | Oracle DB (JDBC 기반 연결)             |
| 프론트엔드     | HTML5, CSS3, JavaScript, Bootstrap 5   |
| 빌드 및 배포   | WAR 방식 (Tomcat)                      |
| 개발 환경      | Eclipse, STS4                          |

---

## 📁 프로젝트 구조

EasyTrade/
├── src/
│   └── com/market/
│       ├── dao/        # DAO 클래스
│       ├── dto/        # DTO 클래스
│       └── servlet/    # 서블릿 클래스
├── WebContent/
│   ├── jsp/            # JSP 파일
│   ├── image/          # 이미지 파일
│   ├── css/            # CSS 파일
│   └── js/             # JavaScript 파일
└── WEB-INF/
    ├── web.xml         # 서블릿 설정
    └── views/          # JSP 뷰


---

## 🗄️ 데이터베이스 구조 (예시)

- **USERS**
  - `user_id` (PK), `password`, `name`, `email`, `phone`
- **BOARD**
  - `board_id` (PK, 시퀀스 사용), `title`, `content`, `user_id(FK)`, `created_at`
- **COMMENT** (추가 필요 시)
  - `comment_id`, `board_id(FK)`, `user_id(FK)`, `content`, `created_at`
- **LIKE** (추가 필요 시)
  - `like_id`, `board_id(FK)`, `user_id(FK)`

> DAO 코드에서 `BOARD_SEQ.NEXTVAL`, `SYSDATE`가 사용됨을 확인했습니다.  

---

## ⚙️ 실행 및 배포

1. Oracle DB에 테이블 및 시퀀스 생성
2. `web.xml` 또는 `context.xml`에서 DB 연결 정보(JNDI 권장) 설정
3. 프로젝트를 WAR로 빌드 후 Tomcat에 배포
4. 브라우저 접속: `http://localhost:8080/EasyTrade`

---

## 🔒 보안 및 개선 포인트

- 비밀번호 저장 시 **SHA-256/BCrypt 해시 적용 필요** (현재 평문 위험)  
- DB 접속 정보는 소스에 직접 노출하지 않고 **JNDI 또는 환경변수**로 관리  
- XSS/SQL Injection 방어를 위한 입력값 검증 필요  
- 업로드 파일 확장자 및 용량 제한 권장  

---

## 🔗 프로젝트 발표 자료

- PPT: [Google Drive 링크](https://docs.google.com/presentation/d/1HBpNIwAppiUK1avKet_7rroTHySNhmR1/edit?usp=sharing&ouid=116787431230251141749&rtpof=true&sd=true)
