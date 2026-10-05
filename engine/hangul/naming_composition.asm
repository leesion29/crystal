; Gold composition uses two-byte glyph IDs in a private editing buffer.
; The adapter owns format conversion and player-name commit boundaries.
NamingScreen_Hangul_CheckEndOfString::
	call HangulNaming_GetTextPosition
	dec hl
	ld a, [hld]
	ld b, [hl]
	ld c, a
	cp $ff
	jr nz, .no_empty
	ld a, b
	cp $b
	jr nz, .no_empty
	scf
	ret

.no_empty
	sla c
	rl b
	ld hl, HangulJamoTable
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	ld c, a
	and b
	cp $ff
	jr nz, .having_table
	and a
	ret

.having_table
	ld a, b
	and $7c
	ret z
	cp $4
	ret z
	cp $10
	ret z
	cp $20
	ret z
	cp $44
	ret z
	scf
	ret


NamingScreen_Hangul_TryAddCharacter::
	ld a, [wHangulNamingLastCharacter]
	cp $7f
	jr nz, .check_question
	ld bc, $0bff ; '　'
	ret

.check_question
	cp $40
	jr nz, .check_exclamation
	ld bc, $0b67 ; '？'
	ret

.check_exclamation
	cp $41
	jr nz, .check_numeric
	ld bc, $0b66 ; '！'
	ret

.check_numeric
	cp $f6
	jr c, .check_korean_jamo
	sub $6
	ld c, a
	ld b, $b ; '０' ~ '９'
	ret

.check_korean_jamo
	ld a, [wHangulNamingCurNameLength]
	and a
	jr nz, .return_before_merge
	ld a, [wHangulNamingLastCharacter]
	sub $a0
	ld c, a
	ld b, $b
	ret

.return_before_merge
	add sp, -6
	ld hl, .return
	push hl
	jr .merge

.return
	add sp, $6
	ret

.merge
	ld a, [wHangulNamingLastCharacter]
	sub $a0
	ld c, a
	ld b, $b
	ld hl, sp + $2
	ld [hli], a
	ld [hl], b

	; hl = HangulJamoTable + bc * 2;
	sla c
	rl b
	ld hl, HangulJamoTable
	add hl, bc

	; *((u16)hl + 2) = *((u16)hl);
	ld a, [hli]
	ld b, [hl]
	ld hl, sp + $4
	ld [hli], a
	ld [hl], b

	; 모음
	ld a, [wHangulNamingLastCharacter]
	cp $c0
	rl a
	and $1
	ld hl, sp + $6
	ld [hl], a

	; bc = *((u16)wHangulNamingCurNameLength + 현재 위치값);
	ld hl, wHangulNamingCurNameLength
	dec [hl]
	dec [hl]
	call HangulNaming_GetTextPosition
	ld a, [hli]
	ld c, [hl]
	ld b, a

	; bc = *((u16)HangulJamoTable + bc * 2)
	sla c
	rl b
	ld hl, HangulJamoTable
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	ld c, a

	; if (bc != -1)
	;     goto .unk_5cc1
	and b
	cp -1
	jr nz, .unk_5cc1

.unk_5cb6
	ld hl, wHangulNamingCurNameLength
	inc [hl]
	inc [hl]
	ld hl, sp + $2
	ld a, [hli]
	ld b, [hl]
	ld c, a
	ret

.unk_5cc1
	ld a, b
	and $7f
	jr nz, .unk_5cde
	ld a, c
	and $e0
	jr nz, .unk_5cde
	ld hl, sp + $6
	bit 0, [hl]
	jr z, .unk_5cd3
	jr .unk_5cb6

.unk_5cd3
	ld hl, sp + $4
	ld a, [hli]
	or c
	ld c, a
	ld a, [hl]
	or b
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5cde
	ld a, b
	and $7c
	jr nz, .unk_5cea
	ld a, c
	and $1f
	jr nz, .unk_5cea
	jr .unk_5cb6

.unk_5cea
	ld a, b
	and $7c
	jr nz, .unk_5d0e
	ld hl, sp + $6
	bit 0, [hl]
	jr z, .unk_5d0c
	ld hl, sp + $2
	ld a, [hl]
	ld e, a
	ld d, $0
	sla e
	rl d
	ld hl, NamingScreen_Hangul_UnkData_5e4f
	add hl, de
	ld a, [hli]
	or c
	ld c, a
	ld a, [hl]
	or b
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d0c
	jr .unk_5cb6

