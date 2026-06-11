# 개발 프롬프트 기록

Focus Matrix 앱을 만들면서 사용한 프롬프트 순서입니다.

---

## 1. 초기 구현 요청 — PRD 전달

아래 PRD 전문을 그대로 전달하여 전체 Xcode 프로젝트 생성을 요청했습니다.

```
# PRD — Eisenhower Matrix for macOS

## 1. 제품 개요

### 제품명
Eisenhower Matrix

### 한 줄 설명
해야 할 일을 중요도와 긴급도로 분류하여 사용자가 가장 가치 있는 일에 집중하도록 돕는 macOS 생산성 앱

### 비전
많은 생산성 앱은 할 일을 "나열"하는 데 집중한다.
하지만 실제 문제는 일이 많아서가 아니라 무엇을 해야 하는지 판단하지 못하는 것이다.
본 제품은 아이젠하워 매트릭스를 기반으로 사용자가 다음 질문에 답하도록 돕는다.
"지금 가장 중요한 일은 무엇인가?"

---

## 2. 핵심 목표

### 사용자 목표
- 해야 할 일을 빠르게 정리하고
- 중요도와 긴급도를 기준으로 판단하며
- 가장 가치 있는 행동을 선택하도록 돕는다.

### 비즈니스 목표
- 하루 3회 이상 앱 재방문
- 매트릭스 기반 작업 분류 습관 형성
- macOS 생산성 앱 시장 진입

---

## 3. 핵심 철학

### Quadrant 1 — 중요 + 긴급 → 즉시 수행
예시: 오늘 마감 업무, 장애 대응, 제출 직전 과제

### Quadrant 2 — 중요 + 긴급하지 않음 → 계획하고 투자
예시: 운동, 독서, 학습, 장기 프로젝트
※ 사용자가 가장 많은 시간을 보내야 하는 영역

### Quadrant 3 — 긴급 + 중요하지 않음 → 위임 또는 최소화
예시: 불필요한 회의, 대부분의 알림

### Quadrant 4 — 중요하지도 긴급하지도 않음 → 제거
예시: 목적 없는 SNS, 의미 없는 반복 작업

---

## 4. 타겟 사용자

Primary: 개발자, 디자이너, 기획자, 학생, 창업가
Secondary: ADHD 성향 사용자, 생산성 매니아, GTD 사용자

---

## 5. 핵심 사용자 시나리오

시나리오 1 — 아침에 오늘 할 일 정리
시나리오 2 — 업무 중 급한 요청 추가 후 분류
시나리오 3 — 저녁 회고 (오늘 시간을 Q1~Q4 어디에 썼는지 확인)

---

## 6. MVP 범위

- 작업 생성: 제목(필수), 메모/마감일(선택)
- 작업 수정: 제목, 메모, 중요도, 긴급도 변경
- 작업 삭제: 소프트 삭제
- 드래그 앤 드롭: Q1~Q4 영역 사이 이동
- 완료 처리: 체크박스, 완료 시 Completed 섹션 이동
- 로컬 저장: SwiftData, 앱 재실행 시 유지

---

## 7. 핵심 화면

### 메인 화면
┌─────────────┬─────────────┐
│ Q1 Do Now   │ Q2 Schedule │
├─────────────┼─────────────┤
│ Q3 Delegate │ Q4 Eliminate│
└─────────────┴─────────────┘

### 작업 생성 모달 (Cmd+N)
입력: 제목, 설명, 중요도, 긴급도

### 완료 작업 화면
필터: 오늘 / 이번 주 / 전체

---

## 8. macOS UX 요구사항

- 메뉴바 앱 지원 (MenuBarExtra)
- 글로벌 단축키 Cmd+Shift+Space (어디서든 작업 추가)
- 단축키: Cmd+N 새 작업 / Cmd+F 검색 / Delete 삭제 / Space 완료 처리
- Drag & Drop SwiftUI Native 지원

---

## 9. 디자인 가이드

- 방향: Apple Notes + Reminders + Things 3
- 스타일: 미니멀, 집중형, 정보 밀도 낮음, 시각적 피로 최소화
- 컬러: Q1 Red / Q2 Blue / Q3 Orange / Q4 Gray
- Glassmorphism 금지, 과도한 그림자 금지
- Typography: SF Pro 계층 사용

---

## 10. 데이터 모델

@Model final class Task {
    var id: UUID
    var title: String
    var note: String?
    var isImportant: Bool
    var isUrgent: Bool
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    var dueDate: Date?
}

---

## 11. 성공 지표

- Engagement: DAU, 작업 생성 수, 완료율
- Productivity: Q2 작업 비율 증가, Q4 작업 비율 감소
- Retention: 7일 유지율, 30일 유지율

---

## 12. 미래 기능

- 통계 (시간 사용 분석)
- Focus Mode (현재 Quadrant만 표시)
- AI 분류 ("운동하기" 입력 시 중요+긴급하지않음 추천)
- AI 코치 ("오늘의 가장 중요한 일은 무엇인가요?" 매일 질문)
- 캘린더 연동 (Apple Calendar, Google Calendar)
- iPhone / iPad 동기화 (CloudKit)

---

## 13. 기술 스택

UI: SwiftUI
데이터: SwiftData
동기화: CloudKit
단축키: KeyboardShortcuts
메뉴바: MenuBarExtra
최소 지원 버전: macOS 15+
```

