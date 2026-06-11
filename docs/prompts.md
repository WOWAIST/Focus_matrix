# 개발 프롬프트 기록

Focus Matrix 앱을 만들면서 사용한 프롬프트 순서입니다.

---

## 1. 초기 구현 요청

**PRD 전달 후:**

```
(PRD 전문 — 제품 개요, 핵심 철학, 타겟 사용자, MVP 범위, 핵심 화면,
macOS UX 요구사항, 디자인 가이드, 데이터 모델, 기술 스택 포함)
```

→ SwiftUI + SwiftData + MenuBarExtra 기반의 전체 Xcode 프로젝트 생성  
→ `project.pbxproj` 포함 10개 파일 생성, macOS 15+ 타겟

---

## 2. 버전 호환성 수정

```
지금 내 컴퓨터 버전 기준으로 수정해줘.
```

→ Xcode 14.2 / macOS 13.1 SDK 환경에 맞게 전면 수정  
→ SwiftData → `ObservableObject` + JSON 파일 저장으로 교체  
→ `@Bindable` / `@Query` / `#Predicate` 제거  
→ 배포 타겟 15.0 → 13.0으로 변경  
→ Swift 5.7 문법 호환 (`switch` 케이스 `return` 명시 등)

---

## 3. 마감 시간 + 알림 설정 추가

```
지금 날짜만 추가할 수 있는데 시간도 선택할 수 있게 해줘.
그리고 나중에 알림 기능 추가하고 싶으니까 몇분전 알림도 선택할 수 있게 해줘.
```

→ `DatePicker` 컴포넌트를 `.date` → `[.date, .hourAndMinute]`로 변경  
→ 기본값 오늘 오후 6시로 설정  
→ 알림 옵션 Picker 추가 (없음 / 5분 전 / 10분 전 / 15분 전 / 30분 전 / 1시간 전 / 2시간 전 / 1일 전)  
→ 선택 시 실제 알림 발송 시각 미리보기 표시  
→ `TaskItem`에 `notifyMinutesBefore: Int?` 필드 추가  
→ 카드에 마감 시각(날짜+시간) 및 알림 아이콘 표시

---

## 4. 깃허브 업로드 준비

```
지금 파일 중에 깃허브 올라가면 안되는 파일 있는지 알려줘.
그리고 지금 만든 내용 리드미에 간단하게 정리해주고.
docs 폴더 만들어서 여기까지 만드는데 사용한 프롬프트 작성해줘.
```

→ `.gitignore` 생성 (Xcode xcuserdata, .DS_Store 등 제외)  
→ README.md 작성 (기능 목록, 기술 스택, 프로젝트 구조, 로드맵)  
→ `docs/prompts.md` 작성 (현재 파일)

---

## 제외 대상 파일 (gitignore 처리됨)

| 파일 | 이유 |
|------|------|
| `.DS_Store` | macOS Finder 메타데이터, 개인 환경 정보 |
| `xcuserdata/` | Xcode 개인 설정 (창 레이아웃, 브레이크포인트 등) |
| `*.xcuserstate` | Xcode UI 상태 (열린 파일, 탭 등), 바이너리라 diff 불가 |
| `xcschememanagement.plist` | 스킴 순서 등 개인 설정 |
| `DerivedData/` | 빌드 산출물 |
