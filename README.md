# Focus Matrix

> "지금 가장 중요한 일은 무엇인가?"

아이젠하워 매트릭스 기반 macOS 생산성 앱입니다.  
할 일을 **중요도 × 긴급도** 4분면으로 분류해, 해야 할 일의 우선순위를 빠르게 판단할 수 있도록 돕습니다.

---

## 프로젝트 소개

많은 할 일 앱은 작업을 *나열*하는 데 집중합니다.  
Focus Matrix는 다릅니다. 작업마다 **"중요한가? 긴급한가?"** 두 가지 질문에 답하게 함으로써,
지금 당장 해야 할 일과 나중으로 미뤄도 되는 일을 구분합니다.

| 분면 | 기준 | 행동 |
|------|------|------|
| **Q1 Do Now** | 중요 + 긴급 | 즉시 수행 |
| **Q2 Schedule** | 중요 + 긴급하지 않음 | 계획하고 투자 |
| **Q3 Delegate** | 긴급 + 중요하지 않음 | 위임 또는 최소화 |
| **Q4 Eliminate** | 중요하지도 긴급하지도 않음 | 제거 |

---

## 주요 기능

### 매트릭스 뷰
- 4분면 레이아웃으로 전체 작업을 한눈에 확인
- 카드를 끌어다 놓아 다른 분면으로 이동 (드래그 앤 드롭)
- 분면별 색상 구분 (빨강 / 파랑 / 주황 / 회색)

### 작업 관리
- **⌘N** 으로 빠른 작업 추가
- 제목, 메모, 중요도/긴급도 설정
- 마감 **날짜 + 시간** 설정 (기본값: 오늘 오후 6시)
- 알림 시간 설정 — 5분 전 / 10분 전 / 15분 전 / 30분 전 / 1시간 전 / 2시간 전 / 1일 전
- 우클릭 컨텍스트 메뉴로 수정 / 삭제

### 완료 목록
- 완료된 작업을 별도 탭에서 관리
- Today / This Week / All 필터
- 완료 취소로 다시 매트릭스로 복귀

### 메뉴바 앱
- 상태바 아이콘 클릭 시 Q1·Q2 작업 빠른 확인
- 메뉴바에서 바로 작업 추가 가능

---

## 단축키

| 단축키 | 동작 |
|--------|------|
| `⌘N` | 새 작업 추가 |
| `⌘↩` | 작업 저장 (모달 내) |
| `Esc` | 모달 닫기 |

---

## 프로젝트 환경

| 항목 | 버전 |
|------|------|
| Xcode | 14.2 이상 |
| macOS (실행) | 13.0 Ventura 이상 |
| Swift | 5.7 이상 |
| UI 프레임워크 | SwiftUI |
| 데이터 저장 | `ObservableObject` + JSON 파일 |
| 저장 경로 | `~/Library/Application Support/FocusMatrix/tasks.json` |

> SwiftData(macOS 14+) 대신 Codable + JSON 저장 방식을 사용합니다.
> Xcode 15+ 환경으로 업그레이드 시 SwiftData로 마이그레이션 가능합니다.

---

## 프로젝트 구조

```
FocusMatrix/
├── FocusMatrixApp.swift          # 앱 진입점, MenuBarExtra
├── ContentView.swift             # Matrix / Completed 탭 전환
├── Models/
│   ├── TaskItem.swift            # 데이터 모델 (Codable) + Quadrant enum
│   └── TaskStore.swift           # 상태 관리 및 JSON 영속성
├── Views/
│   ├── MatrixView.swift          # 2×2 그리드 레이아웃
│   ├── QuadrantView.swift        # 개별 분면 (드롭 대상)
│   ├── TaskCardView.swift        # 작업 카드 (드래그 소스)
│   ├── AddTaskView.swift         # 작업 생성 / 수정 Sheet
│   └── CompletedView.swift       # 완료 목록
└── MenuBar/
    └── MenuBarContentView.swift  # 메뉴바 팝업 뷰
```

---

## 실행 방법

```bash
# 1. 저장소 클론
git clone https://github.com/WOWAIST/Focus_matrix.git

# 2. Xcode에서 열기
open Focus_matrix/FocusMatrix.xcodeproj
```

3. 타겟을 **My Mac** 으로 선택 후 `⌘R` 실행

---

## 로드맵

- [ ] `UNUserNotificationCenter` 연동 — 알림 UI는 이미 구현됨
- [ ] 통계 — Q별 시간 사용 분석
- [ ] Focus Mode — 현재 분면만 표시
- [ ] AI 자동 분류 — 입력 내용 기반 분면 추천
- [ ] CloudKit 동기화 — iPhone / iPad 연동

---

## 라이선스

MIT
