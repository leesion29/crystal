	object_const_def
	const RUINSOFALPHRESEARCHCENTER_SCIENTIST1
	const RUINSOFALPHRESEARCHCENTER_SCIENTIST2
	const RUINSOFALPHRESEARCHCENTER_SCIENTIST3

RuinsOfAlphResearchCenter_MapScripts:
	def_scene_scripts
	scene_script RuinsOfAlphResearchCenterNoopScene,        SCENE_RUINSOFALPHRESEARCHCENTER_NOOP
	scene_script RuinsOfAlphResearchCenterGetUnownDexScene, SCENE_RUINSOFALPHRESEARCHCENTER_GET_UNOWN_DEX

	def_callbacks
	callback MAPCALLBACK_OBJECTS, RuinsOfAlphResearchCenterScientistCallback

RuinsOfAlphResearchCenterNoopScene:
	end

RuinsOfAlphResearchCenterGetUnownDexScene:
	sdefer RuinsOfAlphResearchCenterGetUnownDexScript
	end

RuinsOfAlphResearchCenterScientistCallback:
	checkscene
	ifequal SCENE_RUINSOFALPHRESEARCHCENTER_GET_UNOWN_DEX, .ShowScientist
	endcallback

.ShowScientist:
	moveobject RUINSOFALPHRESEARCHCENTER_SCIENTIST3, 3, 7
	appear RUINSOFALPHRESEARCHCENTER_SCIENTIST3
	endcallback

RuinsOfAlphResearchCenterGetUnownDexScript:
	applymovement RUINSOFALPHRESEARCHCENTER_SCIENTIST3, RuinsOfAlphResearchCenterApproachesComputerMovement
	playsound SFX_BOOT_PC
	pause 60
	playsound SFX_SWITCH_POKEMON
	pause 30
	playsound SFX_TALLY
	pause 30
	playsound SFX_TRANSACTION
	pause 30
	turnobject RUINSOFALPHRESEARCHCENTER_SCIENTIST3, DOWN
	opentext
	writetext RuinsOfAlphResearchCenterModifiedDexText
	waitbutton
	closetext
	applymovement RUINSOFALPHRESEARCHCENTER_SCIENTIST3, RuinsOfAlphResearchCenterApproachesPlayerMovement
	opentext
	writetext RuinsOfAlphResearchCenterDexUpgradedText
	playsound SFX_ITEM
	waitsfx
	setflag ENGINE_UNOWN_DEX
	writetext RuinsOfAlphResearchCenterScientist3Text
	waitbutton
	closetext
	applymovement RUINSOFALPHRESEARCHCENTER_SCIENTIST3, RuinsOfAlphResearchCenterLeavesPlayerMovement
	setscene SCENE_RUINSOFALPHRESEARCHCENTER_NOOP
	special RestartMapMusic
	end

RuinsOfAlphResearchCenterScientist3Script:
	faceplayer
	opentext
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .PrinterAvailable
	writetext RuinsOfAlphResearchCenterScientist3Text
	waitbutton
	closetext
	end

.PrinterAvailable:
	writetext RuinsOfAlphResearchCenterScientist3_PrinterAvailable
	waitbutton
	closetext
	end

RuinsOfAlphResearchCenterScientist1Script:
	faceplayer
	opentext
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .GotAllUnown
	checkflag ENGINE_UNOWN_DEX
	iftrue .GotUnownDex
	checkevent EVENT_MADE_UNOWN_APPEAR_IN_RUINS
	iftrue .UnownAppeared
	writetext RuinsOfAlphResearchCenterScientist1Text
	waitbutton
	closetext
	end

.UnownAppeared:
	writetext RuinsOfAlphResearchCenterScientist1Text_UnownAppeared
	waitbutton
	closetext
	end

.GotUnownDex:
	writetext RuinsOfAlphResearchCenterScientist1Text_GotUnownDex
	waitbutton
	closetext
	end

