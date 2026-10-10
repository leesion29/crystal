_OakText6::
	text "그럼……"
	line "슬슬 너의 이름을"
	cont "가르쳐다오!"
	prompt

_OakText7::
	text "<PLAYER>!"
	line "준비는 되었는가?"

if !DEF(_DEBUG)
	para "드디어 이제부터"
	line "너의 이야기가 시작되어진다"

	para "즐거운 것도 괴로운 것도"
	line "잔뜩 너를 기다리고 있을 것이다!"

	para "꿈과 모험과!"
	line "포켓몬스터의 세계에!"
	cont "렛츠 고!"

endc
	para "그럼 다음에 다시 만나자!"
	done

_ClockTimeMayBeWrongText::
	text "시계의 시간이 틀려"
	line "있는지도 모릅니다"

	para "시간을 맞춰주십시오"
	prompt

_ClockSetWithControlPadText::
	text "십자키로 선택"
	para "A 버튼으로 결정"
	line "B 버튼으로 취소"
	done

_ClockIsThisOKText::
	text "이것으로 결정하겠습니까?"
	done

_ClockHasResetText::
	text "시간을 재 설정했습니다!"
	done

_LinkTimeoutText::
	text "기다린 시간이 길어서"
	line "한번 더 시도해주십시오"
	prompt

_LinkTradeCantBattleText::
	text "그 포켓몬을 교환한다면"
	line "싸우지 못하게 되어버립니다!"
	prompt

_LinkAbnormalMonText::
	text "상대의 포켓몬"
	line "@"
	text_ram wStringBuffer1
	text "에게"
	cont "이상이 있는 것 같습니다!!"
	prompt

_LinkAskTradeForText::
	text "@"
	text_ram wBufferTrademonNickname
	text "과(와)"
	line "@"
	text_ram wStringBuffer1
	text "를(을)"
	cont "교환하겠습니까?"
	done

_MobileBattleMustPickThreeMonText::
	text "모바일 대전에 참가하려면"
	line "포켓몬 3마리를"
	cont "골라야 합니다"

	para "괜찮겠습니까?"
	done

_MobileBattleMoreInfoText::
	text "모바일 대전에 대해"
	line "설명을 듣겠습니까?"
	done

_MobileBattleRulesText::
	text "모바일 대전에서는"
	line "포켓몬 3마리를 고릅니다"

	para "하루에 대전할 수 있는 시간은"
	line "통신하는 사람마다 10분입니다"

	para "제한 시간 안에"
	line "대전이 끝나지 않으면"

	para "기절한 포켓몬의 수가"
	line "더 적은 쪽이 승리합니다"

	para "기절한 수가 같다면"
	line "줄어든 체력이"
	cont "더 적은 쪽이 승리합니다"
	done

_WouldYouLikeToMobileBattleText::
	text "오늘 남은 시간은"
	line "@"
	text_decimal wStringBuffer2, 1, 2
	text "분입니다"

	para "대전하겠습니까?"
	done

_WantAQuickMobileBattleText::
	text "오늘 남은 시간은 @"
	text_decimal wStringBuffer2, 1, 2
	text "분"
	line "밖에 없습니다"

	para "짧게 대전하겠습니까?"
	done

_WantToRushThroughAMobileBattleText::
	text "오늘 남은 시간은"
	line "1분밖에 없습니다!"

	para "서둘러 대전하겠습니까?"
	done

_PleaseTryAgainTomorrowText::
	text "오늘 남은 시간은"
	line "1분도 되지 않습니다!"

	para "내일 다시 시도해주십시오"
	done

_TryAgainUsingSameSettingsText::
	text "같은 설정으로"
	line "다시 시도하겠습니까?"
	done

_MobileBattleLessThanOneMinuteLeftText::
	text "오늘 남은 시간은"
	line "1분도 되지 않습니다!"
	done

_MobileBattleNoTimeLeftForLinkingText::
	text "오늘은 더이상"
	line "통신할 시간이 없습니다"
	done

_PickThreeMonForMobileBattleText::
	text "대전할 포켓몬을"
	line "3마리 골라주십시오"
	done

_MobileBattleRemainingTimeText::
	text "오늘 남은 시간은"
	line "@"
	text_decimal wStringBuffer2, 1, 2
	text "분입니다"
	done

