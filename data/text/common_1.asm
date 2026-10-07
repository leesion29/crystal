_FruitBearingTreeText::
	text "열매가 열리는 나무가 있다!"
	done

_HeyItsFruitText::
	text "……@"
	text_ram wStringBuffer3
	text "(이)다!"
	done

_ObtainedFruitText::
	text "@"
	text_ram wStringBuffer3
	text "를(을)"
	line "손에 넣었다!"
	done

_FruitPackIsFullText::
	text "……그러나 가방이 가득 찼다!"
	done

_NothingHereText::
	text "아무것도 발견하지 못했다……"
	done

_WhichApricornText::
	text "Which APRICORN"
	line "should I use?"
	done

_HowManyShouldIMakeText::
	text "How many should I"
	line "make?"
	done

_RecoveredSomeHPText::
	text "@"
	text_ram wStringBuffer1
	text "의 체력이"
	line "@"
	text_decimal wCurHPAnimDeltaHP, 2, 3
	text " 회복되었다"
	done

_CuredOfPoisonText::
	text "@"
	text_ram wStringBuffer1
	text "의 독은"
	line "깨끗이 사라졌다!"
	done

_RidOfParalysisText::
	text "@"
	text_ram wStringBuffer1
	text "의 몸에"
	line "마비가 사라졌다"
	done

_BurnWasHealedText::
	text "@"
	text_ram wStringBuffer1
	text "의"
	line "화상이 회복되었다"
	done

_WasDefrostedText::
	text "@"
	text_ram wStringBuffer1
	text "의 몸에"
	line "얼음이 녹았다"
	done

_WokeUpText::
	text "@"
	text_ram wStringBuffer1
	text "는(은)"
	line "눈을 떴다"
	done

_HealthReturnedText::
	text "@"
	text_ram wStringBuffer1
	text "는(은)"
	line "건강하게 되었다!"
	done

_RevitalizedText::
	text "@"
	text_ram wStringBuffer1
	text "는(은)"
	line "기운을 되찾았다!"
	done

_GrewToLevelText::
	text "@"
	text_ram wStringBuffer1
	text "의 레벨이"
	line "@"
	text_decimal wCurPartyLevel, 1, 3
	text "(으)로 되었다@"
	sound_dex_fanfare_50_79 ; plays SFX_DEX_FANFARE_50_79, identical to SFX_LEVEL_UP
	text_promptbutton
	text_end

_CameToItsSensesText::
	text "@"
	text_ram wStringBuffer1
	text "는(은)"
	line "제 정신을 차렸다!"
	done

_EnterNewPasscodeText::
	text "Please enter any"
	line "four-digit number."
	done

_ConfirmPasscodeText::
	text "Enter the same"
	line "number to confirm."
	done

_PasscodesNotSameText::
	text "That's not the"
	line "same number."
	done

_PasscodeSetText::
	text "Your PASSCODE has"
	line "been set."

	para "Enter this number"
	line "next time to open"
	cont "the CARD FOLDER."

	para ""
	done

_FourZerosInvalidText::
	text "0000 is invalid!"

	para ""
	done

_EnterPasscodeText::
	text "Enter the CARD"
	next "FOLDER PASSCODE."
	done

_IncorrectPasscodeText::
	text "Incorrect"
	line "PASSCODE!"

	para ""
	done

_CardFolderOpenText::
	text "CARD FOLDER open.@"
	text_end

_OakTimeWokeUpText::
	text "<……><……><……><……><……><……>"
	line "<……><……><……><……><……><……>"

	para "으음- 음냐 음냐……"
	line "뭐야 벌써 이런 시간이……"

	cont "미안하지만 시계를 봐 주겠니?…"
	prompt

_OakTimeWhatTimeIsItText::
	text "지금은 몇시인가?"
	done

_OakTimeWhatHoursText::
	text "뭐야!"
	text_end

_OakTimeHoursQuestionMarkText::
	text "?"
	done

_OakTimeHowManyMinutesText::
	text "그래서 몇 분이라고?"
	done

_OakTimeWhoaMinutesText::
	text "뭐라!@"
	text_end

_OakTimeMinutesQuestionMarkText::
	text "!"
	done

_OakTimeOversleptText::
	text "!"
	line "이런! 마냥 잠만 잔 것 같군"
	done

_OakTimeYikesText::
	text "!"
	line "큰일이군! 거의 잠으로 때웠다!"
	done

_OakTimeSoDarkText::
	text "!"
	line "과연 어두운 것 같군!"
	done

_OakTimeWhatDayIsItText::
	text "오늘은 무슨 요일?"
	done

_OakTimeIsItText::
	text "…?"
	line "설마 틀리지는 않았겠지?"
	done

; Mobile Adapter

_ThereIsNothingConnectedText:: ; unreferenced
	text "There is nothing"
	line "connected."
	done

