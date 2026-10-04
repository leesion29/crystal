ChrisNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 1, 10, TEXTBOX_Y
	dw .MaleNames
	db 1 ; default option
	db 0 ; ???

.MaleNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 5 ; items
	db "스스로 결정하다@"
MalePlayerNameArray:
	db "골드@"
	db "수호@"
	db "인산@"
	db "강산@"
	db 2 ; title indent
	db " 이름 후보 @" ; title

KrisNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 1, 10, TEXTBOX_Y
	dw .FemaleNames
	db 1 ; default option
	db 0 ; ???

.FemaleNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 5 ; items
	db "스스로 결정하다@"
FemalePlayerNameArray:
	db "크리스@"
	db "금선@"
	db "은아@"
	db "동주@"
	db 2 ; title indent
	db " 이름 후보 @" ; title
