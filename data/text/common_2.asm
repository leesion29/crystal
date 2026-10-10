_NoPhotoText::
	text "뭐야……그만둘텐가"
	line "다음에 또 오너라"
	done

_EggPhotoText::
	text "알을"
	line "촬영한다고 해도…………"
	done

_NameRaterHelloText::
	text "예 예! 나는"
	line "이름풀이 점술가"

	para "말하자면 이름으로"
	line "점을 칩니다"

	para "당신 포켓몬의 별명을"
	line "점 칠텐가?"
	done

_NameRaterWhichMonText::
	text "어느 포켓몬의"
	line "별명을"
	cont "점 칠텐가?"
	prompt

_NameRaterBetterNameText::
	text "우움 @"
	text_ram wStringBuffer1
	text "인가……"
	line "꽤"
	cont "좋은 별명을 붙였군"

	para "하지만"
	line "더 좋은 이름을"
	cont "붙일 수도 있지"

	para "내가 붙여줄까?"
	line "어떤가?"
	done

_NameRaterWhatNameText::
	text "그래? 그럼"
	line "어떤 별명으로"
	cont "해 볼까"
	prompt

_NameRaterFinishedText::
	text "전 보다도"
	line "좋은 이름이지 않은가"

	para "잘되었네!"
	done

_NameRaterComeAgainText::
	text "그런가"
	line "알겠네 또 오거라"
	done

_NameRaterPerfectNameText::
	text "움 @"
	text_ram wStringBuffer1
	text "인가!"
	line "이건 대단한 별명이군"
	cont "나쁜건 조금도 없군!"

	para "계속 @"
	text_ram wStringBuffer1
	text_start
	line "귀여워해 주거라!"
	done

_NameRaterEggText::
	text "어이어이……"
	line "그건 알이잖아"
	done

_NameRaterSameNameText::
	text "전이랑 비슷하게"
	line "보이겠지만"

	para "이쪽이 단연"
	line "뛰어나지!"

	para "잘 되었지!"
	done

_NameRaterNamedText::
	text "좋아, 이제부터"
	line "이녀석은"
	cont "@"
	text_ram wStringBuffer1
	text "(이)다!"
	prompt

Text_Gained::
	text_ram wStringBuffer1
	text "는(은)@"
	text_end

_BoostedExpPointsText::
; BUG: Five-digit experience gain is printed incorrectly (see docs/bugs_and_glitches.md)
	text_start
	line "많은 양의"
	cont "@"
	text_decimal wStringBuffer2, 2, 4
	text " 경험치를 얻었다!"
	prompt

_ExpPointsText::
; BUG: Five-digit experience gain is printed incorrectly (see docs/bugs_and_glitches.md)
	text_start
	line "@"
	text_decimal wStringBuffer2, 2, 4
	text " 경험치를 얻었다!"
	prompt

_GoMonText::
	text "가랏! @"
	text_end

_DoItMonText::
	text "나가랏! @"
	text_end

_GoForItMonText::
	text "힘내라!"
	line "@"
	text_end

_YourFoesWeakGetmMonText::
	text "상대가 약해져 있다!"
	line "찬스닷! @"
	text_end

_BattleMonNicknameText::
	text_buffer 6
	text "!"
	done

_BattleMonNickCommaText::
	text_buffer 6
	text " @"
	text_end

_ThatsEnoughComeBackText::
	text " 이젠 됐어"
	line "돌아와!@"
	text_end

_OKComeBackText::
	text " 좋아!"
	line "돌아와랏!@"
	text_end

_GoodComeBackText::
	text " 잘 싸웠다!"
	line "돌아와!@"
	text_end

_ComeBackText::
	text " "
	line "돌아와!"
	done

_BootedTMText::
	text "기술 머신을 가동시켰다!"
	prompt

_BootedHMText::
	text "비전 머신을 가동시켰다!"
	prompt

_ContainedMoveText::
	text "안에 기록된 기술은"
	line "@"
	text_ram wStringBuffer2
	text "(이)다!"

	para "@"
	text_ram wStringBuffer2
	text_start
	line "포켓몬에게 가르치겠습니까?"
	done

_TMHMNotCompatibleText::
	text_ram wStringBuffer2
	text "는(은)"
	line "상성이 좋지 않았다"
	cont "상대는 @"
	text_ram wStringBuffer1
	text "(이)다"

	para "배울 수 없는 기술은"
	line "@"
	text_ram wStringBuffer2
	text "(이)다!"
	prompt