_CheckCellPhoneAdapterText:: ; unreferenced
	text "Check cell phone"
	line "adapter."
	done

_CheckCDMAAdapterText:: ; unreferenced
	text "Check CDMA"
	line "adapter."
	done

_CheckDOCOMOPHSAdapterText:: ; unreferenced
	text "Check DOCOMO PHS"
	line "adapter."
	done

_CheckDDIPHSAdapterText:: ; unreferenced
	text "Check DDI PHS"
	line "adapter."
	done

_CheckMobileAdapterText:: ; unreferenced
	text "Check unlimited"
	line "battle mobile"
	cont "adapter."
	done

; Mobile Adapter End

_ThePasswordIsText:: ; unreferenced
	text "The password is:"
	line ""
	done

_IsThisOKText:: ; unreferenced
	text "Is this OK?"
	done

_EnterTheIDNoText:: ; unreferenced
	text "Enter the"
	line "ID no."
	done

_EnterTheAmountText:: ; unreferenced
	text "Enter the"
	line "amount."
	done

_NothingToChooseText::
	text "고를 수 있는 것이 없습니다!"
	prompt

_WhichSidePutOnText::
	text "어느 쪽으로 배치하겠습니까?"
	done

_WhichSidePutAwayText::
	text "어느 쪽을 정리하겠습니까?"
	done

_PutAwayTheDecoText::
	text "@"
	text_ram wStringBuffer3
	text "를(을)"
	line "정리했다"
	prompt

_NothingToPutAwayText::
	text "정리할 것이 없습니다"
	prompt

_SetUpTheDecoText::
	text "@"
	text_ram wStringBuffer3
	text "를(을)"
	line "놓아두었습니다"
	prompt

_PutAwayAndSetUpText::
	text "@"
	text_ram wStringBuffer3
	text "를(을) 치우고"
	line "@"
	text_ram wStringBuffer4
	text "를(을)"
	cont "놓아두었습니다"
	prompt

_AlreadySetUpText::
	text "이미 놓여져 있습니다"
	prompt

_LookTownMapText::
	text "타운맵이 있다!"
	done

_LookPikachuPosterText::
	text "귀여운 피카츄의 포스터다"
	done

_LookClefairyPosterText::
	text "귀여운 삐삐의 포스터다"
	done

_LookJigglypuffPosterText::
	text "귀여운 푸린의 포스터다"
	done

_LookAdorableDecoText::
	text "@"
	text_ram wStringBuffer3
	text "(이)가 있다!"
	done

_LookGiantDecoText::
	text "커다란 인형이 있다!"
	line "푹신하고 기분 좋을 것 같은……"
	done

_MomHiHowAreYouText::
	text "여보세요"
	line "<PLAYER> 안녕?"
	prompt

_MomFoundAnItemText::
	text "어제 쇼핑을 갔다가"
	line "좋아 보이는 도구를 팔고 있어서"
	prompt

_MomBoughtWithYourMoneyText::
	text "<PLAYER>의 돈으로"
	line "사버렸어! 미안!"
	prompt

_MomItsInPCText::
	text "그렇지만 컴퓨터에 넣어두었으니까"
	line "쓰거라! 반드시 도움이 될 꺼야!"
	done

_MomFoundADollText::
	text "어제 쇼핑을 갔다가"

	para "아주 귀여운"
	line "인형을 팔고있기에……"
	prompt

_MomItsInYourRoomText::
	text "방에 놓아두었으니까 보거라!"
	line "꼭 마음에 들꺼라고 생각해!"
	done

_MonWasSentToText::
	text "@"
	text_ram wPlayerTrademonSpeciesName
	text "을(를)"
	line "@"
	text_ram wOTTrademonSenderName
	text "에게 전송했다!"
	done

_MonNameSentToText::
	text_start
	done

_BidsFarewellToMonText::
	text "@"
	text_ram wOTTrademonSenderName
	text "(이)가"
	line "당신에게"
	done

_MonNameBidsFarewellText::
	text "@"
	text_ram wOTTrademonSpeciesName
	text "를(을)"
	line "전송합니다"
	done

_TakeGoodCareOfMonText::
	text "@"
	text_ram wOTTrademonSpeciesName
	text "를(을)"
	line "귀여워해 줘!"
	done

_ForYourMonSendsText::
	text "@"
	text_ram wPlayerTrademonSenderName
	text "(이)가"
	line "@"
	text_ram wPlayerTrademonSpeciesName
	text "를(을) 보내는 대신"
	done

_OTSendsText::
	text "@"
	text_ram wOTTrademonSenderName
	text "는(은)"
	line "@"
	text_ram wOTTrademonSpeciesName
	text "를(을) 보냅니다"
	done

_WillTradeText::
	text "이제부터"
	line "@"
	text_ram wOTTrademonSenderName
	text "의 @"
	text_ram wOTTrademonSpeciesName
	text "과(와)"
	done

