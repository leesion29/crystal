MACRO landmark
; x, y, name
	db \1 + 8, \2 + 16
	dw \3
ENDM

Landmarks:
; entries correspond to constants/landmark_constants.asm
	table_width 4
	landmark  -8, -16, SpecialMapName
	landmark 140, 100, NewBarkTownName
	landmark 128, 100, Route29Name
	landmark 100, 100, CherrygroveCityName
	landmark 100,  80, Route30Name
	landmark  96,  60, Route31Name
	landmark  84,  60, VioletCityName
	landmark  85,  58, SproutTowerName
	landmark  84,  92, Route32Name
	landmark  76,  76, RuinsOfAlphName
	landmark  84, 124, UnionCaveName
	landmark  82, 124, Route33Name
	landmark  68, 124, AzaleaTownName
	landmark  70, 122, SlowpokeWellName
	landmark  52, 120, IlexForestName
	landmark  52, 112, Route34Name
	landmark  52,  92, GoldenrodCityName
	landmark  50,  92, RadioTowerName
	landmark  52,  76, Route35Name
	landmark  52,  60, NationalParkName
	landmark  64,  60, Route36Name
	landmark  68,  52, Route37Name
	landmark  68,  44, EcruteakCityName
	landmark  70,  42, TinTowerName
	landmark  66,  42, BurnedTowerName
	landmark  52,  44, Route38Name
	landmark  36,  48, Route39Name
	landmark  36,  60, OlivineCityName
	landmark  38,  62, LighthouseName
	landmark  28,  56, BattleTowerName
	landmark  28,  64, Route40Name
	landmark  28,  92, WhirlIslandsName
	landmark  28, 100, Route41Name
	landmark  20, 100, CianwoodCityName
	landmark  92,  44, Route42Name
	landmark  84,  44, MtMortarName
	landmark 108,  44, MahoganyTownName
	landmark 108,  36, Route43Name
	landmark 108,  28, LakeOfRageName
	landmark 120,  44, Route44Name
	landmark 130,  38, IcePathName
	landmark 132,  44, BlackthornCityName
	landmark 132,  36, DragonsDenName
	landmark 132,  64, Route45Name
	landmark 112,  72, DarkCaveName
	landmark 124,  88, Route46Name
	landmark 148,  68, SilverCaveName
	assert_table_length KANTO_LANDMARK
	landmark  52, 108, PalletTownName
	landmark  52,  92, Route1Name
	landmark  52,  76, ViridianCityName
	landmark  52,  64, Route2Name
	landmark  52,  52, PewterCityName
	landmark  64,  52, Route3Name
	landmark  76,  52, MtMoonName
	landmark  88,  52, Route4Name
	landmark 100,  52, CeruleanCityName
	landmark 100,  44, Route24Name
	landmark 108,  36, Route25Name
	landmark 100,  60, Route5Name
	landmark 108,  76, UndergroundName
	landmark 100,  76, Route6Name
	landmark 100,  84, VermilionCityName
	landmark  88,  60, DiglettsCaveName
	landmark  88,  68, Route7Name
	landmark 116,  68, Route8Name
	landmark 116,  52, Route9Name
	landmark 132,  52, RockTunnelName
	landmark 132,  56, Route10Name
	landmark 132,  60, PowerPlantName
	landmark 132,  68, LavenderTownName
	landmark 140,  68, LavRadioTowerName
	landmark  76,  68, CeladonCityName
	landmark 100,  68, SaffronCityName
	landmark 116,  84, Route11Name
	landmark 132,  80, Route12Name
	landmark 124, 100, Route13Name
	landmark 116, 112, Route14Name
	landmark 104, 116, Route15Name
	landmark  68,  68, Route16Name
	landmark  68,  92, Route17Name
	landmark  80, 116, Route18Name
	landmark  92, 116, FuchsiaCityName
	landmark  92, 128, Route19Name
	landmark  76, 132, Route20Name
	landmark  68, 132, SeafoamIslandsName
	landmark  52, 132, CinnabarIslandName
	landmark  52, 120, Route21Name
	landmark  36,  68, Route22Name
	landmark  28,  52, VictoryRoadName
	landmark  28,  44, Route23Name
	landmark  28,  36, IndigoPlateauName
	landmark  28,  92, Route26Name
	landmark  20, 100, Route27Name
	landmark  12, 100, TohjoFallsName
	landmark  20,  68, Route28Name
	landmark 140, 116, FastShipName
	assert_table_length NUM_LANDMARKS

NewBarkTownName:     db "연두마을@"
	assert @ - NewBarkTownName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: NewBarkTownName"
CherrygroveCityName: db "무궁시티@"
	assert @ - CherrygroveCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: CherrygroveCityName"
VioletCityName:      db "도라지시티@"
	assert @ - VioletCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: VioletCityName"
AzaleaTownName:      db "고동마을@"
	assert @ - AzaleaTownName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: AzaleaTownName"