_WouldYouLikeToSaveTheGameText::
	text "여기까지의 활약을"
	line "포켓몬 레포트에 기록하시겠습니까?"
	done

_SavingDontTurnOffThePowerText::
	text "포켓몬 레포트에 기록하고 있습니다"
	line "전원을 끄지 말아주세요"
	done

_SavedTheGameText::
	text "<PLAYER>는(은)"
	line "레포트에 정확히 기록했습니다!"
	done

_AlreadyASaveFileText::
	text "이전에 기록한 레포트에"
	line "덮어써도 괜찮겠습니까?"
	done

_AnotherSaveFileText::
	text "별도의 모험"
	line "레포트가 기록되어 있습니다!"
	cont "새로 기록해도 괜찮겠습니까?"
	done

_SaveFileCorruptedText::
	text "레포트의 내용이"
	line "손상되어 있습니다!!"
	prompt

_ChangeBoxSaveText::
	text "박스를 바꾸면"
	line "동시에 레포트가 기록되어집니다"
	cont "괜찮습니까?"
	done

_MoveMonWOMailSaveText::
	text "포켓몬을 이동할 때마다"
	line "레포트가 기록되어집니다"

	para "괜찮겠습니까?"
	done

_WindowAreaExceededErrorText:: ; unreferenced
	text "창을 저장할 수 있는"
	line "영역을 넘었습니다!"
	done

_WindowPoppingErrorText::
	text "켜질 창이"
	line "없습니다!"
	done

_CorruptedEventText:: ; unreferenced
	text "이벤트가 손상되었습니다!"
	prompt

_ObjectEventText::
	text "오브제 이벤트"
	done

_BGEventText::
	text "배경 이벤트"
	done

_CoordinatesEventText::
	text "좌표 이벤트"
	done

_ReceivedItemText::
	text "<PLAYER>는(은)"
	line "@"
	text_ram wStringBuffer4
	text "를(을)"
	cont "얻었다"
	done

_PutItemInPocketText::
	text "<PLAYER>는(은)"
	line "@"
	text_ram wStringBuffer1
	text "를(을)"
	cont "@"
	text_ram wStringBuffer3
	text "에 넣었다!"
	prompt

_PocketIsFullText::
	text "저런! @"
	text_ram wStringBuffer3
	text_start
	line "(이)가 가득……"
	prompt

_SeerSeeAllText::
	text "나는 모든 것을 보고"
	line "모든 것을 알고 있지……"

	para "물론 네 포켓몬에"
	line "대해서도 알고 있단다!"
	done

_SeerCantTellAThingText::
	text "뭐라고? 아무것도"
	line "알 수가 없잖아!"

	para "내가 이런 것도"
	line "모를 수가 있단 말인가?"
	done

_SeerNameLocationText::
	text "움…… 네가 만난"
	line "@"
	text_ram wSeerNickname
	text "는(은)"
	cont "@"
	text_ram wSeerCaughtLocation
	text ""
	cont "에서 만났구나!"
	prompt

_SeerTimeLevelText::
	text "그때의 시간은"
	line "@"
	text_ram wSeerTimeOfDay
	text "!"

	para "레벨은 @"
	text_ram wSeerCaughtLevelString
	text "였구나!"

	para "어때? 대단하지?"
	prompt

_SeerTradeText::
	text "움…… @"
	text_ram wSeerNickname
	text "는(은)"
	line "@"
	text_ram wSeerOT
	text "에게서"
	cont "교환으로 받았구나?"

	para "만난 장소는"
	line "@"
	text_ram wSeerCaughtLocation
	text ""
	cont "였구나"

	para "@"
	text_ram wSeerOT
	text "(이)가"
	line "@"
	text_ram wSeerNickname
	text "를(을)"
	cont "만났구나!"
	prompt

_SeerNoLocationText::
	text "뭐라고!? 놀랍구나!"

	para "어떻게 된 일인지 모르겠지만"
	line "정말 놀라워!"
	cont "너는 특별한 아이구나"

	para "어디서 만났는지는 모르겠지만"
	line "그때의 레벨은 @"
	text_ram wSeerCaughtLevelString
	text "였구나!"

	para "어때? 대단하지?"
	prompt

