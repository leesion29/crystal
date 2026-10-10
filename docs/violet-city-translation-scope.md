# 도라지시티 대사 번역 범위

작성일: 2026-10-10

이 문서는 도라지시티 관련 대사를 번역할 때 사용할 파일 목록이다. 아직 번역을
수행하지 않았으며, 목록의 ASM 파일은 크리스탈의 실제 맵 스크립트 기준이다.

## 1. 도시 내부 — 우선 번역 대상

| 파일 | 범위 |
|---|---|
| `maps/VioletCity.asm` | 필드 주민·표지판, 장로 안내 이벤트 |
| `maps/VioletGym.asm` | 비상, 체육관 트레이너, 관장 보조원, 석상 |
| `maps/VioletMart.asm` | 상점 점원·주민 |
| `maps/EarlsPokemonAcademy.asm` | 얼·학생·칠판·도감 관련 대사 |
| `maps/VioletNicknameSpeechHouse.asm` | 별명 평가의 집 주민·새 포켓몬 |
| `maps/VioletPokecenter1F.asm` | 공박사 조수의 알 전달 이벤트, 포켓몬센터 NPC |
| `maps/VioletKylesHouse.asm` | 카일의 집 주민 |

## 2. 후속 후보 — 도라지시티 진행과 직접 연결된 인접 지역

| 파일 | 범위 |
|---|---|
| `maps/SproutTower1F.asm` | 모다피의 탑 1층 NPC·석상·아이템 관련 텍스트 |
| `maps/SproutTower2F.asm` | 모다피의 탑 2층 NPC·석상·아이템 관련 텍스트 |
| `maps/SproutTower3F.asm` | 모다피의 탑 정상 이벤트, 라이벌·장로·비전머신 관련 대사 |
| `maps/Route31.asm` | 도라지시티 동쪽 출구·모다피의 탑·체육관을 언급하는 대사 |
| `maps/Route31VioletGate.asm` | 31번도로-도라지시티 관문 NPC |
| `maps/Route32.asm` | 체육관 배지 전 진행 제한 및 도라지 체육관을 언급하는 이벤트 |

## 3. 구조 참고용 — 번역 대상 아님

- `data/maps/maps.asm`: `MapGroup_Violet` 및 각 맵의 랜드마크·음악·타일셋 정의.
- `data/maps/scripts.asm`: 각 맵 ASM의 빌드 포함 순서.
- `data/maps/attributes.asm`: 맵 속성 정의.
- `data/maps/landmarks.asm`: 장소명 데이터. 대사 번역 범위와 별도.

`MapGroup_Violet`에는 32·35·36·37번도로처럼 도라지시티 대사 범위에 포함되지 않는
맵도 함께 있다. 따라서 이 그룹 소속만으로 번역 대상을 정하지 않는다.
