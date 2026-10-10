; Korean Gold is a reference only. All adopted data is owned by Crystal.
INCLUDE "data/items/stats_names.asm"
	const_def 1
	const PINK_PAGE  ; 1
	const GREEN_PAGE ; 2
	const BLUE_PAGE  ; 3
DEF NUM_STAT_PAGES EQU const_value - 1

DEF STAT_PAGE_MASK EQU %00000011
	const_def 4
	const STATS_SCREEN_PLACE_FRONTPIC ; 4
	const STATS_SCREEN_ANIMATE_MON    ; 5
	const STATS_SCREEN_ANIMATE_EGG    ; 6

BattleStatsScreenInit:
	ld a, [wLinkMode]
	cp LINK_MOBILE
	jr nz, StatsScreenInit

	ld a, [wBattleMode]
	and a
	jr z, StatsScreenInit
	jr _MobileStatsScreenInit

StatsScreenInit:
	ld hl, StatsScreenMain
	jr StatsScreenInit_gotaddress

_MobileStatsScreenInit:
	ld hl, StatsScreenMobile
	jr StatsScreenInit_gotaddress

StatsScreenInit_gotaddress:
	ldh a, [hMapAnims]
	push af
	xor a
	ldh [hMapAnims], a ; disable overworld tile animations
	ld a, [wBoxAlignment] ; whether sprite is to be mirrorred
	push af
	ld a, [wJumptableIndex]
	ld b, a
	ld a, [wStatsScreenFlags]
	ld c, a

	push bc
	push hl
	call ClearBGPalettes
	call ClearTilemap
	call UpdateSprites
	farcall StatsScreen_LoadFont
	pop hl
	call _hl_
	call ClearBGPalettes
	call ClearTilemap
	pop bc

	; restore old values
	ld a, b
	ld [wJumptableIndex], a
	ld a, c
	ld [wStatsScreenFlags], a
	pop af
	ld [wBoxAlignment], a
	pop af
	ldh [hMapAnims], a
	ret

StatsScreenMain:
	xor a
	ld [wJumptableIndex], a
	ld [wStatsScreenFlags], a

	ld a, [wStatsScreenFlags]
	and ~STAT_PAGE_MASK
	or PINK_PAGE ; first_page
	ld [wStatsScreenFlags], a

