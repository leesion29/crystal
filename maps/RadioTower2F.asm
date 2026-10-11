DEF BLUE_CARD_POINT_CAP EQU 30

	object_const_def
	const RADIOTOWER2F_SUPER_NERD
	const RADIOTOWER2F_TEACHER
	const RADIOTOWER2F_ROCKET1
	const RADIOTOWER2F_ROCKET2
	const RADIOTOWER2F_ROCKET3
	const RADIOTOWER2F_ROCKET_GIRL
	const RADIOTOWER2F_BLACK_BELT1
	const RADIOTOWER2F_BLACK_BELT2
	const RADIOTOWER2F_JIGGLYPUFF
	const RADIOTOWER2F_BUENA
	const RADIOTOWER2F_RECEPTIONIST

RadioTower2F_MapScripts:
	def_scene_scripts

	def_callbacks

RadioTower2FNoopScene: ; unreferenced
	end

RadioTower2FSuperNerdScript:
	jumptextfaceplayer RadioTower2FSuperNerdText

RadioTower2FTeacherScript:
	faceplayer
	opentext
	checkflag ENGINE_ROCKETS_IN_RADIO_TOWER
	iftrue .Rockets
	writetext RadioTower2FTeacherText
	waitbutton
	closetext
	end

.Rockets:
	writetext RadioTower2FTeacherText_Rockets
	waitbutton
	closetext
	end

RadioTowerJigglypuff:
	opentext
	writetext RadioTowerJigglypuffText
	cry JIGGLYPUFF
	waitbutton
	closetext
	end

RadioTower2FBlackBelt1Script:
	jumptextfaceplayer RadioTower2FBlackBelt1Text

RadioTower2FBlackBelt2Script:
	jumptextfaceplayer RadioTower2FBlackBelt2Text

TrainerGruntM4:
	trainer GRUNTM, GRUNTM_4, EVENT_BEAT_ROCKET_GRUNTM_4, GruntM4SeenText, GruntM4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GruntM4AfterBattleText
	waitbutton
	closetext
	end

TrainerGruntM5:
	trainer GRUNTM, GRUNTM_5, EVENT_BEAT_ROCKET_GRUNTM_5, GruntM5SeenText, GruntM5BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GruntM5AfterBattleText
	waitbutton
	closetext
	end

TrainerGruntM6:
	trainer GRUNTM, GRUNTM_6, EVENT_BEAT_ROCKET_GRUNTM_6, GruntM6SeenText, GruntM6BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GruntM6AfterBattleText
	waitbutton
	closetext
	end

TrainerGruntF2:
	trainer GRUNTF, GRUNTF_2, EVENT_BEAT_ROCKET_GRUNTF_2, GruntF2SeenText, GruntF2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GruntF2AfterBattleText
	waitbutton
	closetext
	end

Buena:
	faceplayer
	opentext
	checkflag ENGINE_ROCKETS_IN_RADIO_TOWER
	iftrue .MidRocketTakeover
	checkevent EVENT_MET_BUENA
	iffalse .Introduction
	checkflag ENGINE_BUENAS_PASSWORD_2
	iftrue .PlayedAlready
	readvar VAR_HOUR
	ifless NITE_HOUR, .TooEarly
	checkflag ENGINE_BUENAS_PASSWORD
	iffalse .TuneIn
	checkitem BLUE_CARD
	iffalse .NoBlueCard
	readvar VAR_BLUECARDBALANCE
	ifequal BLUE_CARD_POINT_CAP, .BlueCardCapped0
	playmusic MUSIC_BUENAS_PASSWORD
	writetext RadioTower2FBuenaDoYouKnowPasswordText
	special AskRememberPassword
	iffalse .ForgotPassword
	writetext RadioTower2FBuenaJoinTheShowText
	waitbutton
	closetext
	turnobject RADIOTOWER2F_BUENA, RIGHT
	readvar VAR_FACING
	ifnotequal RIGHT, .DontNeedToMove
	applymovement PLAYER, RadioTower2FPlayerWalksToMicrophoneMovement
