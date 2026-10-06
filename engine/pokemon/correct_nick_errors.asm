CorrectNickErrors::
; error-check monster nick before use
; must be a peace offering to gamesharkers

; input: de = nick location

	push bc
	push de
	ld b, MON_NAME_LENGTH
	ld a, [de]
	dec a
	cp $0b
	jr nc, .checkchar
	farcall ValidatePackedNickname
	jr nc, .end
	ld a, '?'
	ld [de], a
	inc de
	ld a, '@'
	ld [de], a
	jr .end

.checkchar
; end of nick?
	ld a, [de]
	cp '@' ; terminator
	jr z, .end
	cp HANGUL_POC_ESCAPE
	jr nz, .standard
	ld a, b
	cp 4 ; three encoded bytes and room for the terminator
	jr c, .done
	inc de
	ld a, [de]
	dec a
	cp $0b
	jr nc, .invalid_hangul
	inc de
	dec b
	dec b
	jr .done
.invalid_hangul
	dec de
	ld a, '?'
	ld [de], a
.standard

; check if this char is a text command
	ld hl, .textcommands
	dec hl
.loop
; next entry
	inc hl
; reached end of commands table?
	ld a, [hl]
	cp -1
	jr z, .done

; is the current char between this value (inclusive)...
	ld a, [de]
	cp [hl]
	inc hl
	jr c, .loop
; ...and this one?
	cp [hl]
	jr nc, .loop

; replace it with a '?'
	ld a, '?'
	ld [de], a
	jr .loop

.done
; next char
	inc de
; reached end of nick without finding a terminator?
	dec b
	jr nz, .checkchar

; change nick to "?@"
	pop de
	push de
	ld a, '?'
	ld [de], a
	inc de
	ld a, '@'
	ld [de], a
.end
; if the nick has any errors at this point it's out of our hands
	pop de
	pop bc
	ret

.textcommands
; table defining which characters are actually text commands
; format:
	;      ≥           <
	db '<NULL>',   'ガ'
	db '<PLAY_G>', '<JP_18>' + 1
	db '<NI>',     '<NO>'    + 1
	db '<ROUTE>',  '<GREEN>' + 1
	db '<ENEMY>',  '<ENEMY>' + 1
	db '<MOM>',    '<TM>'    + 1
	db '<ROCKET>', '┘'       + 1
	db -1 ; end
