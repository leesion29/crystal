# 포켓몬 크리스탈 한국어 번역 지침

사용자 지시와 현재 크리스탈 코드를 기준으로 한다. 이전 조사·계획 문서의
완료 상태나 구현 설명이 현재 코드와 다르면 실제 코드를 우선한다.

## 번역 자료와 대응 확인

1. 프로젝트의 형제 디렉터리 `../original-gold`에서 동일한 장소·NPC·이벤트의
   한국어 번역을 찾아 기존 표현을 그대로 사용한다.
2. 대응 번역이 없을 때만 `../oldgold`를 검색한다.
3. 두 자료 모두 대응 번역이 없으면 크리스탈 원문과 사용 문맥을 바탕으로
   기존 문체에 맞춰 새로 번역한다.

레이블, 파일명, 아이템 ID나 배열 순서만으로 대응을 확정하지 않는다.
이름·파일 위치가 달라도 내용과 실제 사용 상황이 같으면 재사용할 수 있다.
크리스탈에 추가된 조건·효과·정보가 있으면 이를 누락하지 않는다.
참조 번역이 원문의 효과나 조건을 뒤집는 경우 대응에 문제가 있음을 기록하고
그대로 복사하지 않는다. 신규 문구는 실제 표시·사용자 문구 검토 전의 초안이다.

## 보존할 내용과 코드

- 이미 한국어인 문자열은 표현이 어색해도 수정하지 않는다. 혼합 언어 블록은
  기존 한국어 행을 보호하고 미번역 행의 필요성을 따로 확인한다.
- 기존 용어·문체·명칭을 유지한다. 장소명은 현재 랜드마크와 대응 골드 명칭을
  참고한다. `#MON`은 포켓몬, `#GEAR`는 포켓기어다.
- 사용자가 수정한 `data/moves/names.asm`은 번역·동기화하지 않는다.
- 골드에서 문자열 표현만 가져온다. 크리스탈의 레이블, 포인터, 데이터 순서,
  이벤트 플래그, 스크립트 명령, 분기, 버퍼, RAM/WRAM 심볼을 보존한다.
- 변수·이름·숫자 삽입의 순서와 인수, 별도 대기·효과음·종료 명령은
  크리스탈을 유지한다. 게임 스크립트와 텍스트 내부 표시 명령을 구분한다.
- 줄바꿈·페이지·스크롤은 `docs/text_commands.md` 및 실제 한국어 소비자를
  기준으로 배치한다. 영문 원문의 행 수·페이지 수에 한국어를 억지로 맞추지 않는다.
  대응하는 골드 문장이 같고 현재 표시 영역·변수 최대 폭에 맞으면 골드의
  `text`/`line`/`cont`/`para` 구성도 그대로 재사용한다. 참조판의 RAM 주소,
  출력 루틴, 변수 인수, 종료 방식까지 복사한다는 뜻은 아니다.
- 텍스트 제어는 장식이 아니라 표시 순서·스크롤·입력 대기·창 지우기·종료를
  정하는 대사의 일부다. 골드 대응 대사를 재사용할 때는 문장뿐 아니라 그 대사의
  제어 구성도 먼저 비교해, 크리스탈의 같은 소비자에서 그대로 성립하면 우선
  보존한다. 크리스탈의 구현·변수·종료 방식이 다르면 크리스탈 동작을 우선한다.
  새 대사는 번역문을 확정하기 전에 대화창 종류, 각 줄의 실제 폭, 다음 문장이
  이어지는 방식과 필요한 입력 대기를 정하고 그에 맞는 제어를 작성한다.
- `text`는 문자열 시작, `line`은 둘째 줄, `cont`는 입력 후 한 줄 스크롤,
  `para`는 입력 후 창을 비우고 새 문단을 출력한다. 일반 창은 18열·한글 두 줄이다.
  이미 둘째 줄에 있을 때 또 `line`을 쓰면 덮어쓰며, `next`는 무조건 둘째 줄로
  이동하는 명령이 아니다. 자동 방송·도감·설명·메뉴는 전용 소비자를 확인한다.
- 문장·어절을 읽을 수 있게 이어 배치한다. 빈 `line`/`cont`로 원문의 남는 행을
  채우지 않는다. 단, 원래 입력 대기·창 지우기 용도의 `para ""`는 무작정 없애지 않는다.
- 변수 뒤 조사는 이름에 따라 달라짐을 고려한다. 이미 있는 크리스탈 제어
  토큰은 임의로 추가·삭제하지 않는다.
- `#MON`은 `포켓몬`, `#GEAR`는 `포켓기어`로 번역한다. 말줄임은 짧은 문맥의
  일반 `...`는 유지할 수 있으나, 긴 침묵·반복·연출용 말줄임은 단순 점을
  반복하지 않고 사전에 등록된 `<……>` 제어 문자열을 우선 검토한다. 이 문자열은
  여섯 점을 한 표시 단위로 다루므로 줄 폭과 `line`/`cont`/`para` 진행을 함께
  확인한다. 원문에 없던 지연·입력 대기를 만들기 위한 용도로는 사용하지 않는다.
- 번역과 무관한 코드 수정·리팩터링·기능 추가는 하지 않는다.
- 두 참조 디렉터리는 읽기 전용으로 취급하며 빌드·실행 의존성으로 추가하지 않는다.
- 문자열 형태의 비교 데이터, 고정 길이 메일 레코드, 전용 그래픽 렌더러 입력은
  대사와 구분한다. 표시 대사라는 근거 없이 치환하지 않는다.

