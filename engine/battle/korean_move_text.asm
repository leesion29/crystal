; Battle-only OldGold names. Do not change the common English MoveNames table.
; ID order checked against both move_constants.asm files (251 moves).
BattleListMoves:
; BC = first baseline coordinate. Render directly from ROM, no short name buffer.
	ld h, b
	ld l, c
	ld de, wListMoves_MoveIndicesBuffer
	ld b, 0
.loop
	ld a, [de]
	inc de
	and a
	jr z, .empty
	push de
	push hl
	push bc
	dec a
	ld hl, BattleMoveNamePointers
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop bc
	pop hl
	push hl
	push bc
	call PlaceString
	pop bc
	ld a, b
	ld [wNumMoves], a
	inc b
	pop hl
	push bc
	ld a, [wListMovesLineSpacing]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	pop de
	ld a, b
	cp NUM_MOVES
	jr nz, .loop
	ret
.empty
	ld a, b
.empty_loop
	push af
	ld de, .EmptyMove
	call PlaceString
	ld a, [wListMovesLineSpacing]
	ld c, a
	ld b, 0
	add hl, bc
	pop af
	inc a
	cp NUM_MOVES
	jr nz, .empty_loop
	ret

.EmptyMove:
	db "-@"

BattlePlaceMoveType:
; BC = output baseline; UpdateMoveData supplied the real Crystal type.
	push bc
	ld a, [wPlayerMoveStruct + MOVE_TYPE]
	ld hl, BattleMoveTypeNames
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	jp PlaceString

BattleMoveNamePointers:
	table_width 2
	dw .m1
	dw .m2
	dw .m3
	dw .m4
	dw .m5
	dw .m6
	dw .m7
	dw .m8
	dw .m9
	dw .m10
	dw .m11
	dw .m12
	dw .m13
	dw .m14
	dw .m15
	dw .m16
	dw .m17
	dw .m18
	dw .m19
	dw .m20
	dw .m21
	dw .m22
	dw .m23
	dw .m24
	dw .m25
	dw .m26
	dw .m27
	dw .m28
	dw .m29
	dw .m30
	dw .m31
	dw .m32
	dw .m33
	dw .m34
	dw .m35
	dw .m36
	dw .m37
	dw .m38
	dw .m39
	dw .m40
	dw .m41
	dw .m42
	dw .m43
	dw .m44
	dw .m45
	dw .m46
	dw .m47
	dw .m48
	dw .m49
	dw .m50
	dw .m51
	dw .m52
	dw .m53
	dw .m54
	dw .m55
	dw .m56
	dw .m57
	dw .m58
	dw .m59
	dw .m60
	dw .m61
	dw .m62
	dw .m63
	dw .m64
	dw .m65
	dw .m66
	dw .m67
	dw .m68
	dw .m69
	dw .m70
	dw .m71
	dw .m72
	dw .m73
	dw .m74
	dw .m75
	dw .m76
	dw .m77
	dw .m78
	dw .m79
	dw .m80
	dw .m81
	dw .m82
	dw .m83
	dw .m84
	dw .m85
	dw .m86
	dw .m87
	dw .m88
	dw .m89
	dw .m90
	dw .m91
	dw .m92
	dw .m93
	dw .m94
	dw .m95
	dw .m96
	dw .m97
	dw .m98
	dw .m99
	dw .m100
	dw .m101
	dw .m102
	dw .m103
	dw .m104
	dw .m105
	dw .m106
	dw .m107
	dw .m108
	dw .m109
	dw .m110
	dw .m111
	dw .m112
	dw .m113
	dw .m114
	dw .m115
	dw .m116
	dw .m117
	dw .m118
	dw .m119
	dw .m120
	dw .m121
	dw .m122
	dw .m123
	dw .m124
	dw .m125
	dw .m126
	dw .m127
	dw .m128
	dw .m129
	dw .m130
	dw .m131
	dw .m132
	dw .m133
	dw .m134
	dw .m135
	dw .m136
	dw .m137
	dw .m138
	dw .m139
	dw .m140
	dw .m141
	dw .m142
	dw .m143
	dw .m144
	dw .m145
	dw .m146
	dw .m147
	dw .m148
	dw .m149
	dw .m150
	dw .m151
	dw .m152
	dw .m153
	dw .m154
	dw .m155
	dw .m156
	dw .m157
	dw .m158
	dw .m159
	dw .m160
	dw .m161
	dw .m162
	dw .m163
	dw .m164
	dw .m165
	dw .m166
	dw .m167
	dw .m168
	dw .m169
	dw .m170
	dw .m171
	dw .m172
	dw .m173
	dw .m174
	dw .m175
	dw .m176
	dw .m177
	dw .m178
	dw .m179
	dw .m180
	dw .m181
	dw .m182
	dw .m183
	dw .m184
	dw .m185
	dw .m186
	dw .m187
	dw .m188
	dw .m189
	dw .m190
	dw .m191
	dw .m192
	dw .m193
	dw .m194
	dw .m195
	dw .m196
	dw .m197
	dw .m198
	dw .m199
	dw .m200
	dw .m201
	dw .m202
	dw .m203
	dw .m204
	dw .m205
	dw .m206
	dw .m207
	dw .m208
	dw .m209
	dw .m210
	dw .m211
	dw .m212
	dw .m213
	dw .m214
	dw .m215
	dw .m216
	dw .m217
	dw .m218
	dw .m219
	dw .m220
	dw .m221
	dw .m222
	dw .m223
	dw .m224
	dw .m225
	dw .m226
	dw .m227
	dw .m228
	dw .m229
	dw .m230
	dw .m231
	dw .m232
	dw .m233
	dw .m234
	dw .m235
	dw .m236
	dw .m237
	dw .m238
	dw .m239
	dw .m240
	dw .m241
	dw .m242
	dw .m243
	dw .m244
	dw .m245
	dw .m246
	dw .m247
	dw .m248
	dw .m249
	dw .m250
	dw .m251
	assert_table_length NUM_ATTACKS