_NoRoomTMHMText::
	text "더 이상"
	line "지닐 수 없는 것은"
	cont "@"
	text_ram wStringBuffer1
	text "(이)다!"
	prompt

_ReceivedTMHMText::
	text "손에 넣은 도구는"
	line "@"
	text_ram wStringBuffer1
	text "(이)다!"
	prompt

_MysteryGiftCanceledText::
	text "통신을"
	line "중지했습니다"
	prompt

_MysteryGiftCommErrorText::
	text "통신"
	line "에러"
	prompt

_RetrieveMysteryGiftText::
	text "이상한 소포를 받으러"
	line "포켓몬 센터에 가보자!"
	prompt

_YourFriendIsNotReadyText::
	text "상대의 준비가"
	line "되어있지 않습니다"
	prompt

_MysteryGiftFiveADayText::
	text "이상한 소포는 하루에"
	line "5번밖에는 되지 않습니다!"
	prompt

_MysteryGiftOneADayText::
	text "같은 사람의 이상한 소포는"
	line "하루에 1번만 받을 수 있습니다!"
	prompt

_MysteryGiftSentText::
	text_ram wMysteryGiftPartnerName
	text "(으)로부터"
	line "@"
	text_ram wStringBuffer1
	text " 선물이다"
	prompt

_MysteryGiftSentHomeText::
	text_ram wMysteryGiftPartnerName
	text "(이)가"
	line "@"
	text_ram wStringBuffer1
	text_start
	cont "@"
	text_ram wMysteryGiftPlayerName
	text "의 집에 보냈다"
	prompt

_NameCardReceivedCardText::
	text "명함을 받았습니다"
	line "@"
	text_ram wMysteryGiftCardHolderName
	text "의 명함입니다"
	prompt

_NameCardListedCardText::
	text_ram wMysteryGiftCardHolderName
	text "님의 명함을"
	line "등록했습니다 번호는 @"
	text_decimal wTextDecimalByte, 1, 2
	text "번입니다"
	prompt

_NameCardNotRegisteredCardText::
	text "명함을"
	line "등록하지 않았습니다"
	prompt

_NameCardLinkCancelledText::
	text "통신을"
	line "중지했습니다"
	prompt

_NameCardLinkCommErrorText::
	text "통신"
	line "에러"
	prompt

_BadgeRequiredText::
	text "새로운 배지를 손에 넣을 때까지"
	line "아직 사용할 수 없습니다!"
	prompt

_CantUseItemText::
	text "이곳에서는"
	line "사용할 수 없습니다"
	prompt

_UseCutText::
	text_ram wStringBuffer2
	text "는(은)"
	line "풀베기를 사용했다!"
	prompt

_CutNothingText::
	text "눈앞에 잘릴만한 것이"
	line "없습니다!"
	prompt

_BlindingFlashText::
	text "눈부신 빛이"
	line "주변을 밝게 비춘다……@"
	text_promptbutton
	text_end

	text_end ; unreferenced

_UsedSurfText::
	text_ram wStringBuffer2
	text "는(은)"
	line "파도타기를 사용했다!"
	done

_CantSurfText::
	text "여기서는 타는 기술을"
	line "사용할 수 없습니다"
	prompt

_AlreadySurfingText::
	text "이미 파도타기를"
	line "사용하고 있습니다"
	prompt

_AskSurfText::
	text "수면은 조용히 흔들리고 있다"
	line "……파도타기를 사용하겠습니까?"
	done

_UseWaterfallText::
	text_ram wStringBuffer2
	text "는(은)"
	line "폭포오르기를 사용했다!"
	done

_HugeWaterfallText::
	text "엄청 큰"
	line "폭포다!"
	done

_AskWaterfallText::
	text "폭포오르기를"
	line "사용하겠습니까?"
	done

_UseDigText::
	text_ram wStringBuffer2
	text "는(은)"
	line "구멍파기를 사용했다!"
	done

_UseEscapeRopeText::
	text "<PLAYER> 동굴탈출 로프를"
	line "사용했다!"
	done

_CantUseDigText::
	text "여기서는"
	line "사용할 수 없습니다!"
	done

_TeleportReturnText::
	text "마지막에 들렀던"
	line "포켓몬 센터로 돌아갑니다"
	done

_CantUseTeleportText::
	text "여기서는"
	line "사용할 수 없습니다!"

	para ""
	done

_AlreadyUsingStrengthText::
	text "이미 괴력을"
	line "발휘하고 있습니다"
	prompt

_UseStrengthText::
	text_ram wStringBuffer2
	text "는(은)"
	line "괴력을 발휘했다!"
	done

