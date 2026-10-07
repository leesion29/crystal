; The species table is fixed at ten data bytes per entry.  OldGold stores its
; Hangul names as two-byte font identifiers; Crystal's ordinary dialogue uses
; an escape byte before that pair.  Assemble this table with OldGold's name
; encoding, then let GetPokemonName expand it into Crystal's display form.
;
; The reference files are intentionally limited to this table's source text
; and glyph IDs.  Species constants, dex order, and base-stat data stay in
; Crystal and are not imported from OldGold.
PURGE dname
MACRO? dname
:
	db \1
	assert (@ - :-) <= NAME_LENGTH - 1, "Pokemon name longer than 10 bytes: \1"
	ds NAME_LENGTH - 1 - (@ - :-), '@'
ENDM

pushc
	newcharmap oldgold_pokemon_names
	charmap "@", $50
	charmap "♀", $f5
	charmap "♂", $ef
	charmap "2", $f8
INCLUDE "../oldgold/constants/charmap_hangul.asm"
INCLUDE "../oldgold/data/pokemon/names.asm"
popc

; Restore the project-wide dname definition for later data files.
PURGE dname
MACRO? dname
	if _NARG == 2
		def n = \2
	else
		def n = NAME_LENGTH - 1
	endc
	assert STRFIND(\1, "@") == -1, "String terminator \"@\" in name: \1"
	assert CHARLEN(\1) <= n, "Name longer than {d:n} characters: \1"
	db \1
	ds n - CHARLEN(\1), '@'
ENDM