.DontNeedToMove:
	turnobject PLAYER, RIGHT
	opentext
	writetext RadioTower2FBuenaEveryoneSayPasswordText
	waitbutton
	closetext
	turnobject RADIOTOWER2F_BUENA, DOWN
	reanchormap
	special BuenasPassword
	closetext
	iffalse .WrongAnswer
	opentext
	writetext RadioTower2FBuenaCorrectAnswerText
	waitbutton
	closetext
	readvar VAR_BLUECARDBALANCE
	addval 1
	writevar VAR_BLUECARDBALANCE
	waitsfx
	playsound SFX_TRANSACTION
	setflag ENGINE_BUENAS_PASSWORD_2
	pause 20
	turnobject RADIOTOWER2F_BUENA, RIGHT
	opentext
	writetext RadioTower2FBuenaThanksForComingText
	waitbutton
	closetext
	special FadeOutMusic
	pause 20
	special RestartMapMusic
	readvar VAR_BLUECARDBALANCE
	ifequal BLUE_CARD_POINT_CAP, .BlueCardCapped1
	end

.Introduction:
	writetext RadioTower2FBuenaShowIntroductionText
	promptbutton
	setevent EVENT_MET_BUENA
	verbosegiveitem BLUE_CARD
.TuneIn:
	writetext RadioTower2FBuenaTuneInToMyShowText
	waitbutton
	closetext
	checkcellnum PHONE_BUENA
	iftrue .Registered0
	checkevent EVENT_BUENA_OFFERED_HER_PHONE_NUMBER
	iftrue .OfferedNumberBefore
.Registered0:
	turnobject RADIOTOWER2F_BUENA, RIGHT
	end

.ForgotPassword:
	writetext RadioTower2FBuenaComeBackAfterListeningText
	waitbutton
	closetext
	turnobject RADIOTOWER2F_BUENA, RIGHT
	special FadeOutMusic
	pause 20
	special RestartMapMusic
	end

.PlayedAlready:
	writetext RadioTower2FBuenaAlreadyPlayedText
	waitbutton
	closetext
	checkcellnum PHONE_BUENA
	iftrue .Registered1
	checkevent EVENT_BUENA_OFFERED_HER_PHONE_NUMBER
	iftrue .OfferedNumberBefore
.Registered1:
	turnobject RADIOTOWER2F_BUENA, RIGHT
	pause 10
	end

.WrongAnswer:
	setflag ENGINE_BUENAS_PASSWORD_2
	opentext
	writetext RadioTower2FBuenaDidYouForgetText
	waitbutton
	closetext
	turnobject RADIOTOWER2F_BUENA, RIGHT
	pause 20
	opentext
	writetext RadioTower2FBuenaThanksForComingText
	waitbutton
	closetext
	turnobject RADIOTOWER2F_BUENA, RIGHT
	special FadeOutMusic
	pause 20
	special RestartMapMusic
	end

.MidRocketTakeover:
	writetext RadioTower2FBuenaPasswordIsHelpText
	waitbutton
	closetext
	end

.NoBlueCard:
	writetext RadioTower2FBuenaNoBlueCardText
	waitbutton
	closetext
	checkcellnum PHONE_BUENA
	iftrue .Registered2
	checkevent EVENT_BUENA_OFFERED_HER_PHONE_NUMBER_NO_BLUE_CARD
	iftrue .OfferedNumberBefore
.Registered2:
	turnobject RADIOTOWER2F_BUENA, RIGHT
	end

.BlueCardCapped0:
	writetext RadioTower2FBuenaCardIsFullText
	waitbutton
	closetext
	checkcellnum PHONE_BUENA
	iftrue .Registered3
	checkevent EVENT_BUENA_OFFERED_HER_PHONE_NUMBER_NO_BLUE_CARD
	iftrue .OfferedNumberBefore
.Registered3:
	turnobject RADIOTOWER2F_BUENA, RIGHT
	end

.TooEarly:
	writetext RadioTower2FBuenaTuneInAfterSixText
	waitbutton
	closetext
	checkcellnum PHONE_BUENA
	iftrue .Registered4
	checkevent EVENT_BUENA_OFFERED_HER_PHONE_NUMBER
	iftrue .OfferedNumberBefore
.Registered4:
	end