.unk_5d0e
	ld hl, sp + $6
	bit 0, [hl]
	jp z, .unk_5dc8
	ld hl, sp + $4
	ld a, [hl]
	and $1f
	ld e, a
	ld a, b
	and $7c
	cp $4
	jr nz, .unk_5d31
	ld a, e
	cp $a
	jp nz, .unk_5cb6
	ld a, b
	and $3
	or $c
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d31
	cp $10
	jr nz, .unk_5d51
	ld a, e
	cp $d
	jr nz, .unk_5d43
	ld a, b
	and $3
	or $14
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d43
	cp $13
	jp nz, .unk_5cb6
	ld a, b
	and $3
	or $18
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d51
	cp $20
	jr nz, .unk_5db2
	ld a, e
	cp $1
	jr nz, .unk_5d63
	ld a, b
	and $3
	or $24
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d63
	cp $7
	jr nz, .unk_5d70
	ld a, b
	and $3
	or $28
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d70
	cp $8
	jr nz, .unk_5d7d
	ld a, b
	and $3
	or $2c
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d7d
	cp $a
	jr nz, .unk_5d8a
	ld a, b
	and $3
	or $30
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d8a
	cp $11
	jr nz, .unk_5d97
	ld a, b
	and $3
	or $34
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5d97
	cp $12
	jr nz, .unk_5da4
	ld a, b
	and $3
	or $38
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5da4
	cp $13
	jp nz, .unk_5cb6
	ld a, b
	and $3
	or $3c
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5db2
	cp $44
	jr nz, .unk_5dc5
	ld a, e
	cp $a
	jp nz, .unk_5cb6
	ld a, b
	and $3
	or $48
	ld b, a
	jp NamingScreen_Hangul_Unk_5e21

.unk_5dc5
	jp .unk_5cb6

.unk_5dc8
	ld hl, wHangulNamingCurNameLength
	inc [hl]
	inc [hl]
	ld a, [wHangulNamingMaxNameLength]
	ld e, a
	ld a, [wHangulNamingCurNameLength]
	cp e
	ret nc
	ld hl, wHangulNamingCurNameLength
	dec [hl]
	dec [hl]
	ld a, b
	and $7c
	ld e, a
	ld d, $0
	srl e
	rr d
	srl e
	rr d
	push bc
	ld hl, NamingScreen_Hangul_UnkData_5e91
	add hl, de
	ld c, [hl]
	ld hl, sp + $6
	ld a, [hli]
	and $e0
	or c
	ld c, a
	ld b, [hl]
	push de
	call NamingScreen_Hangul_Unk_5e28
	pop de
	pop hl
	jp nc, .unk_5cb6
	push bc
	ld c, l
	ld b, h
	ld hl, NamingScreen_Hangul_UnkData_5e75
	add hl, de
	ld a, b
	and $3
	or [hl]
	ld b, a
	call NamingScreen_Hangul_Unk_5e28
	pop hl
	jp nc, .unk_5cb6
	push hl
	call HangulNaming_GetTextPosition
	ld a, b
	ld [hli], a
	ld [hl], c
	ld hl, wHangulNamingCurNameLength
	inc [hl]
	inc [hl]
	pop bc
	ret

NamingScreen_Hangul_Unk_5e21:
	call NamingScreen_Hangul_Unk_5e28
	jp nc, NamingScreen_Hangul_TryAddCharacter.unk_5cb6
	ret

NamingScreen_Hangul_Unk_5e28:
	ld hl, HangulJamoTable.hangul
	ld d, $a
.unk_5e2d
	ld e, $0
.unk_5e2f
	ld a, [hl]
	cp c
	jr nz, .unk_5e45
	inc hl
	ld a, [hli]
	cp b
	jr nz, .unk_5e47
	ld de, $c000
	add hl, de
	srl h
	rr l
	dec hl
	ld c, l
	ld b, h
	scf
	ret

.unk_5e45
	inc hl
	inc hl

.unk_5e47
	dec e
	jr nz, .unk_5e2f
	dec d
	jr nz, .unk_5e2d
	and a
	ret

NamingScreen_Hangul_UnkData_5e4f:
	db $00, $04
	db $00, $10
	db $00, $1c
	db $00, $20
	db $00, $40
	db $00, $44
	db $00, $4c
	db $00, $54
	db $00, $58
	db $00, $5c
	db $00, $60
	db $00, $64
	db $00, $68
	db $00, $6c
	db $00, $08
	db $00, $7c
	db $00, $7c
	db $00, $50
	db $00, $7c

NamingScreen_Hangul_UnkData_5e75:
	db $00, $00
	db $00, $04
	db $00, $10
	db $10, $00
	db $00, $20
	db $20, $20
	db $20, $20
	db $20, $20
	db $00, $00
	db $44, $00
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $00

