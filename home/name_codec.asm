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
	push hl
	add sp, -HANGUL_NAME_DISPLAY_LENGTH
	ld hl, sp + 0
	; homecall is safe here: this wrapper lives in ROM0, not switched ROMX.
	homecall DecodeHangulName
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
