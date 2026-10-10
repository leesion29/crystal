# 포켓몬 크리스탈 한국어화 인수인계

작성일: 2026-10-10. 실제 Git 프로젝트 루트: `C:\Users\LeeSion\Desktop\crystal-to-korean\crystal`.

## 최신 후속 작업 상태 (2026-10-10)

최신 추가 작업: 사용자 승인으로 TM31 이름 189번만 `진흙뿌리기`로 교정했다.
종료 없는 고정 길이 이름 복사, TM 이름 인덱스 전달, 백업 길이 및 가방→전투
글꼴/캐시 복귀 경로를 수정했다. 다섯 임시 문자열 버퍼는 22바이트이며 백업은
기존 미사용 지도 임시 영역에 있다. SRAM 레코드/주소는 동일하다.
일반·디버그 빌드와 기존/신규 정적 검증 통과. 캔슬 반복 입력의 실제 재현은
미실시이며 런타임 해결은 미확정이다. 상세 근거와 검사 한계는
`docs/tmhm-name-and-cache-fix.md`를 읽는다. 다른 기술 이름 및 `common_2.asm`은 보존했다.

아래 기존 인수인계 본문은 수정 전 조사 기록이다. 후속 세션에서 사용자가
② → ⑤ → ① → ③ → ④ 구현을 승인했다. 최신 결과는
`docs/stats-screen-five-bugs-investigation-plan.md` §7을 우선한다.

- ① 배틀 타일 `$00–$54` 전체 보존 및 VRAM bank 복원 수정.
- ② 동행 section 분할과 MBC3 bank 상한 assertion 추가. 통통코/토게피를
  포함한 모든 ROMX가 일반·디버그 모두 `$7f` 이내이며 두 ROM 모두 2 MiB.
- ③ 번호/포케러스 마침표를 올바른 캐시 경로로 출력.
- ④ 세 페이지의 오른쪽 속성맵 재구성과 프레임 팔레트 덮어쓰기 수정.
- ⑤ 공통 뱅크 후보는 제거했으나 자연 부화 정지의 별도 원인은 미확정.
  `breeding.asm`은 추측 수정하지 않았다. 에뮬레이터 실행 검증은 사용자 몫으로 대기.
- 전체 파생 그래픽 재생성에서 발견한 한글 8×16 폰트 타일 순서 결함을
  Makefile의 기존 interleave 도구로 수정했다. 폰트 PNG/그림/문자표는 동일하고
  최종 폰트 바이트는 이전 정상 ROM과 전부 일치한다.
- 일반·디버그 빌드/후처리, 278개 자료/포인터/압축 검사, 수정 루틴의 제한된
  최종 ROM 명령 검사, RAM 주소/기존 폰트/사용자 기술 이름 보존 검사 통과.
  기존 `std_text.asm:155`의 `~` 경고는 남으며 실제 실행 성공을 주장하지 않는다.
- 테스트 대상은 루트 `pokecrystal.gbc` / `pokecrystal_debug.gbc`다.
  원래 ROM 사본은 `.verification/five-bugs-20261010/`에 보존했다.

이하 “승인 대기”, “이번 인수인계 요청은 문서 작성만 허용” 등은 이전 단계의
상태이며 현재 구현을 금지하는 최신 지시가 아니다. 기술 이름/세이브 보호와
중간 사용자 수동 테스트를 요구하지 않는 조건은 계속 유효하다.

## 0. 새 세션에서 먼저 알아야 할 사항

- 이번 인수인계 요청은 **문서 작성만** 허용한다. 아래 다섯 버그는 조사·계획 단계이며 수정 승인 대기 중이다. 새 세션에서도 먼저 계획서를 읽고 사용자 승인을 받은 뒤 구현한다.
- 우선 읽을 문서는 `docs/stats-screen-five-bugs-investigation-plan.md`, 그다음 `docs/stats-screen-eastern-layout-plan.md`이다. 오래된 계획서의 미완료 항목은 현재 코드와 대조해야 한다.
- 사용자가 수정한 `data/moves/names.asm`을 보호한다. 기술 이름 번역·동기화는 이번 버그 수정 범위가 아니다.
- 사용자는 모든 수정이 끝난 뒤 에뮬레이터에서 직접 테스트한다. 중간 수동 테스트를 요구하지 않는다. 빌드·정적 검증과 실제 실행 검증을 구분한다.
- 참고 폴더는 참고 자료일 뿐이다. `oldgold`나 `original-gold`가 없어도 Crystal 소스와 필요한 자산만으로 복구·빌드할 수 있어야 한다.

