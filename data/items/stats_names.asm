; Status-screen-only Korean item names, ported from Korean Gold.
; Base item ID order checked against Crystal; EGG_TICKET is Crystal-specific.
; This is maintained here and never reads the reference project at build time.
PUSHS
SECTION "Korean Stats Item Names", ROMX

StatsScreenPlaceHeldItem:
; BC = text baseline. Real item ID comes from wTempMonItem.
	push bc
	ld a, [wTempMonItem]
	and a
	jr z, .none
	ld b, a
	farcall TimeCapsule_ReplaceTeruSama
	ld a, b
	dec a
	ld c, a
	ld b, 0
	ld hl, StatsItemNamePointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	jr .place
.none
	ld de, .None
.place
	pop hl
	jp PlaceString
.None: db "없음@"

StatsItemNamePointers:
	table_width 2
	dw .i1
	dw .i2
	dw .i3
	dw .i4
	dw .i5
	dw .i6
	dw .i7
	dw .i8
	dw .i9
	dw .i10
	dw .i11
	dw .i12
	dw .i13
	dw .i14
	dw .i15
	dw .i16
	dw .i17
	dw .i18
	dw .i19
	dw .i20
	dw .i21
	dw .i22
	dw .i23
	dw .i24
	dw .i25
	dw .i26
	dw .i27
	dw .i28
	dw .i29
	dw .i30
	dw .i31
	dw .i32
	dw .i33
	dw .i34
	dw .i35
	dw .i36
	dw .i37
	dw .i38
	dw .i39
	dw .i40
	dw .i41
	dw .i42
	dw .i43
	dw .i44
	dw .i45
	dw .i46
	dw .i47
	dw .i48
	dw .i49
	dw .i50
	dw .i51
	dw .i52
	dw .i53
	dw .i54
	dw .i55
	dw .i56
	dw .i57
	dw .i58
	dw .i59
	dw .i60
	dw .i61
	dw .i62
	dw .i63
	dw .i64
	dw .i65
	dw .i66
	dw .i67
	dw .i68
	dw .i69
	dw .i70
	dw .i71
	dw .i72
	dw .i73
	dw .i74
	dw .i75
	dw .i76
	dw .i77
	dw .i78
	dw .i79
	dw .i80
	dw .i81
	dw .i82
	dw .i83
	dw .i84
	dw .i85
	dw .i86
	dw .i87
	dw .i88
	dw .i89
	dw .i90
	dw .i91
	dw .i92
	dw .i93
	dw .i94
	dw .i95
	dw .i96
	dw .i97
	dw .i98
	dw .i99
	dw .i100
	dw .i101
	dw .i102
	dw .i103
	dw .i104
	dw .i105
	dw .i106
	dw .i107
	dw .i108
	dw .i109
	dw .i110
	dw .i111
	dw .i112
	dw .i113
	dw .i114
	dw .i115
	dw .i116
	dw .i117
	dw .i118
	dw .i119
	dw .i120
	dw .i121
	dw .i122
	dw .i123
	dw .i124
	dw .i125
	dw .i126
	dw .i127
	dw .i128
	dw .i129
	dw .i130
	dw .i131
	dw .i132
	dw .i133
	dw .i134
	dw .i135
	dw .i136
	dw .i137
	dw .i138
	dw .i139
	dw .i140
	dw .i141
	dw .i142
	dw .i143
	dw .i144
	dw .i145
	dw .i146
	dw .i147
	dw .i148
	dw .i149
	dw .i150
	dw .i151
	dw .i152
	dw .i153
	dw .i154
	dw .i155
	dw .i156
	dw .i157
	dw .i158
	dw .i159
	dw .i160
	dw .i161
	dw .i162
	dw .i163
	dw .i164
	dw .i165
	dw .i166
	dw .i167
	dw .i168
	dw .i169
	dw .i170
	dw .i171
	dw .i172
	dw .i173
	dw .i174
	dw .i175
	dw .i176
	dw .i177
	dw .i178
	dw .i179
	dw .i180
	dw .i181
	dw .i182
	dw .i183
	dw .i184
	dw .i185
	dw .i186
	dw .i187
	dw .i188
	dw .i189
	dw .i190
	dw .i191
	dw .i192
	dw .i193
	dw .i194
	dw .i195
	dw .i196
	dw .i197
	dw .i198
	dw .i199
	dw .i200
	dw .i201
	dw .i202
	dw .i203
	dw .i204
	dw .i205
	dw .i206
	dw .i207
	dw .i208
	dw .i209
	dw .i210
	dw .i211
	dw .i212
	dw .i213
	dw .i214
	dw .i215
	dw .i216
	dw .i217
	dw .i218
	dw .i219
	dw .i220
	dw .i221
	dw .i222
	dw .i223
	dw .i224
	dw .i225
	dw .i226
	dw .i227
	dw .i228
	dw .i229
	dw .i230
	dw .i231
	dw .i232
	dw .i233
	dw .i234
	dw .i235
	dw .i236
	dw .i237
	dw .i238
	dw .i239
	dw .i240
	dw .i241
	dw .i242
	dw .i243
	dw .i244
	dw .i245
	dw .i246
	dw .i247
	dw .i248
	dw .i249
	dw .i250
	dw .i251
	dw .i252
	dw .i253
	dw .i254
	dw .i255
	assert_table_length $ff
