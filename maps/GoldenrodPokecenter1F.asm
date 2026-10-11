	object_const_def
	const GOLDENRODPOKECENTER1F_NURSE
	const GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	const GOLDENRODPOKECENTER1F_GAMEBOY_KID
	const GOLDENRODPOKECENTER1F_LASS
	const GOLDENRODPOKECENTER1F_POKEFAN_F

GoldenrodPokecenter1F_MapScripts:
	def_scene_scripts
	scene_const SCENE_GOLDENRODPOKECENTER1F_GS_BALL

	def_callbacks

GoldenrodPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

GoldenrodPokecenter1F_GSBallSceneLeft:
	setval BATTLETOWERACTION_GSBALL
	special BattleTowerAction
	ifequal GS_BALL_AVAILABLE, .gsball
	end

.gsball
	checkevent EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
	iftrue .cancel
	playsound SFX_EXIT_BUILDING
	moveobject GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, 0, 7
	disappear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	appear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	playmusic MUSIC_SHOW_ME_AROUND
	applymovement GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtLeftDoorwayTileMovement
	turnobject PLAYER, UP
	opentext
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseAcceptGSBallText
	waitbutton
	verbosegiveitem GS_BALL
	setevent EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
	setevent EVENT_CAN_GIVE_GS_BALL_TO_KURT
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseDoComeAgainText
	waitbutton
	closetext
	applymovement GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromLeftDoorwayTileMovement
	special RestartMapMusic
	disappear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	playsound SFX_EXIT_BUILDING
.cancel
	end

GoldenrodPokecenter1F_GSBallSceneRight:
	setval BATTLETOWERACTION_GSBALL
	special BattleTowerAction
	ifequal GS_BALL_AVAILABLE, .gsball
	end

.gsball
	checkevent EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
	iftrue .cancel
	playsound SFX_EXIT_BUILDING
	moveobject GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, 0, 7
	disappear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	appear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	playmusic MUSIC_SHOW_ME_AROUND
	applymovement GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtRightDoorwayTileMovement
	turnobject PLAYER, UP
	opentext
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseAcceptGSBallText
	waitbutton
	verbosegiveitem GS_BALL
	setevent EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
	setevent EVENT_CAN_GIVE_GS_BALL_TO_KURT
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseDoComeAgainText
	waitbutton
	closetext
	applymovement GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromRightDoorwayTileMovement
	special RestartMapMusic
	disappear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	playsound SFX_EXIT_BUILDING
.cancel
	end

GoldenrodPokecenter1FGameboyKidScript:
	jumptextfaceplayer GoldenrodPokecenter1FGameboyKidText

GoldenrodPokecenter1FLassScript:
	jumptextfaceplayer GoldenrodPokecenter1FLassText

GoldenrodPokecenter1FPokefanF:
	faceplayer
	opentext
	writetext GoldenrodPokecenter1FPokefanFDoYouHaveEonMailText
	waitbutton
	writetext GoldenrodPokecenter1FAskGiveAwayAnEonMailText
	yesorno
	iffalse .NoEonMail
	takeitem EON_MAIL
	iffalse .NoEonMail
	writetext GoldenrodPokecenter1FPlayerGaveAwayTheEonMailText
	waitbutton
	writetext GoldenrodPokecenter1FPokefanFThisIsForYouText
	waitbutton
	verbosegiveitem REVIVE
	iffalse .NoRoom
	writetext GoldenrodPokecenter1FPokefanFDaughterWillBeDelightedText
	waitbutton
	closetext
	end

.NoEonMail:
	writetext GoldenrodPokecenter1FPokefanFTooBadText
	waitbutton
	closetext
	end

.NoRoom:
	giveitem EON_MAIL
	writetext GoldenrodPokecenter1FPokefanFAnotherTimeThenText
	waitbutton
	closetext
	end

GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtLeftDoorwayTileMovement:
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromLeftDoorwayTileMovement:
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtRightDoorwayTileMovement:
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromRightDoorwayTileMovement:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step_end

GoldenrodPokecomCenterWelcomeToTradeCornerText: ; unreferenced
	text "안녕하세요 어서오세요"
	line "포켓몬통신센터의"
	cont "교환코너입니다"

	para "멀리 떨어진 사람들과"
	line "포켓몬을"
	cont "교환할 수 있습니다"
	done