.GotAllUnown:
	writetext RuinsOfAlphResearchCenterScientist1Text_GotAllUnown
	waitbutton
	closetext
	clearevent EVENT_RUINS_OF_ALPH_OUTSIDE_TOURIST_YOUNGSTERS
	end

RuinsOfAlphResearchCenterScientist2Script:
	faceplayer
	opentext
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .GotAllUnown
	checkevent EVENT_MADE_UNOWN_APPEAR_IN_RUINS
	iftrue .UnownAppeared
	writetext RuinsOfAlphResearchCenterScientist2Text
	waitbutton
	closetext
	end

.UnownAppeared:
	writetext RuinsOfAlphResearchCenterScientist2Text_UnownAppeared
	waitbutton
	closetext
	end

.GotAllUnown:
	writetext RuinsOfAlphResearchCenterScientist2Text_GotAllUnown
	waitbutton
	closetext
	end

RuinsOfAlphResearchCenterComputer:
	opentext
	checkevent EVENT_RUINS_OF_ALPH_RESEARCH_CENTER_SCIENTIST
	iftrue .SkipChecking
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .GotAllUnown
.SkipChecking:
	writetext RuinsOfAlphResearchCenterComputerText
	waitbutton
	closetext
	end

.GotAllUnown:
	writetext RuinsOfAlphResearchCenterComputerText_GotAllUnown
	waitbutton
	closetext
	end

RuinsOfAlphResearchCenterPrinter:
	opentext
	checkevent EVENT_RUINS_OF_ALPH_RESEARCH_CENTER_SCIENTIST
	iftrue .SkipChecking
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .PrinterAvailable
.SkipChecking:
	writetext RuinsOfAlphResearchCenterPrinterText_DoesntWork
	waitbutton
	closetext
	end

.PrinterAvailable:
	writetext RuinsOfAlphResearchCenterUnownPrinterText
	waitbutton
	special UnownPrinter
	closetext
	end

RuinsOfAlphResearchCenterPhoto: ; unreferenced
	jumptext RuinsOfAlphResearchCenterProfSilktreePhotoText

RuinsOfAlphResearchCenterBookshelf:
	jumptext RuinsOfAlphResearchCenterAcademicBooksText

RuinsOfAlphResearchCenterApproachesComputerMovement:
	step UP
	step UP
	step LEFT
	turn_head UP
	step_end

RuinsOfAlphResearchCenterApproachesPlayerMovement:
	step DOWN
	step_end

RuinsOfAlphResearchCenterLeavesPlayerMovement:
	step UP
	step_end

RuinsOfAlphResearchCenterModifiedDexText:
	text "좋아!"

	para "포켓몬 도감의"
	line "개조가 끝났다!"

	para "옵션에서"
	line "안농도감을"

	para "추가해"
	line "넣었다"

	para "잡힌 순서대로"
	line "기록될 수"
	cont "있도록 했단다"
	done

RuinsOfAlphResearchCenterDexUpgradedText:
	text "<PLAYER>의"
	line "포켓몬 도감의 성능이 향상되었다!"
	done

RuinsOfAlphResearchCenterScientist3Text:
	text "잡힌 안농이"
	line "전부"
	cont "기록되어질꺼야"

	para "몇 종류나 있을까"
	line "너도 확인해 줘!"
	done

RuinsOfAlphResearchCenterScientist3_PrinterAvailable:
	text "안농을 전부"
	line "잡았다구?"

	para "그것"
	line "굉장하군!"

	para "안농을 프린트할"
	line "수 있도록 여기"
	cont "기계를 준비해 두었어"

	para "언제든지"
	line "자유롭게 사용해!"
	done

RuinsOfAlphResearchCenterScientist1Text:
	text "대략 1500년 전에"
	line "유적이"
	cont "만들어졌지만"

	para "누가 무엇을 위해"
	line "만들었나"
	cont "아직 모릅니다……"
	done

RuinsOfAlphResearchCenterScientist1Text_GotUnownDex:
	text "유적의 포켓몬"
	line "전부 몇"
	cont "종류나 있지?"
	done