_MoveBoulderText::
	text_ram wStringBuffer1
	text "의 괴력덕분에"
	line "바위를 밀 수 있게 되었다!"
	prompt

_AskStrengthText::
	text "커다란 바위지만……"
	line "포켓몬의 기술로 밀 수 있을지도?"

	para "괴력을"
	line "사용하겠습니까?"
	done

_BouldersMoveText::
	text "괴력덕분에"
	line "바위를 밀 수 있게 되었다!"
	done

_BouldersMayMoveText::
	text "커다란 바위지만……"
	line "포켓몬의 기술로 밀 수 있을지도?"
	done

_UseWhirlpoolText::
	text_ram wStringBuffer2
	text "는(은)"
	line "소용돌이를 사용했다"
	prompt

_MayPassWhirlpoolText::
	text "세차게"
	line "소용돌이치고 있다"

	para "……포켓몬의 기술로"
	line "어떻게 될지도 몰라"
	done

_AskWhirlpoolText::
	text "앞길을 거친 소용돌이가"
	line "가로막고 있다!"

	para "소용돌이를"
	line "사용하겠습니까?"
	done

_UseHeadbuttText::
	text_ram wStringBuffer2
	text "는(은)"
	line "박치기를 사용했다!"
	prompt

_HeadbuttNothingText::
	text "……없군……"
	done

_AskHeadbuttText::
	text "이런 나무에는"
	line "포켓몬이 있을지도…"

	para "박치기를"
	line "사용하겠습니까?"
	done

_UseRockSmashText::
	text_ram wStringBuffer2
	text "는(은)"
	line "바위깨기를 사용했다!"
	prompt

_MaySmashText::
	text "단단해 보이는 바위지만……"
	line "포켓몬의 기술로 부술 수 있을지도"
	done

_AskRockSmashText::
	text "포켓몬의 기술로"
	line "부술 수 있겠다!"

	para "……바위깨기를"
	line "사용하겠습니까?"
	done

_RodBiteText::
	text "오!"
	line "걸렸다! 걸렸다!"
	prompt

_RodNothingText::
	text "낚이지 않는군……"
	prompt

_UnusedNothingHereText::
	text "이곳에는 아무것도"
	line "없는 것 같다"
	prompt

_CantGetOffBikeText::
	text "이곳에서는"
	line "내릴 수 없다!"
	done

_GotOnBikeText::
	text "<PLAYER>는(은)"
	line "@"
	text_ram wStringBuffer2
	text "에 탔다"
	done

_GotOffBikeText::
	text "<PLAYER>는(은)"
	line "@"
	text_ram wStringBuffer2
	text "에서 내렸다"
	done

_AskCutText::
	text "……이 나무는 어쩐지"
	line "베어질 것 같다!"

	para "풀베기로 베겠습니까?"
	done

_CanCutText::
	text "이 나무는 어쩐지"
	line "베어질 것 같다!"
	done

_FoundItemText::
	text "<PLAYER> 발견한 것은"
	line "@"
	text_ram wStringBuffer3
	text "(이)다!"
	done

_CantCarryItemText::
	text "그러나 <PLAYER>는(은)"
	line "더 이상 도구를"
	cont "지닐 수 없다!"
	done

_WhitedOutText::
	text "<PLAYER>의 곁에는"
	line "싸울 수 있는 포켓몬이 없다!"

	para "<PLAYER>는(은)"
	line "눈앞이 깜깜해졌다!"
	done

_ItemfinderItemNearbyText::
	text "옷!"
	line "머신이 반응하고 있어!"
	cont "근처에 도구가 묻혀있다!"
	prompt

_ItemfinderNopeText::
	text "…… …… 후우!"
	line "…… 아무것도 반응하지 않는군"
	prompt

_PoisonFaintText::
	text_ram wStringBuffer3
	text_start
	line "힘이 빠졌다!"
	prompt

_PoisonWhiteoutText::
	text "<PLAYER>의 곁에는"
	line "싸울 수 있는 포켓몬이 없다!"

	para "<PLAYER>는(은)"
	line "눈앞이 깜깜해졌다!"
	prompt

_UseSweetScentText::
	text_ram wStringBuffer3
	text "는(은)"
	line "달콤한 향기를 사용했다!"
	done

_SweetScentNothingText::
	text "……이곳에는"
	line "아무것도 없는 것 같다……"
	done

_SquirtbottleNothingText::
	text "<PLAYER>는(은)"
	line "물을 뿌렸다!"

	para "……아무것도"
	line "일어나지 않는다"
	done

