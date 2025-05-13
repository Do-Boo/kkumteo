# 꿈터(KkumTeo) 데이터베이스 설명

이 문서는 꿈터(KkumTeo) 프로젝트의 데이터베이스 구조를 설명합니다.

## 개요

꿈터(KkumTeo) 데이터베이스는 사용자, 계획, 의견/댓글, 그리고 소셜 기능을 지원하기 위한 다양한 테이블로 구성되어 있습니다. 
데이터베이스는 MySQL/MariaDB를 기반으로 설계되었으며, UTF-8 유니코드 인코딩(utf8mb4)을 사용하여 모든 언어의 문자를 처리할 수 있습니다.

## 테이블 구조

### 핵심 테이블

#### 1. 사용자 테이블 (users)

사용자 계정 정보를 저장합니다. 카카오톡 소셜 로그인을 통해 인증되며 카카오 프로필 정보를 활용합니다.

| 필드 | 설명 |
|------|------|
| user_id | 사용자 고유 ID (PK) |
| username | 사용자 계정명 (유니크) |
| email | 이메일 주소 (유니크) |
| kakao_id | 카카오 사용자 ID (유니크) |
| profile_image | 프로필 이미지 경로 (카카오 프로필 사진 활용) |
| display_name | 표시 이름 |
| bio | 자기소개 |
| created_at | 계정 생성 시간 |
| updated_at | 계정 정보 수정 시간 |
| last_login | 마지막 로그인 시간 |
| is_active | 계정 활성화 상태 |

#### 2. 계획 테이블 (plans)

사용자가 생성한 계획 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| plan_id | 계획 고유 ID (PK) |
| user_id | 작성자 ID (FK) |
| title | 계획 제목 |
| description | 계획 설명 |
| thumbnail_image | 대표 이미지 경로 |
| start_date | 시작 날짜 |
| end_date | 종료 날짜 |
| location | 위치 정보 |
| status | 상태 (초안, 게시됨, 완료됨, 보관됨) |
| visibility | 공개 설정 (공개, 비공개, 친구 공개) |
| created_at | 생성 시간 |
| updated_at | 수정 시간 |
| views | 조회수 |

#### 3. 계획 일정 테이블 (plan_schedules)

각 계획의 세부 일정 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| schedule_id | 일정 고유 ID (PK) |
| plan_id | 연관된 계획 ID (FK) |
| title | 일정 제목 |
| description | 일정 설명 |
| schedule_date | 일정 날짜 |
| start_time | 시작 시간 |
| end_time | 종료 시간 |
| location | 위치 정보 |
| location_lat | 위도 |
| location_lng | 경도 |
| order_index | 일정 순서 |

#### 4. 의견/댓글 테이블 (opinions)

계획에 대한 의견이나 댓글을 저장합니다.

| 필드 | 설명 |
|------|------|
| opinion_id | 의견 고유 ID (PK) |
| plan_id | 연관된 계획 ID (FK) |
| user_id | 작성자 ID (FK) |
| parent_id | 상위 의견 ID (대댓글용, FK) |
| content | 의견 내용 |
| content_type | 내용 타입 (텍스트, HTML) |
| created_at | 생성 시간 |
| updated_at | 수정 시간 |

### 시안 및 미디어 관련 테이블

#### 5. 시안 파일 테이블 (design_mockups)

계획에 첨부된 시안 파일 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| mockup_id | 시안 고유 ID (PK) |
| plan_id | 연관된 계획 ID (FK) |
| user_id | 업로더 ID (FK) |
| file_type | 파일 타입 (HTML, Figma 링크) |
| file_name | 파일 이름 |
| file_path | 파일 경로 |
| figma_link | Figma 링크 URL |
| created_at | 생성 시간 |
| updated_at | 수정 시간 |

#### 6. 의견 이미지 테이블 (opinion_images)

의견에 첨부된 이미지 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| image_id | 이미지 고유 ID (PK) |
| opinion_id | 연관된 의견 ID (FK) |
| image_path | 이미지 경로 |
| order_index | 이미지 순서 |
| created_at | 생성 시간 |

#### 7. 의견 Figma 링크 테이블 (opinion_figma_links)

의견에 첨부된 Figma 링크 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| link_id | 링크 고유 ID (PK) |
| opinion_id | 연관된 의견 ID (FK) |
| figma_link | Figma 링크 URL |
| created_at | 생성 시간 |

#### 8. 계획 이미지 테이블 (plan_images)

계획에 첨부된 추가 이미지 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| image_id | 이미지 고유 ID (PK) |
| plan_id | 연관된 계획 ID (FK) |
| image_path | 이미지 경로 |
| description | 이미지 설명 |
| order_index | 이미지 순서 |
| created_at | 생성 시간 |

### 소셜 및 분류 관련 테이블

#### 9. 태그 테이블 (tags)

계획에 적용할 수 있는 태그 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| tag_id | 태그 고유 ID (PK) |
| name | 태그 이름 (유니크) |
| created_at | 생성 시간 |

#### 10. 계획-태그 연결 테이블 (plan_tags)

계획과 태그 간의 다대다 관계를 정의합니다.

| 필드 | 설명 |
|------|------|
| plan_id | 계획 ID (PK, FK) |
| tag_id | 태그 ID (PK, FK) |
| created_at | 생성 시간 |

#### 11. 좋아요 테이블 (likes)

