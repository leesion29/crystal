	object_const_def
	const ROUTE30_YOUNGSTER1
	const ROUTE30_YOUNGSTER2
	const ROUTE30_YOUNGSTER3
	const ROUTE30_BUG_CATCHER
	const ROUTE30_YOUNGSTER4
	const ROUTE30_MONSTER1
	const ROUTE30_MONSTER2
	const ROUTE30_FRUIT_TREE1
	const ROUTE30_FRUIT_TREE2
	const ROUTE30_COOLTRAINER_F
	const ROUTE30_POKE_BALL

Route30_MapScripts:
	def_scene_scripts

	def_callbacks

YoungsterJoey_ImportantBattleScript:
	waitsfx
	playmusic MUSIC_JOHTO_TRAINER_BATTLE
	opentext
	writetext Text_UseTackle
	pause 30
	closetext
	playsound SFX_TACKLE
	applymovement ROUTE30_MONSTER2, Route30_JoeysRattataAttacksMovement
	opentext
	faceplayer
	writetext Text_ThisIsABigBattle
	waitbutton
	turnobject ROUTE30_YOUNGSTER1, UP
	closetext
	playsound SFX_TACKLE
	applymovement ROUTE30_MONSTER1, Route30_MikeysRattataAttacksMovement
	special RestartMapMusic
	end

TrainerYoungsterJoey:
	trainer YOUNGSTER, JOEY1, EVENT_BEAT_YOUNGSTER_JOEY, YoungsterJoey1SeenText, YoungsterJoey1BeatenText, 0, .Script

.Script:
	loadvar VAR_CALLERID, PHONE_YOUNGSTER_JOEY
	endifjustbattled
	opentext
	checkflag ENGINE_JOEY_READY_FOR_REMATCH
	iftrue .Rematch
	checkcellnum PHONE_YOUNGSTER_JOEY
	iftrue .NumberAccepted
	checkevent EVENT_JOEY_ASKED_FOR_PHONE_NUMBER
	iftrue .AskAgain
	writetext YoungsterJoey1AfterText
	promptbutton
	setevent EVENT_JOEY_ASKED_FOR_PHONE_NUMBER
	scall .AskNumber1
	sjump .RequestNumber

.AskAgain:
	scall .AskNumber2
.RequestNumber:
	askforphonenumber PHONE_YOUNGSTER_JOEY
	ifequal PHONE_CONTACTS_FULL, .PhoneFull
	ifequal PHONE_CONTACT_REFUSED, .NumberDeclined
	gettrainername STRING_BUFFER_3, YOUNGSTER, JOEY1
	scall .RegisteredNumber
	sjump .NumberAccepted

.Rematch:
	scall .RematchStd
	winlosstext YoungsterJoey1BeatenText, 0
	readmem wJoeyFightCount
	ifequal 4, .Fight4
	ifequal 3, .Fight3
	ifequal 2, .Fight2
	ifequal 1, .Fight1
	ifequal 0, .LoadFight0
.Fight4:
	checkevent EVENT_BEAT_ELITE_FOUR
	iftrue .LoadFight4
.Fight3:
	checkevent EVENT_CLEARED_RADIO_TOWER
	iftrue .LoadFight3
.Fight2:
	checkflag ENGINE_FLYPOINT_OLIVINE
	iftrue .LoadFight2
.Fight1:
	checkflag ENGINE_FLYPOINT_GOLDENROD
	iftrue .LoadFight1
.LoadFight0:
	loadtrainer YOUNGSTER, JOEY1
	startbattle
	reloadmapafterbattle
	loadmem wJoeyFightCount, 1
	clearflag ENGINE_JOEY_READY_FOR_REMATCH
	end

.LoadFight1:
	loadtrainer YOUNGSTER, JOEY2
	startbattle
	reloadmapafterbattle
	loadmem wJoeyFightCount, 2
	clearflag ENGINE_JOEY_READY_FOR_REMATCH
	end

.LoadFight2:
	loadtrainer YOUNGSTER, JOEY3
	startbattle
	reloadmapafterbattle
	loadmem wJoeyFightCount, 3
	clearflag ENGINE_JOEY_READY_FOR_REMATCH
	end

