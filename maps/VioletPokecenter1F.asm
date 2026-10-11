	object_const_def
	const VIOLETPOKECENTER1F_NURSE
	const VIOLETPOKECENTER1F_GAMEBOY_KID
	const VIOLETPOKECENTER1F_GENTLEMAN
	const VIOLETPOKECENTER1F_YOUNGSTER
	const VIOLETPOKECENTER1F_ELMS_AIDE

VioletPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

VioletPokecenterNurse:
	jumpstd PokecenterNurseScript

VioletPokecenter1F_ElmsAideScript:
	faceplayer
	getfollowerdirection
	ifequal LEFT, .MoveFollowerAround
.Return
	opentext
	checkevent EVENT_REFUSED_TO_TAKE_EGG_FROM_ELMS_AIDE
	iftrue .SecondTimeAsking
	writetext VioletPokecenterElmsAideFavorText
.AskTakeEgg:
	yesorno
	iffalse .RefusedEgg
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .PartyFull
	giveegg TOGEPI, EGG_LEVEL
	getstring STRING_BUFFER_4, .eggname
	scall .AideGivesEgg
	setevent EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE
	clearevent EVENT_ELMS_AIDE_IN_LAB
	clearevent EVENT_TOGEPI_HATCHED
	setmapscene ROUTE_32, SCENE_ROUTE32_OFFER_SLOWPOKETAIL
	writetext VioletPokecenterElmsAideGiveEggText
	waitbutton
	closetext
	readvar VAR_FACING
	ifequal UP, .AideWalksAroundPlayer
	turnobject PLAYER, DOWN
	applymovement VIOLETPOKECENTER1F_ELMS_AIDE, MovementData_AideWalksStraightOutOfPokecenter
	playsound SFX_EXIT_BUILDING
	disappear VIOLETPOKECENTER1F_ELMS_AIDE
	waitsfx
	end

.AideWalksAroundPlayer:
	applymovement VIOLETPOKECENTER1F_ELMS_AIDE, MovementData_AideWalksLeftToExitPokecenter
	turnobject PLAYER, DOWN
	applymovement VIOLETPOKECENTER1F_ELMS_AIDE, MovementData_AideFinishesLeavingPokecenter
	playsound SFX_EXIT_BUILDING
	disappear VIOLETPOKECENTER1F_ELMS_AIDE
	waitsfx
	end

.eggname
	db "알@"

.AideGivesEgg:
	jumpstd ReceiveTogepiEggScript
	end

.PartyFull:
	writetext VioletCityElmsAideFullPartyText
	waitbutton
	closetext
	end

.RefusedEgg:
	writetext VioletPokecenterElmsAideRefuseText
	waitbutton
	closetext
	setevent EVENT_REFUSED_TO_TAKE_EGG_FROM_ELMS_AIDE
	end

.SecondTimeAsking:
	writetext VioletPokecenterElmsAideAskEggText
	sjump .AskTakeEgg

.MoveFollowerAround:
	readvar VAR_FACING
	ifnotequal UP, .Return
	applymovement FOLLOWER, MovementData_VioletPMCFollowerMovesAround
	sjump .Return

VioletPokecenter1FGameboyKidScript:
	jumptextfaceplayer VioletPokecenter1FGameboyKidText

VioletPokecenter1FGentlemanScript:
	jumptextfaceplayer VioletPokecenter1FGentlemanText

VioletPokecenter1FYoungsterScript:
	jumptextfaceplayer VioletPokecenter1FYoungsterText

MovementData_VioletPMCFollowerMovesAround:
	step DOWN
	step RIGHT
	turn_head UP
	step_end

MovementData_AideWalksStraightOutOfPokecenter:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

MovementData_AideWalksLeftToExitPokecenter:
	step LEFT
	step DOWN
	step_end

MovementData_AideFinishesLeavingPokecenter:
	step DOWN
	step DOWN
	step DOWN
	step_end

VioletPokecenterElmsAideFavorText:
	text "<PLAY_G> 오래간만입니다"

	para "공박사님께 부탁을 받아서 당신을"
	line "찾고 있었어요"

	para "사실은 …… 포켓몬 알을 지니고"
	line "있어달라는 것입니다!"
	done

VioletPokecenterElmsAideGiveEggText:
	text "공박사님이 조사한 바로는"
	line "포켓몬은 알 안에서"

	para "어느정도 키우지 않으면"
	line "태어나지 않는다고 합니다!"

	para "그것도 늘 활발한"
	line "포켓몬 곁에 있지 않으면"
	cont "안 된다는 것 같아요"

	para "그러한 것을"
	line "부탁할 만한 사람은"
	cont "<PLAY_G> 뿐이니까"

	para "잘 부탁할께요!"
	line "태어난다면 공박사님에게"
	cont "연락해주세요"
	done

VioletCityElmsAideFullPartyText:
	text "포켓몬이 잔뜩 있어서"
	line "그 이상 데리고 다닐 수 없습니다"
	cont "그럼 이곳에서 기다리겠습니다"
	done

VioletPokecenterElmsAideRefuseText:
	text "그 그런……"
	line "공박사님의 부탁이라니까요"
	done

VioletPokecenterElmsAideAskEggText:
	text "<PLAY_G> 알을"
	line "데리고 있어 주겠습니까?"
	done

VioletPokecenterFarawayLinkText: ; unreferenced
	text "멀리 사는"
	line "친구들과"

	para "통신으로 승부할"
	line "수 있다면"

	para "정말 좋겠다고"
	line "생각했어"
	done

VioletPokecenterMobileAdapterText: ; unreferenced
	text "방금 진청시티의"
	line "친구와 통신으로"
	cont "승부했어"

	para "모바일 어댑터를"
	line "연결하면 멀리"

	para "있는 친구와도"
	line "통신할 수 있단다"
	done

VioletPokecenter1FGameboyKidText:
	text "잡은 포켓몬을"
	line "컴퓨터에 맡기는 시스템을"
	cont "이수재라는 녀석이 만들었대"
	done

VioletPokecenter1FGentlemanText:
	text "3년정도 전쯤의 이야기란다"

	para "로켓단이라고 하는 녀석들이"
	line "포켓몬을 사용해서"
	cont "나쁜 짓만 했단다"

	para "하지만 악은 망한다!"
	line "어떤 소년의 활약으로"
	cont "해산되었단다!"
	done

VioletPokecenter1FYoungsterText:
	text "포켓몬은 머리가 좋으니까"
	line "존경할만한 트레이너가"
	cont "말하는 것이 아니면 듣지 않아"

	para "체육관 배지를 지니고 있지 않으면"
	line "명령도 듣지않고 제멋대로란다"
	done

VioletPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, VIOLET_CITY, 5
	warp_event  4,  7, VIOLET_CITY, 5
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VioletPokecenterNurse, -1
	object_event  7,  6, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VioletPokecenter1FGameboyKidScript, -1
	object_event  1,  4, SPRITE_GENTLEMAN, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VioletPokecenter1FGentlemanScript, -1
	object_event  8,  1, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VioletPokecenter1FYoungsterScript, -1
	object_event  4,  3, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VioletPokecenter1F_ElmsAideScript, EVENT_ELMS_AIDE_IN_VIOLET_POKEMON_CENTER
