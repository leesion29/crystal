# START 메뉴 검은 화면: 글꼴 전송 지연 개선

2026-10-10. 조사 기준 HEAD: `1cc01a580cf0f384efba7a808774591f98c62a39`.
상태: 첫 전송 최적화는 사용자가 실제 실행에서 차이가 없다고 보고했다.
후속으로 메뉴 게시 전 윈도 숨김을 수정했다. 후속 빌드/제한된 명령 검증은
완료했지만 실제 화면의 깜빡임 해소는 아직 런타임 미검증이다.

## 후속: 전송 속도보다 화면 게시 순서 (최신)

사용자 관찰: 첫 수정 후 차이가 없으며, 순정 ROM은 메뉴 진입 시 깜빡임이 없다.
따라서 아래 첫 조사에서 제시한 전송 지연 개선은 깜빡임 해결의 증거가 아니다.

순정 크리스탈의 START는 메뉴를 그려 BGMap0에 전송한 **뒤에**
`LoadFonts_NoOAMUpdate`로 BGMap1 윈도를 숨긴다.
한국어판은 동적 글꼴 캐시 보존을 위해 폰트 로딩을 앞으로 옮겼지만,
폰트 로딩에 포함된 윈도 숨김도 함께 앞당겼다. 그 결과 BGMap0이 아직
검정 타일인 동안 `hWY=$90`이 VBlank를 통해 게시되어 검은 배경이 노출된다.
이는 전송 속도가 빨라져도 사라지지 않는 전환 순서의 결함이다.