.BlueCardCapped1:
	checkcellnum PHONE_BUENA
	iftrue .HasNumber
	pause 20
	turnobject RADIOTOWER2F_BUENA, DOWN
	pause 15
	turnobject PLAYER, UP
	pause 15
	checkevent EVENT_BUENA_OFFERED_HER_PHONE_NUMBER_NO_BLUE_CARD
	iftrue .OfferedNumberBefore
	showemote EMOTE_SHOCK, RADIOTOWER2F_BUENA, 15
	setevent EVENT_BUENA_OFFERED_HER_PHONE_NUMBER_NO_BLUE_CARD
	setevent EVENT_BUENA_OFFERED_HER_PHONE_NUMBER
	opentext
	writetext RadioTower2FBuenaOfferPhoneNumberText
	sjump .AskForNumber

.OfferedNumberBefore:
	opentext
	writetext RadioTower2FBuenaOfferNumberAgainText
.AskForNumber:
	askforphonenumber PHONE_BUENA
	ifequal PHONE_CONTACTS_FULL, .PhoneFull
	ifequal PHONE_CONTACT_REFUSED, .NumberDeclined
	writetext RadioTower2FRegisteredBuenasNumberText
	playsound SFX_REGISTER_PHONE_NUMBER
	waitsfx
	promptbutton
	writetext RadioTower2FBuenaCallMeText
	waitbutton
	closetext
	turnobject RADIOTOWER2F_BUENA, RIGHT
	addcellnum PHONE_BUENA
	end

.NumberDeclined:
	writetext RadioTower2FBuenaSadRejectedText
	waitbutton
	closetext
	turnobject RADIOTOWER2F_BUENA, RIGHT
	end

.PhoneFull:
	writetext RadioTower2FBuenaYourPhoneIsFullText
	waitbutton
	closetext
	turnobject RADIOTOWER2F_BUENA, RIGHT
.HasNumber:
	end

RadioTowerBuenaPrizeReceptionist:
	faceplayer
	opentext
	checkitem BLUE_CARD
	iffalse .NoCard
	writetext RadioTower2FBuenaReceptionistPointsForPrizesText
	promptbutton
	special BuenaPrize
	closetext
	end

.NoCard:
	writetext RadioTower2FBuenaReceptionistNoCardText
	promptbutton
	closetext
	end

RadioTower2FSalesSign:
	jumptext RadioTower2FSalesSignText

RadioTower2FOaksPKMNTalkSign:
	jumptext RadioTower2FOaksPKMNTalkSignText

RadioTower2FPokemonRadioSign:
	jumptext RadioTower2FPokemonRadioSignText

RadioTower2FBookshelf:
	jumpstd MagazineBookshelfScript

RadioTower2FPlayerWalksToMicrophoneMovement:
	slow_step DOWN
	slow_step RIGHT
	step_end

RadioTower2FSuperNerdText:
	text "어디서든 라디오 청취가 가능하니까"
	line "어디서든 라디오를 들어주세요!"
	done

RadioTower2FTeacherText:
	text "라디오에서 흘러나오는 자장가라도"
	line "포켓몬은 잠들어버리거든"
	done

RadioTower2FTeacherText_Rockets:
	text "라디오 방송국을 점령해서"
	line "어떡게 할 작정일까……?"
	done

RadioTowerJigglypuffText:
	text "푸린『푸우…… 푸린……"
	done

RadioTower2FBlackBelt1Text:
	text "여기부터 윗층은 관계자 외"
	line "출입금지란다……"

	para "예전에는 그런 일이 없었는데"
	line "지금 국장은 좀 이상해"
	done

RadioTower2FBlackBelt2Text:
	text "어디든 견학 OK 란다"
	line "예전처럼 상냥한"
	cont "국장으로 되돌아왔단다"
	done

GruntM4SeenText:
	text "3년전 로켓단은"
	line "해산에 몰리게 되었다……"

	para "그러나 우리들은"
	line "이곳에서 부활하는 것이다!"
	done

GruntM4BeatenText:
	text "크윽-"
	line "정떨어지는 놈"
	done

GruntM4AfterBattleText:
	text "너같은 녀석에게"
	line "부활의 방해를 받을 순 없지!"
	done

GruntM5SeenText:
	text "우리들은"
	line "포켓몬의 마피아 로켓단이다!"
	cont "나쁜 짓을 무척 좋아하지"

	para "오호-  겁먹었냐?"
	done