GoldenrodPokecomCenterWeMustHoldYourMonText: ; unreferenced
	text "교환을 하려면"
	line "당신의 포켓몬을"
	cont "맡아두어야 합니다"

	para "교환을"
	line "하시겠습니까?"
	done

GoldenrodPokecomCenterWhatMonDoYouWantText: ; unreferenced
	text "어떤 포켓몬을"
	line "대신 받고"
	cont "싶으신가요?"
	done

GoldenrodPokecomCenterWeWillTradeYourMonForMonText: ; unreferenced
	text "알겠습니다"
	line "교환할 포켓몬은"

	para "@"
	text_ram wStringBuffer3
	text " 대신"
	line "@"
	text_ram wStringBuffer4
	text "입니다"

	para "교환이 이루어지는 동안"
	line "당신의 포켓몬을"
	cont "맡아두겠습니다"

	para "포켓몬을 맡아둘"
	line "방을 준비하겠습니다"
	cont "잠시 기다려주세요"
	done

GoldenrodPokecomCenterWeWillTradeYourMonForNewText: ; unreferenced
	text "알겠습니다"
	line "교환할 포켓몬은"

	para "@"
	text_ram wStringBuffer3
	text " 대신"
	line "당신이 아직 본 적 없는"
	cont "포켓몬입니다"

	para "교환이 이루어지는 동안"
	line "당신의 포켓몬을"
	cont "맡아두겠습니다"

	para "포켓몬을 맡아둘"
	line "방을 준비하겠습니다"
	cont "잠시 기다려주세요"
	done

GoldenrodPokecomCenterYourMonHasBeenReceivedText: ; unreferenced
	text "교환할 포켓몬을 맡았습니다"

	para "교환 상대를 찾는 데는 시간이"
	line "걸립니다 나중에 다시 와주십시오"
	done

GoldenrodPokecomCenterYouHaveOnlyOneMonText: ; unreferenced
	text "어라? 지니고 계신 포켓몬이"
	line "한마리 뿐이군요"

	para "지닌 포켓몬의 수를 늘린 뒤에"
	line "다시 와주십시오"
	done

GoldenrodPokecomCenterWeHopeToSeeYouAgainText: ; unreferenced
	text "그럼 또 오세요"
	done

GoldenrodPokecomCenterCommunicationErrorText: ; unreferenced
	text "통신 에러가"
	line "발생했습니다……"
	done

GoldenrodPokecomCenterCantAcceptLastMonText: ; unreferenced
	text "그 포켓몬을 맡기면"
	line "어떤 포켓몬으로"
	cont "싸우시겠습니까?"
	done

GoldenrodPokecomCenterCantAcceptEggText: ; unreferenced
	text "죄송합니다"
	line "알은 맡길 수 없습니다"
	done

GoldenrodPokecomCenterCantAcceptAbnormalMonText: ; unreferenced
	text "죄송하지만 당신의 포켓몬에 이상이"
	line "있는 것 같아 맡을 수 없습니다"
	done

GoldenrodPokecomCenterAlreadyHoldingMonText: ; unreferenced
	text "어라? 이미"
	line "당신의 포켓몬을"
	cont "맡고 있지 않나요?"
	done

GoldenrodPokecomCenterCheckingTheRoomsText: ; unreferenced
	text "방을"
	line "확인하겠습니다"

	para "잠시 기다려주십시오"
	done

GoldenrodPokecomCenterTradePartnerHasBeenFoundText: ; unreferenced
	text "기다려주셔서"
	line "감사합니다"

	para "교환 상대를"
	line "찾았습니다"
	done

GoldenrodPokecomCenterItsYourNewPartnerText: ; unreferenced
	text "새로운"
	line "파트너입니다"

	para "사랑을 담아서"
	line "소중히 키워주세요"

	para "그럼"
	line "또 오세요"
	done

GoldenrodPokecomCenterYourPartyIsFullText: ; unreferenced
	text "이런 지닌 포켓몬이"
	line "이미 가득하군요"

	para "포켓몬을"
	line "더 지닐 수 있을 때"
	cont "다시 와주십시오"
	done