.loop
	ld a, [wJumptableIndex]
	and ~(1 << 7)
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call StatsScreen_WaitAnim
	ld a, [wJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr z, .loop
	ret

StatsScreenMobile:
	xor a
	ld [wJumptableIndex], a
	ld [wStatsScreenFlags], a

	ld a, [wStatsScreenFlags]
	and ~STAT_PAGE_MASK
	or PINK_PAGE ; first_page
	ld [wStatsScreenFlags], a

.loop
	farcall Mobile_SetOverworldDelay
	ld a, [wJumptableIndex]
	and JUMPTABLE_INDEX_MASK
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call StatsScreen_WaitAnim
	farcall MobileComms_CheckInactivityTimer
	jr c, .exit
	ld a, [wJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr z, .loop

.exit
	ret

StatsScreenPointerTable:
	dw MonStatsInit       ; regular pokémon
	dw EggStatsInit       ; egg
	dw StatsScreenWaitCry
	dw EggStatsJoypad
	dw StatsScreen_LoadPage
	dw StatsScreenWaitCry
	dw MonStatsJoypad
	dw StatsScreen_Exit

StatsScreen_WaitAnim:
	ld hl, wStatsScreenFlags
	bit STATS_SCREEN_ANIMATE_EGG, [hl]
	jr nz, .try_anim
	bit STATS_SCREEN_ANIMATE_MON, [hl]
	jr nz, .finish
	call DelayFrame
	ret

.try_anim
	farcall SetUpPokeAnim
	jr nc, .finish
	ld hl, wStatsScreenFlags
	res STATS_SCREEN_ANIMATE_EGG, [hl]
.finish
	ld hl, wStatsScreenFlags
	res STATS_SCREEN_ANIMATE_MON, [hl]
	farcall HDMATransferTilemapToWRAMBank3
	ret

StatsScreen_SetJumptableIndex:
	ld a, [wJumptableIndex]
	and JUMPTABLE_EXIT
	or h
	ld [wJumptableIndex], a
	ret

StatsScreen_Exit:
	ld hl, wJumptableIndex
	set JUMPTABLE_EXIT_F, [hl]
	ret

MonStatsInit:
	ld hl, wStatsScreenFlags
	res STATS_SCREEN_ANIMATE_EGG, [hl]
	call ClearBGPalettes
	call ClearTilemap
	farcall HDMATransferTilemapToWRAMBank3
	call StatsScreen_CopyToTempMon
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call StatsScreen_InitUpperHalf
	ld hl, wStatsScreenFlags
	set STATS_SCREEN_PLACE_FRONTPIC, [hl]
	ld h, 4
	call StatsScreen_SetJumptableIndex
	ret

.egg
	ld h, 1
	call StatsScreen_SetJumptableIndex
	ret

EggStatsInit:
	call EggStatsScreen
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

EggStatsJoypad:
	call StatsScreen_GetJoypad
	jr nc, .check
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.check
	bit B_PAD_A, a
	jr nz, .quit
if DEF(_DEBUG)
	cp PAD_START
	jr z, .hatch
endc
	and PAD_DOWN | PAD_UP | PAD_A | PAD_B
	jp StatsScreen_JoypadAction

.quit
	ld h, 7
	call StatsScreen_SetJumptableIndex
	ret

if DEF(_DEBUG)
.hatch
	ld a, [wMonType]
	or a
	jr nz, .skip
	push bc
	push de
	push hl
	ld a, [wCurPartyMon]
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1Happiness
	call AddNTimes
	ld [hl], 1
	ld a, 1
	ld [wTempMonHappiness], a
	ld a, 127
	ld [wStepCount], a
	ld de, .HatchSoonString
	hlcoord 8, 17
	call PlaceString
	ld hl, wStatsScreenFlags
	set STATS_SCREEN_ANIMATE_MON, [hl]
	pop hl
	pop de
	pop bc
.skip
	xor a
	jp StatsScreen_JoypadAction

.HatchSoonString:
	db "▶HATCH SOON!@"
endc

StatsScreen_LoadPage:
	call StatsScreen_LoadGFX
	ld hl, wStatsScreenFlags
	res STATS_SCREEN_PLACE_FRONTPIC, [hl]
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

MonStatsJoypad:
	call StatsScreen_GetJoypad
	jr nc, .next
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.next
	and PAD_CTRL_PAD | PAD_A | PAD_B
	jp StatsScreen_JoypadAction

StatsScreenWaitCry:
	call IsSFXPlaying
	ret nc
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

StatsScreen_CopyToTempMon:
	ld a, [wMonType]
	cp TEMPMON
	jr nz, .not_tempmon
	ld a, [wBufferMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wBufferMon
	ld de, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	jr .done

.not_tempmon
	farcall CopyMonToTempMon
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .done
	ld a, [wMonType]
	cp BOXMON
	jr c, .done
	farcall CalcTempmonStats
.done
	and a
	ret

StatsScreen_GetJoypad:
	call GetJoypad
	ld a, [wMonType]
	cp TEMPMON
	jr nz, .not_tempmon
	push hl
	push de
	push bc
	farcall StatsScreenDPad
	pop bc
	pop de
	pop hl
	ld a, [wMenuJoypad]
	and PAD_DOWN | PAD_UP
	jr nz, .set_carry
	ld a, [wMenuJoypad]
	jr .clear_carry

.not_tempmon
	ldh a, [hJoyPressed]
.clear_carry
	and a
	ret

.set_carry
	scf
	ret

StatsScreen_JoypadAction:
	push af
	ld a, [wStatsScreenFlags]
	maskbits NUM_STAT_PAGES
	ld c, a
	pop af
	bit B_PAD_B, a
	jp nz, .b_button
	bit B_PAD_LEFT, a
	jr nz, .d_left
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_A, a
	jr nz, .a_button
	bit B_PAD_UP, a
	jr nz, .d_up
	bit B_PAD_DOWN, a
	jr nz, .d_down
	jr .done

.d_down
	ld a, [wMonType]
	cp BOXMON
	jr nc, .done
	and a
	ld a, [wPartyCount]
	jr z, .next_mon
	ld a, [wOTPartyCount]
.next_mon
	ld b, a
	ld a, [wCurPartyMon]
	inc a
	cp b
	jr z, .done
	ld [wCurPartyMon], a
	ld b, a
	ld a, [wMonType]
	and a
	jr nz, .load_mon
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	jr .load_mon

.d_up
	ld a, [wCurPartyMon]
	and a
	jr z, .done
	dec a
	ld [wCurPartyMon], a
	ld b, a
	ld a, [wMonType]
	and a
	jr nz, .load_mon
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	jr .load_mon

.a_button
	ld a, c
	cp BLUE_PAGE ; last page
	jr z, .b_button
.d_right
	inc c
	ld a, BLUE_PAGE ; last page
	cp c
	jr nc, .set_page
	ld c, PINK_PAGE ; first page
	jr .set_page

.d_left
	dec c
	jr nz, .set_page
	ld c, BLUE_PAGE ; last page
	jr .set_page

.done
	ret

.set_page
	ld a, [wStatsScreenFlags]
	and ~STAT_PAGE_MASK
	or c
	ld [wStatsScreenFlags], a
	ld h, 4
	call StatsScreen_SetJumptableIndex
	ret

.load_mon
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.b_button
	ld h, 7
	call StatsScreen_SetJumptableIndex
	ret

StatsScreen_InitUpperHalf:
	call .PlaceHPBar
	xor a
	ldh [hBGMapMode], a
	ld a, [wBaseDexNo]
	ld [wTextDecimalByte], a
	ld [wCurSpecies], a
	hlcoord 1, 0
	ld [hl], '№'
	inc hl
	call StatsScreen_PlaceDot
	hlcoord 3, 0
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	ld de, wTextDecimalByte
	call PrintNum
	hlcoord 1, 8
	call PrintLevel
	ld hl, .NicknamePointers
	call GetNicknamePointer
	call CopyNickname
	hlcoord 1, 10
	call PlaceHangulName
	hlcoord 5, 8
	call .PlaceGenderChar
	hlcoord 1, 12
	ld de, .Slash
	call PlaceString
	inc hl
	ld a, [wBaseDexNo]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	call PlaceString
	call StatsScreen_PlaceVerticalDivider
	call StatsScreen_PlacePageSwitchArrows
	call StatsScreen_PlaceShinyIcon
	ret

.PlaceHPBar:
	ld hl, wTempMonHP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wTempMonMaxHP
	ld a, [hli]
	ld d, a
	ld e, [hl]
	farcall ComputeHPBarPixels
	ld hl, wCurHPPal
	call SetHPPal
	ld b, SCGB_STATS_SCREEN_HP_PALS
	call GetSGBLayout
	call DelayFrame
	ret

.PlaceGenderChar:
	push hl
	farcall GetGender
	pop hl
	ret c
	ld de, .Male
	jr nz, .got_gender
	ld de, .Female
.got_gender
	jp PlaceString

.Male: db "♂@"
.Female: db "♀@"
.Slash: db "/@"

.NicknamePointers:
	dw wPartyMonNicknames
	dw wOTPartyMonNicknames
	dw sBoxMonNicknames
	dw wBufferMonNickname

StatsScreen_PlaceDot:
; $e8 is a source character, not a fixed CGB tile. Cache a single-height dot
; even before the first Hangul. Avoid the DMG Hangul fallback's upper-row write.
	ldh a, [hCGB]
	and a
	jr z, .static
	ld b, 0
	ld c, '.'
	; Switch through ROM0: an inline homecall would switch out this ROMX code.
	; FarCall_de also preserves HL, the glyph's destination coordinate.
	ld de, _PlaceHangul
	ld a, BANK(_PlaceHangul)
	call FarCall_de
	ret
.static
	ld [hl], '.'
	inc hl
	ret

StatsScreen_PlaceVerticalDivider:
; Korean Gold's left information column ends at x=6.
	hlcoord 7, 0
	ld bc, SCREEN_WIDTH
	ld d, SCREEN_HEIGHT
.loop
	ld a, $31 ; vertical divider
	ld [hl], a
	add hl, bc
	dec d
	jr nz, .loop
	ret

StatsScreen_PlaceHorizontalDivider: ; unreferenced legacy layout
	hlcoord 0, 7
	ld b, SCREEN_WIDTH
	ld a, $62 ; horizontal divider (empty HP/exp bar)
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

StatsScreen_PlacePageSwitchArrows:
; Fixed 8-pixel-high "◀페이지▶" tiles, owned by Crystal.
	hlcoord 2, 16
	ld a, $32
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	ret

StatsScreen_PlaceShinyIcon:
	ld bc, wTempMonDVs
	farcall CheckShininess
	ret nc
	hlcoord 6, 8
	ld [hl], '⁂'
	ret

StatsScreen_LoadGFX:
	ld a, [wBaseDexNo]
	ld [wTempSpecies], a
	ld [wCurSpecies], a
	xor a
	ldh [hBGMapMode], a
	call .ClearBox
	call .PageTilemap
	call .LoadPals
	ld hl, wStatsScreenFlags
	bit STATS_SCREEN_PLACE_FRONTPIC, [hl]
	jr nz, .place_frontpic
	call SetDefaultBGPAndOBP
	ret

.place_frontpic
	call StatsScreen_PlaceFrontpic
	ret

.ClearBox:
	ld a, [wStatsScreenFlags]
	maskbits NUM_STAT_PAGES
	ld c, a
	call StatsScreen_LoadPageIndicators
	hlcoord 8, 0
	lb bc, SCREEN_HEIGHT, 12
	call ClearBox
	jp StatsScreen_ClearPageAttrs

.LoadPals:
	ld a, [wStatsScreenFlags]
	maskbits NUM_STAT_PAGES
	ld c, a
	farcall LoadStatsScreenPals
	ldh a, [hCGB]
	and a
	jr z, .attrs_done
	farcall ApplyAttrmap
.attrs_done
	call DelayFrame
	ld hl, wStatsScreenFlags
	set STATS_SCREEN_ANIMATE_MON, [hl]
	ret

.PageTilemap:
	ld a, [wStatsScreenFlags]
	maskbits NUM_STAT_PAGES
	dec a
	ld hl, .Jumptable
	rst JumpTable
	ret

.Jumptable:
; entries correspond to *_PAGE constants
	table_width 2
	dw LoadPinkPage
	dw LoadGreenPage
	dw LoadBluePage
	assert_table_length NUM_STAT_PAGES

StatsScreen_ClearPageAttrs:
; Each page owns the entire right column. Keep the mon, HP and page icons
; on the left untouched, and do not carry the exp palette to other pages.
	ldh a, [hCGB]
	and a
	ret z
	hlcoord 8, 0, wAttrmap
	lb bc, SCREEN_HEIGHT, 12
	xor a ; stats background/HP palette 0
	call FillBoxWithByte
	ld a, [wStatsScreenFlags]
	and STAT_PAGE_MASK
	cp PINK_PAGE
	ret nz
	hlcoord 9, 16, wAttrmap
	ld bc, 10
	ld a, 2 ; exp bar, including its two end caps
	jp ByteFill

LoadPinkPage:
	hlcoord 10, 1
	ld b, $0
	predef DrawPlayerHP
	hlcoord 18, 1
	ld [hl], $41 ; right HP/exp bar end cap
	ld de, .Status_Type
	hlcoord 9, 4
	call PlaceString
	ld a, [wTempMonPokerusStatus]
	ld b, a
	and $f
	jr nz, .HasPokerus
	ld a, b
	and $f0
	jr z, .NotImmuneToPkrs
	hlcoord 19, 9
	call StatsScreen_PlaceDot ; same cache contract as the number prefix
.NotImmuneToPkrs:
	ld a, [wMonType]
	cp BOXMON
	jr z, .StatusOK
	hlcoord 14, 4
	push hl
	ld de, wTempMonStatus
	call StatsScreen_PlaceStatus
	pop hl
	jr nz, .done_status
	jr .StatusOK
.HasPokerus:
	ld de, .PkrsStr
	hlcoord 14, 4
	call PlaceString
	jr .done_status
.StatusOK:
	hlcoord 14, 4
	ld de, .OK_str
	call PlaceString
.done_status
	bccoord 14, 6
	farcall StatsScreenPlaceTypes
	hlcoord 8, 10
	lb bc, 6, 10
	call TextboxBorder
	ld de, .ExpPointStr
	hlcoord 9, 10
	call PlaceString
	hlcoord 16, 15
	call .PrintNextLevel
	hlcoord 12, 11
	lb bc, 3, 7
	ld de, wTempMonExp
	call PrintNum
	call .CalcExpToNextLevel
	hlcoord 12, 13
	lb bc, 3, 7
	ld de, wExpToNextLevel
	call PrintNum
	ld de, .LevelUpStr
	hlcoord 9, 13
	call PlaceString
	ld de, .ToStr
	hlcoord 9, 15
	call PlaceString
	hlcoord 10, 16
	ld a, [wTempMonLevel]
	ld b, a
	ld de, wTempMonExp + 2
	predef FillInExpBar
	hlcoord 9, 16
	ld [hl], $40 ; left exp bar end cap
	hlcoord 18, 16
	ld [hl], $41 ; right exp bar end cap
	ret

.PrintNextLevel:
	ld a, [wTempMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .AtMaxLevel
	inc a
	ld [wTempMonLevel], a
.AtMaxLevel:
	call PrintLevel
	pop af
	ld [wTempMonLevel], a
	ret

.CalcExpToNextLevel:
	ld a, [wTempMonLevel]
	cp MAX_LEVEL
	jr z, .AlreadyAtMaxLevel
	inc a
	ld d, a
	farcall CalcExpAtLevel
	ld hl, wTempMonExp + 2
	ld hl, wTempMonExp + 2
	ldh a, [hQuotient + 3]
	sub [hl]
	dec hl
	ld [wExpToNextLevel + 2], a
	ldh a, [hQuotient + 2]
	sbc [hl]
	dec hl
	ld [wExpToNextLevel + 1], a
	ldh a, [hQuotient + 1]
	sbc [hl]
	ld [wExpToNextLevel], a
	ret

.AlreadyAtMaxLevel:
	ld hl, wExpToNextLevel
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.Status_Type:
	db   "상태/"
	next "타입/@"

.OK_str:
	db "보통@"

.ExpPointStr:
	db "경험치@"

.LevelUpStr:
	db "앞으로@"

.ToStr:
	db "에서@"

.PkrsStr:
	db "포케러스@"

StatsScreen_PlaceStatus:
; Status-screen-only 8x16 labels; preserve the shared battle/party abbreviations.
; DE = status followed by unused byte then HP. Return NZ for a displayed status.
	push de
	inc de
	inc de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	or b
	pop de
	push de
	ld de, .Fainted
	jr z, .place
	pop de
	push de
	ld a, [de]
	ld de, .Poison
	bit PSN, a
	jr nz, .place
	ld de, .Burn
	bit BRN, a
	jr nz, .place
	ld de, .Freeze
	bit FRZ, a
	jr nz, .place
	ld de, .Paralysis
	bit PAR, a
	jr nz, .place
	ld de, .Sleep
	and SLP_MASK
	jr z, .done
.place
	call PlaceString
	ld a, TRUE
	and a
.done
	pop de
	ret
.Fainted:   db "기절@"
.Poison:    db "독@"
.Burn:      db "화상@"
.Freeze:    db "얼음@"
.Paralysis: db "마비@"
.Sleep:     db "잠듦@"

LoadGreenPage:
	ld de, .Item
	hlcoord 8, 1
	call PlaceString
	bccoord 12, 2
	farcall StatsScreenPlaceHeldItem
	hlcoord 8, 4
	lb bc, 12, 10
	call TextboxBorder
	call .PlaceMoveHeading
	ld hl, wTempMonMoves
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	call CopyBytes
	ld a, $ff ; ListMovePP also handles the zero-move case.
	ld [wNumMoves], a
	ld a, SCREEN_WIDTH * 3
	ld [wListMovesLineSpacing], a
	bccoord 9, 6
	farcall BattleListMoves
	hlcoord 11, 7
	ld a, SCREEN_WIDTH * 3
	ld [wListMovesLineSpacing], a
	predef ListMovePP
	ret

.Item:
	db "소지품@"

.PlaceMoveHeading:
; This fixed nine-cell title uses $42-$53, between the stats tiles ($31-$41)
; and the exp bar ($55-$5c), so four long Korean moves do not exhaust the cache.
	ld de, StatsScreenMoveHeadingGFX
	ld hl, vTiles2 tile $42
	lb bc, BANK(StatsScreenMoveHeadingGFX), 18
	call Get1bppViaHDMA
	hlcoord 9, 3
	ld bc, SCREEN_WIDTH
	ld d, 9
	ld a, $42
.heading_loop
	ld [hl], a
	inc a
	push hl
	add hl, bc
	ld [hl], a
	pop hl
	inc hl
	inc a
	dec d
	jr nz, .heading_loop
	ret

StatsScreenMoveHeadingGFX:
INCLUDE "gfx/stats/korean_move_heading.asm"
assert @ - StatsScreenMoveHeadingGFX == 18 * TILE_1BPP_SIZE
assert $42 + 18 <= $55

LoadBluePage:
	call .PlaceOTInfo
	hlcoord 8, 6
	lb bc, 10, 10
	call TextboxBorder
	call StatsScreen_PrintStats
	ret

.PlaceOTInfo:
	ld de, IDNoString
	hlcoord 9, 1
	call PlaceString
	ld de, OTString
	hlcoord 8, 3
	call PlaceString
	hlcoord 12, 1
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	ld de, wTempMonID
	call PrintNum
	ld hl, .OTNamePointers
	call GetNicknamePointer
	call CopyNickname
	farcall CorrectNickErrors
	hlcoord 12, 3
	call PlaceHangulName
	ld a, [wTempMonCaughtGender]
	and a
	jr z, .done
	cp $7f
	jr z, .done
	and CAUGHT_GENDER_MASK
	ld de, StatsScreen_InitUpperHalf.Male
	jr z, .got_gender
	ld de, StatsScreen_InitUpperHalf.Female
.got_gender
	hlcoord 18, 3
	call PlaceString
.done
	ret

.OTNamePointers:
	dw wPartyMonOTs
	dw wOTPartyMonOTs
	dw sBoxMonOTs
	dw wBufferMonOT

IDNoString:
	db "<ID>№.@"

OTString:
	db "어버이/@"

StatsScreen_PrintStats:
; Gold's number baselines coincide with Hangul label baselines.
	hlcoord 9, 8
	ld de, .Names
	call PlaceString
	hlcoord 15, 8
	ld de, wTempMonAttack
	call .PrintStat
	ld de, wTempMonDefense
	call .PrintStat
	ld de, wTempMonSpclAtk
	call .PrintStat
	ld de, wTempMonSpclDef
	call .PrintStat
	ld de, wTempMonSpeed
	lb bc, 2, 3
	jp PrintNum
.PrintStat
	push hl
	lb bc, 2, 3
	call PrintNum
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	ret
.Names:
	db   "공격"
	next "방어"
	next "특수공격"
	next "특수방어"
	next "스피드@"

StatsScreen_PlaceFrontpic:
	ld hl, wTempMonDVs
	predef GetUnownLetter
	call StatsScreen_GetAnimationParam
	jr c, .egg
	and a
	jr z, .no_cry
	jr .cry

.egg
	call .AnimateEgg
	call SetDefaultBGPAndOBP
	ret

.no_cry
	call .AnimateMon
	call SetDefaultBGPAndOBP
	ret

.cry
	call SetDefaultBGPAndOBP
	call .AnimateMon
	ld a, [wCurPartySpecies]
	call PlayMonCry2
	ret

.AnimateMon:
	ld hl, wStatsScreenFlags
	set STATS_SCREEN_ANIMATE_MON, [hl]
	ld a, [wCurPartySpecies]
	cp UNOWN
	jr z, .unown
	hlcoord 0, 1
	call PrepMonFrontpic
	ret

.unown
	xor a
	ld [wBoxAlignment], a
	hlcoord 0, 1
	call _PrepMonFrontpic
	ret

.AnimateEgg:
	ld a, [wCurPartySpecies]
	cp UNOWN
	jr z, .unownegg
	ld a, TRUE
	ld [wBoxAlignment], a
	call .get_animation
	ret

.unownegg
	xor a
	ld [wBoxAlignment], a
	call .get_animation
	ret

.get_animation
	ld a, [wCurPartySpecies]
	call IsAPokemon
	ret c
	call StatsScreen_LoadTextboxSpaceGFX
	ld de, vTiles2 tile $00
	predef GetAnimatedFrontpic
	hlcoord 0, 1
	ld d, $0
	ld e, ANIM_MON_MENU
	predef LoadMonAnimation
	ld hl, wStatsScreenFlags
	set STATS_SCREEN_ANIMATE_EGG, [hl]
	ret

StatsScreen_GetAnimationParam:
	ld a, [wMonType]
	ld hl, .Jumptable
	rst JumpTable
	ret

.Jumptable:
	dw .PartyMon
	dw .OTPartyMon
	dw .BoxMon
	dw .Tempmon
	dw .Wildmon

.PartyMon:
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld b, h
	ld c, l
	jr .CheckEggFaintedFrzSlp

.OTPartyMon:
	xor a
	ret

.BoxMon:
	ld hl, sBoxMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	call AddNTimes
	ld b, h
	ld c, l
	ld a, BANK(sBoxMons)
	call OpenSRAM
	call .CheckEggFaintedFrzSlp
	push af
	call CloseSRAM
	pop af
	ret

.Tempmon:
	ld bc, wTempMonSpecies
	jr .CheckEggFaintedFrzSlp ; utterly pointless

.CheckEggFaintedFrzSlp:
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call CheckFaintedFrzSlp
	jr c, .FaintedFrzSlp
.egg
	xor a
	scf
	ret

.Wildmon:
	ld a, $1
	and a
	ret

.FaintedFrzSlp:
	xor a
	ret

StatsScreen_LoadTextboxSpaceGFX:
	nop
	push hl
	push de
	push bc
	push af
	call DelayFrame
	ldh a, [rVBK]
	push af
	ld a, $1
	ldh [rVBK], a
	ld de, TextboxSpaceGFX
	lb bc, BANK(TextboxSpaceGFX), 1
	ld hl, vTiles2 tile ' '
	call Get2bpp
	pop af
	ldh [rVBK], a
	pop af
	pop bc
	pop de
	pop hl
	ret

StatsScreenSpaceGFX: ; unreferenced
INCBIN "gfx/font/space.2bpp"

EggStatsScreen:
	xor a
	ldh [hBGMapMode], a
	ld hl, wCurHPPal
	call SetHPPal
	ld b, SCGB_STATS_SCREEN_HP_PALS
	call GetSGBLayout
	call StatsScreen_PlaceVerticalDivider
	ld de, EggString
	hlcoord 3, 9
	call PlaceString
	ld de, IDNoString
	hlcoord 9, 1
	call PlaceString
	ld de, OTString
	hlcoord 8, 3
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 12, 1
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 12, 3
	call PlaceString
if DEF(_DEBUG)
	ld de, .PushStartString
	hlcoord 8, 17
	call PlaceString
	jr .placed_push_start

.PushStartString:
	db "▶PUSH START.@"

.placed_push_start
endc
	ld a, [wTempMonHappiness] ; egg status
	ld de, EggSoonString
	cp $6
	jr c, .picked
	ld de, EggCloseString
	cp $b
	jr c, .picked
	ld de, EggMoreTimeString
	cp $29
	jr c, .picked
	ld de, EggALotMoreTimeString
.picked
	hlcoord 8, 6
	call PlaceString
	ld hl, wStatsScreenFlags
	set STATS_SCREEN_ANIMATE_MON, [hl]
	call SetDefaultBGPAndOBP
	call DelayFrame
	hlcoord 0, 1
	call PrepMonFrontpic
	farcall HDMATransferTilemapToWRAMBank3
	call StatsScreen_AnimateEgg

	ld a, [wTempMonHappiness]
	cp 6
	ret nc
	ld de, SFX_2_BOOPS
	call PlaySFX
	ret

EggString:
	db "알@"

FiveQMarkString:
	db "?????@"

EggSoonString:
	db   "안에서 소리가"
	next "들려온다  이제"
	next "곧 태어날것 같다!@"

EggCloseString:
	db   "가끔씩 안에서"
	next "움직이고 있는듯 하다"
	next "태어나기 전 까지 얼마"
	next "남지 않았나?@"

EggMoreTimeString:
	db   "무엇이 태어나"
	next "줄까 궁금한데?"
	next "태어날 때 까지는"
	next "조금더 걸릴 것 같다@"

EggALotMoreTimeString:
	db   "이 알은"
	next "태어날 때 까지 꽤나"
	next "시간이 걸릴 것 같다@"

StatsScreen_AnimateEgg:
	call StatsScreen_GetAnimationParam
	ret nc
	ld a, [wTempMonHappiness]
	ld e, $7
	cp 6
	jr c, .animate
	ld e, $8
	cp 11
	jr c, .animate
	ret

.animate
	push de
	ld a, $1
	ld [wBoxAlignment], a
	call StatsScreen_LoadTextboxSpaceGFX
	ld de, vTiles2 tile $00
	predef GetAnimatedFrontpic
	pop de
	hlcoord 0, 1
	ld d, $0
	predef LoadMonAnimation
	ld hl, wStatsScreenFlags
	set STATS_SCREEN_ANIMATE_EGG, [hl]
	ret

StatsScreen_LoadPageIndicators:
	hlcoord 1, 14
	ld a, $36 ; first of 4 small square tiles
	call .load_square
	hlcoord 3, 14
	ld a, $36 ; " " " "
	call .load_square
	hlcoord 5, 14
	ld a, $36 ; " " " "
	call .load_square
	ld a, c
	cp GREEN_PAGE
	ld a, $3a ; first of 4 large square tiles
	hlcoord 1, 14 ; PINK_PAGE (< GREEN_PAGE)
	jr c, .load_square
	hlcoord 3, 14 ; GREEN_PAGE (= GREEN_PAGE)
	jr z, .load_square
	hlcoord 5, 14 ; BLUE_PAGE (> GREEN_PAGE)
.load_square
	push bc
	ld [hli], a
	inc a
	ld [hld], a
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	pop bc
	ret

CopyNickname:
	ld de, wStringBuffer1
	ld bc, MON_NAME_LENGTH
	jr .okay ; utterly pointless
.okay
	ld a, [wMonType]
	cp BOXMON
	jr nz, .partymon
	ld a, BANK(sBoxMonNicknames)
	call OpenSRAM
	push de
	call CopyBytes
	pop de
	call CloseSRAM
	ret

.partymon
	push de
	call CopyBytes
	pop de
	ret

GetNicknamePointer:
	ld a, [wMonType]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonType]
	cp TEMPMON
	ret z
	ld a, [wCurPartyMon]
	jp SkipNames

CheckFaintedFrzSlp:
	ld hl, MON_HP
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .fainted_frz_slp
	ld hl, MON_STATUS
	add hl, bc
	ld a, [hl]
	and 1 << FRZ | SLP_MASK
	jr nz, .fainted_frz_slp
	and a
	ret

.fainted_frz_slp
	scf
	ret