_UseSacredAshText::
	text "<PLAYER>의 포켓몬은"
	line "모두 건강해졌다!"
	done

_AnEggCantHoldAnItemText::
	text "알에게는"
	line "물건을 지니게 할 수 없습니다!"
	prompt

_PackNoItemText::
	text "도구가 없습니다"
	done

_AskThrowAwayText::
	text "몇 개"
	line "버리시겠습니까?"
	done

_AskQuantityThrowAwayText::
	text "버릴 개수는 @"
	text_decimal wItemQuantityChange, 1, 2
	text_start
	line "@"
	text_ram wStringBuffer2
	text " 버릴까요?"
	done

_ThrewAwayText::
	text "버린 도구는"
	line "@"
	text_ram wStringBuffer2
	text "(이)다!"
	prompt

_OakThisIsntTheTimeText::
	text "오박사『<PLAYER>야(아)!"
	line "이런 것에는"
	cont "사용할 때가 따로 있는 법!"
	prompt

_YouDontHaveAMonText::
	text "포켓몬을"
	line "가지고 있지 않습니다!"
	prompt

_RegisteredItemText::
	text "편리버튼에 등록한 도구는"
	line "@"
	text_ram wStringBuffer2
	text "(이)다!"
	prompt

_CantRegisterText::
	text "그 도구는"
	line "등록할 수 없습니다!"
	prompt

_AskItemMoveText::
	text "어디로"
	line "이동하겠습니까?"
	done

_PackEmptyText::
	text_start
	done

_YouCantUseItInABattleText::
	text "전투 중에는"
	line "할 수 없습니다!"
	prompt

_AreYouABoyOrAreYouAGirlText::
	text "너는 남자아이니?"
	line "아니면 여자아이니?"
	done

Text_BattleEffectActivate::
	text "<USER>의"
	line "@"
	text_ram wStringBuffer2
	text_end

	text_end ; unreferenced

_BattleStatWentWayUpText::
	text_pause
	text "<SCROLL>(이)가 부쩍 올랐다!"
	prompt

_BattleStatWentUpText::
	text "(이)가 올랐다!"
	prompt

Text_BattleFoeEffectActivate::
	text "<TARGET>의"
	line "@"
	text_ram wStringBuffer2
	text_end

	text_end ; unreferenced

_BattleStatSharplyFellText::
	text_pause
	text "<SCROLL>(이)가 확 떨어졌다!"
	prompt

_BattleStatFellText::
	text "(이)가 떨어졌다!"
	prompt

Text_BattleUser::
	text "<USER>@"
	text_end

_BattleMadeWhirlwindText::
	text_start
	line "주변에서 공기가 소용돌이친다!"
	prompt

_BattleTookSunlightText::
	text_start
	line "빛을 흡수했다!"
	prompt

_BattleLoweredHeadText::
	text_start
	line "목을 집어넣었다!"
	prompt

_BattleGlowingText::
	text_start
	line "세찬 빛이 감싼다!"
	prompt

_BattleFlewText::
	text_start
	line "하늘높이 날아올랐다!"
	prompt

_BattleDugText::
	text_start
	line "구멍을 파서 땅속으로 숨었다!"
	prompt

_ActorNameText::
	text "<USER>@"
	text_end

_UsedMove1Text::
	text_start
	line "@"
	text_end

_UsedMove2Text::
	text_start
	line "@"
	text_end

_UsedInsteadText::
	text "명령을 무시하고"
	cont "@"
	text_end

_MoveNameText::
	text_ram wStringBuffer2
	text_end

	text_end ; unreferenced

_EndUsedMove1Text::
	text "를(을) 사용했다!"
	done

_EndUsedMove2Text::
	text "를(을) 사용했다!"
	done

_EndUsedMove3Text::
	text "를(을) 사용했다!"
	done

_EndUsedMove4Text::
	text "를(을) 사용했다!"
	done

_EndUsedMove5Text::
	text "를(을) 사용했다!"
	done

Text_BreedHuh::
	text "얼라리…………?"

	para "@"
	text_end

_BreedClearboxText::
	text_start
	done

_BreedEggHatchText::
	text_ram wStringBuffer1
	text "(이)가"
	line "알에서 태어났다!@"
	sound_caught_mon
	text_promptbutton
	text_end

	text_end ; unreferenced

_BreedAskNicknameText::
	text "별명을 붙이겠습니까?"
	line "@"
	text_ram wStringBuffer1
	text "에게?"
	done

