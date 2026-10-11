"""Check the approved whole-map ROMX split and cumulative translation output.

Static artifact checks only: no emulator, renderer or event execution claim.
Run from the repository root: python tools/verify_goldenrod_layout.py ROM SYM
"""
import hashlib
import json
import re
import sys
from pathlib import Path

import region_translation as t
from verify_following_sprites import symbols
from verify_landmark_names import charmap

BASE = t.ROOT / '.verification/union-route34-goldenrod-20261011/baseline'
MOVED = ('GoldenrodPPSpeechHouse', 'GoldenrodCity')
SECTION = 'Goldenrod Overflow Map Scripts'


def verify(rom_path, sym_path):
    before = t.read(BASE / 'map-scripts-before-split.asm')
    expected = before
    for name in MOVED:
        include = f'INCLUDE "maps/{name}.asm"\n'
        assert before.count(include) == 1, name
        expected = expected.replace(include, '')
    expected += f'\n\nSECTION "{SECTION}", ROMX\n\n'
    expected += ''.join(f'INCLUDE "maps/{name}.asm"\n' for name in MOVED)
    expected += '\nENDSECTION\n'
    assert t.read(t.ROOT / 'data/maps/scripts.asm') == expected, 'unexpected layout edit'

    rom, sym = rom_path.read_bytes(), symbols(sym_path)

    def read(name, size):
        bank, addr = sym[name]
        assert 1 <= bank <= 0x7f and 0x4000 <= addr <= 0x8000 - size, name
        offset = bank * 0x4000 + addr - 0x4000
        return rom[offset:offset + size]

    def word(target, bank):
        assert sym[target][0] == bank, ('near pointer crosses bank', target)
        return sym[target][1].to_bytes(2, 'little')

    # map_attributes: border/height/width, block bank+pointer, script bank,
    # script pointer, event pointer, connections. Check the whole population.
    attributes = 0
    for label in sym:
        if not label.endswith('_MapAttributes'):
            continue
        name = label.removesuffix('_MapAttributes')
        data = read(label, 12)
        bank = sym[name + '_MapScripts'][0]
        assert data[3] == sym[name + '_Blocks'][0], name
        assert data[4:6] == sym[name + '_Blocks'][1].to_bytes(2, 'little'), name
        assert data[6:11] == bytes([bank]) + word(name + '_MapScripts', bank) + word(name + '_MapEvents', bank), name
        attributes += 1

    pointers = 0
    for name in MOVED:
        bank = sym[name + '_MapScripts'][0]
        source = t.read(t.ROOT / f'maps/{name}.asm')
        callbacks = re.findall(r'^\s*callback\s+[^,]+,\s*(\w+)', source, re.M)
        table = read(name + '_MapScripts', 2 + len(callbacks) * 3)
        assert table[:2] == bytes([0, len(callbacks)]), name
        for i, target in enumerate(callbacks):
            assert table[3 + i*3:5 + i*3] == word(target, bank), target
            pointers += 1

        # Event records from macros/scripts/maps.asm: coord=8, bg=5,
        # object=13 bytes; their script offsets are 4, 3, 9 respectively.
        events = source.split(name + '_MapEvents:', 1)[1]
        groups = [re.findall(r'^\s*' + macro + r'\s+([^;\n]+)', events, re.M)
                  for macro in ('warp_event', 'coord_event', 'bg_event', 'object_event')]
        size = 2 + 4 + sum(len(rows) * width for rows, width in zip(groups, (5, 8, 5, 13)))
        data = read(name + '_MapEvents', size)
        assert data[:2] == b'\x00\x00', name
        pos = 2
        for rows, width, arg, offset in zip(groups, (5, 8, 5, 13), (None, 3, 3, 11), (None, 4, 3, 9)):
            assert data[pos] == len(rows), name
            pos += 1
            for row in rows:
                if arg is not None:
                    target = row.split(',')[arg].strip()
                    assert data[pos+offset:pos+offset+2] == word(target, bank), target
                    pointers += 1
                pos += width
        assert pos == len(data), name

        scope = None
        for line in source.splitlines():
            if match := re.match(r'^(\w+):', line):
                scope = match[1]
                assert sym[scope][0] == bank, ('split map definition', scope)
            if match := re.match(r'^\s*(sjump|scall|iftrue|iffalse|ifequal|writetext|jumptext|jumptextfaceplayer|loadmenu|applymovement|dw)\s+([^;]+)', line):
                for operand in match[2].split(','):
                    target = operand.strip()
                    if target.startswith('.'):
                        target = scope + target
                    if target in sym and sym[target][1] >= 0x4000 and sym[target][1] < 0x8000:
                        assert sym[target][0] == bank, (name, line)

    old = json.loads(t.read(t.ROOT / 'data/translation/routes32-33-azalea-well-ilex.json'))
    new = json.loads(t.read(t.ROOT / 'data/translation/union-route34-goldenrod.json'))
    for path in {e['file'] for e in old}:
        entries = [e for e in old if e['file'] == path]
        entries += [e for e in new if e['file'] == path]
        assert t.transformed(t.baseline(path), entries) == t.read(t.ROOT / path), ('prior source preservation', path)
    t.verify_rom(old, rom_path, sym_path)
    assert hashlib.sha256((t.ROOT / 'data/moves/names.asm').read_bytes()).hexdigest() == '3c84dffc763cb2e3234c630c853949ebad60dfc0c21288751f7ae5d000fa7ee5'
    assert hashlib.sha256((t.ROOT / 'gfx/font/font_hangul.1bpp').read_bytes()).hexdigest() == 'fdb3539a5a1e5309195799ba83aca2f9f721de84829e7ba64a802bb0b705d479'
    assert charmap()['~'] == b'\x17\x0b\x69'
    glyph = read('HangulPoC_Font4', 0x1000)[(2665*16 - 0xa000):(2666*16 - 0xa000)]
    assert glyph == bytes.fromhex('0000000000000000000060920c000000'), glyph.hex()
    body = t.blocks(t.read(t.ROOT / 'data/text/std_text.asm'))['HomepageText'][2]
    encoded = t.assemble_text(body, charmap(), sym, 'HomepageText')
    assert read('HomepageText', len(encoded)) == encoded
    print(rom_path.name, attributes, 'map attribute bank/pointer sets;', pointers,
          'moved-map callback/event pointers; approved source split, previous 200 blocks, names/font/tilde PASS')


if __name__ == '__main__':
    verify(Path(sys.argv[1]), Path(sys.argv[2]))