문서의 **코드 확인**은 현재 소스에서 확인한 사실, **사용자 확인**은 대화에서 보고된 실행 결과, **추정**은 아직 실행 원인을 확정하지 못한 설명을 뜻한다. 이전 빌드 성공 기록을 현재 버그 해결 또는 현재 소스 전체의 실행 검증으로 간주하지 않는다.

## 1. 저장소 기준점과 보존할 변경

조사 당시 브랜치는 `main`, HEAD는 `8936690` (`Fix Build Bugs`), 원격은 `https://github.com/leesion29/crystal.git`이다. 앞선 주요 커밋은 `67c8f1c` (Cherrygrove 번역), `903879b` (배틀 화면), `6f0ceb6` (도감 정렬), `ee2261a` (도감 한국어화), `de20b8f` (포켓몬 이름 한국어화)이다.

`HANDOFF.md` 생성 전 작업 트리에는 다음 변경이 있었다. 모두 기존 변경으로 보존해야 하며, 이 문서를 작성하면서 수정하거나 되돌리지 않았다.

```text
수정됨:
data/moves/names.asm
engine/battle/korean_move_text.asm
engine/gfx/cgb_layouts.asm
engine/gfx/load_font.asm
engine/pokemon/mon_stats.asm
engine/pokemon/stats_screen.asm
gfx/sgb/blk_packets.asm

추적되지 않음:
data/items/stats_names.asm
docs/stats-screen-eastern-layout-plan.md
docs/stats-screen-five-bugs-investigation-plan.md
gfx/stats/korean_move_heading.asm
gfx/stats/korean_page_guide.asm
```

특히 새 파일들은 커밋되지 않은 상태이므로 GitHub의 HEAD만으로 현재 상태창 이식 작업이 복구되는 것은 아니다. 새 세션으로 넘길 때 작업 트리 전체를 유지해야 한다. 커밋·푸시는 별도 사용자 요청 없이 수행하지 않는다.

사용자 기술 이름 파일의 조사 당시 SHA-256:

```text
data/moves/names.asm
3d95c6b6da3cee10575c23c65309a79b7788fb4705efd8a1c11c2ce068317843
```

## 2. 프로젝트 개요와 설계 원칙

기반은 Pokémon Crystal 디스어셈블리이며, 이미 동행 포켓몬·디버그 등 개조 기능이 있는 프로젝트다. 순수 원본 소스라고 전제하지 않는다. 목표는 Crystal의 시스템을 유지하면서 전체 한국어 출력과 한국어판에 자연스러운 UI를 구현하는 것이다.

- `oldgold`: 앞서 서양판 UI를 한국어화한 Gold 참고 프로젝트.
- `original-gold`: 원본 한국어 Gold의 코드·그래픽·UI 비교용 참고 프로젝트.
- 뮤뮤 에디터: 사용자가 편집·빌드·테스트에 사용하는 도구. 리팩터링·이름 변경은 보류이며 이번 작업에 포함되지 않는다.
- 한국어 Gold 상태창은 동양판 세로 배치의 기준으로 확인했다. 이것이 일본어 Crystal 상태창과 완전히 같다는 검증까지 완료한 것은 아니다.
- 참고 문구는 Crystal의 내용·버퍼·제어 코드를 유지하면서 이식한다. `#MON`은 포켓몬, `#GEAR`는 포켓기어로 번역한다.
- 기존 번역과 사용자 변경을 무조건 재번역하지 않는다. 외부 폴더의 파일을 런타임·빌드 의존성으로 추가하지 않는다.

이전 외부 이름 데이터 참조는 Crystal 내부 파일로 옮겼다. `docs/self-contained-source.md`에는 직접 참조 경로 조사와 별도 소스 복사본의 디버그 빌드 검증이 기록돼 있다. 이는 당시의 독립성 검증 기록이며 현재 변경 전체의 클린 빌드를 대신하지 않는다.

