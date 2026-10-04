; Minimal three-byte Hangul encoding for the Crystal display proof of concept.
; The byte pair after $17 matches Gold's (font bank, glyph index) encoding.
; The escape avoids taking over Crystal's one-byte Japanese character values.

DEF HANGUL_POC_ESCAPE EQU $17

	charmap "글", HANGUL_POC_ESCAPE, $01, $ab
	charmap "력", HANGUL_POC_ESCAPE, $03, $f2
	charmap "출", HANGUL_POC_ESCAPE, $08, $e2
	charmap "한", HANGUL_POC_ESCAPE, $0a, $71
	charmap "가", HANGUL_POC_ESCAPE, $01, $01
	charmap "각", HANGUL_POC_ESCAPE, $01, $02
