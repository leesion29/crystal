	object_const_def
	const ROUTE32RUINSOFALPHGATE_OFFICER
	const ROUTE32RUINSOFALPHGATE_POKEFAN_M
	const ROUTE32RUINSOFALPHGATE_YOUNGSTER

Route32RuinsOfAlphGate_MapScripts:
	def_scene_scripts

	def_callbacks

Route32RuinsOfAlphGateOfficerScript:
	jumptextfaceplayer Route32RuinsOfAlphGateOfficerText

Route32RuinsOfAlphGatePokefanMScript:
	jumptextfaceplayer Route32RuinsOfAlphGatePokefanMText

Route32RuinsOfAlphGateYoungsterScript:
	jumptextfaceplayer Route32RuinsOfAlphGateYoungsterText

Route32RuinsOfAlphGateOfficerText:
	text "보고 만질 수 있는"

	para "알프의 유적 관광!"
	line "움직일 수 있는 돌"

	para "아래를 꼭 손으로"
	line "만져봐 주세요"
	done

Route32RuinsOfAlphGatePokefanMText:
	text "옷 유적의"
	line "공부인가?"

	para "장래희망은"
	line "박사로군!"
	done

Route32RuinsOfAlphGateYoungsterText:
	text "돌 아래에"
	line "그림이 그려져"

	para "있다! 움직여"
	line "보았지만 그건"
	cont "무엇일까?"
	done

Route32RuinsOfAlphGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  4, RUINS_OF_ALPH_OUTSIDE, 10
	warp_event  0,  5, RUINS_OF_ALPH_OUTSIDE, 11
	warp_event  9,  4, ROUTE_32, 2
	warp_event  9,  5, ROUTE_32, 3

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  2, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route32RuinsOfAlphGateOfficerScript, -1
	object_event  8,  2, SPRITE_POKEFAN_M, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, Route32RuinsOfAlphGatePokefanMScript, -1
	object_event  1,  6, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route32RuinsOfAlphGateYoungsterScript, -1