## 3. 한국어 출력 시스템

### 문자열 형식과 버퍼 계약

| 용도 | 형식·제한 | 주요 파일 |
| --- | --- | --- |
| 일반 한글 출력 | `$17` escape + 글리프 bank + index, 한 글자 3바이트 | `constants/charmap_hangul_poc.asm`, `constants/charmap_hangul_complete.asm` |
| 저장된 이름 | 한글 한 글자 2바이트의 packed 형식, 이름 레코드 11바이트 | `constants/charmap_pokemon_names.asm`, `engine/hangul/name_codec.asm` |
| 이름 표시 | 최대 한글 5글자와 종결자: 표시 버퍼 16바이트 | `home/name_codec.asm` |
| 박스 이름 | 저장 길이 9바이트, 최대 한글 4글자 | 이름 입력·표시 루틴 |
| 기본 종 이름 | 10바이트 고정 데이터에 호출 측 종결자 추가 | `data/pokemon/names.asm`, `home/names.asm` |

**11바이트 저장 레코드에 3바이트 표시 문자열을 넣으면 안 된다.** `CopyDefaultPokemonName`은 packed 기본 이름을 복사하고, `DecodeHangulName`/`DecodeSizedHangulName`은 표시용으로 풀어낸다. `PlaceHangulName`은 별도 표시 버퍼를 사용한다. `ExpandNicknameBuffer`는 충분히 큰 문자열 버퍼에만 적용한다.

`home/text.asm`이 일반 텍스트·RAM 문자열·글자 출력 명령을 처리하고, `engine/hangul/text.asm`이 글리프 캐시와 VRAM 업로드를 처리한다. `includes.asm`에서 한글 문자표를 포함한다. 이름 입력용 조합·키보드 자료는 Crystal 내부 `data/hangul` 및 이름 입력 루틴에 있다.

### 글리프 캐시·VRAM 주의사항

- 한글 8×16 글리프 캐시는 54슬롯이며 타일 `$80–$eb`를 사용한다. 키·속성은 WRAM bank 2에 있다.
- 한글 모드에서는 일부 일반 문자도 캐시를 통해 출력된다. 문자 코드와 최종 VRAM 타일 번호를 동일시하지 않는다. 점 `$e8`이나 `-`를 타일맵에 직접 쓰는 방식은 충돌할 수 있다.
- `$ec` 이후 고정 글리프 영역과 동적 캐시 영역을 구분한다. 고정 UI 타일도 화면별 그래픽과 겹칠 수 있다.
- 한글 출력 좌표는 아래쪽 타일 기준이다. 위쪽 타일은 한 행 전이다. 화면은 20×18타일, 실제 화면 높이는 144 scanline이다.
- 폰트 업로드는 글리프당 32바이트이며 VRAM bank 복원과 WRAM bank 전환, 인터럽트 상태를 보존해야 한다.
- LCD가 켜져 있을 때의 안전 전송 시점은 VBlank 시작 `LY=144`이다. 화면 타일 높이 18과 혼동하지 않는다. LCD가 꺼진 경로에서 VBlank 대기 루틴을 무조건 호출하지 않는다.
- 폰트를 다시 로드해 캐시 영역을 덮었다면 캐시 키도 무효화해야 한다. 타일맵만 지워서는 그래픽 데이터·속성맵·팔레트가 복원되지 않는다.
- `gfx/font/font_hangul.png`와 파생 1bpp가 글리프 원본이다. 현재 폰트 ROM 영역은 `$79:$4000`, `$78:$5000`, `$7c:$5000`, `$7f:$4000`에 분할돼 있다. 새 자산 추가 시 고정 배치와 겹침을 확인한다.

## 4. 완료된 주요 작업과 유지할 동작

아래는 코드·기존 조사 기록 및 사용자 보고를 함께 정리한 것이다. 모든 조합을 에뮬레이터에서 검증했다는 의미는 아니다.

