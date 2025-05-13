-- 꿈터(KkumTeo) 데이터베이스 스키마 정의
-- 작성일: 2023-05-11
-- 수정일: 2023-05-12 - 카카오 로그인 및 프로필 통합 추가

-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS kkumteo_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE kkumteo_db;

-- 사용자 테이블
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    kakao_id VARCHAR(100) UNIQUE,
    profile_image VARCHAR(255),
    display_name VARCHAR(100) NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_kakao_id (kakao_id)
);

-- 계획 테이블
CREATE TABLE IF NOT EXISTS plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    thumbnail_image VARCHAR(255),
    start_date DATE,
    end_date DATE,
    location VARCHAR(255),
    status ENUM('draft', 'published', 'completed', 'archived') DEFAULT 'draft',
    visibility ENUM('public', 'private', 'friends') DEFAULT 'private',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    views INT DEFAULT 0,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_plan (user_id),
    INDEX idx_status (status),
    INDEX idx_visibility (visibility)
);

-- 계획 일정 테이블
CREATE TABLE IF NOT EXISTS plan_schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    schedule_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    location VARCHAR(255),
    location_lat DECIMAL(10, 8),
    location_lng DECIMAL(11, 8),
    order_index INT NOT NULL DEFAULT 0,
    
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    INDEX idx_plan_schedule (plan_id, schedule_date)
);

-- 시안 파일 테이블
CREATE TABLE IF NOT EXISTS design_mockups (
    mockup_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    user_id INT NOT NULL,
    file_type ENUM('html', 'figma_link') NOT NULL,
    file_name VARCHAR(255),
    file_path VARCHAR(255),
    figma_link VARCHAR(1024),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_plan_mockups (plan_id)
);

-- 태그 테이블
CREATE TABLE IF NOT EXISTS tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_tag_name (name)
);

-- 계획-태그 연결 테이블
CREATE TABLE IF NOT EXISTS plan_tags (
    plan_id INT NOT NULL,
    tag_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (plan_id, tag_id),
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

-- 댓글/의견 테이블
CREATE TABLE IF NOT EXISTS opinions (
    opinion_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    user_id INT NOT NULL,
    parent_id INT NULL, -- 대댓글을 위한 필드
    content TEXT NOT NULL,
    content_type ENUM('text', 'html') DEFAULT 'text',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES opinions(opinion_id) ON DELETE SET NULL,
    INDEX idx_plan_opinions (plan_id)
);

-- 댓글/의견 첨부 이미지 테이블
CREATE TABLE IF NOT EXISTS opinion_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    opinion_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    order_index INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (opinion_id) REFERENCES opinions(opinion_id) ON DELETE CASCADE,
    INDEX idx_opinion_images (opinion_id)
);

-- 댓글/의견 Figma 링크 테이블
CREATE TABLE IF NOT EXISTS opinion_figma_links (
    link_id INT AUTO_INCREMENT PRIMARY KEY,
    opinion_id INT NOT NULL,
    figma_link VARCHAR(1024) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (opinion_id) REFERENCES opinions(opinion_id) ON DELETE CASCADE,
    INDEX idx_opinion_links (opinion_id)
);

-- 좋아요 테이블
CREATE TABLE IF NOT EXISTS likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_user_plan_like (user_id, plan_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    INDEX idx_plan_likes (plan_id)
);

-- 북마크 테이블
CREATE TABLE IF NOT EXISTS bookmarks (
    bookmark_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_user_plan_bookmark (user_id, plan_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    INDEX idx_user_bookmarks (user_id)
);

-- 팔로우 관계 테이블
CREATE TABLE IF NOT EXISTS follows (
    follow_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL, -- 팔로우하는 사용자
    following_id INT NOT NULL, -- 팔로우받는 사용자
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_follow_relationship (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_followers (following_id),
    INDEX idx_user_following (follower_id)
);

-- 알림 테이블
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- 알림 받는 사용자
    type ENUM('like', 'comment', 'follow', 'mention', 'bookmark', 'system') NOT NULL,
    related_user_id INT, -- 알림 발생시킨 사용자
    related_plan_id INT,
    related_opinion_id INT,
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (related_user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (related_plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (related_opinion_id) REFERENCES opinions(opinion_id) ON DELETE CASCADE,
    INDEX idx_user_notifications (user_id, is_read)
);

-- 카카오 인증 토큰 테이블
CREATE TABLE IF NOT EXISTS kakao_tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    refresh_token VARCHAR(512) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_token (user_id)
);

-- 계획 콘텐츠 섹션 테이블
CREATE TABLE IF NOT EXISTS plan_sections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT NOT NULL,
    content_type ENUM('text', 'html', 'markdown') DEFAULT 'markdown',
    order_index INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    INDEX idx_plan_sections (plan_id, order_index)
);

-- 계획 오디오 콘텐츠 테이블
CREATE TABLE IF NOT EXISTS plan_audio (
    audio_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_path VARCHAR(255) NOT NULL,
    file_size INT NOT NULL COMMENT '파일 크기(바이트)',
    duration INT NOT NULL COMMENT '재생 길이(초)',
    audio_type ENUM('podcast', 'mp3', 'other') NOT NULL DEFAULT 'mp3',
    order_index INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    INDEX idx_plan_audio (plan_id, order_index)
);

-- 추가 이미지 테이블
CREATE TABLE IF NOT EXISTS plan_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    order_index INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    INDEX idx_plan_images (plan_id)
);