_LeftWithDayCareLadyText::
	text "@"
	text_ram wBreedMon2Nickname
	text_start
	line "보모 할머니에게"
	cont "맡겼던 포켓몬이다"
	done

_LeftWithDayCareManText::
	text "@"
	text_ram wBreedMon1Nickname
	text_start
	line "보모 할아버지에게"
	cont "맡겼던 포켓몬이다"
	done

_BreedBrimmingWithEnergyText::
	text "기운이"
	line "넘친다!"
	prompt

_BreedNoInterestText::
	text "전혀 흥미가 없는 상대는"
	line "@"
	text_ram wStringBuffer1
	text "(이)다"
	prompt

_BreedAppearsToCareForText::
	text "매우 마음에 들어하는 상대는"
	line "@"
	text_ram wStringBuffer1
	text "(이)다!"
	prompt

_BreedFriendlyText::
	text "매우 사이가 좋은 상대는"
	line "@"
	text_ram wStringBuffer1
	text "(이)다"
	prompt

_BreedShowsInterestText::
	text "약간 흥미를 보이는 상대는"
	line "@"
	text_ram wStringBuffer1
	text "(이)다"
	prompt

_EmptyMailboxText::
	text "메일은 1통도"
	line "없습니다"
	prompt

_MailClearedPutAwayText::
	text "내용을 지운 메일을"
	line "가방에 넣었습니다"
	prompt

_MailPackFullText::
	text "가방이 가득 찼습니다!"
	prompt

_MailMessageLostText::
	text "내용이 지워져버리겠지만"
	line "괜찮습니까?"
	done

_MailAlreadyHoldingItemText::
	text "이미 도구를"
	line "지니고 있습니다"
	prompt

_MailEggText::
	text "알에게는"
	line "메일을 지니게 할 수 없습니다!"
	prompt

_MailMovedFromBoxText::
	text "메일박스로부터"
	line "메일을 옮겼습니다"
	prompt

_YesPromptText:: ; unreferenced
	text "예"
	prompt

_NoPromptText:: ; unreferenced
	text "아니오"
	prompt

_AnimationTypeText:: ; unreferenced
	text_decimal wcf64, 1, 3
	text " @"
	text_ram wStringBuffer1
	text_start
	line "동작 종류 @"
	text_ram wStringBuffer2
	text_end

	text_end ; unreferenced

_MonNumberText:: ; unreferenced
	text "포켓몬 번호?"
	done

_WasSentToBillsPCText::
	text_ram wStringBuffer1
	text "는(은)"
	line "이수재의 컴퓨터에 전송되어졌다!"
	prompt

_PCGottaHavePokemonText::
	text "포켓몬을 가지고있지 않는 놈은"
	line "거절이야!"
	prompt

_PCWhatText::
	text "뭐 할꺼야?"
	done

_PCMonHoldingMailText::
	text "메일을 가지고 있는"
	line "포켓몬이 있습니다"

	para "메일을"
	line "받아주세요"
	prompt

_PCNoSingleMonText::
	text "포켓몬을"
	line "1마리도 가지고있지 않냐?"
	prompt

_PCCantDepositLastMonText::
	text "마지막 포켓몬은"
	line "맡길 수 없어!"
	prompt

_PCCantTakeText::
	text "그이상은"
	line "포켓몬 지닐 수 없을껄!"
	prompt

_ContestCaughtMonText::
	text "잡았다! @"
	text_ram wStringBuffer1
	text "!"
	prompt

_ContestAskSwitchText::
	text "포켓몬을 바꿔 넣을래?"
	done

_ContestAlreadyCaughtText::
	text "이미 잡은 포켓몬은"
	line "@"
	text_ram wStringBuffer1
	text "(이)다"
	prompt

_ContestJudging_FirstPlaceText::
	text "그리고! 이번 대회"
	line "1등의 우승자는@"
	text_pause
	text "…"

	para "@"
	text_ram wBugContestWinnerName
	text "님!"
	line "잡은 포켓몬은"
	cont "@"
	text_ram wStringBuffer1
	text "(이)다!@"
	text_end

_ContestJudging_FirstPlaceScoreText::
	text_start

	para "득점은"
	line "@"
	text_decimal wBugContestFirstPlaceScore, 2, 3
	text "점 입니다!"
	prompt

_ContestJudging_SecondPlaceText::
	text "2등은"
	line "@"
	text_ram wBugContestWinnerName
	text "님!"

	para "잡은 포켓몬은"
	line "@"
	text_ram wStringBuffer1
	text "(이)다!@"
	text_end