.LoadFight3:
	loadtrainer YOUNGSTER, JOEY4
	startbattle
	reloadmapafterbattle
	loadmem wJoeyFightCount, 4
	clearflag ENGINE_JOEY_READY_FOR_REMATCH
	end

.LoadFight4:
	loadtrainer YOUNGSTER, JOEY5
	startbattle
	reloadmapafterbattle
	clearflag ENGINE_JOEY_READY_FOR_REMATCH
	checkevent EVENT_JOEY_HP_UP
	iftrue .GiveHPUp
	checkevent EVENT_GOT_HP_UP_FROM_JOEY
	iftrue .done
	scall .RematchGift
	verbosegiveitem HP_UP
	iffalse .PackFull
	setevent EVENT_GOT_HP_UP_FROM_JOEY
	sjump .NumberAccepted

.done
	end

.GiveHPUp:
	opentext
	writetext YoungsterJoeyText_GiveHPUpAfterBattle
	waitbutton
	verbosegiveitem HP_UP
	iffalse .PackFull
	clearevent EVENT_JOEY_HP_UP
	setevent EVENT_GOT_HP_UP_FROM_JOEY
	sjump .NumberAccepted

.AskNumber1:
	jumpstd AskNumber1MScript
	end

.AskNumber2:
	jumpstd AskNumber2MScript
	end

.RegisteredNumber:
	jumpstd RegisteredNumberMScript
	end

.NumberAccepted:
	jumpstd NumberAcceptedMScript
	end

.NumberDeclined:
	jumpstd NumberDeclinedMScript
	end

.PhoneFull:
	jumpstd PhoneFullMScript
	end

.RematchStd:
	jumpstd RematchMScript
	end

.PackFull:
	setevent EVENT_JOEY_HP_UP
	jumpstd PackFullMScript
	end

.RematchGift:
	jumpstd RematchGiftMScript
	end

TrainerYoungsterMikey:
	trainer YOUNGSTER, MIKEY, EVENT_BEAT_YOUNGSTER_MIKEY, YoungsterMikeySeenText, YoungsterMikeyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterMikeyAfterText
	waitbutton
	closetext
	end

TrainerBugCatcherDon:
	trainer BUG_CATCHER, DON, EVENT_BEAT_BUG_CATCHER_DON, BugCatcherDonSeenText, BugCatcherDonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherDonAfterText
	waitbutton
	closetext
	end

Route30YoungsterScript:
	faceplayer
	opentext
	checkevent EVENT_GAVE_MYSTERY_EGG_TO_ELM
	iftrue .CompletedEggQuest
	writetext Route30YoungsterText_DirectionsToMrPokemonsHouse
	waitbutton
	closetext
	end

.CompletedEggQuest:
	writetext Route30YoungsterText_EveryoneIsBattling
	waitbutton
	closetext
	end

Route30CooltrainerFScript:
	jumptextfaceplayer Route30CooltrainerFText

Route30Sign:
	jumptext Route30SignText

MrPokemonsHouseDirectionsSign:
	jumptext MrPokemonsHouseDirectionsSignText

MrPokemonsHouseSign:
	jumptext MrPokemonsHouseSignText

Route30TrainerTips:
	jumptext Route30TrainerTipsText

Route30Antidote:
	itemball ANTIDOTE

Route30FruitTree1:
	fruittree FRUITTREE_ROUTE_30_1

Route30FruitTree2:
	fruittree FRUITTREE_ROUTE_30_2

Route30HiddenPotion:
	hiddenitem POTION, EVENT_ROUTE_30_HIDDEN_POTION

Route30_JoeysRattataAttacksMovement:
	fix_facing
	big_step UP
	big_step DOWN
	step_end

Route30_MikeysRattataAttacksMovement:
	fix_facing
	big_step DOWN
	big_step UP
	step_end

Text_UseTackle:
	text "가거라 꼬렛!"

	para "몸통박치기!!"
	done

Text_ThisIsABigBattle:
	text "뭐야?"
	line "중요한 승부를 하고있어!"
	cont "저리 가란말야!"
	done

YoungsterJoey1SeenText:
	text "아까 진 것이 분해서"
	line "포켓몬을"
	cont "찾고있었어"

	para "헌데 너"
	line "약해보이는구나……"
	cont "좋아! 승부를 겨루어보자!"
	done