| 작업 | 확인된 원인 및 현재 처리 | 검증·보존 사항 |
| --- | --- | --- |
| Crystal 이름 데이터 독립화 | 외부 이름 자료를 내부 이름표·문자표로 이식 | 참고 폴더 의존성 재도입 금지 |
| 기본 이름 `?`·일부 이름만 깨짐 | 표시용 3바이트 이름을 11바이트 저장 레코드에 넣어 긴 이름이 잘림. packed 기본 이름 복사로 수정 | 치코리타처럼 긴 표시 이름과 브케인의 차이를 폰트 누락으로 오판하지 말 것 |
| 이름 입력·출력 | 저장 형식과 표시 형식 분리, player/rival/mon/box 길이 구분 | 일반 닉네임 테스트는 사용자 이상 없음. 드문 입력 불가 글자는 원본 지원 범위라 확장하지 않음 |
| 배틀 출현·포획·기절 이름 | 일부 문구의 `text_ram`이 packed 이름을 그대로 출력. 이름용 `text_buffer` 경로로 변경 | USER/TARGET 등 이미 디코딩하던 경로와 구분. 문구 전체 재번역은 별도 |
| 맵 이름·메뉴 이름 | 폰트 재로드 후 캐시 키 불일치 및 메뉴 출력 후 폰트 덮어쓰기 | 캐시 초기화와 로드 순서 수정. 사용자 지역 이름 정상 보고 |
| 라디오·도감 문구 경계 | 영문 기준 바이트 복사가 한글 escape 묶음을 분리하고 제어 바이트로 오인 | 글자 단위 복사·줄 경계 및 버퍼 처리. 사용자는 개선 후 문제 없어 보인다고 보고; 전 방송 완전 검증으로 확대하지 않음 |
| 빈 기술 `-`·상태 약어 | 동적 글리프 영역에 직접 문자 타일을 씀 | `PlaceString` 출력 경로 사용. FNT/PSN/BRN/FRZ/PAR/SLP의 포인터·출력 폭 계약 보존 |
| 포획 후 도감 하단 잔여물 | 포획 도감 경로의 하단 타일맵 복구 부족 | 해당 행 복구. 일반 도감 메뉴를 함께 지우지 않음 |
| 닉네임 입력 후 배틀 돈 오염 | 이름 입력 WRAM union이 배틀 데이터·Pay Day 돈과 겹침 | `NamingScreenPreservingBattle`로 배틀 데이터 보존. Pay Day 기능 제거·돈 강제 초기화 금지 |
| 일반 빌드 ROM0 배치 실패 | `RAM Name Display Home`을 넣을 연속 공간 부족 | `PlaceNicknameCommand`를 별도 작은 ROM0 section으로 분리. RAM 주소·명령 동작 변경 없이 배치 해결 |
| pack 메뉴 PNG 빌드 실패 | DMG 변환기에 맞지 않는 비정규 회색 값 | `tools/normalize_dmg_palette.ps1` 및 PNG 정규화. 그림 배치 변경이 아님 |
| common 문구·도감 | oldgold 문구를 참고하되 Crystal 제어 코드·버퍼 유지, 가나다 정렬·한국어 도감 UI | 이미 번역된 문장 보호. 도감 인쇄 제거 범위를 다른 인쇄 기능으로 확대하지 않음 |

현재 `StoreFollowerNickInBuffer`는 저장 이름을 복사한 뒤 `ExpandNicknameBuffer`를 호출한다. 과거 `docs/nickname-battle-follower-fix-plan.md`의 동행 이름 변환 미완료 기록은 현재 코드와 다르므로 그대로 다음 할 일로 가져오지 않는다.

유지할 중요 동작:

- 개조 버전의 배틀 체력바·HUD 배치와 기존 한국어 전투 메뉴.
- 기절 표시는 현재 FNT 방식이 동작한다. 한국어 `기절` 그래픽화는 나중에 하기로 했으며 이번 범위가 아니다.
- 포획·닉네임·돈·동행 포켓몬 등 배틀 상태 보존과 Crystal 고유 시스템.
- 기존에 잘린 저장 이름을 임의로 기본 이름으로 덮어 복구하지 않는다. 사용자 닉네임과 손상 여부를 구분할 수 없다.

## 5. 현재 상태창 이식 내용

미커밋 상태로 한국어 Gold의 세로 UI를 Crystal에 이식했다. 왼쪽 포켓몬 영역과 오른쪽 상세 영역의 구분선은 x=7이다. 페이지 전환·알 상태·파티/박스 호출 등 Crystal 상태창 흐름은 유지하는 방향이다.