_SeerEggText::
	text "이봐!"

	para "그건 알이잖아!"

	para "아직 만났다고"
	line "할 수는 없겠지……"
	done

_SeerDoNothingText::
	text "후후후! 아무것도 하지 않을"
	line "것이라는 건 알고 있었지!"
	done

_SeerMoreCareText::
	text "그건 그렇고……"

	para "포켓몬을 조금 더"
	line "소중히 키워주는 게 좋겠구나"
	done

_SeerMoreConfidentText::
	text "그건 그렇고……"

	para "조금 성장한 것 같구나"

	para "@"
	text_ram wSeerNickname
	text "는(은)"
	line "조금씩 자신감이"
	cont "생기고 있는 것 같아"
	done

_SeerMuchStrengthText::
	text "그건 그렇고……"

	para "@"
	text_ram wSeerNickname
	text "는(은)"
	line "성장했구나"
	cont "힘도 많이 길렀어"
	done

_SeerMightyText::
	text "그건 그렇고……"

	para "정말 강하게 자랐구나!"

	para "이 @"
	text_ram wSeerNickname
	text "는(은)"
	line "많은 포켓몬 대전을"
	cont "겪어왔겠구나"

	para "자신감이 넘치는 것 같아"
	done

_SeerImpressedText::
	text "그건 그렇고……"

	para "네 정성에 감탄했단다"

	para "이렇게 강한 포켓몬은"
	line "오랜만에 보는구나"
	cont "@"
	text_ram wSeerNickname
	text " 말이야"

	para "분명 @"
	text_ram wSeerNickname
	text "의"
	line "대전 모습을 본다면"
	cont "누구라도 가슴이 뛰겠지"
	done

_CongratulationsYourPokemonText::
	text "축하합니다!"
	line "@"
	text_ram wStringBuffer2
	text "는(은)@"
	text_end

	text_end ; unreferenced

_EvolvedIntoText::
	text_start

	para "@"
	text_ram wStringBuffer1
	text "(으)로"
	line "진화했다!"
	done

_StoppedEvolvingText::
	text "얼라리……?"
	line "@"
	text_ram wStringBuffer2
	text "의 변화가"
	cont "멈췄다!"
	prompt

_EvolvingText::
	text "…… 오잉!?"
	line "@"
	text_ram wStringBuffer2
	text "의"
	cont "상태가……!"
	done

_MartHowManyText::
	text "몇 개를 구입하겠습니까?"
	done

_MartFinalPriceText::
	text_decimal wItemQuantityChange, 1, 2
	text "개의"
	line "@"
	text_ram wStringBuffer2
	text "는(은)"
	cont "@"
	text_decimal hMoneyTemp, 3, 6
	text "원입니다"

	para "구입하시겠습니까?"
	done

_HerbShopLadyIntroText::
	text "…… 어서오너라"

	para "싸고 잘 듣는"
	line "한약방이란다"

	para "우리집 한약은 맛이 쓰기 때문에"
	line "포켓몬은 약간 싫어할지도"
	cont "호호호호……"
	done

_HerbalLadyHowManyText::
	text "몇 개를 원하니?"
	done

_HerbalLadyFinalPriceText::
	text_decimal wItemQuantityChange, 1, 2
	text "개의"
	line "@"
	text_ram wStringBuffer2
	text "는(은)"
	cont "@"
	text_decimal hMoneyTemp, 3, 6
	text "원 이란다"
	done

_HerbalLadyThanksText::
	text "고맙구나"
	line "호호호……"
	done

_HerbalLadyPackFullText::
	text "오잉?"
	line "가방이 가득 찬 것 같구나!"
	done

_HerbalLadyNoMoneyText::
	text "호호호호……!"
	line "돈이 부족하구나!"
	done

_HerbalLadyComeAgainText::
	text "다음에 오거라!"
	line "호호호……"
	done

_BargainShopIntroText::
	text "어서오너라"
	line "우리집은 싸게 파는 도구가게란다"

	para "다른 가게에서는 팔지 않는"
	line "진귀한 것을 가지고 있단다!"
	cont "단, 1개씩밖에 없단다!"
	done

_BargainShopFinalPriceText::
	text_ram wStringBuffer2
	text "는(은)"
	line "@"
	text_decimal hMoneyTemp, 3, 6
	text "원이다"
	cont "사고싶니?"
	done

