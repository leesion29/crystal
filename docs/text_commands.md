# Text Commands

Defined in [macros/scripts/text.asm](https://github.com/pret/pokecrystal/blob/master/macros/scripts/text.asm) and [home/text.asm:TextCommands](https://github.com/pret/pokecrystal/blob/master/home/text.asm).


## `$00`: `text_start`

Start writing text until `"@"`. The text can use [control characters](#control-characters).


## `$01`: <code>text_ram <i>address</i></code>

Write text from a RAM address.


## `$02`: <code>text_bcd <i>address</i>, <i>flags</i></code>

Write [BCD][bcd] from an address, typically RAM.

[bcd]: https://en.wikipedia.org/wiki/Binary-coded_decimal


## `$03`: <code>text_move <i>address</i></code>

Move to a new tile.


## `$04`: <code>text_box <i>address</i>, <i>height</i>, <i>width</i></code>

Draw a box.


## `$05`: `text_low`

Write text at (1, 16).


## `$06`: `text_promptbutton`

Wait for button press; show arrow.


## `$07`: `text_scroll`

Pushes text up two lines and sets the `bc` cursor to the border tile below the
first character column of the text box.


## `$08`: `text_asm`

Start interpreting assembly code.


## `$09`: <code>text_decimal <i>address</i>, <i>bytes</i>, <i>digits</i></code>

Read *bytes* bytes from *address* and print them as a *digits*-digit number.


## `$0A`: `text_pause`

Pause for 30 frames unless A or B is pressed.


## `$0B`: `sound_dex_fanfare_50_79`

Play `SFX_DEX_FANFARE_50_79`.


## `$0C`: <code>text_dots <i>n</i></code>

Print *n* `"…"`s, pausing for 10 frames after each; interrupt if A or B is pressed.


## `$0D`: `text_waitbutton`

Wait for button press; don't show arrow.


## `$0E`: `sound_dex_fanfare_20_49`

Play `SFX_DEX_FANFARE_20_49`.


## `$0F`: `sound_item`

Play `SFX_ITEM`.


## `$10`: `sound_caught_mon`

Play `SFX_CAUGHT_MON`.


## `$11`: `sound_dex_fanfare_80_109`

Play `SFX_DEX_FANFARE_80_109`.


## `$12`: `sound_fanfare`

Play `SFX_FANFARE`.


## `$13`: `sound_slot_machine_start`

Play `SFX_SLOT_MACHINE_START`.


## `$14`: <code>text_buffer <i>id</i></code>

Write text from one of the following addresses (listed in [data/text_buffers.asm](https://github.com/pret/pokecrystal/blob/master/data/text_buffers.asm)):

0. `wStringBuffer3`
1. `wStringBuffer4`
2. `wStringBuffer5`
3. `wStringBuffer2`
4. `wStringBuffer1`
5. `wEnemyMonNickname`
6. `wBattleMonNickname`


## `$15`: `text_today`

Print the weekday.


## `$16`: <code>text_far <i>address</i></code>

Write text from a different bank.


## `$50`: `text_end`

Stops processing text commands.


# Control characters

These get interpreted in the context of printing regular text. Macros exist to conveniently place the control characters.


## `$00`: <code>text <i>text</i></code>

Start writing text until `"@"`. (Not actually a control character, but shorter than `text_start` followed by `db`.)


## `$4E`, `"<NEXT>"`: <code>next <i>text</i></code>

Move a line down.


## `$4F`, `"<LINE>"`: <code>line <i>text</i></code>

Start writing at the bottom line.


## `$50`, `"@"`: <code>page <i>text</i></code>

Start a new Pokédex page.


## `$51`, `"<PARA>"`: <code>para <i>text</i></code>

Start a new paragraph.


## `$55`, `"<CONT>"`: <code>cont <i>text</i></code>

Scroll to the next line.


## `$57`, `"<DONE>"`: `done`

End a text box.


## `$58`, `"<PROMPT>"`: `prompt`

Prompt the player to end a text box (initiating some other event).


# 현재 프로젝트의 한국어 출력 적용

위 명령 표는 upstream의 일반 명세다. 한국어 배치 시에는 아래 실제 구현을
함께 확인한다. 영문 원문의 문자열 행 수를 그대로 유지한다는 규칙은 없다.

- `home/text.asm`의 `BuenaPrintText`는 내부 18열·4타일 행을 지운다.
  한글은 `engine/hangul/text.asm`에서 8×16픽셀, 즉 1열·2타일 행을 쓴다.
  일반 대화창에는 한글 두 줄이 들어간다. 기준 아래쪽 타일 좌표는
  `(1,14)`와 `(1,16)`이고 각 글자의 윗부분은 한 타일 행 위에 그린다.
- `text`는 `TX_START`를 출력해 문자열 해석을 시작한다. 보통 첫 문장에 쓴다.
  `text_ram`·숫자·효과음 등 TX 명령으로 넘어가기 전에는 현재 문자열을 `@`로
  끝내야 한다. 그 뒤의 `text`는 **현재 커서에서** 이어쓴다. 매번 새 페이지가 아니다.
- `line`/`<LINE>`은 무조건 둘째 줄 시작으로 이동한다. 둘째 줄에서 반복하면
  앞의 문장을 덮어쓴다. `next`/`<NEXT>`는 현재 줄 시작에서 2타일 행 내려간다.
  일반 창의 셋째 줄을 확보하지 않으므로 도감의 3줄 배치와 혼동하지 않는다.
- `cont`/`<CONT>`는 화살표와 입력 대기 후 2타일 행을 스크롤한다.
  `text "123"` / `line "456"` / `cont "789"`는 먼저 123·456을 보이고,
  A/B 입력 뒤 456·789를 보인다. 셋째 줄부터는 이 방식으로 이어 쓸 수 있다.
- `$07`의 upstream 설명과 코드 주석은 커서를 border tile로 표현하지만,
  실제 `TextCommand_SCROLL`은 `TextScroll`을 두 번 호출하고 `(1,16)`, 즉
  현재 한글 창의 둘째 줄 기준 타일로 이동한다. 이 명령과 `<SCROLL>`은
  `cont`와 달리 자체 입력 대기가 없다. 명령/문자 해석 문맥도 서로 다르다.
- `para`/`<PARA>`는 입력 대기 후 창을 지우고 첫 줄로 돌아간다.
  새 문단·페이지에 사용한다. 짧은 어절마다 페이지를 나누거나 영문 페이지 수를
  채우기 위한 빈 줄을 만들지 않는다. 기존 `para ""` 중에는 입력을 기다린 뒤
  창을 지우는 용도가 있으므로 호출 문맥을 확인해 보존한다.
- `done`은 끝내는 제어 문자다. 자체 입력 대기를 보장하지 않는다.
  `prompt`는 화살표·입력 대기 후 끝낸다. 호출자의 `waitbutton`/`promptbutton`,
  `text_waitbutton`/`text_promptbutton`, 효과음, 숫자 인수와 종료 방식은 보존한다.
- 변수 폭은 인코딩 바이트 수가 아니라 실제 출력 글리프 수로 계산한다.
  `<PLAYER>`는 현재 이름 디코더를 호출하며 최대 영문 7열, 한글 5열이다.
  `<PLAY_G>`는 군/양 한 글자를 더한다. 버퍼는 호출부의 생산자까지 추적한다.
  이름·변수·조사를 같은 줄에 놓을 때 합계 폭을 검사한다.
- `page`는 `@`를 출력하는 **도감 페이지** 구분이다. 일반 대화창의 `para`와
  바꾸어 쓰지 않는다. 현재 도감은 골드의 18열·한글 3줄 **한 페이지** 설명을
  표시하도록 이미 구현되어 있다. 아이템 설명은 별도 2줄 소비자다.
  라디오는 자동 진행 루틴이 첫 두 세그먼트의 줄 위치를 다시 조정하므로,
  일반 대사의 `cont`/`para`를 넣어 문제를 숨기면 입력 대기·진행 방식이 바뀐다.

현재 발견한 예외 및 보류 사항은 `docs/korean-text-layout-audit.md`에 기록한다.
