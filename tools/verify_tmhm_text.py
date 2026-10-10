"""Bounded SM83 checks of final-ROM name copying and Hangul cache redraws.

Not an emulator: glyph upload and hardware timing are modeled. Unknown CPU
instructions fail, and tests use assembled routines, not Python replacements.
"""
import re
import sys
from pathlib import Path
from verify_following_sprites import symbols


class CPU:
    def __init__(self, rom, sym):
        self.rom, self.sym = rom, sym
        self.mem = bytearray(65536)
        self.r = [0] * 8 # B C D E H L (HL) A
        self.z = self.carry = False
        self.stack = []
        self.bank = 1
        self.pc = 0
        self.uploads = {}
        self.key = None
        self.mem[sym['hCGB'][1]] = 1

    def pair(self, i):
        return self.r[i] * 256 + self.r[i+1]

    def setpair(self, i, n):
        self.r[i], self.r[i+1] = (n >> 8) & 255, n & 255

    def read(self, a):
        if a < 0x4000: return self.rom[a]
        if a < 0x8000: return self.rom[self.bank * 0x4000 + a - 0x4000]
        return self.mem[a]

    def get(self, i):
        return self.read(self.pair(4)) if i == 6 else self.r[i]

    def put(self, i, v):
        if i == 6: self.mem[self.pair(4)] = v & 255
        else: self.r[i] = v & 255

    def byte(self):
        n = self.read(self.pc)
        self.pc += 1
        return n

    def word(self):
        a = self.byte()
        return a | self.byte() << 8

    def flags(self):
        return 0x80 * self.z + 0x10 * self.carry

    def special(self, target):
        if target == self.sym['CopyHangulGlyphToBuffer'][1] and self.bank == self.sym['CopyHangulGlyphToBuffer'][0]:
            self.key = self.pair(0)
            return True
        if target == self.sym['CopyHangulTilesToVRAM'][1] and self.bank == self.sym['CopyHangulTilesToVRAM'][0]:
            self.uploads[self.r[7]] = self.key
            return True
        return False

    def run(self, label, limit=100000, caller_bank=None):
        self.bank, self.pc = self.sym[label]
        if caller_bank is not None:
            assert self.pc < 0x4000
            self.bank = caller_bank
        self.mem[self.sym['hROMBank'][1]] = self.bank
        self.stack = [None]
        for _ in range(limit):
            o = self.byte()
            if 0x40 <= o <= 0x7f and o != 0x76:
                self.put((o >> 3) & 7, self.get(o & 7))
            elif o & 0xc7 == 0x06:
                self.put((o >> 3) & 7, self.byte())
            elif o & 0xcf == 0x01:
                self.setpair((o >> 3) & 6, self.word())
            elif o in (0x03, 0x13, 0x23, 0x0b, 0x1b, 0x2b):
                i = (o >> 3) & 6
                self.setpair(i, self.pair(i) + (1 if o & 8 == 0 else -1))
            elif o in (0x04, 0x0c, 0x14, 0x1c, 0x24, 0x2c, 0x3c, 0x05, 0x0d, 0x15, 0x1d, 0x25, 0x2d, 0x3d):
                i = (o >> 3) & 7
                self.put(i, self.get(i) + (1 if o & 1 == 0 else -1))
                self.z = self.get(i) == 0
            elif o in (0x09, 0x19, 0x29):
                n = self.pair(4) + self.pair((o >> 3) & 6)
                self.carry = n > 65535
                self.setpair(4, n)
            elif o in (0x1a, 0x0a): self.r[7] = self.read(self.pair(2 if o == 0x1a else 0))
            elif o in (0x12, 0x02): self.mem[self.pair(2 if o == 0x12 else 0)] = self.r[7]
            elif o in (0x22, 0x2a):
                p = self.pair(4)
                if o == 0x22: self.mem[p] = self.r[7]
                else: self.r[7] = self.read(p)
                self.setpair(4, p+1)
            elif o in (0xfa, 0xea):
                p = self.word()
                if o == 0xfa: self.r[7] = self.read(p)
                else: self.mem[p] = self.r[7]
            elif o in (0xf0, 0xe0):
                p = 0xff00 + self.byte()
                if o == 0xf0: self.r[7] = self.mem[p]
                else: self.mem[p] = self.r[7]
            elif o in (0xc5, 0xd5, 0xe5, 0xf5):
                self.stack.append(self.r[7] * 256 + self.flags() if o == 0xf5 else self.pair((o >> 3) & 6))
            elif o in (0xc1, 0xd1, 0xe1, 0xf1):
                n = self.stack.pop()
                if o == 0xf1:
                    self.r[7], self.z, self.carry = n >> 8, bool(n & 0x80), bool(n & 0x10)
                else: self.setpair((o >> 3) & 6, n)
            elif o in (0xc6, 0xe6, 0xf6, 0xd6, 0xfe) or 0x80 <= o <= 0x87 or 0xa0 <= o <= 0xbf:
                a = self.r[7]
                n = self.byte() if o in (0xc6, 0xe6, 0xf6, 0xd6, 0xfe) else self.get(o & 7)
                if o == 0xc6 or 0x80 <= o <= 0x87:
                    self.carry = a + n > 255
                    a = (a + n) & 255
                elif 0xa8 <= o <= 0xaf: a ^= n
                elif 0xa0 <= o <= 0xa7 or o == 0xe6: a &= n
                elif 0xb0 <= o <= 0xb7 or o == 0xf6: a |= n
                else:
                    self.carry = a < n
                    a = (a - n) & 255
                self.z = a == 0
                if o != 0xfe and not 0xb8 <= o <= 0xbf:
                    self.r[7] = a
                    if o not in (0xd6, 0xc6) and not 0x80 <= o <= 0x87: self.carry = False
            elif o in (0x18, 0x20, 0x28, 0x30, 0x38):
                n = self.byte()
                condition = {0x18: True, 0x20: not self.z, 0x28: self.z, 0x30: not self.carry, 0x38: self.carry}[o]
                if condition: self.pc += n if n < 128 else n - 256
            elif o in (0xc3, 0xcd):
                p = self.word()
                if not self.special(p):
                    if o == 0xcd: self.stack.append(self.pc)
                    self.pc = p
            elif o == 0xcf:  # rst FarCall; execute the real wrapper and callee.
                self.stack.append(self.pc)
                self.pc = 8
            elif o == 0xe9:
                self.pc = self.pair(4)
            elif o in (0xc9, 0xc0, 0xc8, 0xd0, 0xd8):
                condition = {0xc9: True, 0xc0: not self.z, 0xc8: self.z, 0xd0: not self.carry, 0xd8: self.carry}[o]
                if condition:
                    p = self.stack.pop()
                    if p is None: return
                    self.pc = p
            elif o == 0xd7:
                self.bank = self.r[7]
                self.mem[self.sym['hROMBank'][1]] = self.bank
            elif o == 0xcb:
                n = self.byte()
                i, bit = n & 7, (n >> 3) & 7
                if n < 0x40: raise AssertionError('unmodeled CB shift')
                if n < 0x80: self.z = not bool(self.get(i) & (1 << bit))
                elif n < 0xc0: self.put(i, self.get(i) & ~(1 << bit))
                else: self.put(i, self.get(i) | (1 << bit))
            elif o == 0x37: self.carry = True
            elif o in (0xf3, 0xfb, 0x00): pass
            else: raise AssertionError(f'unknown opcode {o:02x} at {self.pc-1:04x}')
        raise AssertionError('instruction limit exceeded')


