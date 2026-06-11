# Focus Matrix

아이젠하워 매트릭스 기반 macOS 생산성 앱.  
할 일을 **중요도 × 긴급도** 4분면으로 분류해 "지금 가장 중요한 일"에 집중하도록 돕습니다.

---

## 스크린샷

> 추후 추가 예정

---

## 기능

| 기능 | 설명 |
|------|------|
| 4분면 매트릭스 | Q1 Do Now / Q2 Schedule / Q3 Delegate / Q4 Eliminate |
| 드래그 앤 드롭 | 카드를 끌어다 다른 분면으로 이동 |
| 마감 일시 | 날짜 + 시간 설정, 지난 마감은 빨간색 표시 |
| 알림 설정 | 5분 전 ~ 1일 전 중 선택 (알림 기능 연동 예정) |
| 완료 처리 | 체크 시 Completed 탭으로 이동, Today / This Week / All 필터 |
| 메뉴바 앱 | 상태바 아이콘 클릭 시 Q1·Q2 작업 빠른 확인 및 추가 |
| 로컬 저장 | JSON 파일 (`~/Library/Application Support/FocusMatrix/tasks.json`) |

### 단축키

| 단축키 | 동작 |
|--------|------|
| `⌘N` | 새 작업 |
| `⌘W` | 창 닫기 |
| `Esc` | 모달 취소 |
| `⌘↩` | 작업 저장 |

---

## 기술 스택

- **UI** — SwiftUI
- **데이터** — `ObservableObject` + JSON 파일 저장 (Codable)
- **메뉴바** — `MenuBarExtra` (macOS 13+)
- **드래그 앤 드롭** — SwiftUI `.draggable` / `.dropDestination`
- **최소 지원 버전** — macOS 13.0 / Xcode 14.2+

---

## 프로젝트 구조

```
FocusMatrix/
├── FocusMatrixApp.swift          # App entry, MenuBarExtra
├── ContentView.swift             # Matrix / Completed 탭
├── Models/
│   ├── TaskItem.swift            # 데이터 모델 + Quadrant enum
│   └── TaskStore.swift           # ObservableObject, JSON 영속성
├── Views/
│   ├── MatrixView.swift          # 2×2 그리드
│   ├── QuadrantView.swift        # 분면 (drop destination)
│   ├── TaskCardView.swift        # 카드 (draggable)
│   ├── AddTaskView.swift         # 작업 생성/편집 Sheet
│   └── CompletedView.swift       # 완료 목록
└── MenuBar/
    └── MenuBarContentView.swift  # 메뉴바 팝업
```

---

## 실행 방법

1. Xcode 14.2 이상에서 `FocusMatrix.xcodeproj` 열기
2. 타겟을 **My Mac** 으로 선택
3. `⌘R` 실행

---

## 로드맵

- [ ] `UNUserNotificationCenter` 연동 (알림 발송)
- [ ] 통계 — Q별 시간 사용 분석
- [ ] Focus Mode — 현재 분면만 표시
- [ ] AI 자동 분류
- [ ] CloudKit 동기화 (iPhone / iPad)

---

## 라이선스

MIT
