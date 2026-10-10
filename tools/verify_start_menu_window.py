"""Bounded final-ROM START entry/window publication checks, not an emulator.

Execute StartMenu and both font wrappers; model graphics/menu helpers and frame
boundaries. Verify the map window hides only after the complete menu is uploaded.
Reject a mutant calling the old window-hiding font wrapper before menu rendering.
"""
import hashlib
import sys
from pathlib import Path
from verify_following_sprites import symbols
from verify_tmhm_text import CPU


class EntryComplete(Exception):
    pass


class WindowCPU(CPU):
    def __init__(self, rom, sym, oam, contest):
        super().__init__(rom, sym)
        self.original_oam = oam
        self.mem[sym['hOAMUpdate'][1]] = oam
        self.mem[sym['wStatusFlags2'][1]] = 255 if contest else 0
        self.mem[sym['wBattleMenuCursorPosition'][1]] = 3
        self.reanchored = self.font = self.drawn = self.uploaded = False
        self.frames = []
        self.calls = []

    def frame(self, reason):
        if not self.reanchored:
            return
        wy = self.mem[self.sym['hWY'][1]]
        assert wy == 0 or (wy == 0x90 and self.uploaded), (
            'map window hidden before menu publication', reason, wy)
        self.frames.append((reason, wy, self.uploaded))

    def modeled(self, name):
        self.calls.append(name)
        if name == 'ReanchorBGMap_NoOAMUpdate':
            # Contract of the unchanged reanchor: window BGMap1 visible, BGMap0
            # black. Full tile transfer/PPU are deliberately not executed here.
            self.mem[self.sym['hWY'][1]] = 0
            self.reanchored = True
        elif name == 'LoadStandardFont':
            assert not self.drawn, 'font reset after cached menu glyphs were drawn'
            self.font = True
            self.frame(name)
        elif name == 'DrawVariableLengthMenuBox':
            assert self.font
            assert self.mem[self.sym['hOAMUpdate'][1]] == self.original_oam
            self.drawn = True
            self.frame(name)
        elif name == 'HDMATransferTilemapAndAttrmap_Menu':
            assert self.drawn and self.font
            self.frame(name)
            self.uploaded = True
        elif name == 'StartMenu.GetInput':
            assert self.uploaded
            assert self.mem[self.sym['hWY'][1]] == 0x90
            assert any(wy == 0x90 for _, wy, _ in self.frames)
            assert self.bank == self.sym['StartMenu'][0]
            assert self.mem[self.sym['hOAMUpdate'][1]] == self.original_oam
            raise EntryComplete
        elif name in ('SafeUpdateSprites', 'DelayFrame', 'LoadFontsExtra'):
            self.frame(name)
        return True

    def special(self, target):
        helpers = (
            'ClearWindowData', 'PlaySFX', 'LoadMenuHeader',
            'StartMenu.SetUpMenuItems', 'StartMenu.DrawMenuAccount',
            'DrawVariableLengthMenuBox', 'SafeUpdateSprites',
            'HDMATransferTilemapAndAttrmap_Menu', 'LoadFontsExtra',
            'LoadStandardFont', 'DelayFrame', 'UpdateTimePals',
            'StartMenu.GetInput', 'ReanchorBGMap_NoOAMUpdate',
            'StartMenu_DrawBugContestStatusBox', 'StartMenu_PrintBugContestStatus',
        )
        for name in helpers:
            bank, address = self.sym[name]
            if address == target and (bank == 0 or bank == self.bank):
                return self.modeled(name)
        if target == self.sym['FarCall_JumpToHL'][1]:
            # Model only external far callees. The new/legacy font wrappers
            # themselves and real bank switching/return wrappers execute.
            for name in helpers:
                if self.sym[name] == (self.bank, self.pair(4)):
                    return self.modeled(name)
        return False


def exercise(rom, sym, oam, contest):
    cpu = WindowCPU(rom, sym, oam, contest)
    try:
        cpu.run('StartMenu')
    except EntryComplete:
        assert cpu.calls.count('LoadStandardFont') == 1
        return cpu
    raise AssertionError('entry never reached menu input')


def verify(rom_path, sym_path):
    rom, sym = rom_path.read_bytes(), symbols(sym_path)
    for oam in (0, 1, 2):
        for contest in (False, True):
            exercise(rom, sym, oam, contest)
    bank, address = sym['StartMenu']
    start = bank * 0x4000 + address - 0x4000
    def farcall(label):
        bank, address = sym[label]
        return bytes((0x3e, bank, 0x21, address & 255, address >> 8, 0xcf))
    new = farcall('LoadFonts_KeepWindow_NoOAMUpdate')
    end = start + 128
    assert rom[start:end].count(new) == 1
    position = rom.index(new, start, end)
    mutant = bytearray(rom)
    mutant[position:position + len(new)] = farcall('LoadFonts_NoOAMUpdate')
    try:
        exercise(mutant, sym, 0, False)
    except AssertionError as error:
        assert error.args[0][0] == 'map window hidden before menu publication', error
    else:
        raise AssertionError('early window-hide mutant accepted')
    print(f'{rom_path.name}: 6 compiled START entry/font-wrapper cases PASS; '
          'early window-hide mutant rejected; helpers/frames modeled, not PPU '
          f'or emulator evidence; SHA256 {hashlib.sha256(rom).hexdigest()}')


if __name__ == '__main__':
    verify(Path(sys.argv[1]), Path(sys.argv[2]))