GoldenrodPokecomCenterNoTradePartnerFoundText: ; unreferenced
	text "안타깝지만 교환할 상대가 나타나지"
	line "않았습니다"

	para "포켓몬을 돌려받으시겠습니까?"
	done

GoldenrodPokecomCenterReturnedYourMonText: ; unreferenced
	text "당신의 포켓몬을"
	line "돌려드렸습니다"
	done

GoldenrodPokecomCenterYourMonIsLonelyText: ; unreferenced
	text "안타깝지만 교환할 상대가 나타나지"
	line "않았습니다"

	para "당신의 포켓몬을 오랫동안 맡고"
	line "있었기 때문에 많이 외로워하고"
	cont "있습니다"

	para "죄송하지만 포켓몬을"
	line "돌려드리겠습니다"
	done

GoldenrodPokecenter1FWeHopeToSeeYouAgainText_2: ; unreferenced
	text "그럼 또 오세요"
	done

GoldenrodPokecomCenterContinueToHoldYourMonText: ; unreferenced
	text "알겠습니다"
	line "계속 포켓몬을"
	cont "맡아두겠습니다"
	done

GoldenrodPokecomCenterRecentlyLeftYourMonText: ; unreferenced
	text "어라? 포켓몬을"
	line "맡기신 지 얼마"
	cont "되지 않았군요"

	para "나중에"
	line "다시 와주십시오"
	done

GoldenrodPokecomCenterSaveBeforeTradeCornerText: ; unreferenced
	text "통신을 시작하기 전에"
	line "레포트를 쓰겠습니다"
	done

GoldenrodPokecomCenterWhichMonToTradeText: ; unreferenced
	text "어느 포켓몬을"
	line "교환하시겠습니까?"
	done

GoldenrodPokecomCenterTradeCanceledText: ; unreferenced
	text "죄송하지만"
	line "교환을 중지하겠습니다"
	done

GoldenrodPokecomCenterEggTicketText: ; unreferenced
	text "어머! 알티켓을 가지고"
	line "계시는군요!"

	para "특별한 분들이 특별한 포켓몬을"
	line "받을 수 있는 티켓입니다!"
	done

GoldenrodPokecomCenterOddEggBriefingText: ; unreferenced
	text "간단하게 설명해드리겠습니다"

	para "교환코너에서의 교환은 서로 모르는"
	line "트레이너끼리 이루어지는 교환입니다"

	para "그래서 시간이 걸릴 수도 있습니다"

	para "하지만 당신을 위해 특별히 준비한"
	line "이상한 알이 있습니다"

	para "그 알은 곧바로 보내드리겠습니다"

	para "센터의 방 중 한 곳을"
	line "선택해주세요 선택하신 방에서"
	cont "이상한 알을 보내드립니다"
	done

GoldenrodPokecomCenterPleaseWaitAMomentText: ; unreferenced
	text "잠시 기다려주십시오"
	done

GoldenrodPokecomCenterHereIsYourOddEggText: ; unreferenced
	text "기다려주셔서"
	line "감사합니다"

	para "당신의 이상한 알이"
	line "도착했습니다"

	para "자 여기 있습니다!"

	para "사랑을 담아서"
	line "소중히 키워주세요"
	done

GoldenrodPokecomCenterNoEggTicketServiceText: ; unreferenced
	text "정말 죄송합니다"

	para "지금은 알티켓"
	line "교환 서비스를"
	cont "이용하실 수 없습니다"
	done

GoldenrodPokecomCenterNewsMachineText: ; unreferenced
	text "포켓몬 뉴스"
	line "기계다"
	done

GoldenrodPokecomCenterWhatToDoText: ; unreferenced
	text "어떻게"
	line "하시겠습니까?"
	done

GoldenrodPokecomCenterNewsMachineExplanationText: ; unreferenced
	text "포켓몬 뉴스는 포켓몬 트레이너의"
	line "레포트를 모아서 만드는 뉴스입니다"

	para "뉴스를 읽을 때 당신의 레포트가"
	line "전송될 수도 있습니다"

	para "레포트의 데이터에는 당신의 모험"
	line "기록과 모바일 프로필이 들어"
	cont "있습니다"

	para "전화번호는 전송되지 않습니다"

	para "당신과 다른 포켓몬 트레이너들이"
	line "보내준 레포트에 따라서 뉴스의"
	cont "내용도 바뀝니다"

	para "당신도 뉴스에 나올 수 있습니다!"
	done

