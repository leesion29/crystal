"""Execute final-ROM bag clearing; seeded glyph geometry, not PPU evidence.

The TM/HM test stops immediately after its actual ClearBox call, before item
lookup/rendering. ClearPocketList and ClearWholeMenuBox execute to return.
Old y=2/height=10 mutants must leave stale upper halves and be rejected.
"""
import hashlib
import sys
from pathlib import Path

from verify_following_sprites import symbols
from verify_tmhm_text import CPU


class Cleared(Exception):
    pass


class ClearCPU(CPU):
    def special(self, target):
        bank, address = self.sym['TMHM_GetCurrentPocketPosition']
        if self.bank == bank and target == address:
            raise Cleared
        return super().special(target)


def clear(cpu, label):
    try:
        cpu.run(label)
    except Cleared:
        assert label == 'TMHM_DisplayPocketItems'


def check_rectangle(cpu, label, left, top, right, bottom):
    start = cpu.sym['wTilemap'][1]
    before = bytes((i % 0x70) + 1 for i in range(360))
    cpu.mem[start-1:start+361] = b'\xcc' + before + b'\xdd'
    clear(cpu, label)
    expected = bytearray(before)
    for y in range(top, bottom+1):
        for x in range(left, right+1):
            expected[y*20+x] = 0x7f
    assert cpu.mem[start:start+360] == expected, (label, 'clear extent/stale tiles')
    assert cpu.mem[start-1] == 0xcc and cpu.mem[start+360] == 0xdd


def old_clear_mutant(rom, sym, label):
    result = bytearray(rom)
    bank, address = sym[label]
    offset = bank*0x4000 + address-0x4000
    tile = sym['wTilemap'][1] + 20 + 5
    prefix = bytes([0x21, tile & 255, tile >> 8, 0x01, 15, 11])
    found = rom.find(prefix, offset, offset+40)
    assert found >= 0, (label, 'assembled clear prefix missing')
    old_tile = tile + 20
    result[found+1:found+3] = old_tile.to_bytes(2, 'little')
    result[found+5] = 10
    return bytes(result)


def verify(rom_path, sym_path):
    rom = rom_path.read_bytes()
    sym = symbols(sym_path)
    cases = 0
    for label in ('ClearPocketList', 'TMHM_DisplayPocketItems'):
        cpu = ClearCPU(rom, sym)
        # Non-tutorial TM/HM entries use the ordinary list redraw branch.
        cpu.mem[sym['wBattleType'][1]] = 0
        check_rectangle(cpu, label, 5, 1, 19, 11)
        start = sym['wTilemap'][1]
        # Repeated long -> short -> empty/CANCEL transitions. Seed both halves
        # at every one of the five legal baselines; check untouched UI guards.
        for redraw in range(32):
            for length in (12, 3, 0):
                check_rectangle(cpu, label, 5, 1, 19, 11)
                for y in (2, 4, 6, 8, 10):
                    for x in range(8, 8+length):
                        cpu.mem[start+(y-1)*20+x] = 0xa0
                        cpu.mem[start+y*20+x] = 0xa1
                clear(cpu, label)
                assert all(cpu.mem[start+y*20+x] == 0x7f
                           for y in range(1, 12) for x in range(5, 20))
                cases += 1
        mutant = ClearCPU(old_clear_mutant(rom, sym, label), sym)
        try:
            check_rectangle(mutant, label, 5, 1, 19, 11)
        except AssertionError as error:
            assert error.args == ((label, 'clear extent/stale tiles'),), error
        else:
            raise AssertionError((label, 'old-height mutant was accepted'))
    # Normal item/key-item/ball scrolling already clears its top border row.
    cpu = ClearCPU(rom, sym)
    for name, value in (('Left', 7), ('Top', 1), ('Right', 19), ('Bottom', 11)):
        cpu.mem[sym['wMenuBorder'+name+'Coord'][1]] = value
    check_rectangle(cpu, 'ClearWholeMenuBox', 7, 1, 19, 11)
    print(f'{rom_path.name}: PASS actual bag/TMHM clears, {cases} seeded redraw '
          'transitions, unchanged generic menu extent, outside-UI guards; '
          '2 old-height mutants rejected. Glyph drawing/PPU not executed.')
    print('SHA256', hashlib.sha256(rom).hexdigest())


if __name__ == '__main__':
    verify(Path(sys.argv[1]), Path(sys.argv[2]))