-- 샘플 사용자 데이터 삽입
INSERT INTO users (username, email, kakao_id, display_name, bio)
VALUES 
('forestpainter', 'forest@example.com', '12345678', '숲의 화가', '자연의 아름다움과 신비로움을 그리는 것을 좋아합니다.');

-- 샘플 계획 데이터 삽입
INSERT INTO plans (user_id, title, description, location, status, visibility)
VALUES 
(1, '숲 속의 작은 집', '고요한 숲 속에 자리 잡은 작은 오두막집을 상상하며 그린 작품입니다. 새벽녘의 부드러운 안개와 따스하게 스며드는 햇살, 그리고 지저귀는 새소리가 들리는 듯한 평화로운 순간을 표현하고자 했습니다.', '숲속 오두막', 'published', 'public');

-- 샘플 태그 데이터 삽입
INSERT INTO tags (name) VALUES 
('숲'), ('오두막'), ('자연'), ('일러스트'), ('평화'), ('힐링'), ('디지털페인팅');

-- 샘플 계획-태그 연결 데이터 삽입
INSERT INTO plan_tags (plan_id, tag_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7);

-- 샘플 계획 섹션 데이터 삽입
INSERT INTO plan_sections (plan_id, title, content, content_type, order_index) VALUES
(1, '프로젝트 개요', '고요한 숲 속에 자리 잡은 작은 오두막집을 상상하며 그린 작품입니다. 새벽녘의 부드러운 안개와 따스하게 스며드는 햇살, 그리고 지저귀는 새소리가 들리는 듯한 평화로운 순간을 표현하고자 했습니다.\n\n이 그림은 자연과 인간의 조화로운 공존을 테마로 하고 있으며, 디지털 페인팅 기법을 활용하여 제작되었습니다.', 'markdown', 0),
(1, '작업 과정', '## 스케치 단계\n\n1. 기본 구도 스케치\n2. 오두막 형태 세부 디자인\n3. 주변 환경 요소 배치\n\n## 컬러링 단계\n\n* 기본 색상 팔레트 선정: 녹색, 갈색, 청색 계열\n* 배경 그라데이션 작업\n* 오두막 및 세부 요소 채색\n* 빛과 그림자 표현', 'markdown', 1),
(1, '사용 도구', '* iPad Pro + Apple Pencil\n* Procreate 앱\n* Adobe Photoshop (후보정)\n* 커스텀 브러쉬: 수채화, 연필, 질감 브러쉬', 'markdown', 2);

-- 샘플 오디오 데이터 삽입
INSERT INTO plan_audio (plan_id, title, description, file_path, file_size, duration, audio_type, order_index) VALUES
(1, '숲 속의 작은 집 - 작업 과정 이야기', '작품의 영감을 얻게 된 과정과 실제 작업 진행 방식에 대한 오디오 설명입니다.', '/uploads/audio/forest_cabin_process.mp3', 4587520, 180, 'mp3', 0),
(1, '자연 속 힐링 - 작가의 생각', '자연을 주제로 한 작품을 그리는 과정에서 느낀 작가의 생각과 감정을 담은 팟캐스트 에피소드입니다.', '/uploads/audio/nature_healing_podcast.mp3', 8956400, 354, 'podcast', 1);

-- 샘플 댓글 데이터 삽입
INSERT INTO opinions (plan_id, user_id, content, content_type)
VALUES 
(1, 1, '정말 아름다운 작품이네요! 숲 속의 평화로움이 그대로 느껴집니다.', 'text'),
(1, 1, '스케치 과정도 볼 수 있어서 좋네요! 다음 작품도 기대하겠습니다 :) <br> 추가로, <strong>이런 강조</strong>나 <i>이탤릭체</i>도 잘 보이면 좋겠어요.', 'html');

-- 인덱스 추가 (성능 향상을 위한 추가 인덱스)
CREATE INDEX idx_plans_created_at ON plans(created_at);
CREATE INDEX idx_plans_popularity ON plans(views, created_at);
CREATE INDEX idx_opinions_created_at ON opinions(created_at); 