## 범위 조사와 검증

맵 연결·워프, NPC/트레이너 이벤트, `jumpstd`, `special`, 다른 파일의
텍스트 참조를 따라 범위를 정한다. 지도 그룹 소속만으로 지역을 확대하지 않는다.
공용 파일에서는 해당 지역에 사용되는 확인된 블록만 수정한다.

지역별 번역 전 기준 소스를 보존하고, 변경 후 문자열 이외의 코드와 기존
한국어 표현이 동일한지 비교한다. 표시 오류 교정에서는 공백·줄바꿈·페이지
제어 변경을 별도 기록하되, 문장·변수 순서와 대기·종료·게임 코드는 보존한다.
집계 단위는 텍스트 레이블의 블록이다.
재사용 출처와 참조 레이블, 신규·유지·제외 이유를 기록한다.

각 지역을 마친 뒤 일반·디버그 빌드를 검증한다. 인코딩/글리프, 문자열 길이,
실제 소비자의 행·표시 폭, 변수의 최대 출력, 버퍼, ROM 섹션과 뱅크 용량,
포인터 및 출력 구조를 확인한다. 일반 대화창은 확인된 18열 범위를 기준으로
검사하되 다른 UI에 이를 무조건 적용하지 않는다.

오류가 나면 해당 지역에서 중단하고 원인을 조사한다. 문자열 버퍼, 출력 루틴,
ROM 섹션 등 코드 구조 변경이 필요하면 수정 전에 사용자에게 보고한다.
문구를 몰래 줄이거나 미등록 문자를 대체·누락해서 오류를 숨기지 않는다.
`data/text/std_text.asm:155`의 미등록 `~` 경고는 2026-10-11 사용자 승인 후
일반 대사 문자표의 기존 글리프 연결(`$17, $0b, $69`)로 해소했다.
승인 범위 밖의 추가 문자 등록이나 버퍼·출력 루틴 변경은 별도 승인 대상이다.

빌드·정적 검사·제한된 CPU 검사와 실제 에뮬레이터 검증을 구분한다. 빌드
성공은 게임 화면의 정상 표시나 이벤트 진행을 보장하지 않는다. 이 프로젝트는
중간 수동 테스트를 요청하지 않고 최종 ROM을 사용자가 직접 확인한다.

## 문서 정리 원칙

README/AGENTS/빌드·설정·원본 기술 문서와 유효한 HANDOFF를 보존한다.
다른 파일이나 자동화가 참조하는 문서는 삭제하지 않는다. 출처 불명·사용자
작성·기술 근거와 검증 기록이 남은 문서는 유지한다. 명확한 일회성 범위 문서는
필요한 목록을 이 문서로 옮긴 뒤에만 삭제하며 Git으로 복구 가능한지 기록한다.

## 2026-10-11 번역 범위 조사

이하 과거 작업 기록의 영문 행 수·제어 순서 보존 검사는 한국어 문단 배치의
정상성을 보증하지 않는다. 2026-10-11 출력 제어 재감사 결과 및 현재 검증 명령은
`docs/korean-text-layout-audit.md`를 우선한다. 과거 번역 JSON의 `rows`는 출처
기록이며 현재 ASM의 줄바꿈을 다시 덮어쓰는 계획으로 사용하지 않는다.
`tools/region_reference_layout.py`의 고정 행 수 배치 경로는 사용 중단했다.

| 지역 | 직접 관련 맵 ASM | 작업 전 상태와 범위 |
|---|---|---|
| 32번도로 | Route32, Route32Pokecenter1F, Route32RuinsOfAlphGate | 본도로 51블록 중 9블록 한국어, 센터 6블록 미번역, 관문 3블록 한국어 |
| 33번도로 | Route33 | 6블록 미번역, 등산가 재대결·노고치 및 주민·표지판 |
| 고동마을 | AzaleaTown, AzaleaPokecenter1F, AzaleaMart, AzaleaGym, KurtsHouse, CharcoalKiln | 82블록 미번역, 라이벌·호일·강집·규토리·GS볼·숯 장인 이벤트 포함 |
| 야돈의 우물 | SlowpokeWellB1F, SlowpokeWellB2F | 19블록 미번역, 로켓단·강집·야돈의 표시 메일·왕의 징표석 |
| 너도밤나무숲 | IlexForest, IlexForestAzaleaGate, Route34IlexForestGate | 25블록 미번역, 파오리·풀베기·박치기·사당·GS볼·세레비 |

파일은 위 이름에 `maps/`와 `.asm`을 붙인 실제 파일이다. 고동마을의 82블록은
22+4+2+23+24+7이며 기존 한국어가 없다. 미참조 대사도 해당 맵의 표시 텍스트로
조사·번역하되 미사용이라는 사실을 결과에 구분한다.

32번도로의 워프는 센터·알프 관문·연결동굴1층으로, 33번도로의 워프는
연결동굴1층으로 연결된다. 고동마을은 동쪽 33번도로, 내부 다섯 건물과 우물,
서쪽 숲 관문으로 연결된다. 우물은 지하1·2층, 숲은 고동 및 34번도로 관문으로
이어진다. 숲과 강집·고동마을·34번도로 관문의 GS볼 이벤트는 같은 진행 플래그를
참조한다. 포켓몬센터는 공용 2층으로 연결된다.

별도 파일에서 현장 대사로 호출되는 번역 대상:

- `data/phone/text/ralph_overworld.asm`, `liz_overworld.asm`: 32번도로의 전화번호
  교환·거절·등록 용량·재대결 안내 12블록. `engine/events/std_scripts.asm`의
  호출자 ID 분기를 통해 선택된다.
- `data/phone/text/anthony_overworld.asm`: 33번도로 같은 현장 안내 6블록.
- `data/text/common_1.asm`의 `_WhichApricornText`, `_HowManyShouldIMakeText`:
  `KurtsHouse` → `SelectApricornForKurt` → `engine/events/kurt.asm`에서 출력한다.
  공용 파일의 다른 블록은 이번 작업에서 보존한다.

공용·인접 의존성으로 조사했으나 이번 지역 범위에서 제외:

- `UnionCave1F/B1F/B2F.asm`, `Route34.asm`, `Pokecenter2F.asm`: 독립 지역·공용 공간.
- `engine/events/std_scripts.asm`: 간호사·체육관 석상·간판·책장·전화 등록 공용
  이벤트. 관련 문자열은 `data/text/common_*.asm` 등에서 이미 한국어인 부분을
  유지하며, 코드 자체는 변경하지 않는다.
- `data/text/std_text.asm`의 일반 간호사·간판·책장·체육관 석상 문구,
  `common_1.asm`의 열매 나무 및 행운의 넘버 방송, `common_2.asm`의
  풀베기·괴력·박치기·낚시·도구 발견 안내는 기존 한국어를 확인하고 유지했다.
  강집집·숯 장인의 라디오는 `Radio2Script` → `MapRadio` → 행운의 넘버 방송을
  호출한다. 포켓몬통신센터 전용 간호사 분기는 환영 플래그가 설정되지 않는
  미사용 분기이며 이번 일반 포켓몬센터 대사의 번역 대상이 아니다.
- `data/phone/text/{ralph,liz,anthony}_{caller,callee}.asm` 및 `engine/phone`:
  현장 대사와 달리 어느 지역에서든 발생하는 전화 통화·타지역 소문은 별도 작업이다.
- `engine/events/celebi.asm`, `kurt.asm`, `engine/items/mart.asm`와 관련 아이템·기술·
  지도 데이터: 이벤트/출력 구조를 확인하는 자료. 위 규토리 질문 2블록 외에
  기능이나 이름 테이블을 수정하지 않는다.

## 보존한 이전 도라지시티 범위 목록

이전 임시 범위 문서의 목록을 이관했다. 도시 내부는 `VioletCity`, `VioletGym`,
`VioletMart`, `EarlsPokemonAcademy`, `VioletNicknameSpeechHouse`,
`VioletPokecenter1F`, `VioletKylesHouse`다. 후속 후보는 `SproutTower1F/2F/3F`,
`Route31`의 도라지 관련 대사, `Route31VioletGate`, `Route32`의 도라지 체육관 관련
대사였다. 실제 최신 번역 상태는 코드에서 확인한다. 지도 목록·스크립트 포함 순서·
속성·랜드마크 데이터는 구조 참고 자료이며 이 목록만으로 수정하지 않는다.

## 2026-10-11 작업 결과와 재검증 기준

작업 시작 시 Git 변경 사항은 없었으며 비교 기준은 커밋
`84739d69ec0a35366f6b83f3aa4ce3711d620d3a`다. 아래 집계의 단위는 텍스트
레이블 블록이다. 참조판의 공백과 행 배치는 크리스탈 명령에 맞췄지만 재사용
블록의 표현은 바꾸지 않았다. 골드 문구 일부와 크리스탈 추가 내용을 함께
사용한 블록은 전체를 신규·추가 내용 번역으로 집계했다.

| 지역 | original-gold | oldgold | 신규·추가 내용 | 기존 한국어 유지 | 지역 완료 후 일반/디버그 빌드 |
|---|---:|---:|---:|---:|---|
| 32번도로 | 46 | 0 | 14 | 12 | 성공 / 성공 |
| 33번도로 | 4 | 0 | 8 | 0 | 성공 / 성공 |
| 고동마을 | 69 | 0 | 15 | 0 | 성공 / 성공 |
| 야돈의 우물 | 19 | 0 | 0 | 0 | 성공 / 성공 |
| 너도밤나무숲 | 17 | 0 | 8 | 0 | 성공 / 성공 |
| 합계 | 155 | 0 | 45 | 12 | 다섯 지역 순서대로 검증 완료 |

기존 한국어 12블록은 지정 맵·현장 전화 대사·규토리 질문으로 확정한
212블록 안의 집계다. 별도로 조사한 공용 간호사·필드 기술·방송 등의 기존
한국어는 이 수에 중복 합산하지 않았다.

### 파일별 완료 목록