- 분홍: HP, 상태, 타입, 경험치.
- 초록: 소지품, 기술·PP.
- 파랑: ID, 어버이, 능력치.
- 왼쪽: 번호, 그림, 레벨·성별, 닉네임·종 이름, 페이지 아이콘·안내.
- `data/items/stats_names.asm`은 Crystal 내부의 상태창용 아이템 이름 자료다. Gold의 미사용 항목을 그대로 대응시키지 않고 Crystal의 알 티켓 등 차이를 반영했다.
- `gfx/stats/korean_move_heading.asm`의 고정 제목은 `$42–$53`에 로드된다. 한글 캐시 압박을 줄이기 위한 선택이나 **배틀의 플레이어 뒷모습 타일과 충돌한다**. 이전 계획의 “빈 영역” 설명은 화면 간 전환까지 고려하면 틀리다.
- 페이지 안내 그래픽은 `gfx/stats/korean_page_guide.asm`이며 상태창 타일 `$32–$35`를 사용한다.
- `engine/pokemon/mon_stats.asm`에서 기술이 없는 경우 PP 반복 길이 0이 256회처럼 처리되지 않도록 하고 빈 표시를 문자열 출력한다.
- 기술 표시용 별도 한국어 자료와 사용자의 `data/moves/names.asm`은 같은 파일이 아니다. 이번 요청을 빌미로 일괄 동기화하거나 사용자의 파일을 재작성하지 않는다.

이식 당시 일반·디버그 조립/링크 기록은 있지만, 아래 다섯 문제가 남아 있다. 빌드 성공은 VRAM 복구·MBC 접근·화면 실행이 정상이라는 증거가 아니다.

## 6. 현재 남은 다섯 문제와 수정 계획

### ① 상태 페이지 종료 후 배틀 잔상

**코드 확인:** `Battle_StatsScreen`은 기존 그래픽을 `$00–$41`까지 보존한다. `GetBattleMonBackpic`은 `$31–$54`의 6×6 타일을 사용한다. 상태창 고정 기술 제목 `$42–$53`이 복구되지 않은 뒷모습 영역을 덮는다. 스크린샷의 기술 글자가 플레이어 그림 위에 남는 증상과 일치한다.

**계획:** 상태창 진입·복귀의 그래픽 백업을 전체 사용 범위까지 확장한다. 백업 대상 VRAM의 다른 사용처와 두 bank, LCD 전송 조건, 타일맵·팔레트 복구를 함께 확인한다. 무조건 뒷모습을 재로드하는 방식은 대타출동·작아지기 등 기존 상태를 잃을 수 있어 피한다.

### ② 통통코 아이콘 및 유사 종

**코드·데이터 확인:** 조사한 278개 아이콘/동행 스프라이트 자료의 원본 크기·압축 해제 왕복·프레임 범위가 정상이며 통통코 원본이 빈 그림인 것은 아니다. 파티 아이콘은 동행 스프라이트 포인터를 통해 압축 자료를 읽는다.

현재 디버그 심벌에서 통통코는 `$80:$5048`, 토게피는 `$80:$450d`이다. `PokemonSprites5`에 해당 종들을 포함한 42종이 bank `$80`에 배치돼 있다. 일반 ROM에서는 통통코 `$7f:$6048`, 토게피 `$7f:$550d`이다. 헤더는 두 ROM 모두 `$10` (MBC3+timer+RAM+battery)이며 일반 2MiB, 디버그 4MiB다.

**유력 원인:** 표준 MBC3의 ROM bank 범위를 넘는 디버그 배치. 실제 에뮬레이터가 MBC30 확장처럼 처리하는지는 확인하지 않았다. 데이터 정상 및 범위 충돌은 정적 근거지만 스크린샷의 모든 깨짐 원인을 실행으로 확정한 상태는 아니다.

**계획:** 디버그 그래픽 section을 분할·배치해 접근 가능한 범위로 제한하고 전체 ROMX bank·포인터를 점검한다. MBC5로 헤더만 바꾸면 RTC 동작이 달라지므로 금지한다. 아이콘 278개, 파티 6슬롯, 알·소지품·안농 변형도 함께 확인한다.

### ③ `NO.` 뒷부분

