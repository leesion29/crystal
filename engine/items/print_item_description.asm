; Keep the direct pointer table and its consumer together in their own bank.
; Korean descriptions no longer fit the shared Miscellaneous Text section.
PUSHS
SECTION "Item Descriptions", ROMX

PrintItemDescription:
	assert BANK(PrintItemDescription) <= $7f, "Item descriptions exceed MBC3 ROM banks"
; Print the description for item [wCurSpecies] at de.

	ld a, [wCurSpecies]
	cp TM01
	jr c, .not_a_tm

	ld [wCurItem], a
	push de
	farcall GetTMHMItemMove
	pop hl
	ld a, [wTempTMHM]
	ld [wCurSpecies], a
	predef PrintMoveDescription
	ret

.not_a_tm
	push de
	ld hl, ItemDescriptions
	ld a, [wCurSpecies]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	jp PlaceString

INCLUDE "data/items/descriptions.asm"
POPS