_ForYourMonWillTradeText::
	text "@"
	text_ram wPlayerTrademonSenderName
	text "의 @"
	text_ram wPlayerTrademonSpeciesName
	text "를(을)"
	line "교환합니다!"
	done

; Oak's Pokémon Talk

_MobilePlayerWillTradeMonText::
	text_ram wPlayerTrademonSenderName
	text " will"
	line "trade @"
	text_ram wPlayerTrademonSpeciesName
	text_end

	text_end ; unreferenced

_MobileForPartnersMonText::
	text "for @"
	text_ram wOTTrademonSenderName
	text "'s"
	line "@"
	text_ram wOTTrademonSpeciesName
	text "."
	done

_MobilePlayersMonTradeText::
	text_ram wPlayerTrademonSenderName
	text "'s"
	line "@"
	text_ram wPlayerTrademonSpeciesName
	text " trade…"
	done

_MobileTakeGoodCareOfMonText::
	text "Take good care of"
	line "@"
	text_ram wOTTrademonSpeciesName
	text "."
	done

_MobilePlayersMonTrade2Text::
	text_ram wPlayerTrademonSenderName
	text "'s"
	line "@"
	text_ram wPlayerTrademonSpeciesName
	text " trade…"
	done

_MobileTakeGoodCareOfText::
	text "Take good care of"
	line "@"
	text_ram wOTTrademonSpeciesName
	text "."
	done

_MobileTradeCameBackText::
	text_ram wOTTrademonSpeciesName
	text " came"
	line "back!"
	done

; Oak's Pokémon Talk

_OPT_IntroText1::
	text_start
	line "호두『오박사님의"
	done

_OPT_IntroText2::
	text_start
	line "포켓몬 강좌!"
	done

_OPT_IntroText3::
	text_start
	line "함께하는 진행자는 호두입니다!"
	done

_OPT_OakText1::
	text_start
	line "오박사『@"
	text_ram wMonOrItemNameBuffer
	text "는(은)"
	done

_OPT_OakText2::
	text_start
	line "@"
	text_ram wStringBuffer1
	text "에서"
	done

_OPT_OakText3::
	text_start
	line "서식하고 있는 것 같다"
	done

_OPT_MaryText1::
	text_start
	line "호두『@"
	text_ram wStringBuffer1
	text "(이)라는 것은 "
	done

_OPT_SweetAdorablyText::
	text_start
	line "눈에 넣어도 아프지 않을 정도로"
	done

_OPT_WigglySlicklyText::
	text_start
	line "꿈틀꿈틀하고서"
	done

_OPT_AptlyNamedText::
	text_start
	line "이름 그대로"
	done

_OPT_UndeniablyKindOfText::
	text_start
	line "정말 말을 듣고보니까"
	done

_OPT_UnbearablyText::
	text_start
	line "더 이상 참을 수 없을 정도로"
	done

_OPT_WowImpressivelyText::
	text_start
	line "이것이 꽤나 어째서"
	done

_OPT_AlmostPoisonouslyText::
	text_start
	line "색이 강렬해서"
	done

_OPT_SensuallyText::
	text_start
	line "야하게 보이고"
	done

_OPT_MischievouslyText::
	text_start
	line "도깨비처럼"
	done

_OPT_TopicallyText::
	text_start
	line "근처에서도 소문이 자자할 정도로"
	done

_OPT_AddictivelyText::
	text_start
	line "나쁜 버릇이 될 정도로"
	done

_OPT_LooksInWaterText::
	text_start
	line "강 근처에서"
	done

_OPT_EvolutionMustBeText::
	text_start
	line "진화하거나 뭔가를 하면"
	done

_OPT_ProvocativelyText::
	text_start
	line "여러 의미로"
	done

_OPT_FlippedOutText::
	text_start
	line "뒤집어본다면"
	done

_OPT_HeartMeltinglyText::
	text_start
	line "지켜주고 싶을 정도로"
	done

_OPT_CuteText::
	text_start
	line "귀엽지요"
	done

_OPT_WeirdText::
	text_start
	line "이상해-"
	done

_OPT_PleasantText::
	text_start
	line "기분이 좋군요"
	done

_OPT_BoldSortOfText::
	text_start
	line "약간 대담하다고 하는 기분"
	done

_OPT_FrighteningText::
	text_start
	line "무섭지 않니?"
	done

_OPT_SuaveDebonairText::
	text_start
	line "순조롭게 진행되고 있는 것 같네!"
	done

_OPT_PowerfulText::
	text_start
	line "강하구나-"
	done

_OPT_ExcitingText::
	text_start
	line "박력이 있어 보여"
	done

_OPT_GroovyText::
	text_start
	line "groovy!"
	done

_OPT_InspiringText::
	text_start
	line "푹 빠져버릴 것 같아-!"
	done

_OPT_FriendlyText::
	text_start
	line "동료로 삼고싶을지도 몰라"
	done

