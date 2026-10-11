# 31·36번도로와 알프의 유적 번역 범위

작성일: 2026-10-11

## 적용 기준

- 실제 크리스탈 맵 스크립트와 호출 흐름을 기준으로 조사했다.
- `original-gold/maps`를 우선하고, 대응 번역이 없으면 `oldgold/maps`를 확인했다.
- 골드 표현만 재사용하며 크리스탈의 레이블, 스크립트, 버퍼, 변수 삽입, 줄바꿈·대기·종료 명령은 보존했다.
- 이미 한국어인 문자열은 수정하지 않았다. 새 대사는 기술 검증용 번역 초안이며 실제 표시·동작과 최종 문구 검토는 별도이다.
- 이번 작업은 문자열만 수정했다. ROM 섹션·버퍼·출력 루틴은 변경하지 않았다.

## 관련 맵 ASM 목록과 결과

수는 텍스트 블록 기준이다. 같은 문장의 반복도 각 레이블별로 센다.

| 파일 | original-gold 재사용 | 신규·추가 내용 번역 | 기존 한국어 유지 | 비표시 데이터 제외 |
|---|---:|---:|---:|---:|
| `maps/Route31.asm` | 14 | 0 | 2 | 1 |
| `maps/Route31VioletGate.asm` | 0 | 0 | 2 | 0 |
| `maps/Route32RuinsOfAlphGate.asm` | 3 | 0 | 0 | 0 |
| `maps/Route36.asm` | 24 | 3 | 0 | 0 |
| `maps/Route36NationalParkGate.asm` | 41 | 0 | 0 | 0 |
| `maps/Route36RuinsOfAlphGate.asm` | 2 | 0 | 0 | 0 |
| `maps/RuinsOfAlphAerodactylChamber.asm` | 2 | 4 | 0 | 0 |
| `maps/RuinsOfAlphAerodactylItemRoom.asm` | 1 | 0 | 0 | 0 |
| `maps/RuinsOfAlphAerodactylWordRoom.asm` | 0 | 0 | 0 | 0 |
| `maps/RuinsOfAlphHoOhChamber.asm` | 2 | 4 | 0 | 0 |
| `maps/RuinsOfAlphHoOhItemRoom.asm` | 1 | 0 | 0 | 0 |
| `maps/RuinsOfAlphHoOhWordRoom.asm` | 0 | 0 | 0 | 0 |
| `maps/RuinsOfAlphInnerChamber.asm` | 5 | 0 | 0 | 0 |
| `maps/RuinsOfAlphKabutoChamber.asm` | 2 | 9 | 0 | 0 |
| `maps/RuinsOfAlphKabutoItemRoom.asm` | 1 | 0 | 0 | 0 |
| `maps/RuinsOfAlphKabutoWordRoom.asm` | 0 | 0 | 0 | 0 |
| `maps/RuinsOfAlphOmanyteChamber.asm` | 2 | 4 | 0 | 0 |
| `maps/RuinsOfAlphOmanyteItemRoom.asm` | 1 | 0 | 0 | 0 |
| `maps/RuinsOfAlphOmanyteWordRoom.asm` | 0 | 0 | 0 | 0 |
| `maps/RuinsOfAlphOutside.asm` | 7 | 7 | 0 | 0 |
| `maps/RuinsOfAlphResearchCenter.asm` | 13 | 6 | 0 | 0 |
| 합계 | 121 | 37 | 4 | 1 |

`oldgold`에서만 가져온 항목은 없다. 관련 맵 21개 중 16개 파일의 표시 문자열을 수정했다. 문자방 4개에는 표시 문자열이 없고, `Route31VioletGate.asm`은 이미 한국어이므로 변경하지 않았다.

같은 장소·문맥의 대응 관계도 확인했다. 아이템방 4개의 고대 포켓몬 모형 설명은 해당 포켓몬의 골드 석판방 번역을 재사용했다. 연구소의 프린터 사용 가능 안내와 투구방 접수원 대사는 크리스탈에 추가된 내용을 포함하므로 전체 블록을 신규·추가 내용 번역으로 집계했다.