GoldenrodCityName:   db "금빛시티@"
	assert @ - GoldenrodCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: GoldenrodCityName"
EcruteakCityName:    db "인주시티@"
	assert @ - EcruteakCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: EcruteakCityName"
OlivineCityName:     db "담청시티@"
	assert @ - OlivineCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: OlivineCityName"
CianwoodCityName:    db "진청시티@"
	assert @ - CianwoodCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: CianwoodCityName"
MahoganyTownName:    db "황토마을@"
	assert @ - MahoganyTownName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: MahoganyTownName"
BlackthornCityName:  db "검은먹시티@"
	assert @ - BlackthornCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: BlackthornCityName"
LakeOfRageName:      db "분노의 호수@"
	assert @ - LakeOfRageName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: LakeOfRageName"
SilverCaveName:      db "은빛 산@"
	assert @ - SilverCaveName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: SilverCaveName"
SproutTowerName:     db "모다피의 탑@"
	assert @ - SproutTowerName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: SproutTowerName"
RuinsOfAlphName:     db "알프의 유적@"
	assert @ - RuinsOfAlphName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: RuinsOfAlphName"
UnionCaveName:       db "연결동굴@"
	assert @ - UnionCaveName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: UnionCaveName"
SlowpokeWellName:    db "야돈 우물@"
	assert @ - SlowpokeWellName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: SlowpokeWellName"
RadioTowerName:      db "라디오타워@"
	assert @ - RadioTowerName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: RadioTowerName"
PowerPlantName:      db "발전소@"
	assert @ - PowerPlantName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: PowerPlantName"
NationalParkName:    db "자연 공원@"
	assert @ - NationalParkName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: NationalParkName"
TinTowerName:        db "방울탑@"
	assert @ - TinTowerName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: TinTowerName"
LighthouseName:      db "담청등대@"
	assert @ - LighthouseName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: LighthouseName"
WhirlIslandsName:    db "소용돌이 섬@"
	assert @ - WhirlIslandsName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: WhirlIslandsName"
MtMortarName:        db "절구산@"
	assert @ - MtMortarName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: MtMortarName"
DragonsDenName:      db "용의 굴@"
	assert @ - DragonsDenName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: DragonsDenName"
IcePathName:         db "얼음샛길@"
	assert @ - IcePathName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: IcePathName"
NotApplicableName:   db "N/A@" ; unreferenced ; "オバケやしき" ("HAUNTED HOUSE") in Japanese
	assert @ - NotApplicableName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: NotApplicableName"
PalletTownName:      db "태초마을@"
	assert @ - PalletTownName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: PalletTownName"
ViridianCityName:    db "상록시티@"
	assert @ - ViridianCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: ViridianCityName"
PewterCityName:      db "회색시티@"
	assert @ - PewterCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: PewterCityName"
CeruleanCityName:    db "블루시티@"
	assert @ - CeruleanCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: CeruleanCityName"
LavenderTownName:    db "보라타운@"
	assert @ - LavenderTownName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: LavenderTownName"
VermilionCityName:   db "갈색시티@"
	assert @ - VermilionCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: VermilionCityName"
CeladonCityName:     db "무지개시티@"
	assert @ - CeladonCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: CeladonCityName"
SaffronCityName:     db "노랑시티@"
	assert @ - SaffronCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: SaffronCityName"
FuchsiaCityName:     db "연분홍시티@"
	assert @ - FuchsiaCityName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: FuchsiaCityName"
CinnabarIslandName:  db "홍련섬@"
	assert @ - CinnabarIslandName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: CinnabarIslandName"
IndigoPlateauName:   db "석영고원@"
	assert @ - IndigoPlateauName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: IndigoPlateauName"
VictoryRoadName:     db "챔피언 로드@"
	assert @ - VictoryRoadName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: VictoryRoadName"
MtMoonName:          db "달맞이 산@"
	assert @ - MtMoonName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: MtMoonName"
RockTunnelName:      db "돌산 터널@"
	assert @ - RockTunnelName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: RockTunnelName"
LavRadioTowerName:   db "보라 라디오타워@"
	assert @ - LavRadioTowerName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: LavRadioTowerName"
SilphCoName:         db "실프주식회사@" ; unreferenced
	assert @ - SilphCoName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: SilphCoName"
SafariZoneName:      db "사파리존@" ; unreferenced
	assert @ - SafariZoneName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: SafariZoneName"
SeafoamIslandsName:  db "쌍둥이섬@"
	assert @ - SeafoamIslandsName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: SeafoamIslandsName"
PokemonMansionName:  db "포켓몬 저택@" ; unreferenced
	assert @ - PokemonMansionName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: PokemonMansionName"
CeruleanCaveName:    db "블루시티 동굴@" ; unreferenced
	assert @ - CeruleanCaveName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: CeruleanCaveName"
Route1Name:          db "1번 도로@"
	assert @ - Route1Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route1Name"