RuinsOfAlphResearchCenterScientist1Text_UnownAppeared:
	text "유적의 포켓몬이"
	line "출현했어요!?"

	para "이건 대"
	line "사건이군"

	para "바로 조사를"
	line "착수해야겠군!"
	done

RuinsOfAlphResearchCenterScientist1Text_GotAllUnown:
	text "네 도움으로"
	line "조사를 진행하면서"

	para "유적에 대해"
	line "알게 되었어"

	para "유적은 포켓몬이"
	line "살 곳으로"

	para "만들어진"
	line "것 같아"
	done

RuinsOfAlphResearchCenterScientist2Text:
	text "벽에 그려져"
	line "있는 모양이"

	para "유적의"
	line "수수께끼를"

	para "푸는"
	line "열쇠다!"
	cont "……라고"
	cont "생각하는데-"
	done

RuinsOfAlphResearchCenterScientist2Text_UnownAppeared:
	text "네가"
	line "만난"
	cont "포켓몬은"

	para "유적 벽의"
	line "모양과"

	para "닮아있는것"
	line "같군"

	para "……흐음"

	para "그렇다고하면 수많은 종류가"
	line "유적에 있다는"
	cont "것인가……"
	done

RuinsOfAlphResearchCenterUnusedText1: ; unreferenced
	text "어떤 일이"
	line "일어나서"

	para "유적에 수수께끼의"
	line "문양이 나타난 것 같아"

	para "우리는 그 점에"
	line "주목해서 연구하고 있어"
	done

RuinsOfAlphResearchCenterUnusedText2: ; unreferenced
	text "내 연구에"
	line "따르면……"

	para "그 수수께끼의"
	line "문양은"

	para "포켓몬 커뮤니케이션센터가"
	line "만들어졌을 때 나타났어"

	para "그렇다면"
	line "전파와"

	para "무언가 관계가"
	line "있다는 뜻이겠지……"
	done

RuinsOfAlphResearchCenterScientist2Text_GotAllUnown:
	text "왜 그"
	line "오래된 문양이"

	para "이제야 벽에"
	line "나타난 걸까?"

	para "수수께끼는 더욱"
	line "깊어지는군……"
	done

RuinsOfAlphResearchCenterComputerText:
	text "알프 유적의 조사"

	para "……올해로"
	line "10년째"
	done

RuinsOfAlphResearchCenterComputerText_GotAllUnown:
	text "수수께끼의 포켓몬"
	line "이름……안농"

	para "전부해서"
	line "{d:NUM_UNOWN}종류 발견"
	done

RuinsOfAlphResearchCenterPrinterText_DoesntWork:
	text "아직 작동하지"
	line "않는 것 같다"
	done

RuinsOfAlphResearchCenterUnownPrinterText:
	text "안농의 모습을"
	line "프린트할 수 있습니다!"
	done

RuinsOfAlphResearchCenterProfSilktreePhotoText:
	text "알프의 유적"
	line "연구소 초대"

	para "소장 작명박사의"
	line "사진이다!"
	done

RuinsOfAlphResearchCenterAcademicBooksText:
	text "어려운 책들이"
	line "가득하군"

	para "『고대 유적』……"
	line "『고대 문명의"
	cont "수수께끼』……"
	done

RuinsOfAlphResearchCenter_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, RUINS_OF_ALPH_OUTSIDE, 6
	warp_event  3,  7, RUINS_OF_ALPH_OUTSIDE, 6

	def_coord_events

	def_bg_events
	bg_event  6,  5, BGEVENT_READ, RuinsOfAlphResearchCenterBookshelf
	bg_event  3,  4, BGEVENT_READ, RuinsOfAlphResearchCenterComputer
	bg_event  7,  1, BGEVENT_READ, RuinsOfAlphResearchCenterPrinter

	def_object_events
	object_event  4,  5, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphResearchCenterScientist1Script, -1
	object_event  5,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_WANDER, 2, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphResearchCenterScientist2Script, -1
	object_event  2,  5, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphResearchCenterScientist3Script, EVENT_RUINS_OF_ALPH_RESEARCH_CENTER_SCIENTIST
