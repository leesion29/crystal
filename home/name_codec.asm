PlacePlayerName::
; Same HL/BC coordinate contract as PlaceString, with a bounded name decoder.
	ld de, wPlayerName
	; fallthrough

PlaceHangulName::
; DE points to an accessible NAME_LENGTH-byte record. This is NOT a replacement
; for general PlaceString or CopyName2, nor for short box/mobile name records.
; The stack-local display buffer survives nested text rendering/interrupts and
; does not borrow any caller-owned wStringBuffer or move WRAM symbols.
; On malformed input, carry is set and no tiles are written (BC = original HL).
	ld c, NAME_LENGTH
	jr PlaceBoxName.decode
PlaceBoxName::
; Never read beyond a BOX_NAME_LENGTH record, including old default box names.
	ld c, BOX_NAME_LENGTH
.decode
	push hl
	add sp, -HANGUL_NAME_DISPLAY_LENGTH
	ld hl, sp + 0
	; homecall is safe here: this wrapper lives in ROM0, not switched ROMX.
	homecall DecodeSizedHangulName
	; homecall restores the caller's AF, not the callee's carry flag.
	; DecodeHangulName also reports failure in B so it survives that restore.
	ld a, b
	inc a
	jr z, .invalid
	ld hl, sp + 0
	ld d, h
	ld e, l
	ld hl, sp + HANGUL_NAME_DISPLAY_LENGTH
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PlaceString
	add sp, HANGUL_NAME_DISPLAY_LENGTH
	pop hl
	and a
	ret
.invalid
	add sp, HANGUL_NAME_DISPLAY_LENGTH
	pop hl
	ld b, h
	ld c, l
	scf
	ret

ExpandNicknameBuffer::
; DE must be a STRING_BUFFER_LENGTH buffer, never an 11-byte saved record.
; Preserve DE/HL; invalid source remains untouched. Other registers change.
	push de
	push hl
	add sp, -HANGUL_NAME_DISPLAY_LENGTH
	ld hl, sp + 0
	ld bc, HANGUL_NAME_DISPLAY_LENGTH
	ld a, '@'
	call ByteFill
	ld hl, sp + 0
	homecall DecodeHangulName
	ld a, b
	inc a
	jr z, .invalid
	ld hl, sp + HANGUL_NAME_DISPLAY_LENGTH + 2
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, sp + 0
	ld bc, HANGUL_NAME_DISPLAY_LENGTH
	call CopyBytes
	add sp, HANGUL_NAME_DISPLAY_LENGTH
	pop hl
	pop de
	and a
	ret
.invalid
	add sp, HANGUL_NAME_DISPLAY_LENGTH
	pop hl
	pop de
	scf
	ret

PlaceMonOrItemName::
; This dual-use 11-byte buffer can hold a packed nickname or an item string.
	ld a, [de]
	dec a
	cp $0b
	jp c, PlaceHangulName
	jp PlaceString

PlaceNicknameCommand::
	call PlaceHangulName
	ld h, b
	ld l, c
	pop de
	jp NextChar

PUSHS
SECTION "RAM Name Display Home", ROM0
PlaceRAMString::
	ld a, d
	cp HIGH(wMonOrItemNameBuffer)
	jr nz, .plain
	ld a, e
	cp LOW(wMonOrItemNameBuffer)
	jp z, PlaceMonOrItemName
.plain
	jp PlaceString
POPS
