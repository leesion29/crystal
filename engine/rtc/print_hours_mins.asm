PrintFiveDigitNumber: ; unreferenced
; Debug function?
; Input: bc = value, de = destination
	ld a, b
	ld b, c
	ld c, a
	push bc ; de points to this on the stack for PrintNum
	push de
	ld hl, sp+2
	ld d, h
	ld e, l
	pop hl
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	pop bc
	ret

PrintHoursMins:
; Hours in b, minutes in c
	; Used by the #GEAR clock, DST prompts, and the clock-reset menu.
	; Keep this compact UI in Crystal's 12:34 AM/PM form.  Route the colon
	; through PlaceString so it still resolves correctly after font caching.
	ld a, b
	cp 12
	push af
	jr c, .AM
	jr z, .PM
	sub 12
	jr .PM
.AM:
	or a
	jr nz, .PM
	ld a, 12
.PM:
	ld b, a
	push bc
	ld hl, sp+1
	push de
	push hl
	pop de
	pop hl
	ld [hl], ' '
	lb bc, 1, 2
	call PrintNum
	ld de, String_Colon
	call PlaceString
	inc hl
	ld d, h
	ld e, l
	ld hl, sp+0
	push de
	push hl
	pop de
	pop hl
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	inc hl
	pop bc
	ld de, String_AM
	pop af
	jr c, .place_am_pm
	ld de, String_PM
.place_am_pm
	jp PlaceString

String_AM:    db "AM@"
String_PM:    db "PM@"
String_Colon: db ":@"