GoldenrodPokecomCenterWouldYouLikeTheNewsText: ; unreferenced
	text "뉴스를"
	line "받으시겠습니까?"
	done

GoldenrodPokecomCenterReadingTheLatestNewsText: ; unreferenced
	text "최신 뉴스를 받는 중……"
	line "잠시 기다려주십시오"
	done

GoldenrodPokecomCenterNoOldNewsText: ; unreferenced
	text "지난 뉴스가"
	line "없습니다……"
	done

GoldenrodPokecomCenterCorruptedNewsDataText: ; unreferenced
	text "뉴스 데이터가"
	line "손상되었습니다"

	para "뉴스를 다시"
	line "받아주십시오"
	done

GoldenrodPokecomCenterMakingPreparationsText: ; unreferenced
	text "지금은"
	line "준비중입니다"

	para "나중에"
	line "다시 와주십시오"
	done

GoldenrodPokecomCenterSaveBeforeNewsMachineText: ; unreferenced
	text "포켓몬 뉴스 기계를 사용하기 전에"
	line "레포트를 쓰겠습니다"
	done

GoldenrodPokecomCenterPerson1Text: ; unreferenced
	text "와아 이 포켓몬 센터는 정말"
	line "크구나"

	para "새로 지은 곳이래 처음 보는"
	line "기계도 잔뜩 들여놓았더라"
	done

GoldenrodPokecomCenterPerson2Text: ; unreferenced
	text "교환코너에서 할 수 있는 재미있는"
	line "일을 생각해냈어!"

	para "구구에게 메일을 지니게 해서 다른"
	line "구구와 교환을 하는거야!"

	para "모두가 그렇게 하면 여러 사람들과"
	line "메일을 교환할 수 있잖아!"

	para "이름하여 구구 메일!"

	para "유행하게 되면 새로운 친구도 많이"
	line "사귈 수 있을꺼야!"
	done

GoldenrodPokecomCenterPerson3Text: ; unreferenced
	text "여기서는 전혀 모르는 사람과도"
	line "포켓몬을 교환할 수 있다고 하더라"

	para "하지만 아직 조정중이래"
	done

GoldenrodPokecomCenterPerson4Text: ; unreferenced
	text "모르는 여자아이가 자기 통통코를"
	line "보내줬어 너도 갖고 싶은"

	para "포켓몬과 교환을 해보면 어때?"
	done

GoldenrodPokecomCenterPerson5Text: ; unreferenced
	text "암컷 통통코를"
	line "받았는데"
	cont "이름이 스탠리야!"

	para "우리 아빠"
	line "이름이잖아!"
	done

GoldenrodPokecomCenterPerson6Text: ; unreferenced
	text "뉴스 기계가"
	line "뭘까?"

	para "라디오보다 더 넓은"
	line "지역의 뉴스를"
	cont "알려주는걸까?"
	done

GoldenrodPokecomCenterPerson7Text: ; unreferenced
	text "포켓몬통신센터는 무선 통신망으로"
	line "모든 포켓몬 센터와 연결된대"

	para "그렇다면 여러 사람들과 통신할 수"
	line "있겠구나"
	done

GoldenrodPokecomCenterPerson8Text: ; unreferenced
	text "여기 기계들은"
	line "아직 쓸 수 없대"

	para "그래도 남들보다"
	line "유행하는 곳에 먼저"

	para "와보니까"
	line "기분이 좋아"
	done

GoldenrodPokecomCenterPerson9Text: ; unreferenced
	text "얼마 전에 내 친구가"
	line "뉴스에 나왔어"

	para "정말"
	line "놀랐다니까!"
	done

GoldenrodPokecomCenterPerson10Text: ; unreferenced
	text "최신 뉴스를"
	line "확인하지 않으면"
	cont "불안하다니까!"
	done

GoldenrodPokecomCenterPerson11Text: ; unreferenced
	text "뉴스에 나와서"
	line "유명해지면"

	para "사람들에게 인기도"
	line "많아지겠지"

	para "어떻게 해야"
	line "뉴스에"
	cont "나올 수 있을까?"
	done