.i1: db "마스터볼@"
.i2: db "하이퍼볼@"
.i3: db "반짝가루@"
.i4: db "수퍼볼@"
.i5: db "몬스터볼@"
.i6: db "?@"
.i7: db "자전거@"
.i8: db "달맞이 돌@"
.i9: db "해독제@"
.i10: db "화상 치료제@"
.i11: db "얼음상태 치료제@"
.i12: db "잠깨는 약@"
.i13: db "마비 치료제@"
.i14: db "회복약@"
.i15: db "풀 회복약@"
.i16: db "고급 상처약@"
.i17: db "좋은 상처약@"
.i18: db "상처약@"
.i19: db "동굴탈출 로프@"
.i20: db "벌레회피스프레이@"
.i21: db "PP 맥스@"
.i22: db "불꽃의 돌@"
.i23: db "천둥의 돌@"
.i24: db "물의 돌@"
.i25: db "?@"
.i26: db "맥스 업@"
.i27: db "타우린@"
.i28: db "사포닌@"
.i29: db "알칼로이드@"
.i30: db "럭키 펀치@"
.i31: db "리보플라빈@"
.i32: db "이상한 사탕@"
.i33: db "잘-맞히기@"
.i34: db "잎사귀 돌@"
.i35: db "금속 파우더@"
.i36: db "금구슬@"
.i37: db "삐삐인형@"
.i38: db "만병통치제@"
.i39: db "기력의 조각@"
.i40: db "기력의 덩어리@"
.i41: db "이펙트 가드@"
.i42: db "실버 스프레이@"
.i43: db "골드 스프레이@"
.i44: db "크리티컬 커터@"
.i45: db "?@"
.i46: db "맛있는 물@"
.i47: db "미네랄 사이다@"
.i48: db "후르츠 밀크@"
.i49: db "플러스파워@"
.i50: db "?@"
.i51: db "디펜드 업@"
.i52: db "스피드 업@"
.i53: db "스페셜 업@"
.i54: db "동전 케이스@"
.i55: db "다우징 머신@"
.i56: db "?@"
.i57: db "학습장치@"
.i58: db "낡은 낚싯대@"
.i59: db "좋은 낚싯대@"
.i60: db "은빛 나뭇잎@"
.i61: db "대단한 낚싯대@"
.i62: db "포인트 업@"
.i63: db "PP 에이드@"
.i64: db "PP 회복@"
.i65: db "PP 에이더@"
.i66: db "빨간 비늘@"
.i67: db "비전 신약@"
.i68: db "승선 티켓@"
.i69: db "이상한 알@"
.i70: db "크리스탈 방울@"
.i71: db "은빛 날개@"
.i72: db "튼튼 밀크@"
.i73: db "선제공격 손톱@"
.i74: db "해독열매@"
.i75: db "금빛 나뭇잎@"
.i76: db "부드러운 모래@"
.i77: db "예리한 부리@"
.i78: db "마비치료열매@"
.i79: db "불탄 나무열매@"
.i80: db "얼은 나무열매@"
.i81: db "독바늘@"
.i82: db "왕의 징표석@"
.i83: db "쓴맛 나무열매@"
.i84: db "박하열매@"
.i85: db "빨간 규토리@"
.i86: db "작은 버섯@"
.i87: db "큰 버섯@"
.i88: db "은빛 가루@"
.i89: db "파란 규토리@"
.i90: db "?@"
.i91: db "부적 금화@"
.i92: db "노랑 규토리@"
.i93: db "초록 규토리@"
.i94: db "순결의 부적@"
.i95: db "신비의 물방울@"
.i96: db "휘어진 스푼@"
.i97: db "하얀 규토리@"
.i98: db "검은띠@"
.i99: db "검은 규토리@"
.i100: db "?@"
.i101: db "담홍 규토리@"
.i102: db "검은 안경@"
.i103: db "맛있는 꼬리@"
.i104: db "핑크빛 리본@"
.i105: db "대파@"
.i106: db "연막탄@"
.i107: db "녹지않는 얼음@"
.i108: db "자석@"
.i109: db "기적의 열매@"
.i110: db "진주@"
.i111: db "큰 진주@"
.i112: db "변함없는 돌@"
.i113: db "저주의 부적@"
.i114: db "분노의 호두과자@"
.i115: db "GS볼@"
.i116: db "블루카드@"
.i117: db "기적의 씨@"
.i118: db "굵은 뼈@"
.i119: db "기합의 머리띠@"
.i120: db "?@"
.i121: db "힘의 가루@"
.i122: db "힘의 뿌리@"
.i123: db "만능가루@"
.i124: db "부활초@"
.i125: db "딱딱한 돌@"
.i126: db "행복의 알@"
.i127: db "카드키@"
.i128: db "기계부품@"
.i129: db "알티켓@"
.i130: db "분실물@"
.i131: db "별의 모래@"
.i132: db "별의 조각@"
.i133: db "지하의 열쇠@"
.i134: db "정기권@"
.i135: db "?@"
.i136: db "?@"
.i137: db "?@"
.i138: db "목탄@"
.i139: db "나무열매쥬스@"
.i140: db "초점 렌즈@"
.i141: db "?@"
.i142: db "?@"
.i143: db "금속코트@"
.i144: db "용의 이빨@"
.i145: db "?@"
.i146: db "먹다 남은 음식@"
.i147: db "?@"
.i148: db "?@"
.i149: db "?@"
.i150: db "이상한 나무열매@"
.i151: db "용의 비늘@"
.i152: db "파괴의 유전자@"
.i153: db "?@"
.i154: db "?@"
.i155: db "?@"
.i156: db "성스러운 분말@"
.i157: db "헤비볼@"
.i158: db "꽃무늬 메일@"
.i159: db "레벨볼@"
.i160: db "루어볼@"
.i161: db "스피드볼@"
.i162: db "?@"
.i163: db "전기구슬@"
.i164: db "프랜드볼@"
.i165: db "문볼@"
.i166: db "러브러브볼@"
.i167: db "나무상자@"
.i168: db "오동나무상자@"
.i169: db "태양의 돌@"
.i170: db "물방울 리본@"
.i171: db "?@"
.i172: db "업그레이드@"
.i173: db "나무열매@"
.i174: db "황금열매@"
.i175: db "꼬부기 물뿌리개@"
.i176: db "?@"
.i177: db "파크볼@"
.i178: db "무지개빛 날개@"
.i179: db "?@"
.i180: db "기와조각@"
.i181: db "파도타기 메일@"
.i182: db "옥빛 메일@"
.i183: db "초상화 메일@"
.i184: db "러브리 메일@"
.i185: db "브이브이 메일@"
.i186: db "변신 메일@"
.i187: db "푸른하늘 메일@"
.i188: db "음표 메일@"
.i189: db "환상의 메일@"
.i190: db "?@"
.i191: db "기술머신01@"
.i192: db "기술머신02@"
.i193: db "기술머신03@"
.i194: db "기술머신04@"
.i195: db "?@"
.i196: db "기술머신05@"
.i197: db "기술머신06@"
.i198: db "기술머신07@"
.i199: db "기술머신08@"
.i200: db "기술머신09@"
.i201: db "기술머신10@"
.i202: db "기술머신11@"
.i203: db "기술머신12@"
.i204: db "기술머신13@"
.i205: db "기술머신14@"
.i206: db "기술머신15@"
.i207: db "기술머신16@"
.i208: db "기술머신17@"
.i209: db "기술머신18@"
.i210: db "기술머신19@"
.i211: db "기술머신20@"
.i212: db "기술머신21@"
.i213: db "기술머신22@"
.i214: db "기술머신23@"
.i215: db "기술머신24@"
.i216: db "기술머신25@"
.i217: db "기술머신26@"
.i218: db "기술머신27@"
.i219: db "기술머신28@"
.i220: db "?@"
.i221: db "기술머신29@"
.i222: db "기술머신30@"
.i223: db "기술머신31@"
.i224: db "기술머신32@"
.i225: db "기술머신33@"
.i226: db "기술머신34@"
.i227: db "기술머신35@"
.i228: db "기술머신36@"
.i229: db "기술머신37@"
.i230: db "기술머신38@"
.i231: db "기술머신39@"
.i232: db "기술머신40@"
.i233: db "기술머신41@"
.i234: db "기술머신42@"
.i235: db "기술머신43@"
.i236: db "기술머신44@"
.i237: db "기술머신45@"
.i238: db "기술머신46@"
.i239: db "기술머신47@"
.i240: db "기술머신48@"
.i241: db "기술머신49@"
.i242: db "기술머신50@"
.i243: db "비전머신01@"
.i244: db "비전머신02@"
.i245: db "비전머신03@"
.i246: db "비전머신04@"
.i247: db "비전머신05@"
.i248: db "비전머신06@"
.i249: db "비전머신07@"
.i250: db "?@"
.i251: db "?@"
.i252: db "?@"
.i253: db "?@"
.i254: db "?@"
.i255: db "?@"
POPS