_BargainShopThanksText::
	text "고맙구나"
	done

_BargainShopPackFullText::
	text "어이 어이"
	line "가방이 가득 찼잖아!"
	done

_BargainShopSoldOutText::
	text "그건 아까 샀잖아"
	line "이젠 품절이야"
	done

_BargainShopNoFundsText::
	text "어이 어이"
	line "돈이 부족한 것 같군"
	done

_BargainShopComeAgainText::
	text "다음에 사러오너라"
	done

_PharmacyIntroText::
	text "응? 무슨 볼일이라도?"
	line "약을 살꺼니?"
	done

_PharmacyHowManyText::
	text "얼만큼 살꺼니?"
	done

_PharmacyFinalPriceText::
	text_decimal wItemQuantityChange, 1, 2
	text "개의"
	line "@"
	text_ram wStringBuffer2
	text "는(은)"
	cont "@"
	text_decimal hMoneyTemp, 3, 6
	text "원 되겠다"
	done

_PharmacyThanksText::
	text "고맙구나!"
	done

_PharmacyPackFullText::
	text "짐이 잔뜩 있잖아"
	done

_PharmacyNoMoneyText::
	text "응? 돈이 부족하군"
	done

_PharmacyComeAgainText::
	text "그럼 할 수 없지"
	line "다음에 또 오너라"
	done

_NothingToSellText::
	text "도구를 한개도"
	line "지니고 있지 않습니다!"
	prompt

_MartSellHowManyText::
	text "몇 개 팔겠습니까?"
	done

_MartSellPriceText::
	text "이 도구는"
	line "@"
	text_decimal hMoneyTemp, 3, 6
	text "원으로"
	cont "쳐서 받겠습니다"

	para "괜찮겠습니까?"
	done

_MartWelcomeText::
	text "어서오세요!"
	line "무엇을 도와드릴까요?"
	done

_MartThanksText::
	text "예! 여기 있습니다!"
	line "고맙습니다"
	done

_MartNoMoneyText::
	text "돈이 부족하군요!"
	done

_MartPackFullText::
	text "그 이상은"
	line "지닐 수 없어요!"
	done

_MartCantBuyText::
	text "그 도구를"
	line "사들일 수는 없습니다!"
	prompt

_MartComeAgainText::
	text "또 오세요!"
	done

_MartAskMoreText::
	text "그 밖에 우리들로서"
	line "무언가 힘이 될 수 있는 일은?"
	done

_MartBoughtText::
	text "@"
	text_decimal hMoneyTemp, 3, 6
	text "원을 받고"
	line "@"
	text_ram wStringBuffer2
	text "를(을)"
	cont "건넸다!"
	done

_SlotsBetHowManyCoinsText::
	text "동전을"
	line "몇 개 걸겠습니까?"
	done

_SlotsStartText::
	text "스타트!"
	done

_SlotsNotEnoughCoinsText::
	text "동전이 부족합니다!"
	prompt

_SlotsRanOutOfCoinsText::
	text "동전이"
	line "다 떨어져버렸다……"
	done

_SlotsPlayAgainText::
	text "다시한번"
	line "하겠습니까?"
	done

_SlotsLinedUpText::
	text "(이)가 모였다"
	line "동전 @"
	text_ram wStringBuffer2
	text "개 확보!"
	done

_SlotsDarnText::
	text "꽝-"
	done

_MobileStadiumEntryText::
	text "N64 포켓몬 스타디움 2의"
	line "모바일 스타디움에서"

	para "사용할 데이터를"
	line "읽을 수 있습니다"

	para "데이터를 읽겠습니까?"
	done

_MobileStadiumSuccessText::
	text "데이터 전송이"
	line "완료되었습니다"

	para "N64 포켓몬 스타디움 2의"
	line "모바일 스타디움에서"
	cont "대전을 즐겨주십시오"

	para ""
	done

_MainMenuTimeUnknownText::
	text "시계의 시각이 불명"
	done

_DeleteSavedLoginPasswordText::
	text "저장된 로그인"
	line "패스워드를 삭제하겠습니까?"
	done

_DeletedTheLoginPasswordText::
	text "저장된 로그인"
	line "패스워드를 삭제했습니다"
	done