| 파일 | original-gold | 신규·추가 내용 | 기존 한국어 유지 |
|---|---:|---:|---:|
| maps/Route32.asm | 40 | 2 | 9 |
| maps/Route32Pokecenter1F.asm | 6 | 0 | 0 |
| maps/Route32RuinsOfAlphGate.asm | 0 | 0 | 3 |
| data/phone/text/ralph_overworld.asm | 0 | 6 | 0 |
| data/phone/text/liz_overworld.asm | 0 | 6 | 0 |
| maps/Route33.asm | 4 | 2 | 0 |
| data/phone/text/anthony_overworld.asm | 0 | 6 | 0 |
| maps/AzaleaTown.asm | 19 | 3 | 0 |
| maps/AzaleaPokecenter1F.asm | 2 | 2 | 0 |
| maps/AzaleaMart.asm | 2 | 0 | 0 |
| maps/AzaleaGym.asm | 23 | 0 | 0 |
| maps/KurtsHouse.asm | 16 | 8 | 0 |
| maps/CharcoalKiln.asm | 7 | 0 | 0 |
| data/text/common_1.asm (규토리 질문 2블록만) | 0 | 2 | 0 |
| maps/SlowpokeWellB1F.asm | 17 | 0 | 0 |
| maps/SlowpokeWellB2F.asm | 2 | 0 | 0 |
| maps/IlexForest.asm | 11 | 7 | 0 |
| maps/IlexForestAzaleaGate.asm | 2 | 0 | 0 |
| maps/Route34IlexForestGate.asm | 4 | 1 | 0 |

맵 15개를 조사하여 14개를 수정했고 공용 파일 4개를 함께 수정했다.
확정한 범위 안의 미번역 대사와 보류 파일은 없다. 미사용 대사는 원래의
미사용 주석과 호출 구조를 유지했다. 위의 제외 대상은 완료 주장에 포함하지
않으며, 특히 이동 중 전화 통화 및 연결동굴·34번도로·센터2층은 별도 작업이다.

### 의미 대응상의 예외

- `FisherRalph1SeenText`: 골드 표현을 일부 재사용하되 크리스탈의
  아이에게 지지 않겠다는 추가 발언을 번역했다.
- `AzaleaPokecenter1FGentlemanText`: 두 골드 자료는 비전 기술을
  **빈사일 때만** 쓸 수 있다는 표현이나 크리스탈 원문은 **빈사여도**
  사용할 수 있다는 뜻이다. 잘못된 조건을 복사하지 않고 크리스탈 의미로
  번역했다. 참조 파일은 수정하지 않았다.
- `AzaleaPokecenter1FUnusedText`: 골드의 박스당 20마리 표현을 참고하고
  크리스탈의 이수재가 시스템을 만들었다는 내용을 추가했다.
- `Text_ShrineCelebiEvent`: 골드의 사당 설명을 재사용하고 구멍·GS볼
  추가 내용을 번역했다. GS 식별 명칭은 유지했다.
- 현장 전화번호 교환 18블록, 규토리 질문 2블록 및 크리스탈 추가 이벤트는
  대응 번역 검색 후 신규로 처리했다. 레이블별 출처·행·예외 메모는
  `data/translation/routes32-33-azalea-well-ilex.json`에 기록했다.

### 문서 정리

삭제한 문서는 `docs/violet-city-translation-scope.md` 하나다. 이전 요청으로
생성한 일회성 범위 목록과 적용 규칙을 위에 통합했고, 저장소 문서·스크립트·
설정 및 로컬 자동화에서 참조되지 않음을 확인했다. 삭제 전 Git에 추적되던
문서라 비교 기준 커밋에서 내용을 복구할 수 있다.

`docs/routes31-36-alph-translation-scope.md`는 메일 비교 데이터·요일 등
고유한 제외 근거와 검증 기록을 포함하여 유지했다. `HANDOFF.md`,
README/INSTALL/STYLE/FAQ, 문서 인덱스와 빌드·설정 문서, 기존 버그 조사·
수정 계획·검증 보고서는 유효한 기술 기록이거나 일회성 여부를 단정할 수
없어 삭제하지 않았다. 게임 소스·데이터·리소스는 삭제하지 않았다.

### 검증 결과와 한계

- `tools/region_translation.py verify all`로 변경 200블록과 보호한 기존
  한국어 12블록, 비문자열 소스, 제어 토큰 및 출력 명령 순서를 비교했다.
  골드 재사용 155블록의 표현 일치, 18열 및 플레이어/라이벌 최대 7글자
  치환 시의 행 길이, 빈 문단 여부를 검사했다.
- 최종 일반·디버그 ROM 각각에서 200블록의 실제 인코딩 바이트와 끝 코드를
  확인하고 맵의 텍스트 참조 153개가 같은 ROM 뱅크에 있음을 검증했다.
  번역 문자열은 해당 뱅크 경계를 넘지 않는다.
- 기존 검증 도구 9종을 두 ROM 모두에 실행해 통과했다: 동행 그래픽,
  상태창 전환, TM/HM 이름·캐시, 아이템 이름·설명·버퍼, 랜드마크,
  START 메뉴 진입, 하위 메뉴 복귀, 가방 클리어, 한글 업로드 타이밍.
  각 도구의 제한된 CPU 실행·모델 결과는 실제 PPU/화면 테스트와 다르다.
- `git diff --check` 통과. 기술 이름, RAM·버퍼, 상수, 출력 루틴과
  맵 포인터/스크립트 포함 테이블을 변경하지 않았다.
- 기존 `data/text/std_text.asm:155`의 미등록 `~` 경고는 남아 있다.
  이번 변경 문자열에는 인코딩 실패가 없지만 프로젝트 전체의 무경고
  출시 빌드라고 주장하지 않는다. 에뮬레이터 화면·이벤트 검증은 미실시다.

검증 대상 ROM SHA-256:

- 일반: `3120f96901bed0222bb1827501a9fce751d939f3f3442156c8c26d2f3f0ca253`
- 디버그: `d25c2b823b1aee7cbc2fe9c026658f94394c82cb65ed9312727cf73e953dca3c`

재검증 명령 (프로젝트 루트, 아래 `python`은 UTF-8 실행 가능한 Python):