Route2Name:          db "2번 도로@"
	assert @ - Route2Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route2Name"
Route3Name:          db "3번 도로@"
	assert @ - Route3Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route3Name"
Route4Name:          db "4번 도로@"
	assert @ - Route4Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route4Name"
Route5Name:          db "5번 도로@"
	assert @ - Route5Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route5Name"
Route6Name:          db "6번 도로@"
	assert @ - Route6Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route6Name"
Route7Name:          db "7번 도로@"
	assert @ - Route7Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route7Name"
Route8Name:          db "8번 도로@"
	assert @ - Route8Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route8Name"
Route9Name:          db "9번 도로@"
	assert @ - Route9Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route9Name"
Route10Name:         db "10번 도로@"
	assert @ - Route10Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route10Name"
Route11Name:         db "11번 도로@"
	assert @ - Route11Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route11Name"
Route12Name:         db "12번 도로@"
	assert @ - Route12Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route12Name"
Route13Name:         db "13번 도로@"
	assert @ - Route13Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route13Name"
Route14Name:         db "14번 도로@"
	assert @ - Route14Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route14Name"
Route15Name:         db "15번 도로@"
	assert @ - Route15Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route15Name"
Route16Name:         db "16번 도로@"
	assert @ - Route16Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route16Name"
Route17Name:         db "17번 도로@"
	assert @ - Route17Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route17Name"
Route18Name:         db "18번 도로@"
	assert @ - Route18Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route18Name"
Route19Name:         db "19번 도로@"
	assert @ - Route19Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route19Name"
Route20Name:         db "20번 도로@"
	assert @ - Route20Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route20Name"
Route21Name:         db "21번 도로@"
	assert @ - Route21Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route21Name"
Route22Name:         db "22번 도로@"
	assert @ - Route22Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route22Name"
Route23Name:         db "23번 도로@"
	assert @ - Route23Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route23Name"
Route24Name:         db "24번 도로@"
	assert @ - Route24Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route24Name"
Route25Name:         db "25번 도로@"
	assert @ - Route25Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route25Name"
Route26Name:         db "26번 도로@"
	assert @ - Route26Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route26Name"
Route27Name:         db "27번 도로@"
	assert @ - Route27Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route27Name"
Route28Name:         db "28번 도로@"
	assert @ - Route28Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route28Name"
Route29Name:         db "29번 도로@"
	assert @ - Route29Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route29Name"
Route30Name:         db "30번 도로@"
	assert @ - Route30Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route30Name"
Route31Name:         db "31번 도로@"
	assert @ - Route31Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route31Name"
Route32Name:         db "32번 도로@"
	assert @ - Route32Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route32Name"
Route33Name:         db "33번 도로@"
	assert @ - Route33Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route33Name"
Route34Name:         db "34번 도로@"
	assert @ - Route34Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route34Name"
Route35Name:         db "35번 도로@"
	assert @ - Route35Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route35Name"
Route36Name:         db "36번 도로@"
	assert @ - Route36Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route36Name"
Route37Name:         db "37번 도로@"
	assert @ - Route37Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route37Name"
Route38Name:         db "38번 도로@"
	assert @ - Route38Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route38Name"
Route39Name:         db "39번 도로@"
	assert @ - Route39Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route39Name"
Route40Name:         db "40번 도로@"
	assert @ - Route40Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route40Name"
Route41Name:         db "41번 도로@"
	assert @ - Route41Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route41Name"
Route42Name:         db "42번 도로@"
	assert @ - Route42Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route42Name"
Route43Name:         db "43번 도로@"
	assert @ - Route43Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route43Name"
Route44Name:         db "44번 도로@"
	assert @ - Route44Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route44Name"
Route45Name:         db "45번 도로@"
	assert @ - Route45Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route45Name"
Route46Name:         db "46번 도로@"
	assert @ - Route46Name <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: Route46Name"
DarkCaveName:        db "어둠의 동굴@"
	assert @ - DarkCaveName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: DarkCaveName"
IlexForestName:      db "너도밤나무 숲@"
	assert @ - IlexForestName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: IlexForestName"
BurnedTowerName:     db "불탄 탑@"
	assert @ - BurnedTowerName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: BurnedTowerName"
FastShipName:        db "쾌속선@"
	assert @ - FastShipName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: FastShipName"
ViridianForestName:  db "상록숲@" ; unreferenced
	assert @ - ViridianForestName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: ViridianForestName"
DiglettsCaveName:    db "디그다의 굴@"
	assert @ - DiglettsCaveName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: DiglettsCaveName"
TohjoFallsName:      db "동성폭포@"
	assert @ - TohjoFallsName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: TohjoFallsName"
UndergroundName:     db "지하통로@"
	assert @ - UndergroundName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: UndergroundName"
BattleTowerName:     db "배틀 타워@"
	assert @ - BattleTowerName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: BattleTowerName"
SpecialMapName:      db "SPECIAL@"
	assert @ - SpecialMapName <= STRING_BUFFER_LENGTH, "Landmark name exceeds string buffer: SpecialMapName"