NamingScreen_Hangul_UnkData_5e91:
	db $00, $01, $02, $0a, $03, $0d, $13, $04, $06, $01, $07, $08, $0a, $11, $12, $13, $07, $08, $0a, $0a, $0b, $0c, $0d, $0f, $10, $11, $12, $13

HangulNaming_GetTextPosition:
	push af
	ld hl, wHangulNamingDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wHangulNamingCurNameLength]
	ld e, a
	ld d, $0
	add hl, de
	pop af
	ret

NamingScreen_Hangul_DeleteCharacter::
	ld hl, wHangulNamingCurNameLength
	dec [hl]
	dec [hl]
	call HangulNaming_GetTextPosition
	ld a, [hli]
	ld c, [hl]
	ld b, a
	sla c
	rl b
	ld hl, HangulJamoTable
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	ld c, a
	and b
	cp -1
	jr nz, .unk_5eef

.unk_5ed8
	call HangulNaming_GetTextPosition
	ld [hl], $b
	inc hl
	ld [hl], $3e
	inc hl
	ld a, [hli]
	cp $b
	ret nz
	ld a, [hld]
	cp $3e
	ret nz
	ld [hl], $b
	inc hl
	ld [hl], $3f
	ret

.unk_5eef
	ld a, b
	and $7c
	jr z, .unk_5f06
	ld hl, NamingScreen_Hangul_UnkData_5f93
	srl a
	srl a
	ld e, a
	ld d, $0
	add hl, de
	ld a, b
	and $3
	or [hl]
	ld b, a
	jr .unk_5f61

.unk_5f06
	ld a, b
	and $3
	jr nz, .unk_5f10
	ld a, c
	and $e0
	jr z, .unk_5ed8

.unk_5f10
	call HangulNaming_GetTextPosition
	ld [hl], $b
	inc hl
	ld [hl], $3e
	inc hl
	ld a, [hli]
	cp $b
	jr nz, .unk_5f28
	ld a, [hld]
	cp $3e
	jr nz, .unk_5f28
	ld [hl], $b
	inc hl
	ld [hl],$3f

.unk_5f28
	ld b, $0
	ld a, c
	and $1f
	ret z
	ld c, a
	ld hl, NamingScreen_Hangul_UnkData_5faf
	add hl, bc
	ld a, [hl]
	ld [wHangulNamingLastCharacter], a
	call NamingScreen_Hangul_TryAddCharacter
	ld a, [wHangulNamingMaxNameLength]
	ld e, a
	ld a, [wHangulNamingCurNameLength]
	cp e
	ret nc
	call HangulNaming_GetTextPosition
	ld a, b
	ld [hli], a
	ld [hl], c
	ld hl, wHangulNamingCurNameLength
	inc [hl]
	inc [hl]
	call HangulNaming_GetTextPosition
	ld a, [hl]
	cp $50
	jr z, .unk_5f5d
	ld [hl], $b
	inc hl
	ld [hl], $3e
	and a
	ret

.unk_5f5d
	call NamingScreen_Hangul_CheckEndOfString
	ret

.unk_5f61
	ld hl, HangulJamoTable.hangul
	ld d, $b
.unk_5f66
	ld e, $0
.unk_5f68
	ld a, [hl]
	cp c
	jr nz, .unk_5f88
	inc hl
	ld a, [hli]
	cp b
	jr nz, .unk_5f8a
	ld de, $c000
	add hl, de
	srl h
	rr l
	dec hl
	ld c, l
	ld b, h
	call HangulNaming_GetTextPosition
	ld a, b
	ld [hli], a
	ld [hl], c
	ld hl, wHangulNamingCurNameLength
	inc [hl]
	inc [hl]
	ret

.unk_5f88
	inc hl
	inc hl
.unk_5f8a
	dec e
	jr nz, .unk_5f68
	dec d
	jr nz, .unk_5f66
	jp .unk_5ed8

NamingScreen_Hangul_UnkData_5f93:
	db $00, $00
	db $00, $04
	db $00, $10
	db $10, $00
	db $00, $20
	db $20, $20
	db $20, $20
	db $20, $20
	db $00, $00
	db $44, $00
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $00

NamingScreen_Hangul_UnkData_5faf:
.start
	db $7f, $a0, $ae, $a1, $a2, $af, $a3, $a4, $a5, $b0, $a6, $b1, $a7, $a8, $b2, $a9, $aa, $ab, $ac, $ad
.zero
	ds 31 - (.zero - .start)