_ContestJudging_SecondPlaceScoreText::
	text_start

	para "득점은"
	line "@"
	text_decimal wBugContestSecondPlaceScore, 2, 3
	text "점 입니다!"
	prompt

_ContestJudging_ThirdPlaceText::
	text "3등은"
	line "@"
	text_ram wBugContestWinnerName
	text "님!"

	para "잡은 포켓몬은"
	line "@"
	text_ram wStringBuffer1
	text "(이)다!@"
	text_end

_ContestJudging_ThirdPlaceScoreText::
	text_start

	para "득점은"
	line "@"
	text_decimal wBugContestThirdPlaceScore, 2, 3
	text "점 입니다!"
	prompt

_MagikarpGuruMeasureText::
	text "그럼 너의 잉어킹"
	line "크기를 재보겠다"

	para "……움, 크기는"
	line "@"
	text_ram wStringBuffer1
	text "(이)군!"
	prompt

_KarpGuruRecordText::
	text "현재의 기록"

	para "@"
	text_ram wStringBuffer1
	text " 잡은 사람"
	line "@"
	text_ram wMagikarpRecordHoldersName
	text_promptbutton
	text_end

	text_end ; unreferenced

_LuckyNumberMatchPartyText::
	text "축하합니다!"

	para "아이디 넘버가 완전히"
	line "일치했습니다"

	para "데리고 있는 @"
	text_ram wStringBuffer1
	text "의"
	line "아이디 넘버입니다"
	prompt

_LuckyNumberMatchPCText::
	text "축하합니다!"

	para "아이디 넘버가 완벽하게"
	line "일치했습니다"

	para "@"
	text_ram wStringBuffer1
	text "는(은)"
	line "컴퓨터에 맡겨져 있습니다"
	prompt

_CaughtAskNicknameText::
	text "이름을 붙이겠습니까?"
	line "받은 @"
	text_ram wStringBuffer1
	text "에게"
	cont "어떤 이름을 붙일까요?"
	done

_PokecenterPCCantUseText::
	text "삐-익!"
	line "포켓몬을 가지고있지 않는"
	cont "사람은 사용 할 수 없습니다!"
	prompt

_PlayersPCTurnOnText::
	text "<PLAYER>는(은)"
	line "컴퓨터의 스위치를 넣었다!"
	prompt

_PlayersPCAskWhatDoText::
	text "무엇을"
	line "하겠습니까?"
	done

_PlayersPCHowManyWithdrawText::
	text "몇 개를"
	line "꺼내겠습니까?"
	done

_PlayersPCWithdrewItemsText::
	text "꺼낸 개수: @"
	text_decimal wItemQuantityChange, 1, 2
	text_start
	line "도구: @"
	text_ram wStringBuffer2
	text ""
	prompt

_PlayersPCNoRoomWithdrawText::
	text "지닌 물건이 잔뜩 있어서"
	line "꺼낼 수 없습니다!"
	prompt

_PlayersPCNoItemsText::
	text "도구를 하나도 가지고 있지 않아!"
	prompt

_PlayersPCHowManyDepositText::
	text "몇 개를"
	line "맡기겠습니까?"
	done

_PlayersPCDepositItemsText::
	text "맡긴 개수: @"
	text_decimal wItemQuantityChange, 1, 2
	text_start
	line "도구: @"
	text_ram wStringBuffer2
	text ""
	prompt

_PlayersPCNoRoomDepositText::
	text "도구가 가득 있습니다"
	line "더 이상 맡길 수 없습니다!"
	prompt

_PokecenterPCTurnOnText::
	text "<PLAYER>는(은)"
	line "컴퓨터의 스위치를 켰다!"
	prompt

_PokecenterPCWhoseText::
	text "어느 컴퓨터와 통신하겠습니까?"
	done

_PokecenterBillsPCText::
	text "이수재의 컴퓨터와"
	line "연결했다!"

	para "포켓몬 맡김 시스템을"
	line "불러냈습니다!"
	prompt

_PokecenterPlayersPCText::
	text "자신의 컴퓨터와 연결했다!"

	para "도구 맡김 시스템을"
	line "불러냈습니다!"
	prompt

_PokecenterOaksPCText::
	text "오박사의 컴퓨터와"
	line "연결했다!"

	para "포켓몬 도감"
	line "평가 시스템을 불러냈습니다!"
	prompt

_PokecenterPCOaksClosedText::
	text "…"
	line "…… …… 통신 종료!"
	done

_OakPCText1::
	text "현재의 포켓몬 도감을"
	line "평가받겠습니까?"
	done

