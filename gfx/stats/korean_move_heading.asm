; "사용할수 있는기술", using Crystal's own 8x16 font and one blank cell.
; Glyph offsets are (font bank - 1) * $1000 + glyph index * 16.
INCBIN "gfx/font/font_hangul.1bpp", $4b70, 16 ; 사
INCBIN "gfx/font/font_hangul.1bpp", $64b0, 16 ; 용
INCBIN "gfx/font/font_hangul.1bpp", $9720, 16 ; 할
INCBIN "gfx/font/font_hangul.1bpp", $5260, 16 ; 수
	ds 16, 0 ; space
INCBIN "gfx/font/font_hangul.1bpp", $6a60, 16 ; 있
INCBIN "gfx/font/font_hangul.1bpp", $1c20, 16 ; 는
INCBIN "gfx/font/font_hangul.1bpp", $0b20, 16 ; 기
INCBIN "gfx/font/font_hangul.1bpp", $52a0, 16 ; 술