**코드 확인:** `StatsScreen_InitUpperHalf`가 번호 기호와 점을 타일맵에 직접 쓴다. 점 문자 `$e8`은 한글 캐시 영역에 포함된다. 번호용 고정 그래픽 데이터 자체는 존재한다. 이 문제는 이번 세로 UI 이전부터 있었다는 사용자 보고다.

**유력 원인:** 문자 코드 `$e8`을 고정 글리프 타일로 사용하면서 캐시 내용에 따라 다른 그림을 표시하는 경로.

**계획:** 번호 주변 문자 출력도 올바른 일반 문자/한글 캐시 경로를 사용하게 한다. 좌표·출력 폭 및 캐시 활성/비활성 상태를 확인하고 원본 글리프를 추측으로 다시 그리지 않는다.

### ④ 경험치·상세 영역 배경색

**코드 확인:** 일반 `Textbox`는 내부 속성에 흰색 팔레트 7을 지정한다. 상태창의 페이지 변경은 타일만 지우는 경로가 있고, 프레임을 다시 그리면서 영역 속성을 덮는다. 현재 페이지 색 및 경험치용 팔레트 지정이 유지되지 않아 분홍뿐 아니라 초록·파랑에서도 흰 영역이 남는다.

**계획:** 상태창에 필요한 프레임만 그리고 페이지별 오른쪽 속성맵을 재설정한다. 분홍 경험치 바 팔레트, HP, 왼쪽 그림·아이콘 팔레트는 별도 유지한다. 전역 `Textbox`의 동작을 바꿔 다른 창의 색까지 변경하지 않는다.

### ⑤ 토게피 알 부화 후/도중 정지

**최신 사용자 확인:** 토게피. 디버그 기능으로는 부화했으나 부화 후 상태보기 불가. 자연 부화는 바로 튕김. 처음의 “알이 깨질 때 정지” 보고보다 이 구분을 우선한다. 정확한 디버그 진입 조작, 자연 부화의 마지막 실행 명령, PC·stack·세이브 데이터는 확보하지 못했다.

**코드 확인:** 디버그 `EggStatsJoypad.hatch`는 행복도 1 및 step count 127을 설정해 다음 걸음의 일반 부화 이벤트를 유도한다. 일반 흐름은 `DoEggStep` → `PLAYEREVENT_HATCH` → `OverworldHatchEgg` → `HatchEggs` → 애니메이션/껍질/조각 → 이름 입력 → 메뉴 종료·맵/스프라이트 복구다.

토게피 frontpic·애니메이션·프레임 자료는 각각 bank `$57`, `$34`, `$36`으로 조사됐으며 `$80` 초과가 아니다. 반면 부화 후 아이콘과 동행 스프라이트는 ②의 bank 배치 영향을 받을 수 있다.

**미확정:** bank 문제는 부화 후 상태보기나 맵 복귀의 유력 후보지만 자연 부화 정지의 실제 지점을 설명했다고 단정할 수 없다. 폰트 문제 또는 알 데이터 문제로도 아직 확정하지 않았다.

**계획:** 먼저 ②의 잘못된 bank 배치를 제거한 뒤 부화 이벤트·데이터 갱신·그래픽/동행 재로드·WRAM/호출 계약을 추적한다. 기존 애니메이션 생략, 임의 지연, 닉네임 덮어쓰기 같은 우회는 하지 않는다. 코드로 특정하지 못한 실행 조건은 마지막 사용자 테스트 항목으로 남긴다.

## 7. 주요 소스·루틴 위치

경로는 위의 프로젝트 루트 기준이다. 행 번호는 조사 당시 참고값이며 이후 수정으로 이동할 수 있으므로 루틴 이름으로 다시 검색한다.

