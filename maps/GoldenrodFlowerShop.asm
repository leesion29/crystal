	object_const_def
	const GOLDENRODFLOWERSHOP_TEACHER
	const GOLDENRODFLOWERSHOP_FLORIA

GoldenrodFlowerShop_MapScripts:
	def_scene_scripts

	def_callbacks

FlowerShopTeacherScript:
	checkevent EVENT_FOUGHT_SUDOWOODO
	iftrue .Lalala
	checkevent EVENT_GOT_SQUIRTBOTTLE
	iftrue .GotSquirtbottle
	checkevent EVENT_MET_FLORIA
	iffalse .HaventMetFloria
	checkevent EVENT_TALKED_TO_FLORIA_AT_FLOWER_SHOP
	iffalse .Lalala
	checkflag ENGINE_PLAINBADGE
	iffalse .NoPlainBadge
	faceplayer
	opentext
	writetext GoldenrodFlowerShopTeacherHeresTheSquirtbottleText
	promptbutton
	verbosegiveitem SQUIRTBOTTLE
	setevent EVENT_GOT_SQUIRTBOTTLE
	closetext
	setevent EVENT_FLORIA_AT_SUDOWOODO
	clearevent EVENT_FLORIA_AT_FLOWER_SHOP
	end

.Lalala:
	turnobject GOLDENRODFLOWERSHOP_TEACHER, LEFT
	opentext
	writetext GoldenrodFlowerShopTeacherLalalaHavePlentyOfWaterText
	waitbutton
	closetext
	end

.GotSquirtbottle:
	jumptextfaceplayer GoldenrodFlowerShopTeacherDontDoAnythingDangerousText

.NoPlainBadge:
	jumptextfaceplayer GoldenrodFlowerShopTeacherAskWantToBorrowWaterBottleText

.HaventMetFloria:
	jumptextfaceplayer GoldenrodFlowerShopTeacherMySisterWentToSeeWigglyTreeRoute36Text

FlowerShopFloriaScript:
	faceplayer
	opentext
	checkevent EVENT_FOUGHT_SUDOWOODO
	iftrue .FoughtSudowoodo
	checkevent EVENT_GOT_SQUIRTBOTTLE
	iftrue .GotSquirtbottle
	writetext GoldenrodFlowerShopFloriaWonderIfSisWillLendWaterBottleText
	waitbutton
	closetext
	setevent EVENT_TALKED_TO_FLORIA_AT_FLOWER_SHOP
	setevent EVENT_FLORIA_AT_FLOWER_SHOP
	clearevent EVENT_FLORIA_AT_SUDOWOODO
	end

.GotSquirtbottle:
	writetext GoldenrodFlowerShopFloriaYouBeatWhitneyText
	waitbutton
	closetext
	end

.FoughtSudowoodo:
	writetext GoldenrodFlowerShopFloriaItReallyWasAMonText
	waitbutton
	closetext
	end

FlowerShopShelf1: ; unreferenced
	jumpstd PictureBookshelfScript

FlowerShopShelf2: ; unreferenced
	jumpstd MagazineBookshelfScript

FlowerShopRadio: ; unreferenced
	jumpstd Radio2Script

GoldenrodFlowerShopTeacherMySisterWentToSeeWigglyTreeRoute36Text:
	text "그 꿈틀꿈틀 움직이는 나무를"
	line "보았니?"

	para "36번 도로에서 자라고 있단다"

	para "내 동생이 잔뜩 신이 나서 그"
	line "나무를 보러 가버렸어……"

	para "걱정이 되는구나…… 위험하지"
	line "않을까?"
	done

GoldenrodFlowerShopTeacherAskWantToBorrowWaterBottleText:
	text "너도 물뿌리개를 빌리고 싶니?"

	para "하지만 그걸로 위험한 짓을 하지"
	line "않았으면 좋겠구나"
	done

GoldenrodFlowerShopTeacherHeresTheSquirtbottleText:
	text "응? 너"
	line "꼭두보다 강하구나"

	para "그럼 걱정 없겠네!"
	line "자 여기"
	cont "꼬부기 물뿌리개야!"
	done

GoldenrodFlowerShopTeacherDontDoAnythingDangerousText:
	text "너무 위험한 짓은"
	line "하지 말아라!"
	done

GoldenrodFlowerShopTeacherLalalaHavePlentyOfWaterText:
	text "라라라 라라라라"
	line "듬뿍 물을 줄께"
	done

GoldenrodFlowerShopFloriaWonderIfSisWillLendWaterBottleText:
	text "언니에게 움직이는 나무 이야기를"
	line "했더니 위험하다고 하더라"

	para "내가 꼭두에게 이기면 언니가"
	line "나한테 물뿌리개를 빌려줄까……"
	done

GoldenrodFlowerShopFloriaYouBeatWhitneyText:
	text "와아 꼭두에게 이겼어?"
	line "굉장하다!"
	done

GoldenrodFlowerShopFloriaItReallyWasAMonText:
	text "역시"
	line "포켓몬이었구나!"
	done

GoldenrodFlowerShop_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, GOLDENROD_CITY, 6
	warp_event  3,  7, GOLDENROD_CITY, 6

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  4, SPRITE_TEACHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FlowerShopTeacherScript, -1
	object_event  5,  6, SPRITE_LASS, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, FlowerShopFloriaScript, EVENT_FLORIA_AT_FLOWER_SHOP
