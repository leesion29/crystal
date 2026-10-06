HangulNaming_Init::
	ld hl, wHangulNamingBuffer
	ld a, l
	ld [wHangulNamingDestinationPointer], a
	ld a, h
	ld [wHangulNamingDestinationPointer + 1], a
	ld a, 20
	ld [wHangulNamingMaxNameLength], a
	xor a
	ld [wHangulNamingCurNameLength], a
	ld hl, wHangulNamingBuffer
	ld bc, 22
	ld a, '@'
	call ByteFill
	ld a, 1
	ld [wHangulNamingActive], a
	call HangulNaming_Serialize
	ret

HangulNaming_Add::
; Snapshot first: Gold can split a final consonant into the next syllable.
	ld hl, wHangulNamingBuffer
	ld de, wHangulNamingBackup
	ld bc, 22
	call CopyBytes
	ld a, [wHangulNamingCurNameLength]
	ld [wHangulNamingBackupLength], a
	ld a, [wNamingScreenLastCharacter]
	ld [wHangulNamingLastCharacter], a
	ld a, [wNamingScreenLetterCase]
	cp 2
	jr c, .latin
	call NamingScreen_Hangul_TryAddCharacter
	jr .write
.latin
	ld b, 0
	ld a, [wNamingScreenLastCharacter]
	ld c, a
.write
	push bc
	ld a, [wHangulNamingCurNameLength]
	cp 20
	jr nc, .full
	call HangulNaming_GetTextPosition
	pop bc
	ld a, b
	ld [hli], a
	ld [hl], c
	ld hl, wHangulNamingCurNameLength
	inc [hl]
	inc [hl]
	jr .validate
.full
	pop bc
.validate
	call HangulNaming_UsesPackedName
	jr nz, .legacy_limit
	; Keep Gold's speculative merge intact, then reject excess logical length.
	call HangulNaming_PackedRecordLength
	ld b, a
	ld a, [wHangulNamingCurNameLength]
	cp b
	jr c, .accepted
	jr .restore
.legacy_limit
	call HangulNaming_Measure
	ld hl, wNamingScreenMaxNameLength
	cp [hl]
	jr c, .accepted
	jr z, .accepted
.restore
	ld hl, wHangulNamingBackup
	ld de, wHangulNamingBuffer
	ld bc, 22
	call CopyBytes
	ld a, [wHangulNamingBackupLength]
	ld [wHangulNamingCurNameLength], a
.accepted
	call HangulNaming_Serialize
	and a
	ret

HangulNaming_Delete::
	ld a, [wHangulNamingCurNameLength]
	and a
	ret z
	call NamingScreen_Hangul_DeleteCharacter
	call HangulNaming_Serialize
	ret

HangulNaming_Measure:
; Return serialized byte count, excluding the terminator.
	ld a, [wHangulNamingCurNameLength]
	srl a
	ld b, a
	ld c, 0
	ld hl, wHangulNamingBuffer
	and a
	jr z, .done
.loop
	ld a, [hli]
	inc hl
	inc c
	and a
	jr z, .next
	inc c
	inc c
.next
	dec b
	jr nz, .loop
.done
	ld a, c
	ret

HangulNaming_Serialize::
	call HangulNaming_UsesPackedName
	jr z, .player_edit
	call HangulNaming_Measure
	ld [wNamingScreenCurNameLength], a
	ld hl, wNamingScreenDestinationPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wHangulNamingBuffer
	ld a, [wHangulNamingCurNameLength]
	srl a
	ld b, a
	and a
	jr z, .end
.loop
	ld a, [hli]
	and a
	jr z, .single
	ld c, a
	ld a, HANGUL_POC_ESCAPE
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
.single
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
.end
	ld a, '@'
	ld [de], a
	ret

.player_edit
; Do not touch the committed destination while editing a packed name.
; Normalize the private record for PlaceHangulName, including stale deleted IDs.
	ld a, [wHangulNamingCurNameLength]
	srl a
	ld [wNamingScreenCurNameLength], a
	call HangulNaming_GetTextPosition
	ld a, [wHangulNamingCurNameLength]
	ld b, a
	ld a, NAME_LENGTH
	sub b
	ld c, a
	ld b, 0
	ld a, '@'
	call ByteFill
	ret

HangulNaming_CommitPlayer::
; Validate the entire editing state before writing the fixed-width destination.
; Carry clear = committed, carry set = rejected with destination unchanged.
	call HangulNaming_PackedRecordLength
	ld b, a
	ld a, [wHangulNamingCurNameLength]
	cp b
	jr nc, .invalid
	bit 0, a
	jr nz, .invalid
	srl a
	ld b, a
	ld hl, wHangulNamingBuffer
	and a
	jr z, .write
.validate
	ld a, [hli]
	dec a
	cp $0b
	jr nc, .invalid
	inc hl ; index is opaque data, including $50/$17
	dec b
	jr nz, .validate
.write
	call HangulNaming_PackedRecordLength
	ld c, a
	ld b, 0
	ld hl, wNamingScreenDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, '@'
	call ByteFill
	ld a, [wHangulNamingCurNameLength]
	and a
	ret z ; empty name still uses the existing default-name policy
	ld c, a
	ld b, 0
	ld hl, wNamingScreenDestinationPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wHangulNamingBuffer
	call CopyBytes
	and a
	ret
.invalid
	scf
	ret

HangulNaming_UsesPackedName:
	ld a, [wNamingScreenType]
	cp NAME_MON
	ret z
	cp NAME_PLAYER
	ret z
	cp NAME_RIVAL
	ret z
	cp NAME_6
	ret z
	cp NAME_BOX
	ret z
	cp NAME_7
	ret

HangulNaming_PackedRecordLength:
	ld a, [wNamingScreenType]
	cp NAME_BOX
	ld a, NAME_LENGTH
	ret nz
	ld a, BOX_NAME_LENGTH
	ret