_OPT_HotHotHotText::
	text_start
	line "몸이 달아오르겠어!"
	done

_OPT_StimulatingText::
	text_start
	line "감전되겠어!"
	done

_OPT_GuardedText::
	text_start
	line "소중히 하고싶어!"
	done

_OPT_LovelyText::
	text_start
	line "헤롱헤롱한 기분!"
	done

_OPT_SpeedyText::
	text_start
	line "동작이 재빠른 것 같네!"
	done

_OPT_PokemonChannelText::
	text "포켓몬"
	done

_PokedexShowText::
	text_start
	line "@"
	text_ram wStringBuffer1
	text_end

; Pokémon Music Channel / Pokémusic

_BenIntroText1::
	text_start
	line "준화『포켓몬 뮤직"
	done

_BenIntroText2::
	text_start
	line "채널!"
	done

_BenIntroText3::
	text_start
	line "DJ는 준화입니다"
	done

_FernIntroText1::
	text_start
	line "석호『포켓몬 노래의 광장!"
	done

_FernIntroText2::
	text_start
	line "DJ는 석호인 것이다-"
	done

_BenFernText1::
	text_start
	line "오늘은 @"
	text_today
	text "(이)라는 것으로"
	done

_BenFernText2A::
	text_start
	line "포켓몬들도 건강해지는"
	done

_BenFernText2B::
	text_start
	line "포켓몬들도 새근새근 잠드는"
	done

_BenFernText3A::
	text_start
	line "포켓몬 마치!"
	done

_BenFernText3B::
	text_start
	line "포켓몬 자장가다!"
	done

; Lucky Channel

_LC_Text1::
	text_start
	line "난영『야아! 라디오를 듣고 있어"
	done

_LC_Text2::
	text_start
	line "모두 요즘 상태는 어때?"
	done

_LC_Text3::
	text_start
	line "즐거운 그대도 저기압인 그대도"
	done

_LC_Text4::
	text_start
	line "이번주의 행운의 넘버"
	done

_LC_Text5::
	text_start
	line "이야기 해보자!"
	done

_LC_Text6::
	text_start
	line "그럼 발표합니다"
	done

_LC_Text7::
	text_start
	line "이번주 행운의 넘버는"
	done

_LC_Text8::
	text_start
	line "@"
	text_pause
	text_dots 3
	text_ram wStringBuffer1
	text "!"
	done

_LC_Text9::
	text_start
	line "다시한번 이야기합니다"
	done

_LC_Text10::
	text_start
	line "이 숫자가 맞았으면"
	done

_LC_Text11::
	text_start
	line "지금바로 라디오타워로 컴온!"
	done

_LC_DragText1::
	text_start
	line "@"
	text_dots 3
	text "같은 것만 이야기하면"
	done

_LC_DragText2::
	text_start
	line "피곤해진다구- 뭐"
	done

; Places and People

_PnP_Text1::
	text_start
	line "그때 그사람!"
	done

_PnP_Text2::
	text_start
	line "이 방송은 저 리리스가"
	done

_PnP_Text3::
	text_start
	line "보내드립니다!"
	done

_PnP_Text4::
	text_start
	line "@"
	text_ram wStringBuffer2
	text "의"
	done

	text_start
	line "@"
	text_ram wStringBuffer1
	text "(이)라는 것"
	done

_PnP_CuteText::
	text_start
	line "귀엽군요"
	done

_PnP_LazyText::
	text_start
	line "나무늘보일지도 몰라"
	done

_PnP_HappyText::
	text_start
	line "언제나 좋은 기분"
	done

_PnP_NoisyText::
	text_start
	line "매우 생기 있고"
	done

_PnP_PrecociousText::
	text_start
	line "약간 느림보씨"
	done

_PnP_BoldText::
	text_start
	line "약간 대담"
	done

_PnP_PickyText::
	text_start
	line "입만 시끄러운 것 같군요!"
	done

_PnP_SortOfOKText::
	text_start
	line "나름대로…네"
	done

_PnP_SoSoText::
	text_start
	line "나로서는 그럭저럭일지도?"
	done

_PnP_GreatText::
	text_start
	line "정말은 대단할지도 몰라"
	done

_PnP_MyTypeText::
	text_start
	line "나한테 있어서는 타입일지도!"
	done

_PnP_CoolText::
	text_start
	line "잘 활용하고 있다고 생각하지않니?"
	done

_PnP_InspiringText::
	text_start
	line "나 푹 빠져버릴 것 같아!"
	done

_PnP_WeirdText::
	text_start
	line "생각해보면 이상해!"
	done

_PnP_RightForMeText::
	text_start
	line "나에 대해 어떻게 생각하고 있을까?"
	done

_PnP_OddText::
	text_start
	line "역시 이상해!"
	done

_PnP_Text5::
	text_start
	line "@"
	text_ram wStringBuffer1
	text "(이)라는 것"
	done