## 표시 문자열이 아닌 데이터와 범위 밖 의존성

- `maps/Route31.asm:ReceivedSpearowMailText`: 표시 대사가 아니라 `checkpokemail`의 비교 데이터이다. `engine/pokemon/mail.asm:CheckPokeMail`은 최대 `MAIL_MSG_LENGTH = $20`바이트를 비교한다. `maps/Route35GoldenrodGate.asm:GiftSpearowMail`과 일치해야 하므로 영어 원문을 유지했다. 이를 한국어로 바꾸려면 선물 메일, 저장·복사·표시 경로와 메일 용량을 함께 검토해야 하므로 이번에는 하지 않았다. NPC가 메일을 읽어 주는 표시 대사는 번역했다.
- `data/events/unown_walls.asm`: `ESCAPE`, `LIGHT`, `WATER`, `HO-OH`는 `engine/events/unown_walls.asm`의 전용 안농 문자 렌더러 입력이다. 일반 한글 문자열로 치환하지 않았다.
- `engine/games/unown_puzzle.asm`: 퍼즐·커서·START/CANCEL은 `gfx/unown_puzzle`의 그래픽 자산이다. ASM 대사 번역으로 바뀌지 않으며 이번에는 수정하지 않았다.
- `engine/events/print_unown.asm`: 안농 프린터의 공용 메뉴 및 스탬프 UI는 이번 맵 대사 번역과 별개로 유지했다.
- `engine/events/std_scripts.asm:DayToTextScript`: 곤충채집 대회 안내에 삽입하는 요일 이름은 현재 영어다. 맵에서 골드의 “요일” 접미사를 재사용했으므로 요일 부분에는 영어가 남는다. 공용 요일 문자열과 다른 소비자를 함께 번역하는 후속 작업이 필요하다.
- 31번도로의 Wade와 36번도로의 Alan 관련 전화용 공용 대사는 `engine/phone` 및 공용 텍스트에 별도로 존재한다. 해당 공용 파일은 수정하지 않았다.

## 정적 확인

수정 전 실제 작업 트리와 비교해 문자열 이외의 소스가 동일하고, 기존 한국어 및 메일 비교 원문이 유지됨을 확인했다. 골드 재사용 121개는 줄 배치용 공백을 제외하면 원문과 동일하다. 변경 문자열은 734줄이다. 이름·수치·종료 토큰과 크리스탈의 출력 명령 순서도 보존했다.

일반·디버그 빌드 모두 성공했다. 두 ROM에서 맵 헤더 388개, 범위 내 텍스트 163블록·754문자열 행의 인코딩과 순서, 같은 뱅크에 있어야 하는 맵 참조 177개, 선물 메일·비교 데이터 일치, 포켓몬 이름 삽입 후속 명령, 18열 표시 범위를 확인했다. 플레이어 이름은 영문 최대 7자, 이름 뒤 호칭은 해당 소비자 기준, 포켓몬 이름 삽입은 최대 10자, 요일은 현재 영문 최대 9자, 대회 남은 시간은 최대 2자리로 검사했다.

최종 ROM SHA-256:

- 일반: `776b756972645b3417228868339479a357081e45310fc1213da1089e53d7463d`
- 디버그: `11e8cae5f20ba4f256dfbe691b8abc1f2be45ab7f24a34bef7872ca939544aca`

실제 에뮬레이터 테스트는 수행하지 않는다. 정적·제한된 CPU 실행 검증의 통과는 게임 화면이나 실제 플레이의 검증을 의미하지 않는다.

일반·디버그 ROM 모두 다음 기존 회귀 검증 7종을 통과했다: `verify_following_sprites.py`, `verify_stats_transitions.py`, `verify_tmhm_text.py`, `verify_item_text.py`, `verify_landmark_names.py`, `verify_start_menu_window.py`, `verify_hangul_upload_timing.py`. ROM 헤더·체크섬·뱅크 범위, 한글 폰트 일치, 아이템·기술머신·랜드마크 경로, 상태창 복귀, START 메뉴 경로 및 한글 업로드 타이밍에 대한 각 검증기의 제한된 검사를 최종 ROM에서 다시 실행했다.