계획에 대한 좋아요 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| like_id | 좋아요 고유 ID (PK) |
| user_id | 사용자 ID (FK) |
| plan_id | 계획 ID (FK) |
| created_at | 생성 시간 |

#### 12. 북마크 테이블 (bookmarks)

사용자가 북마크한 계획 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| bookmark_id | 북마크 고유 ID (PK) |
| user_id | 사용자 ID (FK) |
| plan_id | 계획 ID (FK) |
| created_at | 생성 시간 |

#### 13. 팔로우 관계 테이블 (follows)

사용자 간의 팔로우 관계를 저장합니다.

| 필드 | 설명 |
|------|------|
| follow_id | 팔로우 고유 ID (PK) |
| follower_id | 팔로워 ID (FK) |
| following_id | 팔로잉 ID (FK) |
| created_at | 생성 시간 |

#### 14. 알림 테이블 (notifications)

사용자에게 전송되는 알림 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| notification_id | 알림 고유 ID (PK) |
| user_id | 알림 수신자 ID (FK) |
| type | 알림 유형 |
| related_user_id | 관련 사용자 ID (FK) |
| related_plan_id | 관련 계획 ID (FK) |
| related_opinion_id | 관련 의견 ID (FK) |
| content | 알림 내용 |
| is_read | 읽음 상태 |
| created_at | 생성 시간 |

#### 15. 카카오 인증 토큰 테이블 (kakao_tokens)

카카오 소셜 로그인에 사용되는 리프레시 토큰 정보를 저장합니다.

| 필드 | 설명 |
|------|------|
| token_id | 토큰 고유 ID (PK) |
| user_id | 사용자 ID (FK) |
| refresh_token | 카카오 리프레시 토큰 |
| expires_at | 토큰 만료 시간 |
| created_at | 생성 시간 |
| updated_at | 갱신 시간 |

#### 16. 계획 콘텐츠 섹션 테이블 (plan_sections)

계획의 상세 내용을 섹션별로 저장합니다. 대용량 마크다운/HTML 콘텐츠를 효율적으로 관리합니다.

| 필드 | 설명 |
|------|------|
| section_id | 섹션 고유 ID (PK) |
| plan_id | 연관된 계획 ID (FK) |
| title | 섹션 제목 |
| content | 섹션 내용 (LONGTEXT) |
| content_type | 내용 타입 (텍스트, HTML, 마크다운) |
| order_index | 섹션 순서 |
| created_at | 생성 시간 |
| updated_at | 수정 시간 |

#### 17. 계획 오디오 콘텐츠 테이블 (plan_audio)

계획 설명용 오디오 파일(팟캐스트, MP3 등)을 저장합니다.

| 필드 | 설명 |
|------|------|
| audio_id | 오디오 고유 ID (PK) |
| plan_id | 연관된 계획 ID (FK) |
| title | 오디오 제목 |
| description | 오디오 설명 |
| file_path | 오디오 파일 경로 |
| file_size | 파일 크기(바이트) |
| duration | 재생 길이(초) |
| audio_type | 오디오 유형 (팟캐스트, MP3, 기타) |
| order_index | 오디오 순서 |
| created_at | 생성 시간 |
| updated_at | 수정 시간 |

## 관계 다이어그램

```
users ---1:N---> plans ---1:N---> plan_schedules
  |          |
  |          |---1:N---> plan_images
  |          |
  |          |---1:N---> plan_sections
  |          |
  |          |---1:N---> plan_audio
  |          |
  |          |---M:N---> tags (via plan_tags)
  |          |
  |          O---1:N---> opinions ---1:N---> opinion_images
  |          |               |
  |          |               O---1:N---> opinion_figma_links
  |          |
  |          O---1:N---> design_mockups
  |          |
  |          O---1:N---> likes
  |          |
  O---1:N---> bookmarks
  |
  O---M:N---> users (via follows)
  |
  O---1:N---> notifications
  |
  O---1:N---> kakao_tokens
```

## 인덱스 정보

성능 최적화를 위해 다음과 같은 인덱스가 설정되어 있습니다:

1. 모든 외래 키(FK)에 인덱스 설정
2. 검색 및 정렬에 자주 사용되는 필드에 인덱스 설정
   - 계획 생성 시간 (plans.created_at)
   - 계획 인기도 (plans.views, plans.created_at)
   - 계획 섹션 순서 (plan_sections.plan_id, plan_sections.order_index)
   - 계획 오디오 순서 (plan_audio.plan_id, plan_audio.order_index)
   - 의견 생성 시간 (opinions.created_at)
   - 사용자 이름 (users.username)
   - 태그 이름 (tags.name)

## 데이터 무결성

데이터 무결성을 유지하기 위해 다음과 같은 방법을 사용합니다:

1. 모든 테이블에 고유 식별자(PK) 설정
2. 외래 키 제약 조건을 통한 참조 무결성 유지
3. ON DELETE CASCADE를 사용하여 연관 데이터 자동 삭제
4. UNIQUE 제약 조건을 통한 중복 데이터 방지 (사용자 이름, 이메일 등)

## 샘플 데이터

기본적인 테스트를 위한 샘플 데이터가 포함되어 있습니다:
- 샘플 사용자 (숲의 화가)
- 샘플 계획 (숲 속의 작은 집)
- 관련 태그 및 댓글 