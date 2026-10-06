HangulMail_DrawKeyboard:
	ld de, HangulMail_Layout
	hlcoord 1, 6
	ld b, 8
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
	ret

HangulMail_ReadKey:
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp 5
	ret nc
	ld e, a
	add a
	add e
	add a
	add a
	ld e, a
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	add e
	ld e, a
	ld d, 0
	ld hl, HangulMail_Keys
	add hl, de
	ld a, [hl]
	ld [wNamingScreenLastCharacter], a
	ret

HangulMail_Keys:
	db $a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab
	db $ac,$ad,$ae,$af,$b0,$b1,$b2,$7f,$7f,$7f,$7f,$7f
	db $c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb
	db $cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$7f,$7f,$7f
	db $f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff,$40,$41
	assert @ - HangulMail_Keys == 5 * 12

HangulMail_Layout:
; Gold mail layout: 18 tiles per row, followed by next-row tile advance.
	db $7f,$7f,$00,$01,$02,$03,$7f,$04,$05,$06,$07,$7f,$08,$09,$0a,$0b,$7f,$7f,$16
	db $7f,$7f,$0c,$0d,$0e,$0f,$7f,$10,$11,$12,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$16
	db $7f,$7f,$20,$21,$22,$23,$7f,$24,$25,$26,$27,$7f,$28,$29,$2a,$2b,$7f,$7f,$16
	db $7f,$7f,$2c,$2d,$2e,$2f,$7f,$30,$31,$32,$33,$7f,$34,$7f,$7f,$7f,$7f,$7f,$16
	db $7f,$7f,$f6,$f7,$f8,$f9,$7f,$fa,$fb,$fc,$fd,$7f,$fe,$ff,$40,$41,$7f,$7f,$02
	db $7f,$7f,$7f,$7f,$1c,$1d,$7f,$7f,$7f,$7f,$7f,$7f,$3b,$3c,$7f,$7f,$7f,$7f,$02
	db $16,$16,$16,$16,$17,$18,$16,$16,$16,$16,$16,$16,$37,$38,$16,$16,$16,$16,$02
	db $7f,$7f,$7f,$7f,$1e,$1f,$7f,$7f,$7f,$7f,$7f,$7f,$3d,$3e,$7f,$7f,$7f,$7f,$02
	assert @ - HangulMail_Layout == 8 * 19

HangulMail_UpdateEntry:
	xor a
	ldh [hBGMapMode], a
	hlcoord 1, 1
	lb bc, 4, 18
	call ClearBox
	ld de, wHangulMailBuffer
	hlcoord 6, 2
	ld b, h
	ld c, l
	farcall HangulMail_PlaceMessage
	; Fill unoccupied logical slots; the active slot uses the short underline.
	ld a, [wHangulNamingCurNameLength]
	srl a
	ld e, a
	hlcoord 6, 2
	ld b, 0
.slot
	ld a, b
	cp 8
	jr nz, .at_slot
	push de
	ld de, 2 * SCREEN_WIDTH - 8
	add hl, de
	pop de
.at_slot
	ld a, b
	cp e
	jr c, .next
	ld a, NAMINGSCREEN_UNDERLINE
	jr z, .write
	ld a, NAMINGSCREEN_MIDDLELINE
.write
	ld [hl], a
.next
	inc hl
	inc b
	ld a, b
	cp 16
	jr c, .slot
	ld a, 1
	ldh [hBGMapMode], a
	ret
