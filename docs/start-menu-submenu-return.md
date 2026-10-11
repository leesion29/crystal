# 서브메뉴 복귀 시 임시 영문 타일 노출

## 원인과 범위

사용자는 가방 등에서 스타트 메뉴로 복귀할 때 약 1초 동안 `AC / BD` 등의
영문 배열이 보인다고 보고했다. 정확한 노출 시간은 계측하지 않았다.

현재 코드의 `CloseSubmenu`는 `ReloadTilesetAndPalettes`로 기본 글꼴과 한글
캐시를 초기화한 뒤, `Call_ExitMenu`로 백업한 타일 번호/속성을 복원한다.
백업에는 글리프 VRAM이 포함되지 않는다. `FinishExitMenu`는 이 상태를
전송하고 페이드인하며, 실제 메뉴 문자열은 이후 `StartMenu.GetInput`의
`SetUpMenu`에서 다시 작성된다.

한글 캐시의 첫 두 쌍 `$80/$81`, `$82/$83`은 기본 글꼴의 A/B, C/D와 같다.
따라서 상단 AC, 하단 BD 형태는 이 순서상의 불일치로 설명된다.
호출 순서와 매핑은 코드 확인이며 실제 프레임별 노출은 미검증이다.

## 적용한 변경

`engine/menus/start_menu.asm`에 스타트 메뉴 전용 `StartMenu.CloseSubmenu`를
추가했다. 일반 복귀의 기존 지도/스프라이트/창 복원 순서를 유지하되,
페이드인 전에 메뉴 항목 목록과 커서를 복구하고 `SetUpMenu`로 문자열을
재작성·전송한다. 대회 상태 영역도 다시 작성한 뒤 기존 팔레트 복귀 및
`FinishExitMenu`로 최종 화면을 전송하고 밝힌다.

가방(도구 미사용), 도감, 포켓기어, 트레이너 카드, 포켓몬 목록의 복귀를
이 루틴에 연결했다. 설정 화면의 기존 `StartMenu.Clear`도 같은 재작성
단계를 사용한다. 도구 사용/필드 기술 등 메뉴를 종료하는 분기는 그대로다.
공용 `home/map.asm`의 `CloseSubmenu`와 상점·PC·통신 등의 호출자는 변경하지 않았다.

추가 검은 화면이나 별도 지연 명령은 넣지 않았다. 기존 복귀의 흰 팔레트
구간에 글리프 준비와 전송을 배치했으므로 이 구간의 체감 시간은 실제
화면에서 확인해야 한다. 기존 입력 초기화 단계의 재작성은 유지했으며,
이미 준비한 글리프를 재사용한다. 버퍼, RAM, 문자열, 메뉴 반환 값은 동일하다.

## 검증 (2026-10-11)

- 일반·디버그 `make -j2 RGBDS=rgbds-1.0.0/ crystal crystal_debug` 성공.
- `tools/verify_start_menu_return.py`: 두 ROM 각각 12개 복귀 검사 통과.
  조립된 전용 복귀/설정 복귀 루틴, `SetUpMenu`, `MenuWriteText`,
  `FinishExitMenu`를 제한된 CPU 모델에서 실행한다. 그래픽/팔레트 보조
  루틴은 모델링한다. 커서 복구, 창 복원 1회, 페이드인 전 문자열 작성 및
  전송, 대회 분기와 5개 서브메뉴 호출 연결을 검사했다. 문자열 재작성을
  제거한 변이 ROM은 검사에서 거부됐다.
- 기존 `verify_start_menu_window.py`, `verify_pack_clear.py`,
  `verify_tmhm_text.py`는 두 ROM 모두 통과.
- `git diff --check` 통과.
- 기존 `data/text/std_text.asm:155`의 미등록 `~` 경고는 남는다.

최종 ROM SHA-256:

- 일반: `aeef6a3b68c3a4c57cade1294286de99af1c20262a308ce0cae7b4b0904f724b`
- 디버그: `d6bab677970251cfd63e47ab085cb573066cdb874546a5751726050295cceb23`

PPU/에뮬레이터 실행은 하지 않았다. 실제 영문 노출 제거, 전환 시간,
팔레트·배경·커서의 시각적 정상 여부는 아직 런타임 확인 전이다.
