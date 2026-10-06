; Korean mail: 16 two-byte glyph IDs in the existing 33-byte message record.
; Eight glyphs per line. Legacy Latin mail retains its normal PlaceString path.
HangulMail_Init::
	ld hl, wHangulMailBuffer
	ld a, l
	ld [wHangulNamingDestinationPointer], a
	ld a, h
	ld [wHangulNamingDestinationPointer + 1], a
	ld a, MAIL_MSG_LENGTH + 2
	ld [wHangulNamingMaxNameLength], a
	xor a
	ld [wHangulNamingCurNameLength], a
	ld bc, MAIL_MSG_LENGTH + 2
	ld a, '@'
	jp ByteFill

HangulMail_Add::
	ld hl, wHangulMailBuffer
	ld de, wHangulMailBackup
	ld bc, MAIL_MSG_LENGTH + 2
	call CopyBytes
	ld a, [wHangulNamingCurNameLength]
	ld [wHangulNamingBackupLength], a
	ld a, [wNamingScreenLastCharacter]
	ld [wHangulNamingLastCharacter], a
	call NamingScreen_Hangul_TryAddCharacter
	push bc
	ld a, [wHangulNamingCurNameLength]
	cp MAIL_MSG_LENGTH
	jr nc, .full
	call HangulNaming_GetTextPosition
	pop bc
	ld a, b
	ld [hli], a
	ld [hl], c
	ld hl, wHangulNamingCurNameLength
	inc [hl]
	inc [hl]
	jp HangulMail_Pad
.full
	pop bc
	ld hl, wHangulMailBackup
	ld de, wHangulMailBuffer
	ld bc, MAIL_MSG_LENGTH + 2
	call CopyBytes
	ld a, [wHangulNamingBackupLength]
	ld [wHangulNamingCurNameLength], a
	ret

HangulMail_Delete::
	ld a, [wHangulNamingCurNameLength]
	and a
	ret z
	call NamingScreen_Hangul_DeleteCharacter
HangulMail_Pad:
	call HangulNaming_GetTextPosition
	ld a, [wHangulNamingCurNameLength]
	ld b, a
	ld a, MAIL_MSG_LENGTH + 2
	sub b
	ld c, a
	ld b, 0
	ld a, '@'
	jp ByteFill

HangulMail_Commit::
	ld a, [wHangulNamingCurNameLength]
	cp MAIL_MSG_LENGTH + 1
	jr nc, .invalid
	bit 0, a
	jr nz, .invalid
	ld b, a
	ld hl, wHangulMailBuffer
	and a
	jr z, .write
.validate
	ld a, [hli]
	dec a
	cp $0b
	jr nc, .invalid
	inc hl
	dec b
	dec b
	jr nz, .validate
.write
	ld hl, wNamingScreenDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, MAIL_MSG_LENGTH + 1
	ld a, '@'
	call ByteFill
	pop de
	ld a, [wHangulNamingCurNameLength]
	and a
	ret z
	ld c, a
	ld b, 0
	ld hl, wHangulMailBuffer
	call CopyBytes
	ld b, 0
	and a
	ret
.invalid
	ld b, $ff
	scf
	ret

HangulMail_PlaceMessage::
; BC = first-line tile coordinate, DE = accessible MAIL_MSG_LENGTH+1 record.
; This routine and its caller run in ROMX, so use farcall for the name decoder.
	ld h, b
	ld l, c
	ld a, [de]
	dec a
	cp $0b
	jp nc, PlaceString
	push hl
	push de
	call .row
	pop de
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	push hl
	ld hl, MAIL_LINE_LENGTH
	add hl, de
	ld d, h
	ld e, l
	pop hl
.row
	push hl
	; Temporary bounded record (17 bytes) and expanded display (25 bytes).
	add sp, -42
	ld hl, sp + 0
	ld b, MAIL_LINE_LENGTH
.copy
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .copy
	ld [hl], '@'
	ld hl, sp + 0
	ld d, h
	ld e, l
	ld hl, sp + 17
	ld b, h
	ld c, l
	farcall DecodeHangulMailRow
	ld a, b
	inc a
	jr z, .invalid
	ld hl, sp + 17
	ld d, h
	ld e, l
	ld hl, sp + 42
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PlaceString
.invalid
	add sp, 42
	pop hl
	ret
