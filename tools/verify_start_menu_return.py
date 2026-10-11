"""Execute compiled START return orchestration with modeled graphics helpers.

Checks glyph redraw/upload before palette reveal, restored cursor and menu stack,
both ordinary submenu and options returns. Not a PPU or emulator timing test.
"""
import hashlib
import sys
from pathlib import Path
from verify_following_sprites import symbols
from verify_tmhm_text import CPU


class ReturnCPU(CPU):
    def __init__(self, rom, sym, contest, cursor):
        super().__init__(rom, sym)
        self.mem[sym['wStatusFlags2'][1]] = 255 if contest else 0
        self.mem[sym['wBattleMenuCursorPosition'][1]] = cursor
        self.hidden = self.font = self.restored = False
        self.glyphs = self.uploaded = self.revealed = False
        self.exits = self.draws = 0
        self.calls = []

    def modeled(self, name):
        self.calls.append(name)
        if name == 'ClearPalettes':
            self.hidden = True
        elif name == 'ReloadTilesetAndPalettes':
            assert self.hidden, 'font reset visible'
            self.font = True
            self.glyphs = self.uploaded = False
        elif name == 'Call_ExitMenu':
            assert self.hidden
            self.restored = True
            self.exits += 1
        elif name == 'DrawVariableLengthMenuBox':
            assert self.font and self.restored
        elif name == 'RunMenuItemPrintingFunction':
            assert self.hidden and self.font and self.restored
            self.glyphs = True
            self.draws += 1
        elif name == 'ApplyTilemap':
            assert self.glyphs, 'stale glyph references uploaded'
            self.uploaded = True
        elif name == 'InitMenuCursorAndButtonPermissions':
            assert self.mem[self.sym['wMenuCursorPosition'][1]] == self.mem[
                self.sym['wBattleMenuCursorPosition'][1]]
        elif name == 'FadeInFromWhite':
            assert self.glyphs and self.uploaded, 'stale glyph references revealed'
            assert self.exits == 1
            self.hidden = False
            self.revealed = True
        elif name == 'EnableSpriteUpdates':
            assert self.revealed
        return True

    def special(self, target):
        helpers = (
            'ClearPalettes', 'DelayFrames', 'ReloadTilesetAndPalettes',
            'UpdateSprites', 'Call_ExitMenu', 'StartMenu.SetUpMenuItems',
            'StartMenu.DrawMenuAccount', 'DrawVariableLengthMenuBox',
            'GetMenuIndexSet', 'RunMenuItemPrintingFunction', 'SafeUpdateSprites',
            'ApplyTilemap', 'InitMenuCursorAndButtonPermissions',
            'StartMenu_PrintBugContestStatus', 'GetSGBLayout', 'LoadOW_BGPal7',
            'FadeInFromWhite', 'EnableSpriteUpdates',
        )
        for name in helpers:
            bank, address = self.sym[name]
            if target == address and (bank == 0 or bank == self.bank):
                return self.modeled(name)
        if target == self.sym['FarCall_JumpToHL'][1]:
            for name in helpers:
                if self.sym[name] == (self.bank, self.pair(4)):
                    return self.modeled(name)
        return False


def exercise(rom, sym, label, contest=False, cursor=3):
    cpu = ReturnCPU(rom, sym, contest, cursor)
    cpu.run(label)
    assert cpu.revealed and cpu.draws == 1 and cpu.exits == 1
    assert cpu.calls.count('StartMenu_PrintBugContestStatus') == int(contest)
    assert cpu.bank == sym[label][0]
    return cpu


def verify(rom_path, sym_path):
    rom, sym = rom_path.read_bytes(), symbols(sym_path)
    for label in ('StartMenu.CloseSubmenu', 'StartMenu.Clear'):
        for contest in (False, True):
            for cursor in (1, 3, 7):
                exercise(rom, sym, label, contest, cursor)
    # Removing the redraw must detect the original stale-font publication.
    bank, address = sym['StartMenu.FinishRedraw']
    start = bank * 0x4000 + address - 0x4000
    target = sym['SetUpMenu'][1]
    call = bytes((0xcd, target & 255, target >> 8))
    position = rom.index(call, start, start + 64)
    mutant = bytearray(rom)
    target = sym['DrawVariableLengthMenuBox'][1]
    mutant[position:position + 3] = bytes((0xcd, target & 255, target >> 8))
    try:
        exercise(mutant, sym, 'StartMenu.CloseSubmenu')
    except AssertionError as error:
        assert str(error) == 'stale glyph references revealed', error
    else:
        raise AssertionError('missing text redraw mutant accepted')
    # Each full-screen START submenu uses the guarded return, never the shared
    # map return. Options dispatches via StartMenu.Clear (exercised above).
    guarded = sym['StartMenu.CloseSubmenu'][1].to_bytes(2, 'little')
    for label, end_label in (
        ('StartMenu_Status', 'StartMenu_Pokedex'),
        ('StartMenu_Pokedex', 'StartMenu_Pokegear'),
        ('StartMenu_Pokegear', 'StartMenu_Pack'),
        ('StartMenu_Pack', 'StartMenu_Pack.used_item'),
        ('StartMenu_Pokemon.return', 'StartMenu_Pokemon.quit'),
    ):
        bank, address = sym[label]
        start = bank * 0x4000 + address - 0x4000
        end = start + sym[end_label][1] - address
        assert rom[start:end].count(b'\xcd' + guarded) == 1, label
    print(f'{rom_path.name}: 12 compiled START return cases PASS; '
          '5 submenu callers checked; missing-redraw mutant rejected; '
          'graphics helpers modeled, not PPU/emulator evidence; '
          f'SHA256 {hashlib.sha256(rom).hexdigest()}')


if __name__ == '__main__':
    verify(Path(sys.argv[1]), Path(sys.argv[2]))
