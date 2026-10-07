# 팔로우 포켓몬 한글 이름 출력 수정 계획

작성: 2026-10-07. 상태: 단계 1 구현 및 정적 검토 완료, 사용자 빌드/게임 검증 대기.

## 목표와 범위

팔로우 포켓몬에게 말을 걸었을 때 파티 메뉴와 같은 닉네임이 표시되도록 한다.
사용자 계획 승인 후 단계 1을 구현했다. 이후 단계는 사용자 게임 테스트 결과에 따라 진행한다.

- 사용자가 이미 수정한 팔로우 번역은 그대로 보존한다.
- 저장된 이름 형식, 이름 입력 기능, 최대 5글자, RAM 배치는 유지한다.
- 빌드와 실제 게임 테스트는 사용자가 수행한다.
- 기존 돈 증가 수정의 검증 상태와 이번 이름 출력 검증은 별도로 기록한다.

## 확인한 원인 경로

1. `engine/events/follower.asm`의 `DoFollowerInteraction`은 처음에
   `StoreFollowerNickInBuffer`를 호출한다.
2. 이 함수는 `wFollowerPartyNum - 1`에 해당하는 파티 닉네임 11바이트를
   `wStringBuffer1`에 복사하고 바로 반환한다.
3. 저장용 한글 닉네임은 글자마다 `bank, index` 2바이트를 사용한다.
   표시용 문자열은 글자마다 `$17, bank, index` 3바이트가 필요하다.
4. 팔로우 대사는 공통으로 `text_ram wStringBuffer1`을 사용한다.
   `TextCommand_RAM → PlaceRAMString`은 이 버퍼에 별도의 이름 변환을 하지 않고
   `PlaceString`으로 보낸다. 따라서 저장용 바이트가 일반 문자나 제어 코드로 해석된다.
5. 정상 출력 경로인 `home/pokemon.asm`의 `GetNickname`은 복사 후
   `CorrectNickErrors`와 `ExpandNicknameBuffer`를 호출한다.
   특히 `ExpandNicknameBuffer`가 저장용 이름을 표시용 문자열로 변환한다.

사용자 관측인 '영문 이름은 정상, 한글 이름만 영문/특수문자로 깨짐'과 일치하는
변환 누락이다. 현재 팔로우 대사의 일부는 이미 한글로 바뀌었지만, 문장 번역은
저장 형식의 변환을 대신하지 않는다. 실제 수정 후 같은 이름으로 런타임 확인이 필요하다.

## 구현 전 확인한 조건

- `MON_NAME_LENGTH = 11`, `HANGUL_NAME_DISPLAY_LENGTH = 16`이다.
- `STRING_BUFFER_LENGTH = 19`이므로 `wStringBuffer1`에 5글자 표시용 문자열과
  종료 문자까지 들어간다. 인접한 `wStringBuffer2`를 침범할 필요가 없다.
- `ExpandNicknameBuffer`는 ROM0 함수이고 내부에서 기존 ROMX 디코더를 호출한다.
  팔로우 ROMX 코드에서는 일반 `call` 또는 `jp`로 이 ROM0 함수를 사용할 수 있다.
  새 ROM0 함수나 전용 RAM 버퍼를 만들 필요가 없다.
- `CopyBytes`는 DE를 복사 끝으로 이동시킨다. 변환 전 반드시
  `ld de, wStringBuffer1`로 버퍼 시작 주소를 다시 지정해야 한다.
- `ExpandNicknameBuffer`는 DE/HL을 보존하고 나머지 레지스터를 변경한다.
  호출 직후 `DoFollowerInteraction`은 HL과 포켓몬 종/타입 관련 레지스터를 다시
  설정하므로 이 경계에서 변환하는 것이 적합하다.
- `GetFirstAliveMon`은 파티 번호를 1부터 세고, `GetFollowingSprite`가 이를
  `wFollowerPartyNum`에 저장한다. 닉네임 복사 함수의 `dec a`는 이 계약에 맞는다.
  현 증거로 이름 선택 인덱스를 바꿀 이유는 없다.
- 현재 map에는 Follower Script가 ROMX에 배치되어 있다. 기존 사용자 번역과
  추가 코드의 최종 공간 여부는 사용자 빌드의 linker 결과로 확인한다.
- 디코더는 잘못된 레코드이면 carry를 설정하고 원본 버퍼를 유지한다.
  이 경우는 정상 이름 테스트와 구분하고, 임의 문자 치환으로 덮지 않는다.

## 단계 1 — 공통 복사 경계에서 변환 추가

수정 대상: `engine/events/follower.asm`의 `StoreFollowerNickInBuffer` 끝부분만.

예정 코드:

