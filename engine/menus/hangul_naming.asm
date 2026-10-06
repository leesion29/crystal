HangulNaming_DrawKeyboard:
	call HangulNaming_UsesGoldKeyboard
	jp z, HangulPlayer_DrawKeyboard
; Keep Crystal's nine-column cursor grid; read keys from data, not cached tiles.
	xor a
	ldh [hBGMapMode], a
	hlcoord 1, 7
	lb bc, 10, 18
	call NamingScreen_IsTargetBox
	jr nz, .clear
	hlcoord 1, 5
	lb bc, 12, 18
.clear
	call ClearBox
	call HangulNaming_GetKeyTable
	ld d, h
	ld e, l
	hlcoord 2, 8
	call NamingScreen_IsTargetBox
	jr nz, .coords
	hlcoord 2, 6
.coords
	ld b, 4
.row
	ld c, 9
.cell
	push bc
	push hl
	ld a, [de]
	inc de
	push de
	call HangulNaming_KeyTile
	ld [hli], a
.next
	pop de
	pop hl
	inc hl
	inc hl
	pop bc
	dec c
	jr nz, .cell
	push de
	ld de, 2 * SCREEN_WIDTH - 18
	add hl, de
	pop de
	dec b
	jr nz, .row
	call HangulNaming_DrawCommandLabels
	ld a, 1
	ldh [hBGMapMode], a
	ret

HangulNaming_KeyTile:
; Translate an input code to its preloaded keyboard tile.  Do not use the
; dynamic Hangul cache here: this routine is called while drawing the grid.
	and a
	jr z, .blank
	cp $a0
	jr c, .special
	cp $d5
	jr nc, .blank
	sub $a0
	ret
.special
	cp $f6
	jr c, .punctuation
	sub $c1 ; $f6-$ff (0-9) become tiles $35-$3e.
	ret
.punctuation
	cp $7f
	jr z, .space
	cp $40
	jr z, .question
	cp $41
	jr z, .exclamation
.blank
	ld a, ' '
	ret
.space
	ld a, $3f
	ret
.question
	ld a, $40
	ret
.exclamation
	ld a, $41
	ret

HangulNaming_DrawCommandLabels:
; The bottom cursor row is three logical buttons wide: page, delete, end.
; Its glyphs live in the fixed command font area ($5c-$75), never in cache.
	hlcoord 2, 16
	call NamingScreen_IsTargetBox
	jr nz, .coords
	hlcoord 2, 14
.coords
	ld a, $5c ; A
	ld [hli], a
	inc a ; B
	ld [hli], a
	inc a ; C
	ld [hli], a
	ld de, 3
	add hl, de
	ld a, $5f ; D
	ld [hli], a
	inc a ; E
	ld [hli], a
	ld a, $67 ; L
	ld [hli], a
	ld de, 3
	add hl, de
	ld a, $60 ; E
	ld [hli], a
	ld a, $69 ; N
	ld [hli], a
	ld a, $5f ; D
	ld [hl], a
	ret

HangulNaming_GetKeyTable:
	ld a, [wNamingScreenType]
	cp NAME_PLAYER
	jr z, .player
	ld hl, .Consonants
	ld a, [wNamingScreenLetterCase]
	cp 3
	ret nz
	ld hl, .Vowels
	ret
.player
	ld hl, .PlayerConsonants
	ld a, [wNamingScreenLetterCase]
	cp 3
	ret nz
	ld hl, .PlayerVowels
	ret
; The Korean reference has no numeric input cells. Zero disables an empty
; selector; $7f is the distinct, intentional space-input selector.
.PlayerConsonants
	db $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8
	db $a9, $aa, $ab, $ac, $ad, $ae, $af, $b0, $b1
	db $b2, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, $40, $41, $7f, 0, 0, 0, 0
	assert @ - .PlayerConsonants == 4 * 9
.PlayerVowels
	db $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8
	db $c9, $ca, $cb, $cc, $cd, $ce, $cf, $d0, $d1
	db $d2, $d3, $d4, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, $40, $41, $7f, 0, 0
	assert @ - .PlayerVowels == 4 * 9
.Consonants:
	db $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8
	db $a9, $aa, $ab, $ac, $ad, $ae, $af, $b0, $b1
	db $b2, $f6, $f7, $f8, $f9, $fa, $fb, $fc, $fd
	db $fe, $ff, $40, $41, $7f, 0, 0, 0, 0
.Vowels:
	db $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8
	db $c9, $ca, $cb, $cc, $cd, $ce, $cf, $d0, $d1
	db $d2, $d3, $d4, $f6, $f7, $f8, $f9, $fa, $fb
	db $fc, $fd, $fe, $ff, $40, $41, $7f, 0, 0

