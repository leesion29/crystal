DecodeHangulMailRow::
; BC = 25-byte output buffer, DE = 17-byte terminated mail row.
; Preserve the output pointer across farcall's HL dispatch register.
	ld h, b
	ld l, c
	ld c, MAIL_LINE_LENGTH + 1
	jp DecodeSizedHangulName

DecodeHangulName::
; Input: DE = an accessible NAME_LENGTH-byte name record (not a ROMX string),
;        HL = a HANGUL_NAME_DISPLAY_LENGTH-byte output buffer.
; Output: carry clear, B=0/1 = legacy/packed Crystal display string at the buffer;
;         carry set, B=$ff = invalid record, output buffer untouched.
; DE/HL advance on success; BC/AF are clobbered. Source is never modified.
; Validate before writing: a glyph index may itself be '@' or $17.
	ld c, NAME_LENGTH
	; fallthrough

DecodeSizedHangulName::
; C = accessible record width (NAME_LENGTH or BOX_NAME_LENGTH).

	push de
	push hl
	call .Validate
	pop hl
	pop de
	ret c
	ld a, b
	and a
	jr z, .legacy
.packed
	ld a, [de]
	inc de
	cp '@'
	jr z, .end
	cp $0c
	jr nc, .packed_standard
	ld c, a
	ld a, HANGUL_POC_ESCAPE
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	jr .packed
.packed_standard
; Gold species names may end in a one-byte gender sign or digit.
	ld [hli], a
	jr .packed
.legacy
	ld a, [de]
	inc de
	cp '@'
	jr z, .end
	ld [hli], a
	cp HANGUL_POC_ESCAPE
	jr nz, .legacy
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	jr .legacy
.end
	ld [hl], '@'
	and a
	ret

.Validate
; B selects the format. Only name records use this low-byte discriminator;
; general text strings retain their existing Japanese/control-byte meanings.
	ld b, 0
	ld a, [de]
	dec a
	cp $0b
	jr nc, .legacy_validate
	inc b
.packed_validate
	ld a, c
	and a
	jr z, .invalid
	ld a, [de]
	inc de
	dec c
	cp '@'
	jr z, .padding
	dec a
	cp $0b
	jr c, .packed_glyph
	inc a
	cp FIRST_REGULAR_TEXT_CHAR
	jr c, .invalid
	jr .packed_validate
.packed_glyph
	ld a, c
	cp 2 ; index and at least one terminator byte must remain
	jr c, .invalid
	inc de ; consume index without interpreting it
	dec c
	jr .packed_validate
.padding
; New packed records have deterministic '@' padding up to NAME_LENGTH.
	ld a, c
	and a
	ret z
	ld a, [de]
	inc de
	dec c
	cp '@'
	jr nz, .invalid
	jr .padding
.legacy_validate
	ld a, c
	and a
	jr z, .invalid
	ld a, [de]
	inc de
	dec c
	cp '@'
	jr z, .valid
	cp HANGUL_POC_ESCAPE
	jr z, .legacy_glyph
	cp FIRST_REGULAR_TEXT_CHAR
	jr c, .invalid
	jr .legacy_validate
.legacy_glyph
	ld a, c
	cp 3 ; bank, index and at least one terminator byte must remain
	jr c, .invalid
	ld a, [de]
	inc de
	dec a
	cp $0b
	jr nc, .invalid
	inc de ; index is data, even when it equals '@'
	dec c
	dec c
	jr .legacy_validate
.valid
	and a
	ret
.invalid
	ld b, $ff
	scf
	ret

ValidatePackedNickname::
	push bc
	push de
	ld c, NAME_LENGTH
	call DecodeSizedHangulName.Validate
	pop de
	pop bc
	ret

CopyDefaultPokemonName::
; DE = an 11-byte nickname record, wNamedObjectIndex = species.
; Copy the packed species table, never GetPokemonName's expanded display text.
; Like CopyBytes, advance DE and return BC=0. No save/RAM layout changes.
	push de
	ld a, [wNamedObjectIndex]
	dec a
	ld c, a
	ld b, 0
	ld h, b
	ld l, c
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, hl
	ld bc, PokemonNames
	add hl, bc
	pop de
	ld c, MON_NAME_LENGTH - 1
.copy
	ld a, BANK(PokemonNames)
	call GetFarByte
	ld [de], a
	inc de
	inc hl
	dec c
	jr nz, .copy
	ld a, '@'
	ld [de], a
	inc de
	ld bc, 0
	ret

CopyCurNicknameToMonOrItemName::
; Keep this small buffer packed; display expansion never fits here.
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call SkipNames
	ld de, wMonOrItemNameBuffer
	ld bc, MON_NAME_LENGTH
	jp CopyBytes