```asm
    ld de, wStringBuffer1
    ld bc, MON_NAME_LENGTH
    call CopyBytes
    ld de, wStringBuffer1
    jp ExpandNicknameBuffer
```

기존 `jp CopyBytes`를 복사 후 변환으로 바꾼다. 변환은 대사마다 추가하지 않고,
팔로우 대사가 공유하는 이름 공급 지점에서 한 번 수행한다.
일반 `text_ram`의 의미와 파티 저장 레코드는 변경하지 않는다.
현재 정상적인 입력으로 생성된 레코드를 먼저 대상으로 삼는다.

정적 검토: 대상 함수 밖의 대사 변화가 없는지, 버퍼 크기와 호출 계약이 맞는지,
ROM0/RAM 레이아웃을 추가로 확장하지 않았는지 확인한다.

## 단계 2 — 사용자 검증

먼저 아래 세 이름으로 파티 메뉴와 팔로우 대사의 표시를 비교한다.

| 이름 | 검증 목적 |
|---|---|
| 가가가각 | 반복 글자와 받침의 변환 |
| 포뽀모보옴 | 5글자와 여러 글꼴 bank |
| ㄱㄱㄱㄱㄱ | 조합되지 않은 자음 |

세 경우가 통과하면 다음 회귀를 확인한다.

- 영문 이름과 닉네임을 바꾸지 않은 기본 종 이름이 계속 정상 표시된다.
- 서로 다른 이름을 가진 포켓몬의 파티 순서를 바꾸면 팔로우 이름도 맞게 바뀐다.
- 가능하면 선두 기절로 두 번째 포켓몬이 따라오는 경우도 같은 결과인지 확인한다.
- 같은 이름으로 여러 번 말을 걸어도 이름과 뒤 문장이 깨지지 않는다.
- 이미 접근 가능한 다른 상호작용 대사에서도 확인한다. 새 지역 진행은 필수로 요구하지 않는다.
- 일반 레포트 저장 후 ROM을 다시 실행해도 동일하게 표시된다.
  이전 빌드의 에뮬레이터 상태 저장은 이번 결과의 기준으로 삼지 않는다.

## 단계 3 — 실패할 때만 추가 관측

기본 테스트가 통과하면 메모리 덤프는 요구하지 않는다.
여전히 깨지면 같은 ROM에서 다음 값을 변환 전/후와 출력 직전에 비교한다.

- 선택된 `wFollowerPartyNum`과 해당 파티 닉네임 원본 11바이트.
- `wStringBuffer1` 시작의 19바이트.
- `ExpandNicknameBuffer` 반환 carry 또는 디코더 반환 B.
- PC의 ROM bank 및 `rSVBK`가 가리키는 WRAM bank.

기존 debug sym 기준 `wStringBuffer1 = bank 1:$D073`, `wStringBuffer2 = bank 1:$D086`,
`wFollowerPartyNum = $C2D3`이다. 실제 테스트에서는 새 빌드 sym으로 주소를 재확인한다.
5글자 packed 한글의 정상 변환 결과는 `$17, bank, index` 다섯 묶음과 `$50` 종료 문자이다.
index 자체가 `$50`일 수 있으므로 중간 바이트를 종료 문자로 오인하지 않는다.

변환 후 버퍼가 정상인데 화면만 깨지면 폰트/캐시 경로를 조사한다.
변환 자체가 실패하면 원본 레코드와 선택 번호를 조사한다.
대사 직전에 버퍼가 달라지면 중간 덮어쓰기 경로를 조사한다.
이 관측 결과에 따라 다음 수정 범위를 정한다.

## 완료 조건

같은 닉네임이 파티 메뉴와 팔로우 대사에서 일치하고, 5글자·자음·받침·영문·기본 이름,
파티 순서 변경 및 일반 저장/재로드에서 회귀가 없을 때 완료로 기록한다.
코드 추가만으로 런타임 검증 완료로 처리하지 않는다.

## 단계 1 구현 기록

- `StoreFollowerNickInBuffer`에서 복사를 `call CopyBytes`로 수행한 뒤,
  DE를 `wStringBuffer1` 시작으로 재설정하고 `jp ExpandNicknameBuffer`로 반환한다.
- 기존 표시용 디코더를 사용하며 새 ROM0 함수, RAM 변수, 저장 형식 변경은 없다.
- 실행 코드 증가량은 ROMX의 6바이트다. 대사와 팔로우 선택 로직은 변경하지 않았다.
- 호출 계약과 버퍼 용량을 정적으로 검토했다. 빌드와 게임 테스트는 수행하지 않았다.
- 단계 2의 원래 실패 이름부터 사용자 검증을 요청한다.
