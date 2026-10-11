	object_const_def
	const DAYCARE_GRAMPS
	const DAYCARE_GRANNY

DayCare_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, DayCareEggCheckCallback

DayCareEggCheckCallback:
	checkflag ENGINE_DAY_CARE_MAN_HAS_EGG
	iftrue .PutDayCareManOutside
	clearevent EVENT_DAY_CARE_MAN_IN_DAY_CARE
	setevent EVENT_DAY_CARE_MAN_ON_ROUTE_34
	endcallback

.PutDayCareManOutside:
	setevent EVENT_DAY_CARE_MAN_IN_DAY_CARE
	clearevent EVENT_DAY_CARE_MAN_ON_ROUTE_34
	endcallback

DayCareManScript_Inside:
	faceplayer
	opentext
	checkevent EVENT_GOT_ODD_EGG
	iftrue .AlreadyHaveOddEgg
	writetext DayCareManText_GiveOddEgg
	promptbutton
	closetext
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .PartyFull
	special GiveOddEgg
	opentext
	writetext DayCareText_GotOddEgg
	playsound SFX_KEY_ITEM
	waitsfx
	writetext DayCareText_DescribeOddEgg
	waitbutton
	closetext
	setevent EVENT_GOT_ODD_EGG
	end

.PartyFull:
	opentext
	writetext DayCareText_PartyFull
	waitbutton
	closetext
	end

.AlreadyHaveOddEgg:
	special DayCareMan
	waitbutton
	closetext
	end

DayCareLadyScript:
	faceplayer
	opentext
	checkflag ENGINE_DAY_CARE_MAN_HAS_EGG
	iftrue .HusbandWasLookingForYou
	special DayCareLady
	waitbutton
	closetext
	end

.HusbandWasLookingForYou:
	writetext Text_GrampsLookingForYou
	waitbutton
	closetext
	end

DayCareBookshelf:
	jumpstd DifficultBookshelfScript

Text_GrampsLookingForYou:
	text "할아버지가"
	line "너를 찾고있단다"
	done

Text_DayCareManTalksAboutEggTicket: ; unreferenced
	text "나는 보모 할아버지다"

	para "금빛시티에 새로운 곳이 생겼는데"
	line "교환 코너라고 하더구나"

	para "이상한 알로 바꿀 수 있는"
	line "알티켓을 받았단다"

	para "하지만 우리는 보모 일을 하고"
	line "있어서 필요가 없으니 네가"
	cont "가지려무나"
	done

DayCareManText_GiveOddEgg:
	text "나는 보모 할아버지다 알에 대해"
	line "알고 있니?"

	para "할머니와 함께 포켓몬을 돌보고"
	line "있었는데 알이 있어서 깜짝"
	cont "놀랐단다!"

	para "정말 신기한 일이지 않니?"

	para "이 알을 갖고 싶으니? 좋아 그럼"
	line "네가 가지려무나!"
	done

DayCareText_ComeAgain: ; unreferenced
	text "또 오너라"
	done

DayCareText_GotOddEgg:
	text "<PLAYER>는(은)"
	line "이상한 알을 받았다!"
	done

DayCareText_DescribeOddEgg:
	text "전에 어떤 사람의"
	line "포켓몬을"

	para "돌봐주던 중에"
	line "발견한 알이란다"

	para "그런데 그 트레이너가"
	line "알을 원하지 않아서"

	para "내가 이렇게"
	line "보관하고 있었단다"
	done

DayCareText_PartyFull:
	text "이것을 받을"
	line "자리가 없구나"
	done

DayCare_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  5, ROUTE_34, 3
	warp_event  0,  6, ROUTE_34, 4
	warp_event  2,  7, ROUTE_34, 5
	warp_event  3,  7, ROUTE_34, 5

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, DayCareBookshelf
	bg_event  1,  1, BGEVENT_READ, DayCareBookshelf

	def_object_events
	object_event  2,  3, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, DayCareManScript_Inside, EVENT_DAY_CARE_MAN_IN_DAY_CARE
	object_event  5,  3, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, DayCareLadyScript, -1