_MobilePickThreeMonForBattleText::
	text "대전할 포켓몬을"
	line "3마리 골라주십시오"
	prompt

_MobileUseTheseThreeMonText::
	text_ram wMobileParticipant1Nickname
	text "와(과)"
	line "@"
	text_ram wMobileParticipant2Nickname
	text "와(과)"
	cont "@"
	text_ram wMobileParticipant3Nickname
	text ""

	para "이 3마리로 하겠습니까?"
	done

_MobileOnlyThreeMonMayEnterText::
	text "포켓몬은 3마리만"
	line "참가할 수 있습니다"
	prompt

_MobileCardFolderIntro1Text::
	text "카드 폴더에는"
	line "자신과 친구들의"
	cont "카드가 들어있습니다"

	para "카드에는 이름이나 전화번호"
	line "자기소개 같은 정보가"
	cont "적혀 있습니다"

	para ""
	done

_MobileCardFolderIntro2Text::
	text "이것은 자신의 카드입니다"

	para "자신의 전화번호를 입력하면"
	line "친구들과 카드를"
	cont "교환할 수 있습니다"

	para ""
	done

_MobileCardFolderIntro3Text::
	text "친구의 카드를 가지고 있으면"

	para "포켓몬센터 2층의"
	line "휴대전화를 이용해서"

	para "그 친구에게"
	line "전화를 걸 수 있습니다"

	para ""
	done

_MobileCardFolderIntro4Text::
	text "모은 카드를 안전하게"
	line "보관하기 위해서는"

	para "카드 폴더에"
	line "비밀번호를 설정해야 합니다"

	para ""
	done

_MobileCardFolderAskDeleteText::
	text "카드 폴더를 삭제하면"
	line "모든 카드와 비밀번호도"
	cont "함께 삭제됩니다"

	para "삭제한 카드 폴더는"
	line "되돌릴 수 없으니"
	cont "주의해주십시오"

	para "카드 폴더를 삭제하겠습니까?"
	done

_MobileCardFolderDeleteAreYouSureText::
	text "정말 삭제하겠습니까?"
	done

_MobileCardFolderDeletedText::
	text "카드 폴더를 삭제했습니다"

	para ""
	done

_MobileCardFolderAskOpenOldText::
	text "이전 모험에서 사용했던"
	line "카드 폴더가 있습니다"

	para "열어보겠습니까?"
	done

_MobileCardFolderAskDeleteOldText::
	text "이전의 카드 폴더를"
	line "삭제하겠습니까?"
	done

_MobileCardFolderFinishRegisteringCardsText::
	text "카드 등록을"
	line "끝내겠습니까?"
	done

_PhoneWrongNumberText::
	text "앗?"
	line "죄송합니다 틀렸네요……"
	done

_PhoneClickText::
	text "삑!"
	done

_PhoneEllipseText::
	text "……"
	done

_PhoneOutOfAreaText::
	text "……연결되지 않는군!"
	line "범위 밖에 있는 것 같다……"
	done

_PhoneJustTalkToThemText::
	text "근처에 있으니까"
	line "직접 만나서 이야기하자!"
	done

_PhoneThankYouText::
	text "고마워!"
	done

_SpaceSpaceColonText:: ; unreferenced
	text "  :"
	done

_PasswordAskResetText::
	text "패스워드를 확인했습니다"
	line "「모험을 계속하다」를 선택"
	cont "재 설정을 해 주십시오"
	prompt

_PasswordWrongText::
	text "패스워드가 틀렸습니다!"
	prompt

_PasswordAskResetClockText::
	text "시계를 재 설정 하겠습니까?"
	done

_PasswordAskEnterText::
	text "패스워드를"
	line "넣어주세요"
	done

_ClearAllSaveDataText::
	text "모든 세이브 데이터 영역을"
	line "지우겠습니까?"
	done

_LearnedMoveText::
	text_ram wMonOrItemNameBuffer
	text "는(은) 새로"
	line "@"
	text_ram wStringBuffer2
	text "를(을)"
	cont "배웠다!@"
	sound_dex_fanfare_50_79
	text_promptbutton
	text_end

	text_end ; unreferenced

_MoveAskForgetText::
	text "어느 기술을"
	next "잊게 하고싶은가?"
	done