GruntM5BeatenText:
	text "정의의 편에 설 작정이냐?"
	done

GruntM5AfterBattleText:
	text "특별히 우리들은"
	line "나쁜 짓을 하려는건 아니구"
	cont "단지 좋아하는 것을 하려는거야"
	done

GruntM6SeenText:
	text "이봐 이봐!"
	line "우리들을 방해해서는 않되지!"
	done

GruntM6BeatenText:
	text "우우…… 졌다"
	done

GruntM6AfterBattleText:
	text "간부들은 이곳을 점령하려고"
	line "엄청난 일을 벌일 것 같아"
	cont "그건 그렇고 이제 뭘 할까나?"
	done

GruntF2SeenText:
	text "호호호!"
	line "너무나 간단하게 점령되어서"
	cont "싫증이 났지뭐야!"

	para "니가 날 즐겁게 해주겠어?"
	done

GruntF2BeatenText:
	text "네 녀석은 어떤 놈이냐!?"
	done

GruntF2AfterBattleText:
	text "나보다 강하다니……"

	para "용서할 수 없어!"
	done

RadioTower2FBuenaShowIntroductionText:
	text "부에나『안녕! 나는 부에나라고"
	line "해!"

	para "암호라는 라디오 방송을 알고"
	line "있니?"

	para "방송에서 나온 암호를 나에게"
	line "알려주면 포인트를 받을 수 있어"

	para "그 포인트를 모아서 저기 있는"
	line "친절한 아가씨에게 가져가면 멋진"
	cont "경품과 바꿔준단다!"

	para "자 여기!"

	para "너만의 포인트 카드야!"
	done

RadioTower2FBuenaTuneInToMyShowText:
	text "부에나『내 암호 방송"
	line "꼭 들어줘!"
	done

RadioTower2FBuenaDoYouKnowPasswordText:
	text "부에나『안녕!"
	line "내 라디오 방송"
	cont "들었니?"

	para "오늘의 암호를"
	line "기억하고 있어?"
	done

RadioTower2FBuenaJoinTheShowText:
	text "부에나『와아!"
	line "고마워!"

	para "이름이"
	line "뭐라고 했지?"

	para "……<PLAY_G> 맞구나!"

	para "자 <PLAY_G>!"
	line "방송에 참가해줘"
	done

RadioTower2FBuenaEveryoneSayPasswordText:
	text "부에나『여러분 준비됐나요?"

	para "오늘의 암호를 크게 외쳐주세요"
	line "<PLAY_G>를(을) 위해서!"
	done

RadioTower2FBuenaComeBackAfterListeningText:
	text "부에나『내 방송을 들어본 뒤에"
	line "다시 찾아와줘 그럼 또 보자!"
	done

RadioTower2FBuenaAlreadyPlayedText:
	text "부에나『미안해……"

	para "하루에 한 번만"
	line "참가할 수 있단다"

	para "내일 다시"
	line "도전해줘!"
	done

RadioTower2FBuenaCorrectAnswerText:
	text "부에나『야호!"
	line "정답이야!"

	para "방송을 들어줬구나!"
	line "정말 기뻐!"

	para "1포인트 획득!"
	line "축하해!"
	done

RadioTower2FBuenaDidYouForgetText:
	text "부에나『아아……"
	line "그게 아닌데……"

	para "암호를"
	line "잊어버렸니?"
	done

RadioTower2FBuenaThanksForComingText:
	text "부에나『네! 오늘의 참가자는"
	line "<PLAY_G>였습니다!"
	cont "참가해줘서 고마워!"

	para "방송을 듣고 있는 여러분도 꼭"
	line "찾아와주세요! 기다릴께요!"
	done

RadioTower2FBuenaPasswordIsHelpText:
	text "부에나『응?"
	line "오늘의 암호?"

	para "물론 도와주세요!"
	done

RadioTower2FBuenaCardIsFullText:
	text "부에나『블루카드가"
	line "가득 찼구나"

	para "멋진 경품과"
	line "교환해봐!"
	done

RadioTower2FBuenaTuneInAfterSixText:
	text "부에나『암호 방송은 매일 밤"
	line "6시부터 자정까지야!"

	para "방송을 듣고 나서 나를 만나러"
	line "와줘!"
	done

