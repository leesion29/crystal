ResetHangulTiles::
; Drop cache keys when the standard text font reloads.
	ldh a, [hCGB]
	and a
	jr nz, .color_mode
	xor a
	ld [wHangulDynamicMode], a
	ret
.color_mode
	push af
	push bc
	push hl
	ldh a, [rSVBK]
	push af
	di
	ld a, BANK(wHangulAttributes)
	ldh [rSVBK], a
	ld hl, wHangulAttributes
	ld c, MAX_HANGUL_TILE_COUNT * 2
	xor a
.clear
	ld [hli], a
	dec c
	jr nz, .clear
	xor a
	ld [wHangulDynamicMode], a
	pop af
	ldh [rSVBK], a
	ei
	pop hl
	pop bc
	pop af
	ret

_PlaceHangul::
; Input: BC = glyph identifier (B=0 for a standard character),
;        HL = lower tile position.
; Output: one standard glyph or one 8x16 Hangul glyph uses a cached tile pair.

	ldh a, [hCGB]
	and a
	jr nz, .color_mode
	; The cache uses banked WRAMX, so leave DMG mode untouched.
	push de
	push hl
	push bc
	ld a, ' '
	push hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	ld [hl], a
	pop hl
	ld [hli], a
	pop bc
	pop hl
	pop de
	ret
.color_mode
	push de
	push bc
	ldh a, [rSVBK]
	push af
	di
	ld a, BANK(wHangulAttributes)
	ldh [rSVBK], a
	ld a, [wHangulDynamicMode]
	and 1 ; bit 0: cache active; bit 7: inverted font
	jr nz, .cache_ready
	; Preserve static glyphs already present when this is the first Hangul.
	call TrimHangulTiles
	ld a, [wHangulDynamicMode]
	or 1 ; retain the Pokédex's inverted-font flag
	ld [wHangulDynamicMode], a
.cache_ready

	call TryGetHangulTileId
	jr nc, .place_glyph
	call FindFreeHangulTileId
	jr nc, .copy_glyph
	call TrimHangulTiles
	call FindFreeHangulTileId
	jr c, .no_free_tile

.copy_glyph
	push af
	call CopyHangulGlyphToBuffer
	pop af
	call CopyHangulTilesToVRAM
	call StoreHangulGlyphId

.place_glyph
	push af
	ld a, b
	and a
	jr z, .place_single_tile
	pop af
	push hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	ld [hl], a
	inc a
	pop hl
	ld [hli], a
	jr .done

.place_single_tile
	pop af
	ld [hli], a
	jr .done

.no_free_tile
	; Leave a blank cell rather than overwrite a glyph still on screen.
	ld a, b
	and a
	jr z, .blank_single_tile
	push hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	ld a, ' '
	ld [hl], a
	pop hl
	ld a, ' '
	ld [hli], a
	jr .done

.blank_single_tile
	ld a, ' '
	ld [hli], a

.done
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	pop de
	ret

TryGetHangulTileId:
	push bc
	push de
	push hl
	ld hl, wHangulAttributes
	ld e, $80
	ld d, MAX_HANGUL_TILE_COUNT
.loop
	ld a, [hli]
	bit HANGUL_ATTR_USED_F, a
	jr z, .next
	and $3f ; strip USED and PINNED, leaving the font bank
	cp b
	jr nz, .next
	ld a, [hl]
	cp c
	jr z, .found
.next
	inc hl
	ld a, e
	add 2
	ld e, a
	dec d
	jr nz, .loop
	scf
	jr .done
.found
	; A sidebar label may reuse a glyph already loaded for the name list.
	ld a, [wHangulDynamicMode]
	bit 6, a
	jr z, .tile_id
	dec hl
	set 6, [hl]
	inc hl
.tile_id
	ld a, e
	and a
.done
	pop hl
	pop de
	pop bc
	ret

FindFreeHangulTileId:
	push de
	push hl
	ld hl, wHangulAttributes
	ld e, $80
	ld d, MAX_HANGUL_TILE_COUNT