_StopLearningMoveText::
	text "그렇다면……"
	line "@"
	text_ram wStringBuffer2
	text "를(을)"
	cont "배우는 것을 그만두겠습니까?"
	done

_DidNotLearnMoveText::
	text_ram wMonOrItemNameBuffer
	text "는(은)"
	line "@"
	text_ram wStringBuffer2
	text "를(을)"
	cont "배우지 않고 끝났다!"
	prompt

_AskForgetMoveText::
	text_ram wMonOrItemNameBuffer
	text "는(은) 새로"
	line "@"
	text_ram wStringBuffer2
	text "를(을)"
	cont "배우고싶다……!"

	para "그러나 @"
	text_ram wMonOrItemNameBuffer
	text "는(은)"
	line "기술을 4개"
	cont "기억하고있기에 더 이상은 무리다"

	para "다른 기술을 잊게하고"
	line "@"
	text_ram wStringBuffer2
	text "를(을)"
	cont "배우게 하겠습니까?"
	done

Text_MoveForgetCount::
	text "1 2 ……@"
	text_pause
	text_end

	text_end ; unreferenced

_MoveForgotText::
	text "짠!@"
	text_pause
	text_start

	para "@"
	text_ram wMonOrItemNameBuffer
	text "는(은)"
	line "@"
	text_ram wStringBuffer1
	text "의"
	cont "사용방법을 깨끗이 잊었다!"

	para "그리고……!"
	prompt

_MoveCantForgetHMText::
	text "그것은 중요한 기술입니다"
	line "잊게하는 것은 할 수 없습니다!"
	prompt

_CardFlipPlayWithThreeCoinsText::
	text "동전 3개로 도전할 수 있습니다"
	line "하시겠습니까?"
	done

_CardFlipNotEnoughCoinsText::
	text "동전이 부족해……"
	prompt

_CardFlipChooseACardText::
	text "카드를 골라주십시오"
	done

_CardFlipPlaceYourBetText::
	text "어디에 걸겠습니까?"
	done

_CardFlipPlayAgainText::
	text "다시 한번 하겠습니까?"
	done

_CardFlipShuffledText::
	text "카드를 섞었습니다"
	prompt

_CardFlipYeahText::
	text "당첨-"
	done

_CardFlipDarnText::
	text "꽝-"
	done

_GearTodayText::
	text_today
	text_end

	text_end ; unreferenced

_GearEllipseText::
	text "……"
	done

_GearOutOfServiceText::
	text "이곳은 범위 밖 같군……"
	prompt

_PokegearAskWhoCallText::
	text "누구에게"
	line "전화를 걸겠습니까?"
	done

_PokegearPressButtonText::
	text "버튼을 누르면"
	line "포켓기어를 종료합니다"
	done

_PokegearAskDeleteText::
	text "이 전화번호를"
	line "정말 삭제하겠습니까?"
	done

_BuenaAskWhichPrizeText::
	text "어느 경품을"
	line "받겠습니까?"
	done

_BuenaIsThatRightText::
	text_ram wStringBuffer1
	text "(으)로"
	line "하시겠습니까?"
	done

_BuenaHereYouGoText::
	text "예! 여기 있습니다!"

	para ""
	done

_BuenaNotEnoughPointsText::
	text "포인트가 부족합니다!"

	para ""
	done

_BuenaNoRoomText::
	text "지닌 물건이 가득 차서"
	line "받을 수 없습니다!"

	para ""
	done

_BuenaComeAgainText::
	text "그런가요?"
	line "다음에 또 오세요!"
	done

_BTExcuseMeText::
	text "잠시 실례하겠습니다!"

	para ""
	done

_ExcuseMeYoureNotReadyText::
	text "죄송합니다"
	line "아직 준비가 되지 않았습니다"

	para ""
	done

_BattleTowerReturnWhenReadyText::
	text "준비가 되면"
	line "다시 와주십시오"
	done

_NeedAtLeastThreeMonText::
	text "포켓몬이 적어도"
	line "3마리는 있어야 합니다"

	para ""
	done

_EggDoesNotQualifyText::
	text "죄송하지만 알은"
	line "참가할 수 없습니다"

	para ""
	done

_OnlyThreeMonMayBeEnteredText::
	text "포켓몬은 3마리만"
	line "참가할 수 있습니다"

	para ""
	done

