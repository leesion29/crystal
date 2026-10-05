; Player-only Korean keyboard. Static glyphs and commands use Gold's tiles;
; selection uses a separate logical table, never the mutable tilemap/cache.
HangulPlayer_DrawKeyboard:
	xor a
	ldh [hBGMapMode], a
	hlcoord 1, 8
	lb bc, 10, 18
	call ClearBox
	ld de, HangulPlayer_Layout
	hlcoord 1, 8
	ld b, 7
.row
	ld c, 18
.cell
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .cell
	push de
	ld a, [de]
	ld e, a
	ld d, 0
	add hl, de
	pop de
	inc de
	dec b
	jr nz, .row
	ld a, 1
	ldh [hBGMapMode], a
	ret

HangulPlayer_GetCursorPosition:
; BC = cursor object. Return 0=key, 2=correct, 3=confirm.
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp 4
	jr nz, .key
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp 6
	ld a, 2
	ret c
	inc a
	ret
.key
	xor a
	ret

HangulPlayer_ReadKey:
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp 4
	jr nc, .inactive
	ld e, a
	add a
	add e
	add a
	add a ; row * 12
	ld e, a
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp 12
	jr nc, .inactive
	add e
	ld e, a
	ld d, 0
	ld hl, HangulPlayer_Keys
	add hl, de
	ld a, [hl]
	jr .store
.inactive
	xor a
.store
	ld [wNamingScreenLastCharacter], a
	ret

HangulPlayer_AnimateCursor:
	call .DPad
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	ld e, a
	swap e
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], e
	cp 4
	ld de, .Letters
	ld a, 0
	jr nz, .frameset
	ld de, .Commands
	inc a
.frameset
	ld hl, SPRITEANIMSTRUCT_VAR3
	add hl, bc
	add [hl]
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, de
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret
.Letters
	db $08, $10, $18, $20, $30, $38, $40, $48, $58, $60, $68, $70
.Commands
	db $0c, $0c, $0c, $0c, $0c, $0c, $4c, $4c, $4c, $4c, $4c, $4c
.DPad
	ldh a, [hJoyLast]
	and PAD_UP
	jr nz, .up
	ldh a, [hJoyLast]
	and PAD_DOWN
	jr nz, .down
	ldh a, [hJoyLast]
	and PAD_LEFT
	jr nz, .left
	ldh a, [hJoyLast]
	and PAD_RIGHT
	ret z
	call HangulPlayer_GetCursorPosition
	and a
	jr nz, .toggle
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp 12
	ret c
	ld [hl], 0
	ret
.left
	call HangulPlayer_GetCursorPosition
	and a
	jr nz, .toggle
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .decrement
	ld [hl], 12
.decrement
	dec [hl]
	ret
.toggle
	; Both directions toggle the two bottom commands, as in the reference.
	ld e, 0
	cp 3
	jr z, .set_column
	ld e, 6
.set_column
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], e
	ret
.down
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp 5
	ret c
	ld [hl], 0
	ret
.up
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .decrement
	ld [hl], 5
	jr .decrement

HangulPlayer_Keys:
	db $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab
	db $ac, $ad, $ae, $af, $b0, $b1, $b2, $7f, $7f, $7f, $7f, $7f
	db $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb
	db $cc, $cd, $ce, $cf, $d0, $d1, $d2, $d3, $d4, $7f, $7f, $7f
	assert @ - HangulPlayer_Keys == 4 * 12

HangulPlayer_Layout:
; Gold NameInputLayout: 18 tiles plus next-row advance for every row.
; Every blank logical selector is an intentional space-input cell, like Gold.
	db $7f,$7f,$00,$01,$02,$03,$7f,$04,$05,$06,$07,$7f,$08,$09,$0a,$0b,$7f,$7f,$16
	db $7f,$7f,$0c,$0d,$0e,$0f,$7f,$10,$11,$12,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$16
	db $7f,$7f,$20,$21,$22,$23,$7f,$24,$25,$26,$27,$7f,$28,$29,$2a,$2b,$7f,$7f,$16
	db $7f,$7f,$2c,$2d,$2e,$2f,$7f,$30,$31,$32,$33,$7f,$34,$7f,$7f,$7f,$7f,$7f,$02
	db $13,$13,$13,$13,$14,$15,$13,$13,$13,$13,$13,$13,$35,$36,$13,$13,$13,$13,$02
	db $16,$16,$16,$16,$17,$18,$16,$16,$16,$16,$16,$16,$37,$38,$16,$16,$16,$16,$02
	db $19,$19,$19,$19,$1a,$1b,$19,$19,$19,$19,$19,$19,$39,$3a,$19,$19,$19,$19,$02
	assert @ - HangulPlayer_Layout == 7 * 19