.m1: db "막치기@"
.m2: db "태권당수@"
.m3: db "연속 뺨치기@"
.m4: db "연속펀치@"
.m5: db "메가톤펀치@"
.m6: db "고양이돈받기@"
.m7: db "불꽃펀치@"
.m8: db "냉동펀치@"
.m9: db "번개펀치@"
.m10: db "할퀴기@"
.m11: db "찝기@"
.m12: db "가위자르기@"
.m13: db "칼바람@"
.m14: db "칼춤@"
.m15: db "풀베기@"
.m16: db "바람일으키기@"
.m17: db "날개치기@"
.m18: db "날려버리기@"
.m19: db "공중날기@"
.m20: db "조이기@"
.m21: db "힘껏치기@"
.m22: db "덩쿨채찍@"
.m23: db "짓밟기@"
.m24: db "두번치기@"
.m25: db "메가톤킥@"
.m26: db "점프킥@"
.m27: db "돌려차기@"
.m28: db "모래뿌리기@"
.m29: db "박치기@"
.m30: db "뿔찌르기@"
.m31: db "마구찌르기@"
.m32: db "뿔드릴@"
.m33: db "몸통박치기@"
.m34: db "누르기@"
.m35: db "김밥말이@"
.m36: db "돌진@"
.m37: db "난동부리기@"
.m38: db "이판사판태클@"
.m39: db "꼬리흔들기@"
.m40: db "독침@"
.m41: db "더블니들@"
.m42: db "바늘미사일@"
.m43: db "째려보기@"
.m44: db "물기@"
.m45: db "울음소리@"
.m46: db "울부짖기@"
.m47: db "노래하기@"
.m48: db "초음파@"
.m49: db "소닉붐@"
.m50: db "사슬묶기@"
.m51: db "용해액@"
.m52: db "불꽃세례@"
.m53: db "화염방사@"
.m54: db "흰안개@"
.m55: db "물대포@"
.m56: db "하이드로펌프@"
.m57: db "파도타기@"
.m58: db "냉동빔@"
.m59: db "눈보라@"
.m60: db "환상빔@"
.m61: db "거품광선@"
.m62: db "오로라 빔@"
.m63: db "파괴광선@"
.m64: db "쪼기@"
.m65: db "회전부리@"
.m66: db "지옥의바퀴@"
.m67: db "잡치기@"
.m68: db "카운터@"
.m69: db "지구던지기@"
.m70: db "괴력@"
.m71: db "흡수@"
.m72: db "메가드레인@"
.m73: db "씨뿌리기@"
.m74: db "성장@"
.m75: db "잎날가르기@"
.m76: db "솔라빔@"
.m77: db "독가루@"
.m78: db "저리가루@"
.m79: db "수면가루@"
.m80: db "꽃잎댄스@"
.m81: db "실뿜기@"
.m82: db "용의분노@"
.m83: db "회오리불꽃@"
.m84: db "전기쇼크@"
.m85: db "10만볼트@"
.m86: db "전기자석파@"
.m87: db "번개 @"
.m88: db "돌떨구기@"
.m89: db "지진@"
.m90: db "땅가르기@"
.m91: db "구멍파기@"
.m92: db "맹독@"
.m93: db "염동력@"
.m94: db "사이코키네시스@"
.m95: db "최면술@"
.m96: db "요가포즈@"
.m97: db "고속이동@"
.m98: db "전광석화@"
.m99: db "분노@"
.m100: db "순간이동@"
.m101: db "나이트헤드@"
.m102: db "흉내내기@"
.m103: db "싫은소리@"
.m104: db "그림자 분신@"
.m105: db "HP 회복@"
.m106: db "단단해지기@"
.m107: db "작아지기@"
.m108: db "연막@"
.m109: db "이상한빛@"
.m110: db "껍질에숨기@"
.m111: db "웅크리기@"
.m112: db "배리어@"
.m113: db "빛의 장막@"
.m114: db "흑안개@"
.m115: db "리플렉터@"
.m116: db "기충전@"
.m117: db "참기@"
.m118: db "손가락흔들기@"
.m119: db "따라하기@"
.m120: db "자폭@"
.m121: db "알폭탄@"
.m122: db "핥기@"
.m123: db "스모그@"
.m124: db "오물공격@"
.m125: db "뼈다귀치기@"
.m126: db "불대문자@"
.m127: db "폭포오르기@"
.m128: db "껍질끼우기@"
.m129: db "스피드스타@"
.m130: db "로케트박치기@"
.m131: db "가시대포@"
.m132: db "휘감기@"
.m133: db "망각술@"
.m134: db "숟가락휘기@"
.m135: db "알낳기@"
.m136: db "무릎차기@"
.m137: db "뱀의미소@"
.m138: db "꿈먹기@"
.m139: db "독가스@"
.m140: db "알던지기@"
.m141: db "흡혈@"
.m142: db "악마의키스@"
.m143: db "불새@"
.m144: db "변신@"
.m145: db "거품@"
.m146: db "잼잼펀치@"
.m147: db "버섯포자@"
.m148: db "플래시@"
.m149: db "사이코웨이브@"
.m150: db "튀어오르기@"
.m151: db "녹기@"
.m152: db "찝게햄머@"
.m153: db "대폭발@"
.m154: db "마구할퀴기@"
.m155: db "뼈다귀부메랑@"
.m156: db "잠자기@"
.m157: db "스톤샤워@"
.m158: db "필살앞니@"
.m159: db "각지기@"
.m160: db "텍스쳐@"
.m161: db "트라이어택@"
.m162: db "분노의앞니@"
.m163: db "베어가르기@"
.m164: db "대타출동@"
.m165: db "발버둥@"
.m166: db "스케치@"
.m167: db "트리플 킥@"
.m168: db "도둑@"
.m169: db "거미집@"
.m170: db "마음의 눈@"
.m171: db "악몽@"
.m172: db "화염 자동차@"
.m173: db "코골기@"
.m174: db "저주@"
.m175: db "바둥바둥@"
.m176: db "텍스쳐2@"
.m177: db "에어로블레스트@"
.m178: db "목화포자@"
.m179: db "기사회생@"
.m180: db "원한@"
.m181: db "눈싸라기@"
.m182: db "방어@"
.m183: db "마하펀치@"
.m184: db "겁나는 얼굴@"
.m185: db "속여 때리기@"
.m186: db "천사의 키스@"
.m187: db "배북@"
.m188: db "오물 폭탄@"
.m189: db "진흙 뿌리기@"
.m190: db "대포무노포@"
.m191: db "압정 뿌리기@"
.m192: db "전자포@"
.m193: db "꿰뚫어 보기@"
.m194: db "길동무@"
.m195: db "멸망의 노래@"
.m196: db "얼다바람@"
.m197: db "선찰@"
.m198: db "본러쉬@"
.m199: db "록온@"
.m200: db "역린@"
.m201: db "모래바람@"
.m202: db "기가 드레인@"
.m203: db "버티기@"
.m204: db "애교부리기@"
.m205: db "구르기@"
.m206: db "칼등치기@"
.m207: db "뽐내기@"
.m208: db "우유 마시기@"
.m209: db "스파크@"
.m210: db "연속 자르기@"
.m211: db "강철 날개@"
.m212: db "검은 눈빛@"
.m213: db "헤롱헤롱@"
.m214: db "잠꼬대@"
.m215: db "치료방울@"
.m216: db "은혜갚기@"
.m217: db "프레젠트@"
.m218: db "화풀이@"
.m219: db "신비의 부적@"
.m220: db "아픔나누기@"
.m221: db "성스러운 불꽃@"
.m222: db "매그니튜드@"
.m223: db "폭발 펀치@"
.m224: db "메가폰@"
.m225: db "용의 숨결@"
.m226: db "바톤 터치@"
.m227: db "앵콜@"
.m228: db "따라가때리기@"
.m229: db "고속스핀@"
.m230: db "달콤한 향기@"
.m231: db "아이언테일@"
.m232: db "메탈크로우@"
.m233: db "받아 던지기@"
.m234: db "아침햇살@"
.m235: db "광합성@"
.m236: db "달의불빛@"
.m237: db "잠재파워@"
.m238: db "크로스촙@"
.m239: db "회오리@"
.m240: db "비바라기@"
.m241: db "쾌청@"
.m242: db "깨물어부수기@"
.m243: db "미러코트@"
.m244: db "자기암시@"
.m245: db "신속@"
.m246: db "원시의 힘@"
.m247: db "새도우볼@"
.m248: db "미래예지@"
.m249: db "바위깨기@"
.m250: db "바다 회오리@"
.m251: db "집단구타@"

BattleMoveTypeNames:
	table_width 2
	dw .normal, .fighting, .flying, .poison, .ground, .rock, .bird, .bug, .ghost, .steel
	assert_table_length UNUSED_TYPES
	rept UNUSED_TYPES_END - UNUSED_TYPES - 1
	dw .normal
	endr
	dw .curse
	assert_table_length UNUSED_TYPES_END
	dw .fire, .water, .grass, .electric, .psychic, .ice, .dragon, .dark
	assert_table_length TYPES_END
.normal: db "노말@"
.fighting: db "격투@"
.flying: db "비행@"
.poison: db "독@"
.ground: db "땅@"
.rock: db "바위@"
.bird: db "새@"
.bug: db "벌레@"
.ghost: db "고스트@"
.steel: db "강철@"
.curse: db "???@"
.fire: db "화염@"
.water: db "물@"
.grass: db "풀@"
.electric: db "전기@"
.psychic: db "에스퍼@"
.ice: db "얼음@"
.dragon: db "드래곤@"
.dark: db "악@"