_RocketRadioText1::
	text_start
	line "……@"
	text_pause
	text "아-@"
	text_pause
	text "……@"
	text_pause
	text "우리들은"
	done

_RocketRadioText2::
	text_start
	line "우는 애도 울음을 그치는 로켓단!"
	done

_RocketRadioText3::
	text_start
	line "조직의 재건을 실행했다"
	done

_RocketRadioText4::
	text_start
	line "3년간의 노력이 결실을 맺었다"
	done

_RocketRadioText5::
	text_start
	line "지금 여기에 로켓단의"
	done

_RocketRadioText6::
	text_start
	line "부활을 선언한다!"
	done

_RocketRadioText7::
	text_start
	line "비주기님! @"
	text_pause
	text "…… @"
	text_pause
	text "들리십니까?"
	done

_RocketRadioText8::
	text_start
	line "…… @"
	text_pause
	text "결국 해냈습니다!"
	done

_RocketRadioText9::
	text_start
	line "두목님은 어디에 계시는 걸까@"
	text_pause
	text "……?"
	done

_RocketRadioText10::
	text_start
	line "라디오를 듣고 있을까@"
	text_pause
	text "…… @"
	text_pause
	text "……"
	done

_BuenaRadioText1::
	text_start
	line "BUENA: BUENA here!"
	done

_BuenaRadioText2::
	text_start
	line "Today's password!"
	done

_BuenaRadioText3::
	text_start
	line "Let me think… It's"
	done

_BuenaRadioText4::
	text_start
	line "@"
	text_ram wStringBuffer1
	text "!"
	done

_BuenaRadioText5::
	text_start
	line "Don't forget it!"
	done

_BuenaRadioText6::
	text_start
	line "I'm in GOLDENROD's"
	done

_BuenaRadioText7::
	text_start
	line "RADIO TOWER!"
	done

_BuenaRadioMidnightText1::
	text_start
	line "BUENA: Oh my…"
	done

_BuenaRadioMidnightText2::
	text_start
	line "It's midnight! I"
	done

_BuenaRadioMidnightText3::
	text_start
	line "have to shut down!"
	done

_BuenaRadioMidnightText4::
	text_start
	line "Thanks for tuning"
	done

_BuenaRadioMidnightText5::
	text_start
	line "in to the end! But"
	done

_BuenaRadioMidnightText6::
	text_start
	line "don't stay up too"
	done

_BuenaRadioMidnightText7::
	text_start
	line "late! Presented to"
	done

_BuenaRadioMidnightText8::
	text_start
	line "you by DJ BUENA!"
	done

_BuenaRadioMidnightText9::
	text "I'm outta here!"
	done

_BuenaRadioMidnightText10::
	text "…"
	done

_BuenaOffTheAirText::
	text_start
	line ""
	done

_EnemyWithdrewText::
	text "<ENEMY>는(은)"
	line "@"
	text_ram wEnemyMonNickname
	text "를(을)"
	cont "도로 불러 들였다!"
	prompt

_EnemyUsedOnText::
	text "<ENEMY>는(은)"
	line "@"
	text_ram wEnemyMonNickname
	text "에게"

	para "@"
	text_ram wMonOrItemNameBuffer
	text "를(을)"
	line "사용했다!"
	prompt

_ThatCantBeUsedRightNowText:: ; unreferenced
	text "That can't be used"
	line "right now."
	prompt

_ThatItemCantBePutInThePackText:: ; unreferenced
	text "That item can't be"
	line "put in the PACK."
	done

_TheItemWasPutInThePackText:: ; unreferenced
	text "The @"
	text_ram wStringBuffer1
	text_start
	line "was put in the"
	cont "PACK."
	done

_RemainingTimeText:: ; unreferenced
	text "Remaining Time"
	done

_YourMonsHPWasHealedText:: ; unreferenced
	text "Your #MON's HP"
	line "was healed."
	prompt

_WarpingText:: ; unreferenced
	text "Warping…"
	done

_ChangeWhichNumberText:: ; unreferenced
	text "Which number"
	line "should be changed?"
	done

_WillYouPlayWithMonText:: ; unreferenced
	text "Will you play with"
	line "@"
	text_ram wStringBuffer2
	text "?"
	done

_YouNeedTwoMonForBreedingText:: ; unreferenced
	text "You need two #-"
	line "MON for breeding."
	prompt

_BreedingIsNotPossibleText:: ; unreferenced
	text "Breeding is not"
	line "possible."
	prompt

_CompatibilityShouldTheyBreedText:: ; unreferenced
	text "The compatibility"
	line "is @"
	text_decimal wBreedingCompatibility, 1, 3
	text "."
	cont "Should they breed?"
	done

_ThereIsNoEggText:: ; unreferenced
	text "There is no EGG."
	line ""
	prompt

_ItsGoingToHatchText:: ; unreferenced
	text "It's going to"
	line "hatch!"
	prompt