def read_names(rom, sym, label='MoveNames', count=251):
    bank, addr = sym[label]
    p = bank * 0x4000 + addr - 0x4000
    names = []
    for _ in range(count):
        start = p
        while rom[p] != 0x50:
            p += 3 if rom[p] == 0x17 else 1
        p += 1
        names.append(rom[start:p])
    return names


def verify(rom_path, sym_path):
    root = Path(__file__).resolve().parent.parent
    rom, sym = rom_path.read_bytes(), symbols(sym_path)
    names = read_names(rom, sym)
    size = sym['wStringBuffer2'][1] - sym['wStringBuffer1'][1]
    expected_size = int(re.search(r'DEF STRING_BUFFER_LENGTH EQU (\d+)',
        (root / 'constants/script_constants.asm').read_text(encoding='utf-8'))[1])
    assert size == expected_size
    assert max(map(len, names)) <= size
    # Other ROM tables using the shared GetName copier also fit its buffer.
    for label, count in (('ItemNames', 256), ('TrainerClassNames', 67)):
        assert max(map(len, read_names(rom, sym, label, count))) <= size, label
    # GetNthString still scans bytes: no current glyph may contain its delimiter.
    assert all(0x50 not in s[:-1] for s in names)
    cpu = CPU(rom, sym)
    start = sym['wStringBuffer1'][1]
    for i, name in enumerate(names, 1):
        cpu.mem[start-1:start+size+1] = bytes([0xcc])*(size+2)
        cpu.mem[sym['wNamedObjectType'][1]] = 2
        cpu.mem[sym['wCurSpecies'][1]] = i
        cpu.setpair(0, 0x1234)
        cpu.setpair(2, 0x5678)
        cpu.setpair(4, 0x9abc)
        cpu.run('GetName', caller_bank=127)
        assert cpu.mem[start:start+len(name)] == name, i
        assert cpu.mem[start-1] == cpu.mem[start+size] == 0xcc, i
        assert (cpu.pair(0), cpu.pair(2), cpu.pair(4)) == (0x1234, 0x5678, 0x9abc)
        assert cpu.bank == 127
        cpu.setpair(2, start)
        cpu.run('CopyName1')
        other = sym['wStringBuffer2'][1]
        assert cpu.mem[other:other+len(name)] == name
    for i in range(1, 5):
        assert sym[f'wStringBuffer{i+1}'][1] - sym[f'wStringBuffer{i}'][1] == size
    assert sym['wTMHMMoveNameBackup'] == sym['wUnusedMapBuffer']
    assert sym['wUnusedMapBufferEnd'][1] - sym['wTMHMMoveNameBackup'][1] == 24
    cpu.mem[sym['wTempTMHM'][1]] = 31
    cpu.run('GetTMHMMove')
    assert cpu.mem[sym['wTempTMHM'][1]] == 189
    longest = max(names, key=len)
    other = sym['wStringBuffer2'][1]
    backup = sym['wTMHMMoveNameBackup'][1]
    backup_size = int(re.search(r'DEF TMHM_MOVE_NAME_BUFFER_LENGTH EQU (\d+)',
        (root / 'constants/script_constants.asm').read_text(encoding='utf-8'))[1])
    assert max(map(len, names)) <= backup_size <= 24
    payload = longest + bytes([0xcc])*(backup_size-len(longest))
    cpu.mem[other:other+backup_size] = payload
    cpu.mem[backup-1:backup+backup_size+1] = bytes([0xcc])*(backup_size+2)
    for source, dest in ((other, backup), (backup, other)):
        cpu.setpair(4, source)
        cpu.setpair(2, dest)
        cpu.setpair(0, backup_size)
        cpu.run('CopyBytes')
    assert cpu.mem[other:other+backup_size] == cpu.mem[backup:backup+backup_size] == payload
    assert cpu.mem[backup-1] == cpu.mem[backup+backup_size] == 0xcc
    # Table prose: only ID 189 changed from the user's working baseline.
    before = root / '.verification/tmhm-20261010/names-before.asm'
    if before.exists():
        original = re.findall(r'\bli "([^"\n]*)"', before.read_text(encoding='utf-8'))
        current = re.findall(r'\bli "([^"\n]*)"', (root / 'data/moves/names.asm').read_text(encoding='utf-8'))
        assert [i+1 for i,(a,b) in enumerate(zip(original,current)) if a!=b] == [189]
        assert current[188] == '진흙뿌리기'
        assert len(original) == len(current) == 251
    baseline_sym = root / '.verification/tmhm-20261010/pokecrystal.sym'
    if baseline_sym.exists():
        old = symbols(baseline_sym)
        # Buffer growth must not change save data or the repurposed map span.
        for label, location in old.items():
            if label.startswith('s') and 0xa000 <= location[1] < 0xc000:
                assert sym[label] == location, ('SRAM layout', label)
        for label in ('wUnusedMapBuffer', 'wUnusedMapBufferEnd'):
            assert sym[label] == old[label]
    def routine(label, length):
        bank, addr = sym[label]
        offset = addr if bank == 0 else bank * 0x4000 + addr - 0x4000
        return rom[offset:offset+length]
    def call(label):
        return bytes([0xcd]) + sym[label][1].to_bytes(2, 'little')
    index_flow = bytes([0xfa]) + sym['wTempTMHM'][1].to_bytes(2, 'little')
    for label in ('wPutativeTMHMMove', 'wNamedObjectIndex'):
        index_flow += bytes([0xea]) + sym[label][1].to_bytes(2, 'little')
    index_flow += call('GetMoveName')
    for label in ('AskTeachTMHM', 'TMHM_DisplayPocketItems.okay', 'PlaceMoveNameAfterTMHMName'):
        assert index_flow in routine(label, 64), ('TM/HM name input', label)
    # Inspect assembled consumers, including item-use and cancellation paths.
    for label, length in (('BattleMenu_Pack.didnt_use_item', 60), ('BattleMenu_Pack.ball', 100)):
        code = routine(label, length)
        chain = [call(x) for x in ('LoadStandardFont', '_LoadBattleFontsHPBar',
                                  'ExitMenu', 'EmptyBattleTextbox', 'UpdateBattleHUDs', 'WaitBGMap')]
        positions = [code.index(x) for x in chain]
        assert positions == sorted(positions), ('battle return order', label)
    tilemap = sym['wTilemap'][1]
    cache = CPU(rom, sym)
    cache.mem[tilemap:tilemap+360] = bytes([0x7f])*360
    # Fill all 54 slots with real, distinct name glyphs before exercising
    # reclamation. Only the last dummy glyph remains visible in the tilemap.
    keys = set()
    for name in names:
        p = 0
        while p < len(name)-1:
            if name[p] == 0x17:
                keys.add(name[p+1]*256+name[p+2])
                p += 3
            else:
                p += 1
    assert len(keys) >= 54
    for g in sorted(keys)[:54]:
        cache.setpair(0, g)
        cache.setpair(4, tilemap+150)
        cache.run('_PlaceHangul')
    assert len(cache.uploads) == 54
    key = names[188]
    glyphs = []
    p = 0
    while p < len(key)-1:
        assert key[p] == 0x17
        glyphs.append(key[p+1]*256+key[p+2])
        p += 3
    for redraw in range(256):
        cache.mem[tilemap+40:tilemap+240] = bytes([0x7f])*200
        # First row of Hangul is retained just like the current TM/HM list.
        for n, g in enumerate(glyphs):
            cache.setpair(0, g)
            cache.setpair(4, tilemap+48+n)
            cache.run('_PlaceHangul')
        for n,c in enumerate('CANCEL'):
            cache.setpair(0, 0x80+ord(c)-ord('A'))
            cache.setpair(4, tilemap+88+n)
            cache.run('_PlaceHangul')
        for n,c in enumerate('CANCEL'):
            t = cache.mem[tilemap+88+n]
            assert t != 0x7f and cache.uploads[t] == 0x80+ord(c)-ord('A'), redraw
        for n,g in enumerate(glyphs):
            t = cache.mem[tilemap+48+n]
            assert t != 0x7f and cache.uploads[t-1] == g, redraw
    print(f'{rom_path.name}: 251 compiled GetName/CopyName1 cases, bank/{size}-byte buffer guards, TM31 mapping/name, backup round trip, unchanged SRAM layout, battle-return call order, 256 compiled cache redraws PASS. Upload/timing modeled; not emulator evidence.')


if __name__ == '__main__':
    verify(Path(sys.argv[1]), Path(sys.argv[2]))
