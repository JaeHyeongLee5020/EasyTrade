# EasyTrade

중고거래 플랫폼 **EasyTrade**는 사용자 간의 중고 물품 거래를 돕는 웹 애플리케이션입니다. Java, JSP, Servlet, Oracle DB, Bootstrap 기반으로 개발되었습니다.

## 📌 주요 기능

- 회원가입 및 로그인
- 게시글 등록, 조회, 수정, 삭제 (CRUD)
- 게시판 기능 (목록, 페이징, 인기 상품 슬라이드)
- 댓글 기능
- 좋아요 버튼 구현
- 최근 본 상품 표시
- 세션 유지 및 자동 로그아웃
- Bootstrap 기반 반응형 UI

## 🗂️ 기술 스택

| 항목            | 기술                                   |
|----------------|----------------------------------------|
| 언어           | Java (Servlet, JSP)                    |
| 프레임워크     | 없음 (Custom MVC 패턴)                |
| DB             | Oracle DB                              |
| 프론트엔드     | HTML5, CSS3, JavaScript, Bootstrap 5   |
| 빌드 및 배포   | WAR 방식 (Tomcat)                      |
| 개발 환경      | Eclipse, STS4                          |

## 📁 프로젝트 구조

EasyTrade/
├── src/
│   └── com.market/       # DAO, DTO, Servlet 클래스
├── WebContent/
│   ├── jsp/              # 각종 JSP 파일
│   ├── image/            # 이미지 파일
│   └── css/, js/         # 정적 리소스
├── WEB-INF/
│   ├── web.xml           # 서블릿 설정
│   └── views/            # JSP 뷰

## 📷 시연 이미지

(스크린샷 첨부)

## 🔗 프로젝트 발표 자료

- PPT: [Google Drive 링크](https://docs.google.com/presentation/d/1HBpNIwAppiUK1avKet_7rroTHySNhmR1/edit?usp=sharing&ouid=116787431230251141749&rtpof=true&sd=true)