_TestEventText:: ; unreferenced
	text "Test event"
	line "@"
	text_decimal wStringBuffer2, 1, 2
	text "?"
	done

_StartText:: ; unreferenced
	text "Start!"
	done

_EndText:: ; unreferenced
	text "End!"
	done

_ForABoyText:: ; unreferenced
	text "For a boy!"
	done

_ForAGirlText:: ; unreferenced
	text "For a girl!"
	done

_DoesntConcernABoyText:: ; unreferenced
	text "This doesn't"
	line "concern a boy!"
	done

_TheBoxIsFullText:: ; unreferenced
	text "The BOX is full!"
	done

; Mobile Adapter

_NewCardArrivedText::
	text "A new CARD arrived"
	line "from @"
	text_ram wStringBuffer2
	text "."
	done

_PutCardInCardFolderText::
	text "Put this CARD in"
	line "the CARD FOLDER?"
	done

_CardWasListedText::
	text_ram wStringBuffer2
	text "'s CARD was"
	line "listed as no.@"
	text_decimal wStringBuffer1, 1, 2
	text "."
	prompt

_StartingLinkText::
	text "Starting link."
	done

_LinkTerminatedText::
	text "Link terminated."
	done

_ClosingLinkText::
	text "Closing link."
	done

_ClearTimeLimitText:: ; unreferenced
	text "Clear the time"
	line "limit?"
	done

_TimeLimitWasClearedText:: ; unreferenced
	text "The time limit was"
	line "cleared."
	done

_PickErrorPacketText:: ; unreferenced
	text "Pick which packet"
	line "as an error?"
	done

_TradingMonForOTMonText::
	text "Trading @"
	text_ram wStringBuffer2
	text_start
	line "for @"
	text_ram wStringBuffer1
	text "…"
	done

; Mobile Adapter End

_ObtainedTheVoltorbBadgeText:: ; unreferenced
	text "Obtained the"
	line "VOLTORBBADGE!"
	done

_AskFloorElevatorText::
	text "몇층에 가십니까?"
	done

_BugCatchingContestTimeUpText::
	text "아나운서『딩동댕!"

	para "시간이 되었습니다!"
	done

_BugCatchingContestIsOverText::
	text "아나운서『곤충채집 대회"
	line "끝났습니다!"
	done

_RepelWoreOffText::
	text "스프레이의 효과가 떨어졌다"
	done

_PlayerFoundItemText::
	text "<PLAYER>는(은)"
	line "@"
	text_ram wStringBuffer3
	text "를(을)"
	cont "발견했다!"
	done

_ButNoSpaceText::
	text "그러나 <PLAYER>는(은)"
	line "도구를 더 이상 지닐 수 없다!"
	done

_JustSawSomeRareMonText::
	text "지금 @"
	text_ram wStringBuffer2
	text "에서"
	line "희귀한 @"
	text_ram wStringBuffer1
	text_start
	cont "를(을) 봤어!"

	para "또 희귀한 포켓몬을"
	line "발견하면 전화할께!"
	prompt

_SavingRecordText::
	text "전당등록 데이터를 쓰고 있는 중"
	line "전원을 끊지 말아주세요"
	done

_ReceiveItemText::
	text "@"
	text_ram wPlayerName
	text "는(은)"
	line "배달원으로부터"
	cont "@"
	text_ram wStringBuffer1
	text "를(을) 받았다@"
	sound_item
	text_promptbutton
	text_end

_NoCoinsText::
	text "동전을 가지고 있지 않습니다!"
	prompt

_NoCoinCaseText::
	text "동전 케이스가 없습니다!!"
	prompt

_NPCTradeCableText::
	text "자-"
	line "케이블을 연결해서……그리고"
	prompt

Text_NPCTraded::
	text "<PLAYER>는(은)"
	line "@"
	text_ram wMonOrItemNameBuffer
	text "와(과)"
	cont "@"
	text_ram wStringBuffer2
	text "를(을)"
	cont "교환했다!@"
	text_end

_NPCTradeFanfareText::
	text "@"
	sound_dex_fanfare_80_109
	text_pause
	text_end

_NPCTradeIntroText1::
	text "나, 포켓몬 모으고 있어!"
	line "너는 @"
	text_ram wStringBuffer1
	text "를(을)"
	cont "가지고 있니?"

	para "내 @"
	text_ram wStringBuffer2
	text "(이)랑"
	line "교환할래?"
	done

_NPCTradeCancelText1::
	text "바꿔주지 않을꺼니?"
	line "쳇, 실망이다……"
	done

_NPCTradeWrongText1::
	text "얼라리……?"
	line "@"
	text_ram wStringBuffer1
	text "(이)가 아니야"
	cont "쳇, 유감이로군……"
	done

_NPCTradeCompleteText1::
	text "신난다!"
	line "@"
	text_ram wStringBuffer1
	text "(이)가"
	cont "손에 들어왔다"
	cont "고마워!"
	done