```text
python -X utf8 tools/region_translation.py verify all --plan data/translation/routes32-33-azalea-well-ilex.json --baseline-ref 84739d69ec0a35366f6b83f3aa4ce3711d620d3a
python -X utf8 tools/region_translation.py rom all --plan data/translation/routes32-33-azalea-well-ilex.json --rom pokecrystal.gbc --sym pokecrystal.sym
python -X utf8 tools/region_translation.py rom all --plan data/translation/routes32-33-azalea-well-ilex.json --rom pokecrystal_debug.gbc --sym pokecrystal_debug.sym
make -j2 RGBDS=rgbds-1.0.0/ crystal crystal_debug
git diff --check
```

JSON은 출처·번역 계획 및 검증용 데이터다. 제품 빌드 입력은 수정한 ASM이며,
참조 골드 디렉터리나 이 JSON을 ROM 빌드의 필수 의존성으로 추가하지 않았다.

## 2026-10-11 후속: 연결동굴·34번도로·금빛시티

기존 미커밋 번역과 문서 정리 결과를 보존하고 별도 범위로 조사했다.
이번 시작 상태는 HEAD에 없는 기존 변경을 포함하므로 Git HEAD만을 비교
기준으로 사용하지 않는다. 관련 38개 소스 파일(맵 36개·전화 2개)의 시작
내용을 `.verification/union-route34-goldenrod-20261011/baseline/`에 복사했다.
범위·제외 대상은 `data/translation/union-route34-goldenrod-scope.json`,
적용한 582블록의 출처·정확한 문자열 행은
`data/translation/union-route34-goldenrod.json`에 기록한다.

### 조사한 지역별 파일과 연결

- 연결동굴: `maps/UnionCave1F.asm`, `UnionCaveB1F.asm`, `UnionCaveB2F.asm`.
  1층은 32·33번도로와 지하1층, 지하1층은 알프 유적 및 지하2층으로
  연결된다. 지하2층의 라프라스 요일 이벤트와 각 층의 트레이너 대사를 포함했다.
  인접 알프 유적·32·33번도로의 기존 번역은 재수정하지 않는다.
- 34번도로: `maps/Route34.asm`, `DayCare.asm`, `Route34IlexForestGate.asm`.
  남쪽 숲 관문·북쪽 금빛시티, 보모의 집 안팎과 알 이벤트를 확인했다.
  관문의 기존 한국어 5블록은 유지했다. `PHONE_CAMPER_TODD` 및
  `PHONE_PICNICKER_GINA`와 공용 스크립트 분기를 통해 호출되는
  `data/phone/text/todd_overworld.asm`, `gina_overworld.asm`도 포함했다.
  보모의 공용 양육·회수 대사는 `engine/events/daycare.asm`에서
  `data/text/common_1.asm`을 참조하며 이미 한국어인 문구는 유지했다.
- 금빛시티 직접 건물·관문: `maps/GoldenrodCity.asm`, `GoldenrodGym.asm`,
  `GoldenrodBikeShop.asm`, `GoldenrodHappinessRater.asm`, `BillsFamilysHouse.asm`,
  `GoldenrodMagnetTrainStation.asm`, `GoldenrodFlowerShop.asm`,
  `GoldenrodPPSpeechHouse.asm`, `GoldenrodNameRater.asm`, `GoldenrodGameCorner.asm`,
  `GoldenrodPokecenter1F.asm`, `PokecomCenterAdminOfficeMobile.asm`,
  `Route35GoldenrodGate.asm`.
- 금빛시티 백화점: `maps/GoldenrodDeptStore1F.asm`부터 `GoldenrodDeptStore6F.asm`,
  `GoldenrodDeptStoreRoof.asm`, `GoldenrodDeptStoreB1F.asm`,
  `GoldenrodDeptStoreElevator.asm`. 옥상·지하 창고의 워프까지 확인했다.
- 금빛시티 지하·라디오타워: `maps/GoldenrodUnderground.asm`,
  `GoldenrodUndergroundSwitchRoomEntrances.asm`, `GoldenrodUndergroundWarehouse.asm`,
  `RadioTower1F.asm`부터 `RadioTower5F.asm`. 지하 창고에서 백화점으로 연결되는
  워프 및 라디오타워 점령·열쇠·국장 구출 이벤트를 포함한다.

금빛시티 맵 30개에는 표시 대사 블록이 472개 있다. 이름풀이 집과
백화점 엘리베이터에는 자체 `text` 블록이 없지만 공용 루틴과 메뉴를 호출한다.
코인 판매·경품 메뉴, 엘리베이터 현재 층, 암호 포인트 UI, 기술 가르침,
포켓몬통신센터 메뉴 등 별도 표시 문자열도 확인했다. 공용 파일에서는
지역 관련 문구만 후속 적용해야 하며 고정 길이 레코드와 구별해야 한다.
특히 `Route35GoldenrodGate.asm`의 선물 메일·포켓몬 이름·OT는 저장/비교
데이터이며 기존 알프 조사 기록의 `Route31:ReceivedSpearowMailText`와 관계가
있어 원문을 유지한다. 35번도로 본도로, 노랑시티 역, 공용 센터2층 및
이동 중 전화 통화는 이번 지역 조사와 분리한다.

### 물결표 승인 전 상태(이전 빌드 기록)

