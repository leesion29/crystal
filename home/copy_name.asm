; A small floating section fits the remaining header-side ROM0 gap; keep the
; larger nickname reader in Home so section fragmentation does not block linking.
PUSHS
SECTION "Name Copy Home", ROM0
CopyName1::
; Copies the name from de to wStringBuffer2
	ld hl, wStringBuffer2

CopyName2::
; Copies the name from de to hl
.loop
	ld a, [de]
	inc de
	ld [hli], a
	cp HANGUL_POC_ESCAPE
	jr nz, .terminator
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	jr .loop
.terminator
	cp '@'
	jr nz, .loop
	ret
POPS