GoldenrodPokecenter1FGameboyKidText:
	text "포켓몬 센터의"
	line "2층에 있는 콜로세움에서"
	cont "통신대전을 할 수 있지"

	para "벽을 보면 자신의 성적을"
	line "알 수 있으니까 질 수 없어"
	done

GoldenrodPokecomCenterPerson12Text: ; unreferenced
	text "금빛시티의"
	line "포켓몬 센터에"

	para "아무도 본 적 없는"
	line "새로운 기계가"

	para "들어왔다는"
	line "소식을 듣고"
	cont "찾아왔단다"

	para "하지만 아직"
	line "준비를 하느라"

	para "다들"
	line "바쁜 것 같구나……"
	done

GoldenrodPokecomCenterPerson13Text: ; unreferenced
	text "여기서 새로운 것들을"
	line "구경하는 것만으로도"

	para "젊어지는"
	line "기분이 드는군!"
	done

GoldenrodPokecenter1FLassText:
	text "얼마나 레벨이 높든"
	line "타입의 상성이 있단다"

	para "절대 강한 포켓몬이란 것은"
	line "그렇게 없는 것 같아"
	done

GoldenrodPokeCenter1FLinkReceptionistPleaseAcceptGSBallText:
	text "<PLAYER> 맞으시죠?"

	para "축하합니다!"

	para "특별 선물로"
	line "당신 앞으로"
	cont "GS볼이 도착했습니다!"

	para "받아주십시오!"
	done

GoldenrodPokeCenter1FLinkReceptionistPleaseDoComeAgainText:
	text "그럼 또 오세요"
	done

GoldenrodPokecomCenterSignText: ; unreferenced
	text "포켓몬통신센터"
	line "1층……안내"

	para "왼쪽:"
	line "관리 사무실"

	para "가운데:"
	line "교환코너"

	para "오른쪽:"
	line "포켓몬 뉴스"
	done

GoldenrodPokecomCenterNewsMachineNotYetText: ; unreferenced
	text "포켓몬 뉴스"
	line "기계다!"

	para "아직"
	line "작동하지 않는 것 같다……"
	done

GoldenrodPokecenter1FPokefanFDoYouHaveEonMailText:
	text "어머 가방이 아주 무거워"
	line "보이는구나!"

	para "앗 혹시 브이브이 메일이라는 것을"
	line "가지고 있니?"

	para "내 딸이 갖고 싶어 하거든 하나만"
	line "나눠주지 않겠니?"
	done

GoldenrodPokecenter1FAskGiveAwayAnEonMailText:
	text "브이브이 메일을"
	line "건네주겠습니까?"
	done

GoldenrodPokecenter1FPokefanFThisIsForYouText:
	text "어머 정말 기쁘구나!"
	line "고맙다 얘야!"

	para "자 이건"
	line "답례로 줄께!"
	done

GoldenrodPokecenter1FPokefanFDaughterWillBeDelightedText:
	text "우리 딸이"
	line "아주 좋아하겠구나!"
	done

GoldenrodPokecenter1FPokefanFTooBadText:
	text "어라? 가지고 있지"
	line "않니? 아쉽구나"
	done

GoldenrodPokecenter1FPokefanFAnotherTimeThenText:
	text "아…… 그럼"
	line "다음 기회에 부탁할께"
	done

GoldenrodPokecenter1FPlayerGaveAwayTheEonMailText:
	text "<PLAYER>는(은)"
	line "브이브이 메일을 건네주었다"
	done

GoldenrodPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, GOLDENROD_CITY, 15
	warp_event  4,  7, GOLDENROD_CITY, 15
	warp_event  0,  6, POKECOM_CENTER_ADMIN_OFFICE_MOBILE, 1
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events
	coord_event  3,  7, SCENE_GOLDENRODPOKECENTER1F_GS_BALL, GoldenrodPokecenter1F_GSBallSceneLeft
	coord_event  4,  7, SCENE_GOLDENRODPOKECENTER1F_GS_BALL, GoldenrodPokecenter1F_GSBallSceneRight

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FNurseScript, -1
	object_event 16,  8, SPRITE_LINK_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event  6,  1, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FGameboyKidScript, -1
	object_event  1,  4, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FLassScript, -1
	object_event  7,  5, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FPokefanF, -1
