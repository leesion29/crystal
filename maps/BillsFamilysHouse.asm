	object_const_def
	const BILLSFAMILYSHOUSE_BILL
	const BILLSFAMILYSHOUSE_POKEFAN_F
	const BILLSFAMILYSHOUSE_TWIN

BillsFamilysHouse_MapScripts:
	def_scene_scripts

	def_callbacks

BillScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_EEVEE
	iftrue .GotEevee
	writetext BillTakeThisEeveeText
	yesorno
	iffalse .Refused
	writetext BillImCountingOnYouText
	promptbutton
	waitsfx
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	writetext ReceivedEeveeText
	playsound SFX_CAUGHT_MON
	waitsfx
	givepoke EEVEE, 20
	setevent EVENT_GOT_EEVEE
	writetext BillEeveeMayEvolveText
	waitbutton
	closetext
	end

.NoRoom:
	writetext BillPartyFullText
	waitbutton
	closetext
	end

.Refused:
	writetext BillNoEeveeText
	waitbutton
	closetext
	end

.GotEevee:
	writetext BillPopWontWorkText
	waitbutton
	closetext
	end

BillsMomScript:
	faceplayer
	opentext
	checkevent EVENT_MET_BILL
	iffalse .HaventMetBill
	writetext BillsMomText_BeforeEcruteak
	waitbutton
	closetext
	end

.HaventMetBill:
	writetext BillsMomText_AfterEcruteak
	waitbutton
	closetext
	end

BillsYoungerSisterScript:
	faceplayer
	opentext
	checkcellnum PHONE_BILL
	iftrue .GotBillsNumber
	writetext BillsYoungerSisterUsefulNumberText
	askforphonenumber PHONE_BILL
	ifequal PHONE_CONTACTS_FULL, .NoRoom
	ifequal PHONE_CONTACT_REFUSED, .Refused
	waitsfx
	addcellnum PHONE_BILL
	writetext RecordedBillsNumberText
	playsound SFX_REGISTER_PHONE_NUMBER
	waitsfx
	promptbutton
.GotBillsNumber:
	writetext BillsYoungerSisterStorageSystemText
	waitbutton
	closetext
	end

.Refused:
	writetext BillsYoungerSisterRefusedNumberText
	waitbutton
	closetext
	end

.NoRoom:
	writetext BillsYoungerSisterPhoneFullText
	promptbutton
	sjump .Refused

BillsHouseBookshelf1:
	jumpstd PictureBookshelfScript

BillsHouseBookshelf2:
	jumpstd MagazineBookshelfScript

BillsHouseRadio:
	jumpstd Radio2Script

BillTakeThisEeveeText:
	text "이수재『오오 <PLAYER>! 그래"
	line "부탁이 있어 이브이를 맡아줘"

	para "이녀석 타임캡슐을 조정했더니"
	line "갑자기 보내져왔단다"

	para "누군가 돌봐줘야 할텐데 나는 밖에"
	line "나가는 것을 좋아하지 않아서 말야"

	para "이녀석이랑 같이 잘 놀아주겠니"
	line "<PLAYER>?"
	done

BillImCountingOnYouText:
	text "이수재『역시 들어줄 줄 알았어!"

	para "멋지구나! 정말 믿음직해!"

	para "그럼 부탁할께 많이 이뻐해줘!"
	done

ReceivedEeveeText:
	text "<PLAYER>는(은)"
	line "이브이를 얻었다!"
	done

BillEeveeMayEvolveText:
	text "이수재『이브이에게는 새로운"
	line "진화의 가능성이 있다고"
	cont "공박사님이 발표했단다"
	done

BillPartyFullText:
	text "으… 이런"
	line "그 이상 포켓몬을 지닐 수 없잖아"
	done

BillNoEeveeText:
	text "그러냐……"
	done

BillPopWontWorkText:
	text "이수재『우리 아버지는 일도"
	line "안하시고 하루종일 놀기만 하신단다"

	para "정말 골치가 아파지는군……"
	done

BillsMomText_BeforeEcruteak:
	text "너 포켓몬 모으고 있니 내 아들"
	line "이수재는 포켓몬에 박식하단다"

	para "방금 인주시티의 포켓몬 센터에서"
	line "와달라고 해서 거기로 갔단다"

	para "우리 남편은 부르지도 않았는데"
	line "게임코너로 가버렸지……"
	done

BillsMomText_AfterEcruteak:
	text "우리 남편은 예전에 포켓몬"
	line "매니아로 불렸었단다 이수재도"
	cont "아버지를 닮았나봐"
	done

BillsYoungerSisterUsefulNumberText:
	text "너 포켓몬 트레이너니?"

	para "그렇다면 내가 굉장한"
	line "전화번호를 가르쳐줄까?"
	done

RecordedBillsNumberText:
	text "<PLAYER>는(은) 이수재의"
	line "전화번호를 등록했다!"
	done

BillsYoungerSisterRefusedNumberText:
	text "컴퓨터로 포켓몬을 맡길 수 있는"
	line "시스템을 만든 것은"
	cont "내 오빠야"

	para "너에게 이수재 오빠의"
	line "전화번호를"
	cont "가르쳐주려고 생각했는데"
	done

BillsYoungerSisterPhoneFullText:
	text "앗!"
	line "그 이상 등록을 할 수 없구나"
	done

BillsYoungerSisterStorageSystemText:
	text "컴퓨터로 포켓몬을"
	line "맡길 수 있는 시스템을 만든 것은"
	cont "이수재 오빠란다"
	done

BillsFamilysHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, GOLDENROD_CITY, 4
	warp_event  3,  7, GOLDENROD_CITY, 4

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, BillsHouseBookshelf2
	bg_event  1,  1, BGEVENT_READ, BillsHouseBookshelf1
	bg_event  7,  1, BGEVENT_READ, BillsHouseRadio

	def_object_events
	object_event  2,  3, SPRITE_BILL, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, BillScript, EVENT_MET_BILL
	object_event  5,  3, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, BillsMomScript, -1
	object_event  5,  4, SPRITE_TWIN, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, BillsYoungerSisterScript, -1