_NPCTradeAfterText1::
	text "야아!"
	line "나랑 바꿨던 @"
	text_ram wStringBuffer2
	text_start
	cont "잘 지내니?"
	done

_NPCTradeIntroText2::
	text "이봐 너……"
	line "찾는 포켓몬이 있는데"

	para "만일 @"
	text_ram wStringBuffer1
	text "를(을)"
	line "가지고 있다면"
	cont "내 @"
	text_ram wStringBuffer2
	text "(이)랑"
	cont "교환하지 않을래?"
	done

_NPCTradeCancelText2::
	text "너도 가지고 있지 않다고?……"
	line "유감이군……"
	done

_NPCTradeWrongText2::
	text "@"
	text_ram wStringBuffer1
	text "을(를)"
	line "가지고 있지 않니?"
	cont "그럼 할 수 없군……"
	done

_NPCTradeCompleteText2::
	text "오오!"
	line "고맙다!"

	para "드디어 @"
	text_ram wStringBuffer1
	text "(이)가"
	line "손에 들어왔어!"
	done

_NPCTradeAfterText2::
	text "오오!"

	para "네게 받은 @"
	text_ram wMonOrItemNameBuffer
	text_start
	line "는(은) 매우 건강하단다!"
	done

_NPCTradeIntroText3::
	text "@"
	text_ram wMonOrItemNameBuffer
	text " 귀엽지!"
	line "하지만 나는 가지고 있지 않아……"
	cont "너 @"
	text_ram wStringBuffer1
	text_start
	cont "가지고 있니?"

	para "내 @"
	text_ram wStringBuffer2
	text "(이)랑"
	line "교환하자!"
	done

_NPCTradeCancelText3::
	text "교환하지 않는다구?"
	line "에이…… 실망……"
	done

_NPCTradeWrongText3::
	text "@"
	text_ram wStringBuffer1
	text "(이)가"
	line "아니잖아"
	cont "그거 잡으면 바꿔줘!"
	done

_NPCTradeCompleteText3::
	text "와아! 고마워!"
	line "@"
	text_ram wMonOrItemNameBuffer
	text " 갖고싶었어!"
	done

_NPCTradeAfterText3::
	text "교환했던 @"
	text_ram wStringBuffer2
	text_start
	line "잘 있니?"
	cont "@"
	text_ram wMonOrItemNameBuffer
	text "는(은)"
	cont "엄청 귀여워!"
	done

_NPCTradeCompleteText4::
	text "Uh? What happened?"
	done

_NPCTradeAfterText4::
	text "Trading is so odd…"

	para "I still have a lot"
	line "to learn about it."
	done

_MomLeavingText1::
	text "와아 귀여운 포켓몬이네"
	line "어쩐 일이니?"

	para "…………………………"
	line "……그래…… 모험을 떠나는구나"

	para "좋아!"
	line "엄마도 협력해 줄게"
	cont "뭘 할 수 있을까……?"

	para "맞아!"
	line "돈을 맡아줄게"

	para "긴 여행이 될 것 같으니까"
	line "돈을 소중히 해야지!"

	para "어때, 저금할래?"
	done

_MomLeavingText2::
	text "저금한다고?"
	line "맡겨줘!"

	para "…………………………"
	prompt

_MomLeavingText3::
	text "……몸조심하거라"

	para "포켓몬은 소중한 친구"
	line "힘을 합쳐 분발하는거야"

	para "잘 다녀와라!"
	done

_MomIsThisAboutYourMoneyText::
	text "어서오너라!"
	line "열심히하고 있는 것 같네"

	para "2층은 잘 정리되어있단다"
	line "그게 아니면 저금때문이니?"
	done

_MomBankWhatDoYouWantToDoText::
	text "뭘 하겠니?"
	done

_MomStoreMoneyText::
	text "얼마 맡길꺼니?"
	done

_MomTakeMoneyText::
	text "얼마 찾아갈꺼야?"
	done

_MomSaveMoneyText::
	text "저금할래?"
	done

_MomHaventSavedThatMuchText::
	text "그렇게 많이 맡아두지 않았어"
	prompt

_MomNotEnoughRoomInWalletText::
	text "그렇게 많이 가지고 갈 수 없어"
	prompt

_MomInsufficientFundsInWalletText::
	text "그렇게 많이 지니고 있지 않잖아"
	prompt

_MomNotEnoughRoomInBankText::
	text "그렇게 맡아둘 수 없어"
	prompt

_MomStartSavingMoneyText::
	text "저금한다고?"
	line "맡겨둬!"

	para "<PLAYER>! 힘내라!"
	done

_MomStoredMoneyText::
	text "소중히 맡아둘께"
	line "힘내!"
	done

_MomTakenMoneyText::
	text "<PLAYER>! 힘내거라!"
	done

_MomJustDoWhatYouCanText::
	text "무리하지 말거라"
	done