RadioTower2FBuenaNoBlueCardText:
	text "부에나『어라?"
	line "블루카드를"
	cont "두고 왔니?"

	para "카드가 없으면"
	line "포인트를"
	cont "줄 수 없단다"
	done

RadioTower2FBuenaOfferPhoneNumberText:
	text "부에나『와아! 오늘 블루카드가"
	line "{d:BLUE_CARD_POINT_CAP}포인트가 되었구나! 정말"
	cont "대단해!"

	para "음…… {d:BLUE_CARD_POINT_CAP}포인트를 모은 경품은"
	line "없지만……"

	para "이렇게 자주 와줬으니"
	line "<PLAY_G>에게 특별한 선물을"
	cont "해줄께!"

	para "내 전화번호를 알려줄까?"
	done

RadioTower2FBuenaOfferNumberAgainText:
	text "부에나『<PLAY_G> 내"
	line "전화번호를 등록하고 싶니?"
	done

RadioTower2FRegisteredBuenasNumberText:
	text "<PLAYER>는(은) 부에나의"
	line "전화번호를 등록했다"
	done

RadioTower2FBuenaCallMeText:
	text "부에나『너의 전화를 기다리고"
	line "있을께!"
	done

RadioTower2FBuenaSadRejectedText:
	text "부에나『아아……"
	line "특별한 선물인데……"
	done

RadioTower2FBuenaYourPhoneIsFullText:
	text "부에나『<PLAY_G> 전화번호"
	line "수첩에 내 번호를 넣을 자리가"
	cont "없구나……"
	done

RadioTower2FBuenaReceptionistPointsForPrizesText:
	text "모아둔 포인트로 마음에 드는 멋진"
	line "경품을 교환할 수 있단다!"
	done

RadioTower2FBuenaReceptionistNoCardText:
	text "블루카드가 없으면"
	line "포인트로 경품을"
	cont "교환할 수 없단다"

	para "블루카드를"
	line "잊지 말아라!"
	done

RadioTower2FSalesSignText:
	text "2층 …… 영업부"
	done

RadioTower2FOaksPKMNTalkSignText:
	text "오박사의 포켓몬 강좌"
	line "대 호평 방송중!"
	done

RadioTower2FPokemonRadioSignText:
	text "24시간 언제든지"
	line "어디에 있던지 포켓몬 라디오"
	done

RadioTower2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  0, RADIO_TOWER_3F, 1
	warp_event 15,  0, RADIO_TOWER_1F, 3

	def_coord_events

	def_bg_events
	bg_event  3,  0, BGEVENT_READ, RadioTower2FSalesSign
	bg_event  5,  0, BGEVENT_READ, RadioTower2FOaksPKMNTalkSign
	bg_event  9,  1, BGEVENT_READ, RadioTower2FBookshelf
	bg_event 10,  1, BGEVENT_READ, RadioTower2FBookshelf
	bg_event 11,  1, BGEVENT_READ, RadioTower2FBookshelf
	bg_event 13,  0, BGEVENT_READ, RadioTower2FPokemonRadioSign

	def_object_events
	object_event  6,  6, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, RadioTower2FSuperNerdScript, EVENT_GOLDENROD_CITY_CIVILIANS
	object_event 17,  2, SPRITE_TEACHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, RadioTower2FTeacherScript, -1
	object_event  1,  4, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 3, TrainerGruntM4, EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	object_event  8,  4, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 3, TrainerGruntM5, EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	object_event  4,  1, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 2, TrainerGruntM6, EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	object_event 10,  5, SPRITE_ROCKET_GIRL, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerGruntF2, EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	object_event  0,  1, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, RadioTower2FBlackBelt1Script, EVENT_RADIO_TOWER_BLACKBELT_BLOCKS_STAIRS
	object_event  1,  1, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, RadioTower2FBlackBelt2Script, EVENT_RADIO_TOWER_CIVILIANS_AFTER
	object_event 12,  1, SPRITE_JIGGLYPUFF, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, RadioTowerJigglypuff, -1
	object_event 14,  5, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Buena, -1
	object_event 12,  7, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, RadioTowerBuenaPrizeReceptionist, EVENT_GOLDENROD_CITY_CIVILIANS