| 지역 | original-gold 재사용 | oldgold 재사용 | 신규·추가 내용 | 기존 한국어 유지 | 일반/디버그 빌드 |
|---|---:|---:|---:|---:|---|
| 연결동굴 | 37 | 0 | 0 | 0 | 성공 / 성공 |
| 34번도로·보모·현장 전화 | 34 | 0 | 25 | 5 | 성공 / 성공 |
| 금빛시티 | 미적용 | 미적용 | 미적용 | — | 번역 적용 전 인코딩 문제로 보류 |

실제 게임 소스 수정은 연결동굴 3개, 34번도로·보모의 집 2개, 현장 전화
2개의 총 7파일이다. 금빛시티 맵 30개는 시작 스냅샷과 모두 동일하다.
문자열 이외의 코드 및 기존 한국어는 바꾸지 않았다. 이번 후속 작업에서
문서를 추가 삭제하거나 기존 사용자 변경을 되돌리지 않았다.

34번도로의 다음 문구는 골드를 무조건 복사하지 않고 크리스탈 의미를 보존했다.

- `CamperTodd1AfterText`: 골드에 없는 도구 사용 고민을 추가했다.
- `CooltrainerfIreneSeenText`: 원문의 `Someone`과 여주인공 가능성을 보존하여
  골드의 “남자애”라는 특정 성별 표현을 적용하지 않았다.
- `CooltrainerfJennAfterText1`: 자기 방심을 후회하는 골드 표현과 달리
  상대에게 자만하지 말라고 하는 크리스탈 원문을 번역했다.
- `DayCareText_ComeAgain`: 같은 보모 맥락의
  `original-gold/data/text/common_1.asm:_ComeAgainText`를 재사용했다.

### 중단 사유와 필요한 승인

골드의 `maps/RadioTower4F.asm:GruntM10BeatenText`는 `오- 이런~!`,
`maps/RadioTower5F.asm:RadioTower5FRocketBossWinText`는 `…… 크윽~`다.
`oldgold`에도 같은 물결표가 있으며 현재 일반 대사 문자표
(`charmap.asm`, `charmap_hangul_poc.asm`, `charmap_hangul_complete.asm`)에는
`~`가 없다. 그대로 삽입하면 미등록 문자 경고와 원시 ASCII 바이트가
남으며 올바른 글리프 출력을 보장할 수 없다. 문구를 임의로 바꾸거나
경고를 숨기지 않는 규칙에 따라 금빛시티 적용을 중단했다.

기존 `constants/charmap_pokemon_names.asm`에는 물결표가 `$0b, $69`로
등록되어 있고 `gfx/font/font_hangul.1bpp`의 2665번 글리프에도 물결 모양의
픽셀이 있다. 일반 한글 출력 루틴은 이 뱅크·글리프 범위를 지원한다.
후속 후보는 일반 대사 문자표에 다음 1줄을 추가하는 것이다:

```asm
charmap "~", HANGUL_POC_ESCAPE, $0b, $69
```

이는 버퍼·폰트 자산·게임 로직 변경 없이 기존 글리프를 연결하는 후보지만,
번역 문자열 이외의 수정이므로 승인 전에는 적용하지 않았다. 승인 후
기존 `std_text.asm:155` 문구의 인코딩 변화와 관련 출력 소비자도 검증하고
금빛시티 번역을 이어가야 한다. 실제 화면은 여전히 사용자 확인 대상이다.

골드 대응을 확인한 192블록의 미적용 행 배치 초안은
`data/translation/goldenrod-draft-pending.json`으로 분리했고 적용 계획이나
ROM 빌드 입력으로 취급하지 않는다. 선택 근거 목록은
`goldenrod-reference-selection.json`, 문구를 바꾸지 않는 배치 도구는
`tools/region_reference_layout.py`에 있다. 변수 삽입·숫자 매크로·메뉴 문구와
크리스탈 고유 대사는 별도 행 배치 및 의미 검토가 남아 있다. 금빛시티의
같은 레이블이 뜻까지 같다는 보장은 없으며 특히 이수재 가족·체육관·
라디오 퀴즈의 변경 내용을 다시 확인해야 한다.

### 물결표 승인 전 ROM 검증(이전 기록)

적용 96블록의 소스 보존·18열·최대 7글자 이름·인코딩 검사, 일반·디버그
ROM의 정확한 인코딩 바이트와 종료 코드 및 맵 텍스트 참조 37개를 검증했다.
지역별 일반·디버그 빌드 성공, `git diff --check` 통과.
기존 검증 도구 9종도 두 ROM 모두 통과했다. 기존 앞선 다섯 지역의 200블록도
소스 및 최종 ROM 검사를 다시 실행해 보존 여부를 확인했다.
기존 `std_text.asm:155`의 `~` 경고는 변경하지 않아 여전히 남아 있다.
새로 적용한 문자열은 미등록 문자가 없다. 에뮬레이터 검증은 미실시다.

- 일반 ROM SHA-256: `0fc6cadc38e5ea72235ca5d52638863ad784859c1baacd5f9f19d37a595fce01`
- 디버그 ROM SHA-256: `df74a9a52bd80e0df0230744199b23621d40131742d911f4984c17e2535b09cf`