.loop
	ld a, [hl]
	bit HANGUL_ATTR_USED_F, a
	jr z, .found
	inc hl
	inc hl
	ld a, e
	add 2
	ld e, a
	dec d
	jr nz, .loop
	scf
	jr .done
.found
	ld a, e
	and a
.done
	pop hl
	pop de
	ret

StoreHangulGlyphId:
	push af
	push hl
	call GetHangulAttributeAddress
	ld a, [wHangulDynamicMode]
	and $40 ; pin labels that remain visible in the other Pokédex BG map
	or b
	set HANGUL_ATTR_USED_F, a
	ld [hli], a
	ld a, c
	ld [hl], a
	pop hl
	pop af
	ret

GetHangulAttributeAddress:
	sub $80
	ld l, a
	ld h, 0
	ld de, wHangulAttributes
	add hl, de
	ret

TrimHangulTiles:
	push bc
	push de
	push hl
	ld hl, wHangulAttributes
	ld d, MAX_HANGUL_TILE_COUNT
.clear_used
	bit 6, [hl]
	jr z, .unpin_slot
	set HANGUL_ATTR_USED_F, [hl]
	jr .next_slot
.unpin_slot
	res HANGUL_ATTR_USED_F, [hl]
.next_slot
	inc hl
	inc hl
	dec d
	jr nz, .clear_used

	ld bc, SCREEN_AREA
	ld de, wTilemap
.mark_visible_tiles
	ld a, [de]
	inc de
	cp $80
	jr c, .skip_tile
	; $ec-$ef are fixed cursor/gender glyph tiles, not cache slots.
	cp $ec
	jr nc, .skip_tile
	and $fe
	push de
	call GetHangulAttributeAddress
	set HANGUL_ATTR_USED_F, [hl]
	pop de
.skip_tile
	dec bc
	ld a, b
	or c
	jr nz, .mark_visible_tiles
	pop hl
	pop de
	pop bc
	ret

ReleasePinnedHangulTiles::
; Called when leaving/rebuilding the Pokédex list, before its next text draw.
	ldh a, [hCGB]
	and a
	ret z
	ldh a, [rSVBK]
	push af
	di
	ld a, BANK(wHangulAttributes)
	ldh [rSVBK], a
	ld hl, wHangulAttributes
	ld b, MAX_HANGUL_TILE_COUNT
.loop
	res 6, [hl]
	inc hl
	inc hl
	dec b
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ei
	ret

CopyHangulGlyphToBuffer:
	push bc
	push hl
	ld a, b
	and a
	jr nz, .hangul

	; Standard text codes $80-$ff index the original 128-tile Font asset.
	ld a, c
	sub $80
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, Font
	add hl, de
	ld bc, TILE_1BPP_SIZE
	ld a, BANK(Font)
	jr .copy_one_tile

.hangul
	; Gold stores a completed Hangul glyph as (font bank, glyph index).
	ld a, b
	dec a
	cp $0b
	jr nc, .invalid_hangul
	ld h, a
	ld l, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; (font bank - 1) * $1000
	ld a, c
	ld e, a
	ld d, 0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d ; glyph index * 16
	add hl, de

	; Crystal's free ROM ranges split the font into four segments.
	ld a, h
	cp $40
	jr nc, .font_bank_2
	add $40
	ld h, a
	ld a, BANK(HangulPoC_Gfx)
	jr .copy_hangul
.font_bank_2
	ld a, h
	cp $70
	jr nc, .font_bank_3
	add $10
	ld h, a
	ld a, BANK(HangulPoC_Font2)
	jr .copy_hangul
.font_bank_3
	ld a, h
	cp $a0
	jr nc, .font_bank_4
	sub $20
	ld h, a
	ld a, BANK(HangulPoC_Font3)
	jr .copy_hangul
.font_bank_4
	ld a, h
	sub $60
	ld h, a
	ld a, BANK(HangulPoC_Font4)
.copy_hangul
	ld bc, 2 * TILE_1BPP_SIZE
	jr .copy

.invalid_hangul
	; An invalid internal key becomes an empty glyph, never arbitrary ROM.
	ld hl, wHangulFontGfx
	ld bc, 2 * TILE_SIZE
	xor a
	call ByteFill
	pop hl
	pop bc
	ret