YoungsterJoey1BeatenText:
	text "아아"
	line "더 이상 싸울 포켓몬이 없어"
	done

YoungsterJoey1AfterText:
	text "역시 포켓몬이"
	line "많지 않으면"

	para "승부를 할 때"
	line "힘든걸까?"

	para "아니야! 무슨 일이 있어도"
	line "이 한 마리로"
	cont "계속할거야!"
	done

YoungsterMikeySeenText:
	text "너 포켓몬"
	line "트레이너지?"

	para "그렇다면 포켓몬"
	line "승부를 하자!"
	done

YoungsterMikeyBeatenText:
	text "이상하네?"
	line "아까 이겼는데"
	done

YoungsterMikeyAfterText:
	text "포켓몬의 길은"
	line "멀고도"
	cont "험하구낭……"

	para "좋아! 여러 트레이너랑"
	line "승부를 해서 단련하고"
	cont "돌아와야지!"
	done

BugCatcherDonSeenText:
	text "벌레포켓몬"
	line "대신"
	cont "트레이너 발견!"
	done

BugCatcherDonBeatenText:
	text "에구구"
	line "강하구나-!"
	done

BugCatcherDonAfterText:
	text "포켓몬을 잡으니까"
	line "몬스터볼을 다"
	cont "써버려서……"

	para "더 많이"
	line "사두었으면 좋았는데"
	done

Route30YoungsterText_DirectionsToMrPokemonsHouse:
	text "포켓몬 할아버지의"
	line "집?"
	cont "조금 더 가야해"
	done

Route30YoungsterText_EveryoneIsBattling:
	text "모두 포켓몬 승부를"
	line "즐기고 있단다!"
	cont "괜찮다면 너도 어떠니?"
	done

Route30CooltrainerFText:
	text "나는 트레이너가 아니야"

	para "하지만 트레이너끼리"
	line "시선이 마주치는 것은"
	cont "승부하자는 사인이지"
	done

Route30SignText:
	text "이곳은 30번 도로"

	para "도라지시티 ……"
	line "무궁시티"
	done

MrPokemonsHouseDirectionsSignText:
	text "여기서 곧장"
	line "포켓몬 할아버지의 집"
	done

MrPokemonsHouseSignText:
	text "포켓몬 할아버지의 집"
	done

Route30TrainerTipsText:
	text "득이 되는 게시판!"

	para "다른 사람의 포켓몬을"
	line "잡으면 도둑놈!"

	para "몬스터볼은 야생의"
	line "포켓몬에게만"
	cont "던집시다!"
	done

YoungsterJoeyText_GiveHPUpAfterBattle:
	text "또 졌네……"
	line "너 정말 강하구나!"

	para "아 맞다!"
	line "이걸 너에게 주려던 걸"
	cont "깜빡할 뻔했어"

	para "이걸로 더욱"
	line "강해져야해 알았지?"

	para "나도 더"
	line "강해질거야!"
	done

Route30_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7, 39, ROUTE_30_BERRY_HOUSE, 1
	warp_event 17,  5, MR_POKEMONS_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event  9, 43, BGEVENT_READ, Route30Sign
	bg_event 13, 29, BGEVENT_READ, MrPokemonsHouseDirectionsSign
	bg_event 15,  5, BGEVENT_READ, MrPokemonsHouseSign
	bg_event  3, 21, BGEVENT_READ, Route30TrainerTips
	bg_event 14,  9, BGEVENT_ITEM, Route30HiddenPotion

	def_object_events
	object_event  5, 26, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, YoungsterJoey_ImportantBattleScript, EVENT_ROUTE_30_BATTLE
	object_event  2, 28, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerYoungsterJoey, EVENT_ROUTE_30_YOUNGSTER_JOEY
	object_event  5, 23, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 1, TrainerYoungsterMikey, -1
	object_event  1,  7, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBugCatcherDon, -1
	object_event  7, 30, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route30YoungsterScript, -1
	object_event  5, 24, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_ROUTE_30_BATTLE
	object_event  5, 25, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_ROUTE_30_BATTLE
	object_event  5, 39, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route30FruitTree1, -1
	object_event 11,  5, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route30FruitTree2, -1
	object_event  2, 13, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route30CooltrainerFScript, -1
	object_event  8, 35, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route30Antidote, EVENT_ROUTE_30_ANTIDOTE