**결과:** SwiftUI + SwiftData + MenuBarExtra 기반 전체 Xcode 프로젝트 생성 (macOS 15+ 타겟)

---

## 2. 버전 호환성 수정

```
지금 내 컴퓨터 버전 기준으로 수정해줘.
```

**결과:**
- Xcode 14.2 / macOS 13.1 SDK 환경에 맞게 전면 수정
- SwiftData → `ObservableObject` + JSON 파일 저장으로 교체
- `@Bindable` / `@Query` / `#Predicate` 제거
- 배포 타겟 15.0 → 13.0으로 변경
- Swift 5.7 문법 호환 (`switch` 케이스 `return` 명시 등)

---

## 3. 마감 시간 + 알림 설정 추가

```
지금 날짜만 추가할 수 있는데 시간도 선택할 수 있게 해줘.
그리고 나중에 알림 기능 추가하고 싶으니까 몇분전 알림도 선택할 수 있게 해줘.
```

**결과:**
- `DatePicker`를 `.date` → `[.date, .hourAndMinute]`로 변경
- 기본값 오늘 오후 6시로 설정
- 알림 옵션 Picker 추가 (없음 / 5분 전 / 10분 전 / 15분 전 / 30분 전 / 1시간 전 / 2시간 전 / 1일 전)
- 선택 시 실제 알림 발송 시각 미리보기 표시
- `TaskItem`에 `notifyMinutesBefore: Int?` 필드 추가
- 카드에 마감 시각(날짜+시간) 및 알림 아이콘 표시

---

## 4. 깃허브 업로드 준비

```
지금 파일 중에 깃허브 올라가면 안되는 파일 있는지 알려줘.
그리고 지금 만든 내용 리드미에 간단하게 정리해주고.
docs 폴더 만들어서 여기까지 만드는데 사용한 프롬프트 작성해줘.
```

**결과:**
- `.gitignore` 생성 (Xcode xcuserdata, .DS_Store 등 제외)
- README.md 작성
- `docs/prompts.md` 작성 (현재 파일)

**깃허브 제외 파일:**

| 파일 | 이유 |
|------|------|
| `.DS_Store` | macOS Finder 메타데이터, 개인 환경 정보 |
| `xcuserdata/` | Xcode 개인 설정 (창 레이아웃, 브레이크포인트 등) |
| `*.xcuserstate` | Xcode UI 상태 (열린 파일, 탭 등), 바이너리라 diff 불가 |
| `xcschememanagement.plist` | 스킴 순서 등 개인 설정 |
| `DerivedData/` | 빌드 산출물 |

---

## 5. README 개선 + 프롬프트 기록 업데이트

```
우리가 처음에 넣었던 프롬프트 내용 정리해서 프롬프트 md에 저장해주고,
리드미는 기능 소개 프로젝트 소개 프로젝트 환경 등을 요약해서 써줘.
```

**결과:**
- `docs/prompts.md`에 최초 PRD 전문 포함하여 재작성
- README.md를 프로젝트 소개 / 주요 기능 / 환경 / 구조 중심으로 재작성