_TheMonMustAllBeDifferentKindsText::
	text "@"
	text_ram wStringBuffer2
	text "마리의"
	line "포켓몬은 모두"
	cont "종류가 달라야 합니다"

	para ""
	done

_TheMonMustNotHoldTheSameItemsText::
	text "@"
	text_ram wStringBuffer2
	text "마리의"
	line "포켓몬에게 같은 도구를"
	cont "지니게 할 수 없습니다"

	para ""
	done

_YouCantTakeAnEggText::
	text "알을 데려갈 수는 없습니다!"

	para ""
	done

_BallDodgedText::
	text "던진 볼을 피해버렸다!"
	para "이 포켓몬은"
	line "붙잡지 못할 것 같다!"
	prompt

_BallMissedText::
	text "포켓몬에게"
	line "잘 맞추지 못했다!"
	prompt

_BallBrokeFreeText::
	text "이런! 포켓몬이"
	line "볼에서 튀어 나와버렸다!"
	prompt

_BallAppearedCaughtText::
	text "으으!"
	line "잡았다고 생각했는데!"
	prompt

_BallAlmostHadItText::
	text "분하다!"
	line "조금만 더하면 잡을 수 있었는데!"
	prompt

_BallSoCloseText::
	text "아까워라!"
	line "이제 곧 잡을 수 있었는데!"
	prompt

Text_BallCaught::
	text "신난다!"
	line "@"
	text_buffer 5
	text "를(을)"
	cont "잡았다!@"
	sound_caught_mon
	text_end

	text_end ; unreferenced

_WaitButtonText::
	text_promptbutton
	text_end

	text_end ; unreferenced

_BallSentToPCText::
	text_ram wMonOrItemNameBuffer
	text "는(은)"
	line "이수재의 PC에"
	cont "전송되었다!"
	prompt

_NewDexDataText::
	text_buffer 5
	text "의"
	line "데이터가 새롭게"
	cont "포켓몬 도감에 추가되었습니다!@"
	sound_slot_machine_start
	text_promptbutton
	text_end

	text_end ; unreferenced

_AskGiveNicknameText::
	text "잡은 포켓몬"
	line "@"
	text_ram wStringBuffer1
	text "에게"
	cont "별명을 붙이겠습니까?"
	done

_ItemStatRoseText::
	text_ram wStringBuffer1
	text "의"
	line "@"
	text_ram wStringBuffer2
	text "의"
	cont "기초 포인트가 올라갔다!"
	prompt

_ItemCantUseOnMonText::
	text "그 포켓몬에는"
	line "사용할 수 없습니다"
	prompt

_RepelUsedEarlierIsStillInEffectText::
	text "아직 전에 사용한 스프레이의"
	line "효과가 남아있습니다!"
	prompt

_PlayedFluteText::
	text "포켓몬의 피리를 불었다!"

	para "우음!"
	line "훌륭한 음색이다!"
	prompt

_FluteWakeUpText::
	text "모든 포켓몬이"
	line "눈을 떴다!"
	prompt

Text_PlayedPokeFlute::
	text "<PLAYER>는(은)"
	line "포켓몬의 피리를 불어보았다!@"
	text_promptbutton
	text_end

	text_end ; unreferenced

_BlueCardBalanceText::
	text "현재의 포인트는"
	line "@"
	text_decimal wBlueCardBalance, 1, 2
	text "점입니다"
	done

_CoinCaseCountText::
	text "당신의 동전은"
	line "@"
	text_decimal wCoins, 2, 4
	text "개@"
	text_end

	text_end ; unreferenced

_RaiseThePPOfWhichMoveText::
	text "어느 기술의"
	line "포인트를 늘릴까?"
	done

_RestoreThePPOfWhichMoveText::
	text "어느 기술을"
	line "회복할까?"
	done

_PPIsMaxedOutText::
	text_ram wStringBuffer2
	text "의"
	line "기술 포인트는 더이상"
	cont "늘릴 수가 없습니다!"
	prompt

_PPsIncreasedText::
	text_ram wStringBuffer2
	text "의"
	line "기술 포인트가 늘었다!"
	prompt

_PPRestoredText::
	text "기술 포인트가"
	line "회복되었다!"
	prompt