_OakPCText2::
	text "포켓몬 도감의"
	line "현재 완성도……"
	prompt

_OakPCText3::
	text_ram wStringBuffer3
	text "종류의 포켓몬을 발견"
	line "@"
	text_ram wStringBuffer4
	text "종류의 포켓몬을 잡았다"

	para "오박사의"
	line "평가……"
	done

_OakRating01::
	text "여기저기의 풀숲에 들어가"
	line "포켓몬을 잡는 것이다!"
	done

_OakRating02::
	text "움! 몬스터볼의"
	line "사용방법은"
	cont "알고있는 것 같군!"
	done

_OakRating03::
	text "그럭저럭"
	line "적응된 것 같구나"

	para "하지만 아직도"
	line "갈 길은 멀단다!"
	done

_OakRating04::
	text "포켓몬 도감으로는"
	line "아직 양이 부족해!"

	para "여러 종류의"
	line "포켓몬을 잡도록 하거라!"
	done

_OakRating05::
	text "후움, 열심히"
	line "하고 있군"

	para "그런대로 포켓몬 도감"
	line "답게 되어가고 있단다!"
	done

_OakRating06::
	text "어떤 포켓몬은"
	line "키워서 진화하고"

	para "어떤 포켓몬은"
	line "돌의 영향으로 진화한단다!"
	done

_OakRating07::
	text "낚싯대는 손에 넣었는가?"
	line "여기저기서 낚시를 한다면"

	para "더욱 많은 포켓몬을"
	line "모을 수 있단다!"
	done

_OakRating08::
	text "굉장하군!"
	line "너는 물건을 수집하는 것을"
	cont "좋아하지?"
	done

_OakRating09::
	text "정해진 시간대밖에"
	line "움직이지 않는"

	para "포켓몬이"
	line "있다고 한다"
	done

_OakRating10::
	text "페이지도 늘어난 것 같구나!"
	line "그 상태로 더욱"
	cont "열심히 하거라!"
	done

_OakRating11::
	text "호오! 흥미가 생기는구나!"
	line "포켓몬을 잡는 것뿐만 아니라"

	para "진화도"
	line "시키고 있구나!"
	done

_OakRating12::
	text "강집이란 사람과는 만났나?"
	line "볼을 만들어 받으면"
	cont "모으는 것도 순조롭다고 생각한다!"
	done

_OakRating13::
	text "옷! 생각해보면"
	line "저번에 조사했을 때보다도"

	para "많은 포켓몬이"
	line "발견되었었지"
	done

_OakRating14::
	text "친구들과"
	line "교환하고 있는가?"

	para "혼자서는"
	line "매우 힘들테니까"
	done

_OakRating15::
	text "뭐랏! 200종류를 넘었다고!"
	line "이것은 대단히 좋은 도감이"
	cont "될 것 같구나! 기대하겠다!"
	done

_OakRating16::
	text "이렇게 많은 포켓몬을"
	line "발견할줄은……"

	para "이번 포켓몬 연구는"
	line "너의 덕분이다!"
	done

_OakRating17::
	text "대단해!"
	line "너는 지금이라도"

	para "포켓몬 박사가"
	line "될 수 있겠구나!"
	done

_OakRating18::
	text "여기까지 도감이"
	line "만들어졌다면"

	para "이미"
	line "프로의 경지다!"
	done

_OakRating19::
	text "오옷 꿈에서도 그리던"
	line "퍼펙트한 도감의"

	para "완성이구나!"
	line "…… 축하한다!"
	done

_OakPCText4::
	text "…… 오박사의 컴퓨터와의"
	line "접속을 끝냈다!"
	done

_TrainerRankingExplanationText:: ; unreferenced
	text "세 가지 주제의"
	line "트레이너 랭킹!"

	para "방금 보낸"
	line "레포트의 기록이"
	cont "랭킹에 오를지도 모릅니다!"

	para ""
	done

_TrainerRankingNoDataText:: ; unreferenced
	text "랭킹 데이터가"
	line "없습니다"

	para "통신으로 랭킹 데이터를"
	line "받아주십시오"

	para ""
	done

_MemoryGameYeahText::
	text " 잘먹을께!"
	done

_MemoryGameDarnText::
	text "안됐다……"
	done

_StartMenuContestEndText::
	text "대회를"
	line "끝내겠습니까?"
	done

_ItemsTossOutHowManyText::
	text "몇 개 버리겠습니까?"
	line "@"
	text_ram wStringBuffer2
	text "를(을)?"
	done