.copy
	ld de, wHangulFontGfx
	call FarCopyBytesDouble
	jr .copy_done

.copy_one_tile
	ld de, wHangulFontGfx
	call FarCopyBytesDouble
	; The shared cache uploads pairs, but a standard character uses only one tile.
	; Clear the unused half so it cannot show stale pixels from an earlier glyph.
	push hl
	ld hl, wHangulFontGfx + TILE_SIZE
	ld b, TILE_SIZE
	.clear_second_tile
	xor a
	ld [hli], a
	dec b
	jr nz, .clear_second_tile
	pop hl
.copy_done
	; Match the font polarity selected by Pokedex_LoadInvertedFont, including
	; standard characters uploaded after the first Hangul glyph activates cache.
	ld a, [wHangulDynamicMode]
	bit 7, a
	jr z, .restore
	ld hl, wHangulFontGfx
	ld b, 2 * TILE_SIZE
.invert
	ld a, [hl]
	cpl
	ld [hli], a
	dec b
	jr nz, .invert
.restore
	pop hl
	pop bc
	ret

CopyHangulTilesToVRAM:
	push af
	push bc
	push de
	push hl
	; vTiles0 is $8000, so cache tile $80 maps to $8800.
	ld h, 0
	ld l, a
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, vTiles0
	add hl, de
	call HDMATransfer_HangulFontToVRAM
	pop hl
	pop de
	pop bc
	pop af
	ret

HDMATransfer_HangulFontToVRAM::
; Copy a cached 8x16 glyph (two 2bpp tiles) directly during VBlank.

	; Menus such as the Trainer Card print while the LCD is disabled. In that
	; state LY never reaches VBlank, but VRAM is immediately writable.
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr z, .copy
.wait_vblank
	ldh a, [rLY]
	; LY counts pixel scanlines, not tilemap rows (SCREEN_HEIGHT = 18).
	cp SCREEN_HEIGHT_PX
	jr c, .wait_vblank
	; The unrolled copy takes less than 1000 T-cycles from the LY read to
	; return. Even at normal speed, starting on LY 150 leaves at least three
	; complete scanlines (1368 dots). Use LY 144-150, not just LY 144: menus
	; otherwise wait nearly a whole frame for every newly cached glyph.
	; _PlaceHangul disables interrupts across this transfer.
	cp SCREEN_HEIGHT_PX + 7
	jr c, .copy
	; Late VBlank still waits for the next frame; never risk a Mode 3 write.
.wait_next_frame
	ldh a, [rLY]
	cp SCREEN_HEIGHT_PX
	jr nc, .wait_next_frame
	jr .wait_vblank


.copy
	; vTiles0/vTiles1 are font tiles in VRAM bank 0.  The active bank can be
	; bank 1 after an attrmap transfer, so preserve it and select bank 0 here.
	ldh a, [rVBK]
	push af
	xor a
	ldh [rVBK], a
	ld de, wHangulFontGfx
.copy_byte
	REPT 2 * TILE_SIZE
	ld a, [de]
	inc de
	ld [hli], a
	ENDR
	ld bc, 0 ; preserve the previous loop's return value
	pop af
	ldh [rVBK], a
	ret


SECTION "Hangul Font Bank 1", ROMX[$4000], BANK[$79]
HangulPoC_Gfx:
	INCBIN "gfx/font/font_hangul.1bpp", 0, $4000

SECTION "Hangul Font Bank 2", ROMX[$5000], BANK[$78]
HangulPoC_Font2:
	INCBIN "gfx/font/font_hangul.1bpp", $4000, $3000

SECTION "Hangul Font Bank 3", ROMX[$5000], BANK[$7c]
HangulPoC_Font3:
	INCBIN "gfx/font/font_hangul.1bpp", $7000, $3000

SECTION "Hangul Font Bank 4", ROMX[$4000], BANK[$7f]
HangulPoC_Font4:
	INCBIN "gfx/font/font_hangul.1bpp", $a000, $1000
