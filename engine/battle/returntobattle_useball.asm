_ReturnToBattle_UseBall:
	call ClearBGPalettes
	call ClearTilemap
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .gettutorialbackpic
	farcall GetBattleMonBackpic
	jr .continue

.gettutorialbackpic
	farcall GetTrainerBackpic
.continue
	farcall GetEnemyMonFrontpic
	farcall _LoadBattleFontsHPBar
	call GetMemSGBLayout
	call CloseWindow
	; Restored tile IDs alone do not restore Hangul glyphs reused by the Pack.
	; Rebuild both names/status rows before the ball animation/text is shown.
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .tutorial_hud
	farcall UpdateBattleHUDs
	jr .hud_ready
.tutorial_hud
	; The tutorial has a trainer backpic, not an active player Pokemon HUD.
	farcall UpdateEnemyHUD
.hud_ready
	call LoadStandardMenuHeader
	call WaitBGMap
	jp SetDefaultBGPAndOBP