참조: [순정 START](https://github.com/pret/pokecrystal/blob/master/engine/menus/start_menu.asm),
[순정 윈도/폰트 전환](https://github.com/pret/pokecrystal/blob/master/engine/overworld/init_map.asm).

수정:

- `LoadFonts_KeepWindow_NoOAMUpdate`를 추가해 OAM 상태 보존과 폰트 준비를
  유지하되 `hWY`는 변경하지 않는다. 기존 함수와 다른 호출자는 그대로다.
- START에서 새 함수를 호출하고, 완성된 메뉴 전송 이후에만 `hWY=$90`을
  설정한다. `DelayFrame`으로 다음 VBlank에서 게시한 뒤 메뉴 입력으로 진입한다.
- 기존처럼 폰트는 캐시 글자 출력 **전**에 초기화한다. 순정 순서를 그대로
  되돌려 한글 글자를 덮어쓰는 회귀는 만들지 않는다.

첫 조사에서 지도/폰트 영역 공유를 이유로 윈도 유지를 배제한 판단은 너무 넓었다.
실제 `LoadTilesetGFX`는 지도 타일을 bank 0의 `$9000–$95ff`와 bank 1의
동일 주소에 각각 96개씩 배치한다. 한글/표준 캐시는 bank 0 `$8800–$8fff`다.
추가 프레임 글꼴은 bank 0 `$9600` 이상이다. 이 지도 표시 경로의 타일과
겹치지 않으므로 BGMap1 지도 윈도를 유지하면서 폰트를 준비할 수 있다.

검증:

- 일반·디버그 빌드 성공. 기존 미매핑 `~` 경고 유지.
- `verify_start_menu_window.py`로 두 ROM의 실제 START/폰트 래퍼 명령 실행:
  일반/대회 분기와 초기 OAM 값 0/1/2의 6개 조건, 뱅크/OAM 복원,
  폰트→캐시 그리기→메뉴 전송→윈도 숨김 순서 확인.
- 이전 폰트 함수를 앞에서 호출하도록 변경한 오류 ROM은
  `map window hidden before menu publication`로 거부된다.
- 두 ROM의 기존 TM/HM 캐시 반복 출력, 글꼴 전송 타이밍 9,058개 조건,
  동행/아이콘 278개 자료 검증 통과. 일반 ROM의 상태 페이지/배틀 복귀와
  폰트 PNG→ROM 일치 검사도 통과했다.
- 그래픽/메뉴 그리기 도우미와 프레임 경계는 모델링한다. 실제 PPU 표시,
  메뉴 내용/설명 전체 및 실제 실행의 깜빡임 해소를 증명하는 검사는 아니다.

후속 최종 ROM SHA256 (아래 첫 수정 ROM과 구별):

- 일반: `5de6141d02a257a9e664f4280129bd23fa9c62e62a8e3cd7f81f8cb414ee5c0f`
- 디버그: `fe928c9f504c555fcf34452e66b861d78452de1a0bf4ac2dceb6738b5de7cc5e`

아래는 첫 수정의 조사/검증 기록이며, 깜빡임 해결 기록으로 해석하지 않는다.

## 관찰과 원인 구분

- 사용자 관찰: START 메뉴를 열면 약 1초 검은 화면이 보인다. 첨부 화면에는
  플레이어/동행 스프라이트와 일부 지도/창 테두리가 남고 배경이 검게 보인다.
- 코드 확인: `StartMenu` → `ReanchorBGMap_NoOAMUpdate`는 지도를 BGMap1에
  복사해 윈도로 표시하고 BGMap0을 검정 타일로 채운다.
  `LoadFonts_NoOAMUpdate`가 윈도를 숨긴 뒤 표준 폰트를 올린다.
  `DrawVariableLengthMenuBox`의 한글 글자 준비가 끝난 뒤
  `HDMATransferTilemapAndAttrmap_Menu`가 완성된 메뉴를 전송한다.
- 코드 확인: 글꼴 캐시 미스 → `_PlaceHangul`(DI) → `CopyHangulTilesToVRAM`
  → `HDMATransfer_HangulFontToVRAM`. 수정 전에는 LY가 정확히 144일 때만
  32바이트 복사를 시작했다. 한 번의 복사만으로 이 한 줄을 지나면 다음
  글자는 다음 프레임까지 대기한다. 메뉴는 표준 문자도 공유 캐시를 사용한다.
- 추정: 위 화면 비우기와 글자당 대기가 결합해 사용자가 본 긴 검은 화면을
  만든다. 전송 병목은 소스/명령 실행으로 확인했지만 실제 메뉴에서 소요 시간의
  각 항목을 계측하지 않았으므로 첨부 현상의 유일한 원인이라고 단정하지 않는다.

## 채택한 수정과 영향

1. 화면 전환 순서, 메뉴 구조, 글꼴 캐시/버퍼는 보존한다. 지도와 폰트가
   VRAM 타일 영역을 공유하므로 단순히 윈도를 계속 표시하는 수정은 채택하지 않았다.
2. `engine/hangul/text.asm`의 32바이트 복사를 REPT로 펼쳐 루프 비용을 줄인다.
   복사 원본/목적지, 양, VRAM bank 0 선택과 원래 bank 복원은 동일하다.
   BC=0, DE/HL의 32바이트 증가도 보존한다. 외부 래퍼가 AF/BC/DE/HL을 복원한다.
3. 시작 가능 구간을 LY 144–150으로 넓힌다. 151 이상은 기존처럼 다음 프레임을
   기다린다. LY 읽기부터 반환까지 1000 T-cycle 미만이며, LY 150의 마지막에서
   시작해도 보통 속도에서 최소 3줄(1368 dots)이 남는다. 인터럽트 차단은
   유일한 생산 호출자인 `_PlaceHangul`의 기존 DI 구간에 의존한다.
4. LCD-off 즉시 복사 경로는 보존한다. 공유 전송 루틴이므로 다른 한글 화면의
   캐시 미스도 빨라진다. 문장 지연/입력/줄바꿈/종료 코드는 변경하지 않는다.

타이밍 근거: [Pan Docs Rendering](https://github.com/gbdev/pandocs/blob/master/src/Rendering.md),
[CGB Registers](https://github.com/gbdev/pandocs/blob/master/src/CGB_Registers.md).
수정은 CGB의 보통/배속 두 CPU 속도를 모두 고려한다.

## 검증

빌드: `make -j2 RGBDS=rgbds-1.0.0/ crystal crystal_debug` 성공.
기존 `data/text/std_text.asm:155`의 미매핑 `~` 경고는 남아 있다.

`tools/verify_hangul_upload_timing.py ROM SYM`은 최종 ROM의 SM83 명령을
제한된 사이클 모델로 실행한다. 정상/배속, 초기 VRAM bank 0/1,
VBlank 전후 4 T-cycle 단위 시작 위상과 프레임 전체 표본, LCD-off를 검사한다.
각 ROM 9,058개 조건에서 32바이트 값/주소, VBlank 안의 모든 쓰기,
bank 복원과 반환을 확인한다. 허용 시점을 154로 넓힌 고의적 오류도 거부한다.
PPU 전체/인터럽트/메뉴 전체 실행은 모델링하지 않으며 에뮬레이터 증거가 아니다.

54개 연속 캐시 미스에 호출 사이 비용을 1000 T-cycle로 고정한 비교:

| 조건 | 보존된 이전 ROM | 수정 ROM |
|---|---:|---:|
| 보통 속도 | 0.888초 | 0.436초 |
| CGB 배속 | 0.888초 | 0.218초 |

이전 ROM은 `.verification/tmhm-20261010/pokecrystal.gbc`와 동명 SYM을 사용했다.
이는 전송 루틴 비교 모델값이며 실제 START 메뉴의 글자 수/소요 시간 측정이 아니다.

기존 제한된 검증: 일반·디버그 TM/HM 이름/캐시 반복 재출력 통과.
일반 ROM의 상태 페이지/배틀 복귀, 동행/아이콘 278개 자료, 아이템 이름·설명,
랜드마크 이름 검증 통과. 폰트 2816자/45056바이트도 기존 PNG와 일치한다.
번역 문자열, 기술 이름, RAM/SRAM 정의, 참조 골드 자료는 수정하지 않았다.

최종 ROM SHA256:

- 일반: `1002198c8db684d247f158e7ef3e28c7a5a05cb7251aee603d5cb82750c1f18b`
- 디버그: `378b36d0e622886d87f33c36437243c357539c726ef7cecc16cc24c3ed282415`

실행 검증 미실시: 일반/벌레잡기대회/통신 조건의 메뉴 진입·종료·재진입,
메뉴 설명 켬/끔, 한글 대화 및 상태/배틀 화면의 실제 표시.
검은 전환 자체를 없애는 수정이 아니라 확인된 전송 병목을 줄이는 수정이다.