```text
python -X utf8 tools/region_translation.py verify union --scope data/translation/union-route34-goldenrod-scope.json --plan data/translation/union-route34-goldenrod.json --baseline-dir .verification/union-route34-goldenrod-20261011/baseline
python -X utf8 tools/region_translation.py verify route34 --scope data/translation/union-route34-goldenrod-scope.json --plan data/translation/union-route34-goldenrod.json --baseline-dir .verification/union-route34-goldenrod-20261011/baseline
python -X utf8 tools/region_translation.py rom all --scope data/translation/union-route34-goldenrod-scope.json --plan data/translation/union-route34-goldenrod.json --rom pokecrystal.gbc --sym pokecrystal.sym
python -X utf8 tools/region_translation.py rom all --scope data/translation/union-route34-goldenrod-scope.json --plan data/translation/union-route34-goldenrod.json --rom pokecrystal_debug.gbc --sym pokecrystal_debug.sym
```

### 물결표 승인 후 적용 결과와 이전 용량 오류

위 보류 상태는 이전 시점의 기록이다. 이후 사용자의 `승인!`에 따라
`constants/charmap_hangul_poc.asm`에 물결표 한 줄을 등록하고 금빛시티를
번역했다. 버퍼·폰트·출력 루틴·맵 섹션 배치는 변경하지 않았다.

금빛시티 맵 30개를 조사하여 자체 대사가 있는 28개 맵의 471블록을 적용했다.
골드 재사용 323블록, 신규·크리스탈 추가 내용 148블록이다. 이름풀이 집과
백화점 엘리베이터 맵은 자체 대사가 없어 변경하지 않았다.
공용 `data/text/common_1.asm`의 부에나 방송 15블록도 신규 번역했다.
그 외 기존 한국어 25블록(이름풀이 10, 경품 6, 코인 판매 8, 층 질문 1)은
그대로 보존했다. `oldgold`만에서 가져온 대사는 없다.

별도 표시 문자열 38행(골드 표현·명칭 30행, 신규 8행)은
`data/translation/goldenrod-literals.json`에 기록했다. 대상은 기술 가르침,
게임코너 경품, 백화점 자판기, 모바일 관리실 메뉴, 공용 코인 판매 메뉴,
엘리베이터의 현재 층, 블루카드 포인트, 부에나 방송명과 암호 후보다.
공용 파일은 `engine/events/{std_scripts,elevator,buena}.asm`,
`engine/pokegear/{radio,pokegear}.asm`, `data/radio/buenas_passwords.asm`이며
해당 문자열 외에는 수정하지 않았다.

- 가격은 골드와 다른 크리스탈의 경품 구성·금액을 유지한다. 골드의 `₩`는
  현재 문자표에 없어 삽입하지 않고 기존 크리스탈 `¥`를 유지했다.
- `<PLAY_G>`는 실제 코드에서 이름에 `군/양`을 붙인다. 이름 최대 7열에
  접미사 1열을 포함해 검사한다. 국장의 골드 표현을 재사용할 때도
  크리스탈의 성별 이름 토큰을 보존하고 중복 접미사를 넣지 않는다.
- 모바일 관리실의 `<WO>`는 현재 소비자에서 공백으로 유지한다. `<GA>`는
  일본어 고정 글자 축약 토큰이며 현재 영문 소비자에서는 `PKMN`을 출력한다.
  해당 메뉴의 번역에서는 이를 한국어 조사 문자열로 대체했다. 변수·대기·
  줄바꿈·종료·이벤트 토큰은 변경하지 않았다.
- 부에나는 골드에 없는 `BUENA`의 신규 음역으로 통일한 개발 초안이다.
  일반 라디오 채널명 전체, 이동 중 전화, 공용 센터2층 등으로 범위를 확대하지 않았다.
- 점만 있는 대사, 부에나의 변수 암호/말줄임/방송 종료 빈 문자열, 기술
  가르침의 빈 텍스트, 관문의 고정 길이 선물 메일·포켓몬 이름·OT는 유지했다.
  미사용 모바일 대사는 번역했지만 모바일 기능을 활성화하지 않았다.

#### 섹션 분리 전 검증 기록

시작 스냅샷과 전체 소스를 대조하여 지정 문자열 외의 코드·레이블·포인터·
버퍼·숫자·제어 구조와 기존 한국어가 동일함을 검증했다. 18열 및 이름 최대
폭, 전체 신규 글자 매핑, 각 메뉴의 표시 폭·항목 수·가격·종료 코드 검사를
통과했다. 부에나의 raw 암호 소비자는 바이트 단위로 `$50`을 찾으므로,
새 후보 9개에 내장 `$50`이 없고 25바이트 버퍼 안에 들어감을 별도 검증했다.
`git diff --check`도 통과했다. 앞선 다섯 지역의 200블록은 원본과 이번 공용
변경을 합쳐 소스 보존을 확인했고, 마지막 성공 ROM의 200블록 검사도 통과했다.

물결표 등록 직후의 일반·디버그 빌드는 성공했다. 실제 ROM에서 2665번
글리프의 폰트 바이트와 기존 `HomepageText`의 `$17,$0b,$69` 인코딩도 확인했다.
이 성공 ROM에는 아직 금빛시티 번역이 포함되지 않는다.

금빛시티 적용 후 일반 빌드와 디버그 맵 오브젝트 조립은 다음 용량 오류로
실패했다. 번역된 최종 ROM은 만들어지지 않았으며, 아래 수치는 마지막 성공
`.map` 크기에 실제 활성 문자열의 정확한 인코딩 증감량을 더해 계산했다.
초과 수치는 조립기의 진단과 일치한다.

| 섹션 | 변경 전 | 변경 후 | 16,384바이트 한도 초과 |
|---|---:|---:|---:|
| Map Scripts 1 | 13,098 | 16,391 | 7 |
| Map Scripts 19 | 15,743 | 16,464 | 80 |