_ItemsThrowAwayText::
	text "버릴 개수는 @"
	text_decimal wItemQuantityChange, 1, 2
	text_start
	line "@"
	text_ram wStringBuffer2
	text " 버릴까요?"
	done

_ItemsDiscardedText::
	text "버린 도구는"
	line "@"
	text_ram wStringBuffer1
	text "(이)다!"
	prompt

_ItemsTooImportantText::
	text "그것은 매우 중요한 것 입니다!"
	line "버리는 것은 할 수 없습니다!"
	prompt

_ItemsOakWarningText::
	text "오박사『<PLAYER>야(아)!"
	line "그런 것은"
	cont "사용할 때가 따로 있단다!"
	done

_PokemonSwapItemText::
	text "@"
	text_ram wMonOrItemNameBuffer
	text "(이)가 지닌"
	line "@"
	text_ram wStringBuffer1
	text " 대신"

	para "지니게 한 도구는"
	line "@"
	text_ram wStringBuffer2
	text "(이)다!"
	prompt

_PokemonHoldItemText::
	text "@"
	text_ram wMonOrItemNameBuffer
	text_start
	line "지닌 도구:@"
	text_ram wStringBuffer2
	text ""
	prompt

_PokemonRemoveMailText::
	text "먼저 메일을"
	line "풀어주세요"
	prompt

_PokemonNotHoldingText::
	text_ram wMonOrItemNameBuffer
	text "는(은)"
	line "아무것도 지니고 있지 않습니다!"
	prompt

_ItemStorageFullText::
	text "도구가 잔뜩 있어서"
	line "지닌 물건을 맡을 수 없습니다!"
	prompt

_PokemonTookItemText::
	text "받은 도구:@"
	text_ram wStringBuffer1
	text_start
	line "준 상대: @"
	text_ram wMonOrItemNameBuffer
	text "!"
	prompt

_PokemonAskSwapItemText::
	text_ram wMonOrItemNameBuffer
	text "는(은)"
	line "이미 도구를 지니고 있습니다"

	para "@"
	text_ram wStringBuffer1
	text "입니다"
	line "들고 있는 도구를 바꾸겠습니까?"
	done

_ItemCantHeldText::
	text "이 도구는"
	line "지닐 수가 없습니다!"
	prompt

_MailLoseMessageText::
	text "메일의 내용이 지워지지만"
	line "괜찮습니까?"
	done

_MailDetachedText::
	text "메일을 받았습니다!"
	line "@"
	text_ram wStringBuffer1
	text "에게서!"
	prompt

_MailNoSpaceText::
	text "도구가 잔뜩 있어서"
	line "메일을 받을 수 없습니다"
	prompt

_MailAskSendToPCText::
	text "받은 메일을 컴퓨터에"
	line "전송하겠습니까?"
	done

_MailboxFullText::
	text "컴퓨터의 메일박스가"
	line "가득 찼습니다!"
	prompt

_MailSentToPCText::
	text "메일을 컴퓨터에"
	line "전송했습니다"
	prompt

_PokemonNotEnoughHPText::
	text "체력이 부족합니다!"
	prompt

_MayRegisterItemText::
	text "가방에 넣어둔 도구를"
	line "편리버튼에 등록하면"

	para "셀렉트 버튼으로"
	line "사용할 수 있습니다"
	done

_OakText1::
	text "이야- 오래 기다리게 했다!"

if !DEF(_DEBUG)
	para "포켓몬스터의 세계에"
	line "잘왔단다!"

	para "나의 이름은 오박사"

	para "모두로부터는 포켓몬박사라고"
	line "존경받고 있단다"
endc
	prompt

_OakText2::
	text "포켓몬스터……포켓몬"
	para "이 세계에는"
	line "포켓몬스터라고 불려지는"
	cont "생명체들이"
	cont "도처에 살고있다!@"
	text_end

_OakText3::
	text_promptbutton
	text_end

	text_end ; unreferenced

_OakText4::
	text "사람은 포켓몬들과"
	line "정답게 지내거나"
	cont "함께 싸우거나…………"

	para "서로 도와가며"
	line "살아가고 있단다"
	prompt

_OakText5::
	text "하지만 우리들은 포켓몬 전부를"
	line "알고 있지는 못하다"

	para "포켓몬의 비밀은"
	line "아직도 잔뜩 있다!"

	para "나는 그것을 밝혀내기 위하여"
	line "매일 포켓몬의 연구를"
	cont "계속하고 있다는 말이다!"
	prompt