HangulNaming_ReadKey:
	call HangulNaming_UsesGoldKeyboard
	jp z, HangulPlayer_ReadKey
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [wNamingScreenLetterCase]
	cp 2
	jr c, .latin
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp 4
	jr nc, .numbers
	ld e, a
	add a
	add a
	add a
	add e
	ld e, a
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	add e
	ld e, a
	ld d, 0
	call HangulNaming_GetKeyTable
	add hl, de
	ld a, [hl]
	jr .store
.numbers
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	add $f7
.store
	ld [wNamingScreenLastCharacter], a
	ret
.latin
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	ld e, a
	swap a
	add e
	ld e, a
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	add a
	add e
	ld c, a
	ld b, 0
	ld hl, NameInputUpper
	ld a, [wNamingScreenLetterCase]
	and a
	jr z, .latin_case
	ld hl, NameInputLower
.latin_case
	add hl, bc
	call NamingScreen_IsTargetBox
	jr nz, .latin_read
	ld bc, BoxNameInputLower - NameInputLower
	add hl, bc
.latin_read
	ld a, [hl]
	jr .store

HangulNaming_SwitchPage:
	call HangulNaming_UsesGoldKeyboard
	ret z ; one-screen keyboards have no page command
	ld a, $80
	call HangulNaming_RecordPlayerStage
	ld hl, wNamingScreenLetterCase
	ld a, [wNamingScreenType]
	cp NAME_PLAYER
	jr z, .player
	ld a, [hl]
	inc a
	and 3
	jr .page_ready
.player
; Player names follow the Korean reference: no Latin input pages.
; Keep the temporary consonant/vowel pages until the final one-screen layout.
	ld a, [hl]
	xor 1
	and 1
	or 2
.page_ready
	ld [hl], a
	push af
	ld a, $81
	call HangulNaming_RecordPlayerStage
	pop af
	cp 2
	jr nc, .hangul
	ld de, NameInputUpper
	and a
	jr z, .latin
	ld de, NameInputLower
.latin
	ld a, $82
	call HangulNaming_RecordPlayerStage
	call NamingScreen_ApplyTextInputMode
	jr .done
.hangul
	ld a, $85
	call HangulNaming_RecordPlayerStage
	call HangulNaming_DrawKeyboard
.done
	push af
	ld a, $86
	call HangulNaming_RecordPlayerStage
	pop af
	ret

HangulNaming_RecordPlayerStage:
; A = diagnostic stage. Preserve registers/flags and instrument NAME_PLAYER
; only; the existing WRAM byte keeps its address and is never saved.
	push af
	ld a, [wNamingScreenType]
	cp NAME_PLAYER
	jr nz, .skip
	pop af
	ld [wHangulNamingInitStage], a
	ret
.skip
	pop af
	ret

HangulNaming_LoadKeyboardFonts::
	call HangulNaming_UsesGoldKeyboard
	ret z ; labels are already in the Gold keyboard graphics
; Preload the current keyboard font regions during screen setup.
; Get1bpp supports both LCD states; preloading is a residency choice.
	ld de, Font + ('A' - $80) * TILE_1BPP_SIZE
	ld hl, vTiles2 tile $42
	lb bc, BANK(Font), 26
	call Get1bpp
; Reserve a second, immutable alphabet for the Hangul keyboard command row.
	ld de, Font + ('A' - $80) * TILE_1BPP_SIZE
	ld hl, vTiles2 tile $5c
	lb bc, BANK(Font), 26
	call Get1bpp
	ret

HangulNaming_AlphabetTile:
; Carry: A is a keyboard tile; otherwise C retains the standard text code.
	ld a, [wNamingScreenLetterCase]
	and a
	ld a, c
	jr nz, .lower
	sub 'A'
	jr .range
.lower
	sub 'a'
.range
	cp 26
	ret nc
	add $42
	scf
	ret

HangulNaming_KeyboardGFX:
INCBIN "gfx/naming_screen/hangul.2bpp", 0, 66 tiles

HangulNaming_UsesGoldKeyboard:
; Z = player, rival, Pokemon nickname (including aliases), or box name.
; Only AF changes. Storage/serialization dispatch deliberately stays separate.
	ld a, [wNamingScreenType]
	cp NAME_MON
	ret z
	cp NAME_PLAYER
	ret z
	cp NAME_RIVAL
	ret z
	cp NAME_6
	ret z
	cp NAME_BOX
	ret z
	cp NAME_MAIL
	ret z
	cp NAME_7
	ret