| 파일 | 확인할 루틴·역할 |
| --- | --- |
| `engine/battle/core.asm` | `Battle_StatsScreen` 약 5246행, `GetBattleMonBackpic` 약 8081행 |
| `engine/pokemon/stats_screen.asm` | `StatsScreen_InitUpperHalf` 약 422행, `.ClearBox` 약 561행, 각 페이지 프레임·알 디버그 입력 |
| `engine/gfx/mon_icons.asm` | `GetIcon` 약 423행, 동행 자료 압축 해제·파티 타일 로딩 |
| `gfx/following_sprites.asm` | 스프라이트 section·bank 배치 및 포인터 자료 연결 |
| `engine/gfx/cgb_layouts.asm` | `_CGB_StatsScreenHPPals` 약 198행, 초기 상태창 속성·팔레트 |
| `engine/gfx/color.asm` | `LoadStatsScreenPals` 약 373행, 페이지별 팔레트 갱신 |
| `home/text.asm` | `Textbox`, `TextboxPalette`, `PlaceString`, 한글/일반 문자 출력 경로 |
| `engine/gfx/load_font.asm` | 일반·맵·상태창 폰트 로드, 캐시 초기화 순서 |
| `engine/hangul/text.asm` | `ResetHangulTiles`, `_PlaceHangul`, `TrimHangulTiles`, `CopyHangulGlyphToBuffer`, `CopyHangulTilesToVRAM` |
| `engine/hangul/name_codec.asm` | `DecodeHangulName`, `DecodeSizedHangulName`, `CopyDefaultPokemonName` |
| `home/name_codec.asm` | `PlaceHangulName`, `PlaceBoxName`, `ExpandNicknameBuffer`, `PlaceRAMString`, `PlaceNicknameCommand` |
| `home/names.asm` | `GetPokemonName` 등 이름 조회·표시 형식 변환 |
| `engine/pokemon/breeding.asm` | `OverworldHatchEgg` 약 198행, `HatchEggs` 약 206행, `EggHatch_AnimationSequence` 약 682행, `EggHatch_CrackShell` 약 778행, 껍질 조각 출력 경로 |
| `engine/events/follower.asm` | `StoreFollowerNickInBuffer`, 부화·맵 복귀 이후 동행 그림 연결 |
| `engine/menus/naming_screen.asm` | `NamingScreenPreservingBattle`, 이름 입력 및 배틀 WRAM 보존 |
| `engine/battle/korean_move_text.asm` | 상태창과 배틀의 기술·타입 표시 보조 자료; 사용자 기술 이름 파일과 별개 |
| `gfx/sgb/blk_packets.asm` | SGB 상태창 영역 지정, CGB 화면 수정 시 함께 점검 |
| `layout.link`, `main.asm`, `ram.asm` | ROM/RAM section 배치·include·WRAM union |

## 8. 빌드 환경과 검증 한계

Windows 환경이며 사용자는 MSYS2 UCRT64 터미널과 에디터로 빌드한다. 로컬에 `C:\cygwin64\bin\make.exe`도 있다. `.rgbds-version`은 `1.0.0`, 프로젝트 안 `rgbds-1.0.0/`의 도구를 사용한다.

프로젝트 루트에서 MSYS/Cygwin 계열 셸 기준:

```sh
make RGBDS=rgbds-1.0.0/ crystal
make RGBDS=rgbds-1.0.0/ crystal_debug
# 같은 소스로 두 타깃 검증:
make RGBDS=rgbds-1.0.0/ crystal crystal_debug
```

현재 기본 빌드가 항상 두 ROM을 자동 생성하도록 바꾸는 작업은 완료되지 않았다. 사용자가 나중에 하자고 한 개선이며 이번 다섯 버그에 포함하지 않는다.

`Makefile`은 18개 object 단위, 그래픽 변환·압축, `layout.link` 기반 링크, `.sym`/`.map`, `rgbfix` 및 후처리를 사용한다. RGBDS 경고는 `-Weverything`, truncation 검사도 켜져 있다. `pokecrystal.gbc`와 `pokecrystal_debug.gbc`뿐 아니라 심벌·map의 bank 배치를 확인한다.

- 이전 기록의 18개 조립 단위 일반/디버그 빌드는 그래픽 전체의 클린 재생성을 보장하지 않는다.
- `.verification` 등의 로컬 산출물은 Git에서 보존되지 않을 수 있다. 존재를 전제로 새 환경의 복구 계획을 만들지 않는다.
- `make clean`은 파생 그래픽 등을 삭제하므로 무심코 실행하지 않는다. 사용자의 작업 파일·세이브·스냅샷을 보호한다.
- 이번 인수인계 작성에서는 빌드를 새로 실행하지 않았다.
- 기존 `data/text/std_text.asm` 약 155행의 조사상 경고/과제는 별도 항목이다. 이번 수정과 무관하게 함께 고치지 않는다.

