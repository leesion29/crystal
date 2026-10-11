	object_const_def
	const VIOLETGYM_FALKNER
	const VIOLETGYM_YOUNGSTER1
	const VIOLETGYM_YOUNGSTER2
	const VIOLETGYM_GYM_GUIDE

VioletGym_MapScripts:
	def_scene_scripts

	def_callbacks

VioletGymFalknerScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_FALKNER
	iftrue .FightDone
	writetext FalknerIntroText
	waitbutton
	closetext
	winlosstext FalknerWinLossText, 0
	loadtrainer FALKNER, FALKNER1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_FALKNER
	opentext
	writetext ReceivedZephyrBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_ZEPHYRBADGE
	readvar VAR_BADGES
	scall VioletGymActivateRockets
.FightDone:
	checkevent EVENT_GOT_TM31_MUD_SLAP
	iftrue .SpeechAfterTM
	setevent EVENT_BEAT_BIRD_KEEPER_ROD
	setevent EVENT_BEAT_BIRD_KEEPER_ABE
	setmapscene ELMS_LAB, SCENE_ELMSLAB_NOOP
	specialphonecall SPECIALCALL_ASSISTANT
	writetext FalknerZephyrBadgeText
	promptbutton
	verbosegiveitem TM_MUD_SLAP
	iffalse .NoRoomForMudSlap
	setevent EVENT_GOT_TM31_MUD_SLAP
	writetext FalknerTMMudSlapText
	waitbutton
	closetext
	end

.SpeechAfterTM:
	writetext FalknerFightDoneText
	waitbutton
.NoRoomForMudSlap:
	closetext
	end

VioletGymActivateRockets:
	ifequal 7, .RadioTowerRockets
	ifequal 6, .GoldenrodRockets
	end

.GoldenrodRockets:
	jumpstd GoldenrodRocketsScript

.RadioTowerRockets:
	jumpstd RadioTowerRocketsScript

TrainerBirdKeeperRod:
	trainer BIRD_KEEPER, ROD, EVENT_BEAT_BIRD_KEEPER_ROD, BirdKeeperRodSeenText, BirdKeeperRodBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperRodAfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeperAbe:
	trainer BIRD_KEEPER, ABE, EVENT_BEAT_BIRD_KEEPER_ABE, BirdKeeperAbeSeenText, BirdKeeperAbeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperAbeAfterBattleText
	waitbutton
	closetext
	end

VioletGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_FALKNER
	iftrue .VioletGymGuideWinScript
	writetext VioletGymGuideText
	waitbutton
	closetext
	end

.VioletGymGuideWinScript:
	writetext VioletGymGuideWinText
	waitbutton
	closetext
	end

VioletGymStatue:
	checkflag ENGINE_ZEPHYRBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	gettrainername STRING_BUFFER_4, FALKNER, FALKNER1
	jumpstd GymStatue2Script

FalknerIntroText:
	text "내가 도라지시티"
	line "포켓몬 체육관"
	cont "관장인 비상이다!"

	para "세간에서는"
	line "비행타입의 포켓몬같은 것은"

	para "전기 충격에"
	line "한방이라고……"
	cont "그렇게 새포켓몬을"

	para "바보취급한다"
	line "나는 그것을"
	cont "용서 못 한다"

	para "넓은 하늘을"
	line "화려하게 나는"

	para "새포켓몬의 진정 강함을"
	line "알게 해주겠다!"
	done

FalknerWinLossText:
	text "……젠장"
	line "아버지가 소중하게"
	cont "여기던 포켓몬이……"

	para "알겠다"
	line "이것을 가지고 가거라!"

	para "포켓몬 리그"
	line "공인"
	cont "윙배지다!"
	done

ReceivedZephyrBadgeText:
	text "<PLAYER>는(은) 비상으로부터"
	line "윙배지를 받았다!"
	done

FalknerZephyrBadgeText:
	text "윙배지를 지니고 있으면"
	line "너의 포켓몬"
	cont "공격력이 올라간다!"

	para "그리고 플래시라고 하는"
	line "기술을 배운 포켓몬은"

	para "싸우고 있지 않을 때에도"
	line "플래시를 쓸 수 있다!"

	para "그리고 이것도"
	line "가지고 가라"
	done

FalknerTMMudSlapText:
	text "기술머신을 사용하면"
	line "단숨에 포켓몬에게"

	para "기술을 가르칠"
	line "수 있다!"

	para "그러나 1회용이기때문에"
	line "잘 생각해서"
	cont "써야할꺼야"

	para "덧붙여서 기술머신31의"
	line "안에는 진흙 뿌리기가 들어있다"

	para "상대의 명중력을"
	line "떨어뜨리면서"

	para "데미지를"
	line "준단다"

	para "다시 말해서"
	line "공격과 방어가"
	cont "동시에 되는 기술이다"
	done

FalknerFightDoneText:
	text "이 앞에는 여러마을에"
	line "포켓몬 체육관이"
	cont "있으니까"

	para "거기서 실력을"
	line "겨루어보면"
	cont "좋을꺼다"

	para "나는최강의"
	line "새 조련사가 되기위하여"

	para "포켓몬과 내 자신을"
	line "단련시키겠어!"
	done

BirdKeeperRodSeenText:
	text "표어는"
	line "강한 근성"

	para "이곳에 모여있는"
	line "인간은"

	para "새포켓몬으로 최강을 목표로 하여"
	line "밤낮 없이 특훈을 하고있다!"

	para "덤벼랏!"
	done

BirdKeeperRodBeatenText:
	text "쿠-웅!!"
	done

BirdKeeperRodAfterBattleText:
	text "비상님의"
	line "실력은 진짜다"

	para "나를 이긴"
	line "것 정도로"
	cont "들뜨지말아라!"
	done

BirdKeeperAbeSeenText:
	text "비상님에게"
	line "도전할 수 있을까"
	cont "시험해보겠다!"
	done

BirdKeeperAbeBeatenText:
	text "진짜냐"
	line "!?"
	done

BirdKeeperAbeAfterBattleText:
	text "신출내기 트레이너"
	line "녀석에게 진다는 것은"
	cont "말도 안 되지……"
	done

VioletGymGuideText:
	text "여어!"
	line "나는 트레이너가 아니지만"
	cont "어드바이스는 할 수 있지!"

	para "믿음이야!"
	line "믿는다면"

	para "챔피언도"
	line "꿈은 아니지!"

	para "그래 들어주겠니?"
	line "좋아!"

	para "풀타입은"
	line "비행타입에"

	para "대단히 상성이 나쁘단다"
	line "꼭 주의를 해야해!"
	done

VioletGymGuideWinText:
	text "나이스 파이트!"
	line "그 상태로"

	para "단번에 포켓몬"
	line "챔피언이 되어라!"
	done

VioletGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 15, VIOLET_CITY, 2
	warp_event  5, 15, VIOLET_CITY, 2

	def_coord_events

	def_bg_events
	bg_event  3, 13, BGEVENT_READ, VioletGymStatue
	bg_event  6, 13, BGEVENT_READ, VioletGymStatue

	def_object_events
	object_event  5,  1, SPRITE_FALKNER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VioletGymFalknerScript, -1
	object_event  7,  6, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_LEFT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperRod, -1
	object_event  2, 10, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperAbe, -1
	object_event  7, 13, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VioletGymGuideScript, -1