_SentTrophyHomeText::
	text "안으로부터 트로피가 나왔다!@"
	sound_dex_fanfare_50_79
	text_start

	para "@"
	text_ram wPlayerName
	text "는(은) 트로피를"
	line "집으로 보냈다"
	prompt

_ItemLooksBitterText::
	text "…굉장히 맛이 쓸 것 같다……"
	prompt

_ItemCantUseOnEggText::
	text "알에 사용해도"
	line "효과가 없을꺼야"
	prompt

_ItemOakWarningText::
	text "오박사님의 말씀……"
	line "<PLAYER>야(아)! 그런 것은"
	cont "사용할 때가 따로 있단다!"
	prompt

_ItemBelongsToSomeoneElseText::
	text "다른 사람의 물건입니다!"
	line "사용하는 것은 할 수 없습니다!"
	prompt

_ItemWontHaveEffectText::
	text "사용해도 효과가 없을껄"
	prompt

_BallBlockedText::
	text "트레이너가 볼을 쳐냈다!"
	prompt

_BallDontBeAThiefText::
	text "다른사람의 물건을 훔치면 도둑놈!"
	prompt

_NoCyclingText::
	text "여기서는 자전거에"
	line "탈 수 없습니다"
	prompt

_ItemCantGetOnText::
	text "지금은"
	line "@"
	text_ram wStringBuffer1
	text "에"
	cont "탈 수 없습니다"
	prompt

_BallBoxFullText::
	text "박스에 맡겨놓은 포켓몬이"
	line "가득차서"
	cont "지금은 사용할 수 없습니다!"
	prompt

_ItemUsedText::
	text "<PLAYER>는(은)@"
	text_low
	text_ram wStringBuffer2
	text "를(을)"
	cont "사용했다!"
	done

_ItemGotOnText::
	text "<PLAYER>는(은)@"
	text_low
	text_ram wStringBuffer2
	text "에 탔다"
	prompt

_ItemGotOffText::
	text "<PLAYER>는(은)@"
	text_low
	text_ram wStringBuffer2
	text "에서 내렸다"
	prompt

_KnowsMoveText::
	text_ram wStringBuffer1
	text "는(은)"
	line "@"
	text_ram wStringBuffer2
	text "를(을)"
	cont "이미 알고 있습니다"
	prompt

_MoveKnowsOneText::
	text "그 포켓몬은 기술을 1개밖에"
	line "가지고 있지 않아"
	done

_AskDeleteMoveText::
	text "오오!"
	line "@"
	text_ram wStringBuffer1
	text "를(을)"
	cont "잊게 하겠니?"
	done

_DeleterForgotMoveText::
	text "대성공! 너의 포켓몬"
	line "기술을 잊게했다"
	done

_DeleterEggText::
	text "어이 어이"
	line "그건 알이잖아"
	done

_DeleterNoComeAgainText::
	text "그래? 잊게 하고싶은 기술이"
	line "있다면 또 오너라"
	done

_DeleterAskWhichMoveText::
	text "어느 기술을"
	line "잊게 하고싶니?"
	prompt

_DeleterIntroText::
	text "움 그리고……"
	line "그래 나는 망각의 아저씨"

	para "포켓몬의 기술을"
	line "잊게할 수 있단다"

	para "포켓몬의 기술을"
	line "잊게하겠니?"
	done

_DeleterAskWhichMonText::
	text "어느 포켓몬?"
	prompt

_DSTIsThatOKText::
	text " 서머타임으로"
	line "해도 괜찮겠습니까?"
	done

_TimeAskOkayText::
	text ","
	line "이것으로 결정하겠습니까?"
	done

_TimesetAskDSTText::
	text "서머타임으로"
	line "바꾸겠니?"
	done

_TimesetDSTText::
	text "시계를 1시간"
	line "앞으로 맞췄단다"
	prompt

_TimesetAskNotDSTText::
	text "서머타임이"
	line "끝났니?"
	done

_TimesetNotDSTText::
	text "시계를 1시간"
	line "뒤로 맞췄단다"
	prompt

_TimesetAskAdjustDSTText::
	text "서머타임에 맞춰"
	line "시계를 조정하겠니?"
	done

_MomLostGearBookletText::
	text "포켓기어의 설명서를"
	line "잃어버렸단다"

	para "잠시 뒤에"
	line "다시 오거라"
	prompt
