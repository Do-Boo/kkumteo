# 꿈터(KkumTeo) - 계획 관리 웹사이트

꿈터(KkumTeo)는 사용자들이 다양한 계획을 생성, 관리, 공유할 수 있는 웹 기반 계획 관리 시스템입니다. 이 프로젝트는 HTML, CSS, JavaScript를 기반으로 개발되었으며, 백엔드는 PHP와 MySQL을 통해 구현될 예정입니다.

## 프로젝트 개요

이 프로젝트는 기존의 "OGO GRAFOLIO" HTML 템플릿을 바탕으로 "꿈터(KkumTeo)"라는 계획 관리 시스템으로 변환한 것입니다. 주요 변경 사항으로는 디자인 통일, 공통 스타일 추출, 그리고 계획 관리에 특화된 기능 구현이 있습니다.

## 주요 기능

### 1. 메인 페이지
- 인기/최신/추천 계획 필터링 기능
- 계획 카드 그리드 형태의 레이아웃
- 로그인 모달 팝업

### 2. 계획 상세 페이지
- 계획 세부 정보 표시
- 작성자 정보 및 작성일 표시
- 댓글 기능

### 3. 계획 에디터
- 새 계획 작성 및 기존 계획 수정 기능
- 이미지 업로드 및 미리보기
- 태그 추가 기능
- HTML 파일 업로드 옵션

### 4. 내 계획 대시보드
- 사용자가 작성한 계획 목록 표시
- 계획 수정 및 삭제 기능
- 검색 기능

### 5. 피드 페이지
- 친구 및 관심 사용자의 계획 피드 표시

### 6. 달력 페이지
- 월간/주간/일간 캘린더 뷰
- 계획 일정 시각화
- 다가오는 일정 표시

### 7. 커뮤니티 페이지
- 게시글 목록 표시
- 카테고리별 게시글 필터링 (질문, 꿀팁, 성취)
- 인기 게시글 및 태그 목록
- 댓글 및 좋아요 기능

## 파일 구조

```
📦 꿈터(KkumTeo)
 ┣ 📜 common.css       - 공통 스타일 정의
 ┣ 📜 main_page.html   - 웹사이트 메인 페이지
 ┣ 📜 detail_page.html - 계획 상세 페이지
 ┣ 📜 plan_editor.html - 계획 작성/수정 페이지
 ┣ 📜 my_plans.html    - 사용자 계획 대시보드
 ┣ 📜 feed_page.html   - 피드 페이지
 ┣ 📜 calendar.html    - 계획 달력 페이지
 ┗ 📜 community.html   - 커뮤니티 페이지
```

## 기술 스택

- **프론트엔드**:
  - HTML5
  - CSS3
  - JavaScript (vanilla)
  - Tailwind CSS (CDN)
  - Font Awesome (아이콘)
  - Google Fonts (Noto Sans KR)

- **백엔드** (예정):
  - PHP
  - MySQL 데이터베이스

## 설치 및 실행 방법

### 로컬 개발 환경

1. 저장소 클론
```bash
git clone https://github.com/your-username/kkumteo.git
cd kkumteo
```

2. 웹 서버 설정
- PHP가 설치된 로컬 웹 서버(Apache 또는 Nginx)에 프로젝트 파일을 배치합니다.
- 또는 간단한 PHP 내장 웹 서버를 사용할 수 있습니다:
```bash
php -S localhost:8000
```

3. 데이터베이스 설정
- MySQL 데이터베이스 서버를 설치하고 실행합니다.
- 데이터베이스와 필요한 테이블을 생성합니다(SQL 스크립트 예정).

## 데이터베이스 구조 (예정)

### 사용자(users) 테이블
```sql
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  full_name VARCHAR(100) NOT NULL,
  profile_image VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 계획(plans) 테이블
```sql
CREATE TABLE plans (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  main_image VARCHAR(255),
  html_content TEXT,
  visibility ENUM(\"public\", \"private\", \"friends\") DEFAULT \"public\",
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 태그(tags) 테이블
```sql
CREATE TABLE tags (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE
);
```

### 계획-태그 관계(plan_tags) 테이블
```sql
CREATE TABLE plan_tags (
  plan_id INT NOT NULL,
  tag_id INT NOT NULL,
  PRIMARY KEY (plan_id, tag_id),
  FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);
```

### 일정(events) 테이블
```sql
CREATE TABLE events (
  id INT PRIMARY KEY AUTO_INCREMENT,
  plan_id INT,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  start_date DATETIME NOT NULL,
  end_date DATETIME,
  all_day BOOLEAN DEFAULT FALSE,
  event_type ENUM("plan", "personal", "deadline") DEFAULT "plan",
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE SET NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 게시글(posts) 테이블
```sql
CREATE TABLE posts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  category ENUM("questions", "tips", "achievements") NOT NULL,
  views INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 게시글 댓글(post_comments) 테이블
```sql
CREATE TABLE post_comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 게시글 좋아요(post_likes) 테이블
```sql
CREATE TABLE post_likes (
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (post_id, user_id),
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 댓글(comments) 테이블
```sql
CREATE TABLE comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  plan_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

## PHP 연동 방법

1. 데이터베이스 연결 설정 파일 생성
```php
<?php
// config.php
define(\"DB_SERVER\", \"localhost\");
define(\"DB_USERNAME\", \"사용자명\");
define(\"DB_PASSWORD\", \"비밀번호\");
define(\"DB_NAME\", \"kkumteo_db\");

// 데이터베이스 연결
$conn = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// 연결 확인
if($conn === false) {
    die(\"ERROR: Could not connect. \" . mysqli_connect_error());
}
?>
```

2. 각 기능별 PHP 파일 구현
   - 로그인/회원가입 처리 (auth.php)
   - 계획 생성/수정/삭제 (plan_management.php)
   - 댓글 기능 (comments.php)
   - 검색 기능 (search.php)

## 향후 개발 계획

1. 백엔드 시스템 구현
   - PHP 스크립트 개발
   - MySQL 데이터베이스 연동

2. 사용자 인증 및 권한 관리 구현
   - 로그인/로그아웃 기능
   - 사용자 프로필 관리

3. 계획 관리 기능 강화
   - 이미지 업로드 및 저장 기능
   - 계획 템플릿 기능 추가

4. 소셜 기능 개발
   - 친구 추가 및 관리
   - 계획 공유 및 추천 시스템

## 기여 방법

이 프로젝트에 기여하고 싶으시다면:
1. 저장소를 포크하세요
2. 새 브랜치를 만드세요 (`git checkout -b feature/amazing-feature`)
3. 변경사항을 커밋하세요 (`git commit -m \"Add some amazing feature\"`)
4. 브랜치에 푸시하세요 (`git push origin feature/amazing-feature`)
5. Pull Request를 열어주세요

## 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.