_DaycareDummyText::
	text_start
	done

_DayCareManIntroText::
	text "나는 보모 할아버지다"
	line "뭔가 양육시키고싶은가?"
	done

_DayCareManIntroEggText::
	text "나는 보모 할아버지다"
	line "알에 대한 이야기 해줄까?"

	para "할멈과 포켓몬을 양육하고 있는데"
	line "………깜짝 놀랬단다!"

	para "어쩐지! 알이 있더군!"
	line "이상한 일도 있지"

	para "어떤가?"
	line "네 포켓몬의 양육을 맡겨보겠니?"
	done

_DayCareLadyIntroText::
	text "나는 보모 할머니다"
	line "뭔가 양육시키고싶은가?"
	done

_DayCareLadyIntroEggText::
	text "나는 보모 할머니다"
	line "알에 대한 이야기 해줄까?"

	para "할아범과 포켓몬을 양육하고 있는데"
	line "………깜짝 놀랬단다!"

	para "어쩐지! 알이 있더군!"
	line "이상한 일도 있지"

	para "어떤가?"
	line "네 포켓몬의 양육을 맡겨보겠니?"
	done

_WhatShouldIRaiseText::
	text "그럼"
	line "어느 것을 양육해보겠니?"
	prompt

_OnlyOneMonText::
	text "으응? 포켓몬이"
	line "1마리밖에 없는 것 같구만"
	prompt

_CantAcceptEggText::
	text "미안하지만"
	line "알은 맡아줄 수 없단다"
	prompt

_RemoveMailText::
	text "그전에"
	line "메일을 빼놓고 오거라"
	prompt

_LastHealthyMonText::
	text "그것을 맡긴다면"
	line "싸울 수 없게 되어버릴껄"
	prompt

_IllRaiseYourMonText::
	text "알겠다"
	line "잠시 @"
	text_ram wStringBuffer1
	text "를(을)"
	cont "맡아두마"
	prompt

_ComeBackLaterText::
	text "적당히 시간이 지나면"
	line "또 오너라"
	done

_AreWeGeniusesText::
	text "역시 우리들은 천재인가봐!"
	line "너의 @"
	text_ram wStringBuffer1
	text " 봐 볼까"
	done

_YourMonHasGrownText::
	text "자네의 @"
	text_ram wStringBuffer1
	text_start
	line "꽤 성장했단다"

	para "그렇지, 레벨로 말하자면"
	line "@"
	text_decimal wStringBuffer2 + 1, 1, 3
	text "정도로 키웠단다"

	para "……음, 포켓몬을 찾아간다면"
	line "요금은 @"
	text_decimal wStringBuffer2 + 2, 3, 4
	text "원일세!"
	done

_PerfectHeresYourMonText::
	text "자 여기!"
	line "그럼 포켓몬 데리고가거라"
	prompt

_GotBackMonText::
	text "<PLAYER>는(은) 보모로부터"
	line "@"
	text_ram wStringBuffer1
	text "를(을)"
	cont "찾았다!"
	prompt

_BackAlreadyText::
	text "뭐야, 벌써 왔는가?"
	line "너의 @"
	text_ram wStringBuffer1
	text "는(은)…"

	para "아직 약간"
	line "시간이 걸릴 것 같다"

	para "……그래도 포켓몬을 찾아간다면"
	line "요금은 100원이다"
	done

_HaveNoRoomText::
	text "그 이상은 지닐 수 없단다"
	prompt

_NotEnoughMoneyText::
	text "돈이 부족한 것 같구만"
	prompt

_OhFineThenText::
	text "그래, 그렇다면"
	prompt

_ComeAgainText::
	text "또 오너라"
	done

_NotYetText::
	text "아직이란다"
	done

_FoundAnEggText::
	text "오오! 자넨가"

	para "맡고있던 포켓몬을"
	line "양육하고 있으니까……이런일이!"

	para "포켓몬이 알을"
	line "가지고 있더군!"

	para "어디서 가지고 왔는지 모르겠지만"
	line "너의 포켓몬이 가지고 왔겠지!"
	cont "역시 가지고싶겠지?"
	done

_ReceivedEggText::
	text "<PLAYER>는(은) 보모로부터"
	line "알을 건네어 받았다!"
	done

_TakeGoodCareOfEggText::
	text "소중히 키우거라"
	done

_IllKeepItThanksText::
	text "그렇다면 내가 받지"
	line "고맙구나"
	done

_NoRoomForEggText::
	text "그 이상은 지니고 갈 수 없단다"
	line "다음 번에 가지고가거라"
	done

_WhichMonPhotoText::
	text "어느 포켓몬을"
	line "촬영할껀가?"
	prompt

_HoldStillText::
	text "좋아!"
	line "잠시 가만 있거라"
	prompt

_PrestoAllDoneText::
	text "자! 다 끝났다!"
	line "또 오너라"
	done
