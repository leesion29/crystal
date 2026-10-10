; name lengths
DEF NAME_LENGTH               EQU 11
DEF PLAYER_NAME_LENGTH        EQU 8
DEF BOX_NAME_LENGTH           EQU 9
DEF MON_NAME_LENGTH           EQU 11
DEF MOVE_NAME_LENGTH          EQU 13
DEF ITEM_NAME_LENGTH          EQU 13
DEF TRAINER_CLASS_NAME_LENGTH EQU 13
DEF NAME_LENGTH_JAPANESE      EQU 6

; Committed Hangul player names keep the original 11-byte record width.
; The display form uses one escape byte plus the two-byte Gold glyph ID.
DEF HANGUL_PLAYER_NAME_MAX_CHARS EQU 5
DEF HANGUL_NAME_DISPLAY_LENGTH EQU HANGUL_PLAYER_NAME_MAX_CHARS * 3 + 1
assert HANGUL_PLAYER_NAME_MAX_CHARS * 2 + 1 == NAME_LENGTH
DEF HANGUL_BOX_NAME_MAX_CHARS EQU (BOX_NAME_LENGTH - 1) / 2
assert HANGUL_BOX_NAME_MAX_CHARS * 2 + 1 == BOX_NAME_LENGTH

; GetName types (see home/names.asm)
	const_def 1
	const MON_NAME              ; 1
	const MOVE_NAME             ; 2
	const DUMMY_NAME            ; 3
	const ITEM_NAME             ; 4
	const PARTY_OT_NAME         ; 5
	const ENEMY_OT_NAME         ; 6
	const TRAINER_NAME          ; 7
	const MOVE_DESC_NAME_BROKEN ; 8
DEF NUM_NAME_TYPES EQU const_value - 1

; see home/text.asm
DEF BORDER_WIDTH   EQU 2
DEF TEXTBOX_WIDTH  EQU SCREEN_WIDTH
DEF TEXTBOX_INNERW EQU TEXTBOX_WIDTH - BORDER_WIDTH
DEF TEXTBOX_HEIGHT EQU 6
DEF TEXTBOX_INNERH EQU TEXTBOX_HEIGHT - BORDER_WIDTH
DEF RADIO_TEXT_BUFFER_LENGTH EQU 128
DEF TEXTBOX_X      EQU 0
DEF TEXTBOX_INNERX EQU TEXTBOX_X + 1
DEF TEXTBOX_Y      EQU SCREEN_HEIGHT - TEXTBOX_HEIGHT
DEF TEXTBOX_INNERY EQU TEXTBOX_Y + 2

; see gfx/frames/*.png
DEF TEXTBOX_FRAME_TILES EQU 6

; PrintNum bit flags (see engine/math/print_num.asm)
	const_def 5
	shift_const PRINTNUM_MONEY        ; 5
	shift_const PRINTNUM_LEFTALIGN    ; 6
	shift_const PRINTNUM_LEADINGZEROS ; 7

; character sets (see charmap.asm)
DEF FIRST_REGULAR_TEXT_CHAR     EQU $60
DEF FIRST_HIRAGANA_DAKUTEN_CHAR EQU $20

; gfx/font/unown_font.png
DEF FIRST_UNOWN_CHAR EQU $40

; Text glyph cache: 54 pairs of vTiles1 tiles from $80 through $eb.
; Keep the fixed cursor tiles $ec-$ee
; (and the gender glyph at $ef) outside the Hangul cache.
DEF MAX_HANGUL_TILE_COUNT EQU 54
DEF HANGUL_ATTR_USED_F    EQU 7