조사 당시 루트 ROM의 SHA-256은 다음과 같다. 두 ROM의 생성 시각이 다르고 현재 소스와 정확히 같은 시점인지 확정하지 않았으므로 비교 기준으로만 사용한다.

```text
pokecrystal.gbc (2MiB)
e601f90f8ca797fa8d1617e08ff3a57746b311ccdea9f11c656c066fa51eb8a8
pokecrystal_debug.gbc (4MiB)
5e4031fb5f8ef8afd6d190286a24d87ab41c4d7ae4cf9dbb2b62cbae50a43a3c
```

## 9. 다음 작업 순서와 최종 테스트

1. 작업 트리와 사용자 변경을 다시 확인하고, 다섯 문제의 계획을 제시해 명시적인 승인을 받는다.
2. **② 아이콘·전체 ROM bank 배치**: ⑤에도 관련된 공통 전제를 먼저 해결한다. mapper/RTC를 유지한다.
3. **⑤ 부화**: 진행 불가 문제라 중요도가 가장 높다. 자연/디버그 경로 차이와 후처리를 조사하고 원인의 확정 범위를 명시한다.
4. **① 배틀 복귀**: 백업 범위와 다른 VRAM 용도를 일치시킨다.
5. **③ 번호 기호**, **④ 페이지 배경**: 각각 출력 경로와 속성맵/팔레트를 수정한다.
6. 같은 소스로 일반·디버그를 빌드하고 ROM0/ROMX 배치, 포인터, 압축 자료, RAM 및 관련 차분을 정적 검증한다.
7. 수정 파일과 근거를 문제별로 보고하고, 모든 수정 후 사용자에게 다음 수동 테스트를 전달한다.

최종 테스트 항목(중간에 사용자에게 요구하지 않는다):

- 일반/디버그 각각: 배틀 → 파티 → 상태창 3페이지 → 파티 → 배틀을 반복. 대타출동·작아지기 등 그림 변형도 복귀 확인.
- 통통코·토게피 및 bank 재배치 대상 종의 파티 6슬롯, 프레임 전환, 알·소지품·안농 표시.
- 상태창을 여러 종·페이지로 반복 진입하며 `NO.`와 이름·레벨·성별 및 일반 글자 캐시 확인.
- 분홍·초록·파랑 페이지의 프레임 안쪽과 경험치 바 배경색, HP·그림·아이콘 색 확인.
- 토게피 자연 부화와 디버그 유도 부화 각각: 껍질·조각 → 이름 입력 여부 → 맵 복귀 → 동행 → 파티/상태보기. 다른 종도 비교.
- 이름 미변경/닉네임 지정, 포획·돈·전투 문자열·빈 기술 표시·맵 이름 등 기존 수정의 회귀 확인.

확인하지 않은 실행 결과를 정상이라고 기록하지 않는다. 저장 데이터 복구나 추가 기능이 필요하면 임의로 범위를 확대하지 말고 사용자에게 상담한다.

## 10. 참고 문서

- `docs/stats-screen-five-bugs-investigation-plan.md`: 이번 다섯 버그의 근거·단계별 수정 계획. 승인 전.
- `docs/stats-screen-eastern-layout-plan.md`: 세로 UI 이식 내용과 이전 빌드 기록. 타일 “빈 영역” 설명은 본 문서 ①의 최신 조사로 보정한다.
- `docs/name-radio-font-fix-plan.md`, `docs/battle-text-transition-fix-plan.md`: 이름·캐시·배틀 전환의 이전 원인 분석.
- `docs/release-build-rom0-plan.md`: 일반 ROM0 배치 오류의 수정 기록.
- `docs/self-contained-source.md`: 참고 프로젝트 종속성 제거 및 소스 독립성 기록.
- `docs/common3-oldgold-adaptation.md`: 문구 이식 시 버퍼·제어 코드 보존 기록.

한글패치 스킬의 기록 지침에 따라 승인 상태, 코드 근거, 사용자 실행 보고, 미확정 추정 및 회귀 테스트를 구분했다. 문서와 코드가 다르면 현재 코드와 최신 사용자 보고를 우선해 재조사한다.