다른 관련 섹션의 여유는 Scripts 3: 1,850, Scripts 4: 443,
Violet Academy: 12,632, Scripts 10: 1,331바이트다.
금빛시티 최종 ROM의 텍스트 바이트·포인터·회귀 검사는 빌드 실패로 미실시다.
에뮬레이터·표시 검증도 미실시이며 성공한 것으로 취급하지 않는다.

당시 성공 ROM(금빛시티 적용 전)의 SHA-256 — 현재 산출물 아님:

- 일반: `cbbc30bd63c6d06a0eb4349b0491cde6c1a857e45cc58dfb2af23b8d77fba2bd`
- 디버그: `eb5327e69afd6d35b97842d846293d811342d73f3c60754f6523596b793c5b63`

#### 승인한 섹션 분리 적용 및 최종 검증 — 2026-10-11

사용자는 섹션 분리를 승인했고 필요하면 ROM도 확장해도 된다고 지시했다.
`data/maps/scripts.asm`에서 `GoldenrodPPSpeechHouse.asm`(330바이트)와
`GoldenrodCity.asm`(3,362바이트)을 통째로 새 `ROMX` 섹션
`Goldenrod Overflow Map Scripts`로 옮겼다. 그 외 INCLUDE 순서와 맵 소스의
코드·이벤트·번역은 그대로다. 원래 섹션의 사용량은 각각 16,061·13,102바이트,
16KB 한도 대비 성장 여유는 323·3,282바이트다. 이는 섹션 여유이며 뱅크 전체의
미사용량으로 취급하지 않는다.

일반·디버그 빌드 모두 성공했다. 새 묶음은 3,692바이트이며 둘 다 뱅크
`$20`에 배치됐다. 일반 범위는 `$70f5..$7f60`, 디버그는 `$7102..$7f6d`다.
기존 2MiB 안에 들어가 ROM 확장·카트리지 변경·버퍼 변경은 필요하지 않았다.
최종 ROM의 MBC3 헤더·ROM/RAM 크기 필드·헤더 및 전체 체크섬도 통과했다.

- 지정 소스의 문자열 외 코드, 기존 한국어, 출력 제어·변수·숫자 보존 검사 통과.
- 각 ROM에서 582 대사 블록의 정확한 인코딩·종료·제어 바이트 및
  402개 맵 텍스트 참조의 같은 뱅크 관계를 검증했다.
- 각 ROM에서 38개 표시 문자열·메뉴 헤더 바이트 검증 통과.
- 이전 다섯 지역의 200블록 소스·ROM 바이트와 153개 텍스트 참조 보존 통과.
- `tools/verify_goldenrod_layout.py`는 승인한 두 INCLUDE 이동만 발생했는지,
  전체 388개 맵 속성의 블록/스크립트/이벤트 포인터·뱅크와 이동한 두 맵의
  34개 콜백/이벤트 포인터를 실제 ROM에서 검사한다. 지역 분기·대사·메뉴·
  이동 데이터의 near 참조 뱅크도 검사한다. 일반·디버그 모두 통과했다.
- 기존 9개 도구(`following_sprites`, `stats_transitions`, `tmhm_text`,
  `item_text`, `landmark_names`, `start_menu_window`, `start_menu_return`,
  `pack_clear`, `hangul_upload_timing`)를 각 최종 ROM에서 모두 실행해 통과했다.
  제한된 CPU 모델과 외부 호출 스텁을 사용하는 검사이며 PPU/실게임 증거가 아니다.
- 기술 이름과 폰트 해시를 보존했고, 두 ROM에서 물결표 글리프와
  `HomepageText` 인코딩도 확인했다. 추가 문서 삭제나 참조 디렉터리 변경은 없다.

현재 번역 반영 완료 ROM의 SHA-256:

- 일반: `e8b96851fefce3ed6eef46f5c3a4accabd30c33a3d4da90bc1e0eaf0e9f42eaf`
- 디버그: `7d2268cb41c8386419b36f43d90fa2f052b8a3935e7edfe66776515378b9f733`

에뮬레이터의 실제 표시·이벤트·출입/재진입은 미검증이다. 최종 ROM을 사용자가
테스트할 예정이며, 기술적 빌드·정적 검증 완료를 배포 준비 완료로 취급하지 않는다.

상태·집계·검증 근거는 `data/translation/goldenrod-status.json`에 기록한다.
`goldenrod-draft-pending.json`은 이전 초안으로 표시했으며 실제 적용 계획은
`union-route34-goldenrod.json`과 `goldenrod-literals.json`이다. 개발·검토 상태이며
배포 후보 또는 실제 게임 동작 검증 완료로 취급하지 않는다.

```text
python -X utf8 tools/region_translation.py verify all --scope data/translation/union-route34-goldenrod-scope.json --plan data/translation/union-route34-goldenrod.json --literals data/translation/goldenrod-literals.json --baseline-dir .verification/union-route34-goldenrod-20261011/baseline
python -X utf8 tools/goldenrod_literals.py verify --plan data/translation/goldenrod-literals.json --text-plan data/translation/union-route34-goldenrod.json --baseline-dir .verification/union-route34-goldenrod-20261011/baseline
python -X utf8 tools/verify_goldenrod_layout.py pokecrystal.gbc pokecrystal.sym
python -X utf8 tools/verify_goldenrod_layout.py pokecrystal_debug.gbc pokecrystal_debug.sym
```
