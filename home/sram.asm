OpenSRAM::
; if invalid bank, sram is disabled
	cp NUM_SRAM_BANKS
	jr c, .valid
if DEF(_DEBUG)
	; Keep a compact diagnostic for invalid SRAM-bank requests.  The detailed
	; per-bank bitmask used to live in ROM0, which prevents the debug build from
	; linking once the Hangul support is present.  A nonzero RAM: value still
	; reports the invalid request without changing release builds.
	push af
	ld a, BANK(sOpenedInvalidSRAM)
	call OpenSRAM
	ld a, 1
	ld [sOpenedInvalidSRAM], a
	pop af
endc
	jr CloseSRAM

.valid:
; switch to sram bank a
	push af
; latch clock data
	ld a, 1
	ld [rRTCLATCH], a
; enable sram/clock write
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
; select sram bank
	pop af
	ld [rRAMB], a
	ret

CloseSRAM::
	push af
	ld a, RAMG_SRAM_DISABLE
; reset clock latch for next time
	ld [rRTCLATCH], a
; disable sram/clock write
	ld [rRAMG], a
	pop af
	ret
