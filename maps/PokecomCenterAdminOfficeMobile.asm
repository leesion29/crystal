	object_const_def
	const POKECOMCENTERADMINOFFICEMOBILE_SCIENTIST1
	const POKECOMCENTERADMINOFFICEMOBILE_SCIENTIST2
	const POKECOMCENTERADMINOFFICEMOBILE_SCIENTIST3

PokecomCenterAdminOfficeMobile_MapScripts:
	def_scene_scripts

	def_callbacks

PokecomCenterAdminOfficeMobileScientist1Script:
	jumptextfaceplayer PokecomCenterAdminOfficeMobileScientist1Text

PokecomCenterAdminOfficeMobileScientist2Script:
	jumptextfaceplayer PokecomCenterAdminOfficeMobileScientist2Text

PokecomCenterAdminOfficeMobileScientist3Script:
	jumptextfaceplayer PokecomCenterAdminOfficeMobileScientist3Text

PokecomCenterAdminOfficeMobileComputer1:
	opentext
	writetext PokecomCenterAdminOfficeMobileComputer1Text
	waitbutton
.loop:
	refreshmap
	loadmenu .Computer1MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .PokeComClub
	ifequal 2, .MobileCenter
	sjump .Quit

.PokeComClub:
	opentext
	writetext PokecomCenterAdminOfficeMobileComputer1Text_PokeComClub
	waitbutton
	sjump .loop

.MobileCenter:
	opentext
	writetext PokecomCenterAdminOfficeMobileComputer1Text_MobileCenter
	waitbutton
	sjump .loop

.Quit:
	closetext
	end

.Computer1MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 15, 8
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 3 ; items
	db "포켓몬통신 클럽@" ; # COM CLUB
	db "모바일 센터@" ; MOBILE CENTER
	db "그만두다@" ; QUIT

PokecomCenterAdminOfficeMobileComputer2:
	opentext
	writetext PokecomCenterAdminOfficeMobileComputer2Text
	waitbutton
.loop:
	refreshmap
	loadmenu .Computer2MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .UsePhone
	ifequal 2, .DontUsePhone
	sjump .Quit

.UsePhone:
	opentext
	writetext PokecomCenterAdminOfficeMobileComputer2Text_UsePhone
	waitbutton
	sjump .loop

.DontUsePhone:
	opentext
	writetext PokecomCenterAdminOfficeMobileComputer2Text_DontUsePhone
	waitbutton
	sjump .loop

.Quit:
	closetext
	end

.Computer2MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 15, 8
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 3 ; items
	db "전화<WO>사용할 때@" ; Use phone
	db "전화가 연결되지 않을 때@" ; Don't use phone
	db "그만두다@" ; QUIT

PokecomCenterAdminOfficeMobileComputer3:
	jumptext PokecomCenterAdminOfficeMobileComputer3Text

PokecomCenterAdminOfficeMobileScientist1Text:
	text "포켓몬통신센터와 모바일 센터는"
	line "멀리 떨어진 사람과 교환이나"
	cont "대전을 즐기고 싶다는 트레이너들의"
	cont "요청에 따라 만들어졌단다"
	done

PokecomCenterAdminOfficeMobileScientist2Text:
	text "누군가와 휴대전화로 처음 통신을"
	line "했을 때 감동하지 않았니?"

	para "나는 첫 통신이 성공했을 때 너무"
	line "감동해서 몸이 떨릴 정도였단다!"
	done

PokecomCenterAdminOfficeMobileScientist3Text:
	text "이렇게 커다란 시설을 만들 수"
	line "있었던 것은 무선 통신 기술이"
	cont "발전한 덕분이란다"
	done

PokecomCenterAdminOfficeMobileComputer1Text:
	text "모바일 어댑터를 어디에서 사용할"
	line "수 있는지 안내되어 있다……"
	done

PokecomCenterAdminOfficeMobileComputer1Text_PokeComClub:
	text "포켓몬통신 클럽은 어느 포켓몬"
	line "센터든 2층에 있습니다"

	para "그곳에서는 교환이나 대전을 모바일"
	line "어댑터로 멀리 있는 친구와 즐길"
	cont "수 있습니다"

	para "통신하려면 친구도 당신과 같은"
	line "종류의 모바일 어댑터를 가지고"
	cont "있어야 합니다"
	done

PokecomCenterAdminOfficeMobileComputer1Text_MobileCenter:
	text "교환코너를 이용하거나 포켓몬"
	line "뉴스를 읽으려면 모바일 센터에"
	cont "전화를 걸어야 합니다"

	para "통신하기 전에 모바일 센터에"
	line "등록을 해두어야 합니다"
	done

PokecomCenterAdminOfficeMobileComputer2Text:
	text "전화 사용에 대한 안내문이다……"
	done

PokecomCenterAdminOfficeMobileComputer2Text_UsePhone:
	text "전화와 모바일 어댑터가 제대로"
	line "연결되었는지 확인해주세요"

	para "전화의 전파가 강하게 잡히는지도"
	line "확인해주세요"

	para "통신중에는 전화를 만지거나 끊지"
	line "마세요"
	done

PokecomCenterAdminOfficeMobileComputer2Text_DontUsePhone:
	text "서버가 혼잡할 때는 접속하지"
	line "못하는 경우가 있습니다"

	para "그럴 때는 나중에 다시"
	line "전화해주세요"

	para "접속할 수 없거나 에러 메시지가"
	line "무슨 뜻인지 모르겠다면"

	para "고객 지원센터에 문의하거나"
	line "설명서를 읽어주세요"
	done

PokecomCenterAdminOfficeMobileComputer3Text:
	text "관리 사무실에 전자우편이 도착해"
	line "있다 내용은……"

	para "<……> <……> <……>"

	para "포켓몬통신센터 직원 여러분께……"

	para "무선 통신 기술 덕분에 전국의"
	line "포켓몬 트레이너들이 서로 교류할"
	cont "수 있게 되었습니다"

	para "세계의 모든 트레이너들이 장벽"
	line "없이 통신할 수 있도록 계속"
	cont "노력합시다!"

	para "<……> <……> <……>"
	done

PokecomCenterAdminOfficeMobile_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0, 31, GOLDENROD_POKECENTER_1F, 3
	warp_event  1, 31, GOLDENROD_POKECENTER_1F, 3

	def_coord_events

	def_bg_events
	bg_event  6, 26, BGEVENT_UP, PokecomCenterAdminOfficeMobileComputer1
	bg_event  6, 28, BGEVENT_UP, PokecomCenterAdminOfficeMobileComputer2
	bg_event  3, 26, BGEVENT_UP, PokecomCenterAdminOfficeMobileComputer3

	def_object_events
	object_event  4, 28, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PokecomCenterAdminOfficeMobileScientist1Script, -1
	object_event  7, 27, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PokecomCenterAdminOfficeMobileScientist2Script, -1
	object_event  7, 29, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, PokecomCenterAdminOfficeMobileScientist3Script, -1
