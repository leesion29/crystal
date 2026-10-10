"""Execute the three small modified routines from the final SM83 ROM.

This is a bounded instruction harness, not an emulator or runtime proof.
External calls use their declared interfaces; unknown instructions/calls fail.
Run from the project root: python tools/verify_stats_transitions.py ROM SYM
"""

import sys
import struct
import zlib
from pathlib import Path

from verify_following_sprites import symbols


def hangul_font_from_png(path):
    """Read this project's indexed 8-bit PNG and independently pack 8x16 glyphs."""
    png = path.read_bytes()
    assert png[:8] == b"\x89PNG\r\n\x1a\n"
    pos, compressed, palette = 8, bytearray(), None
    while pos < len(png):
        size = int.from_bytes(png[pos:pos + 4], "big")
        kind, body = png[pos + 4:pos + 8], png[pos + 8:pos + 8 + size]
        crc = int.from_bytes(png[pos + 8 + size:pos + 12 + size], "big")
        assert zlib.crc32(kind + body) == crc, "font PNG checksum"
        if kind == b"IHDR":
            width, height, depth, color, compression, filtering, interlace = struct.unpack(">IIBBBBB", body)
            assert depth == 8 and color == 3 and (compression, filtering, interlace) == (0, 0, 0)
            assert width % 8 == 0 and height % 16 == 0
        elif kind == b"PLTE":
            palette = [body[i:i + 3] for i in range(0, len(body), 3)]
        elif kind == b"IDAT":
            compressed.extend(body)
        elif kind == b"tRNS":
            raise AssertionError("font PNG transparency is unsupported")
        pos += size + 12
    assert palette is not None
    packed = zlib.decompress(compressed)
    assert len(packed) == (width + 1) * height
    previous, pixels = bytes(width), bytearray()
    for y in range(height):
        offset = y * (width + 1)
        filtering = packed[offset]
        row = bytearray(packed[offset + 1:offset + 1 + width])
        for x in range(width):
            left, up, corner = row[x - 1] if x else 0, previous[x], previous[x - 1] if x else 0
            if filtering == 0:
                predictor = 0
            elif filtering == 1:
                predictor = left
            elif filtering == 2:
                predictor = up
            elif filtering == 3:
                predictor = (left + up) // 2
            elif filtering == 4:
                p = left + up - corner
                distances = (abs(p - left), abs(p - up), abs(p - corner))
                predictor = (left, up, corner)[distances.index(min(distances))]
            else:
                raise AssertionError("unsupported PNG filter")
            row[x] = (row[x] + predictor) & 255
        previous = row
        pixels.extend(row)
    result = bytearray()
    for y in range(0, height, 16):
        for x in range(0, width, 8):
            for dy in range(16):
                value = 0
                for dx in range(8):
                    color = palette[pixels[(y + dy) * width + x + dx]]
                    assert color in (b"\x00\x00\x00", b"\xff\xff\xff"), "non-binary font color"
                    value = (value << 1) | (color == b"\x00\x00\x00")
                result.append(value)
    return bytes(result)


class Harness:
    def __init__(self, rom, sym, entry, color=1, vbank=0):
        self.rom, self.sym = rom, sym
        self.bank, self.pc = sym[entry]
        self.mem = bytearray(65536)
        self.mem[sym["hCGB"][1]] = color
        self.mem[0xff4f] = vbank
        self.mem[sym["hROMBank"][1]] = self.bank
        self.a = self.bc = self.de = self.hl = 0
        self.z = False
        self.stack = []
        self.lcd = True
        self.stats_exit_vbank = 1
        self.copies = []
        self.glyphs = []
        self.done = False

    def byte(self):
        offset = self.pc if self.pc < 0x4000 else self.bank * 0x4000 + self.pc - 0x4000
        value = self.rom[offset]
        self.pc += 1
        return value

    def word(self):
        low = self.byte()
        return low | (self.byte() << 8)

    def call(self, addr):
        def is_name(name):
            return addr == self.sym[name][1]

        if is_name("DisableLCD"):
            self.lcd = False
        elif is_name("EnableLCD"):
            self.lcd = True
        elif is_name("CopyBytes"):
            assert not self.lcd and self.mem[0xff4f] == 0, "unsafe VRAM copy"
            self.copies.append((self.hl, self.de, self.bc))
            self.mem[self.de:self.de + self.bc] = self.mem[self.hl:self.hl + self.bc]
            self.hl += self.bc
            self.de += self.bc
            self.bc = 0
        elif is_name("FillBoxWithByte"):
            height, width = self.bc >> 8, self.bc & 255
            assert height and width
            for y in range(height):
                start = self.hl + y * 20
                self.mem[start:start + width] = bytes([self.a]) * width
            self.hl += height * 20
        elif is_name("ByteFill"):
            self.mem[self.hl:self.hl + self.bc] = bytes([self.a]) * self.bc
            self.hl += self.bc
            self.bc = 0
        elif is_name("_PlaceHangul"):
            assert self.bank == self.sym["_PlaceHangul"][0], "wrong glyph ROM bank"
            assert self.bc == 0xe8, "dot must be a standard single-height glyph"
            self.glyphs.append((self.bc, self.hl))
            self.mem[self.hl] = 0x80  # consumer supplies a cache tile, not source $e8
            self.hl += 1
        elif is_name("FarCall_de"):
            bank = self.bank
            assert self.de == self.sym["_PlaceHangul"][1]
            self.bank = self.a
            self.call(self.de)
            self.bank = bank
        elif any(is_name(name) for name in ("ClearSprites", "LowVolume", "MaxVolume")):
            pass
        else:
            raise AssertionError(f"unmodeled call {self.bank:02x}:{addr:04x}")

    def run(self):
        for _ in range(200):
            if self.done:
                assert not self.stack, "unbalanced AF stack"
                return
            opcode = self.byte()
            if opcode in (0x01, 0x11, 0x21):
                setattr(self, {0x01: "bc", 0x11: "de", 0x21: "hl"}[opcode], self.word())
            elif opcode == 0x3e:
                self.a = self.byte()
            elif opcode in (0x06, 0x0e):
                value = self.byte()
                self.bc = (value << 8) | (self.bc & 255) if opcode == 6 else (self.bc & 0xff00) | value
            elif opcode == 0xaf:
                self.a, self.z = 0, True
            elif opcode == 0xa7:
                self.z = self.a == 0
            elif opcode == 0xe6:
                self.a &= self.byte()
                self.z = self.a == 0
            elif opcode == 0xfe:
                self.z = self.a == self.byte()
            elif opcode == 0xfa:
                self.a = self.mem[self.word()]
            elif opcode == 0xea:
                self.mem[self.word()] = self.a
            elif opcode == 0xf0:
                self.a = self.mem[0xff00 + self.byte()]
            elif opcode == 0xe0:
                self.mem[0xff00 + self.byte()] = self.a
            elif opcode == 0xf5:
                self.stack.append((self.a, self.z))
            elif opcode == 0xf1:
                self.a, self.z = self.stack.pop()
            elif opcode == 0x36:
                self.mem[self.hl] = self.byte()
            elif opcode == 0x23:
                self.hl += 1
            elif opcode in (0x18, 0x20, 0x28):
                offset = self.byte()
                if opcode == 0x18 or (opcode == 0x20 and not self.z) or (opcode == 0x28 and self.z):
                    self.pc += offset if offset < 128 else offset - 256
            elif opcode == 0xcd:
                self.call(self.word())
            elif opcode == 0xc3:
                self.call(self.word())
                self.done = True
            elif opcode in (0xc9, 0xc8, 0xc0):
                self.done = opcode == 0xc9 or (opcode == 0xc8 and self.z) or (opcode == 0xc0 and not self.z)
            elif opcode == 0xd7:  # rst Bankswitch
                self.bank = self.a
                self.mem[self.sym["hROMBank"][1]] = self.a
            elif opcode == 0xcf:  # rst FarCall, only the stats-screen boundary
                assert (self.a, self.hl) == self.sym["BattleStatsScreenInit"]
                # Stats replaces frontpic, page tiles, heading and exp graphics.
                self.mem[0x9000:0x9600] = bytes([0xaa]) * 0x600
                self.mem[0xff4f] = self.stats_exit_vbank
            else:
                raise AssertionError(f"unmodeled SM83 opcode ${opcode:02x} at ${self.pc - 1:04x}")
        raise AssertionError("routine did not terminate")


def verify(rom_path, sym_path):
    rom, sym = rom_path.read_bytes(), symbols(sym_path)
    root = Path(__file__).resolve().parent.parent

    def code(name, size):
        bank, addr = sym[name]
        offset = bank * 0x4000 + addr - 0x4000 if bank else addr
        return rom[offset:offset + size]

    def instruction(opcode, operand):
        return bytes([opcode]) + struct.pack("<H", operand)

    font = hangul_font_from_png(root / "gfx/font/font_hangul.png")
    assert len(font) == 45056
    assert font == (root / "gfx/font/font_hangul.1bpp").read_bytes(), "Hangul 8x16 tile ordering"
    for name, start, size in (("HangulPoC_Gfx", 0, 0x4000),
                              ("HangulPoC_Font2", 0x4000, 0x3000),
                              ("HangulPoC_Font3", 0x7000, 0x3000),
                              ("HangulPoC_Font4", 0xa000, 0x1000)):
        assert code(name, size) == font[start:start + size], f"ROM Hangul font: {name}"

    tiles = sym["wTilemap"][1]
    dot_call = instruction(0xcd, sym["StatsScreen_PlaceDot"][1])
    number = instruction(0x21, tiles + 1) + bytes([0x36, 0x74, 0x23]) + dot_call
    assert number in code("StatsScreen_InitUpperHalf", 100), "number prefix consumer"
    assert instruction(0x21, tiles + 199) + dot_call in code("LoadPinkPage", 150), "immunity dot consumer"
    for name, x, y, height in (("LoadPinkPage", 8, 10, 6),
                               ("LoadGreenPage", 8, 4, 12), ("LoadBluePage", 8, 6, 10)):
        frame = instruction(0x21, tiles + y * 20 + x)
        frame += instruction(0x01, height * 256 + 10)
        frame += instruction(0xcd, sym["TextboxBorder"][1])
        assert frame in code(name, 250), f"frame consumer/palette: {name}"
    clear = sym["StatsScreen_LoadGFX.ClearBox"][1]
    pals = sym["StatsScreen_LoadGFX.LoadPals"][1]
    assert code("StatsScreen_LoadGFX.ClearBox", pals - clear).endswith(
        instruction(0xc3, sym["StatsScreen_ClearPageAttrs"][1])
    ), "attribute reset consumer"
    apply_bank, apply_addr = sym["ApplyAttrmap"]
    apply = bytes([0x3e, apply_bank]) + instruction(0x21, apply_addr) + bytes([0xcf])
    assert apply in code("StatsScreen_LoadGFX.LoadPals", 40), "attribute transfer consumer"
    for vbank in (0, 1):
        cpu = Harness(rom, sym, "Battle_StatsScreen", vbank=vbank)
        pattern = bytes((i * 37 + i // 256) & 255 for i in range(4096))
        cpu.mem[0x8000:0x9000] = pattern
        original = pattern[:0x550]
        cpu.mem[0x9000:0x9550] = original
        cpu.run()
        assert cpu.mem[0x9000:0x9550] == original, "backpic/frontpic not fully restored"
        assert cpu.mem[0x8800:0x9000] == pattern[0x800:], "backup overlaps Hangul cache"
        assert cpu.mem[0xff4f] == vbank and cpu.lcd, "VRAM bank/LCD return state"
        assert cpu.copies == [(0x9310, 0x8000, 576), (0x9000, 0x8240, 784),
                              (0x8000, 0x9310, 576), (0x8240, 0x9000, 784)]

    attrs = sym["wAttrmap"][1]
    flags = sym["wStatsScreenFlags"][1]
    dmg = Harness(rom, sym, "StatsScreen_ClearPageAttrs", color=0)
    original_attrs = bytes(i % 8 for i in range(360))
    dmg.mem[attrs:attrs + 360] = original_attrs
    dmg.run()
    assert dmg.mem[attrs:attrs + 360] == original_attrs, "DMG attributes changed"
    # All directed transitions, including repeated pages and animation flag bits.
    for old_page in (1, 2, 3):
        for new_page in (1, 2, 3):
            for high_bits in (0, 0x10, 0x20, 0x40, 0x70):
                cpu = Harness(rom, sym, "StatsScreen_ClearPageAttrs")
                initial = bytearray((i % 8) for i in range(360))
                for y in range(18):
                    initial[y * 20 + 8:y * 20 + 20] = bytes([7]) * 12
                if old_page == 1:
                    initial[329:339] = bytes([2]) * 10
                cpu.mem[attrs:attrs + 360] = initial
                cpu.mem[flags] = new_page | high_bits
                cpu.run()
                actual = cpu.mem[attrs:attrs + 360]
                for y in range(18):
                    assert actual[y * 20:y * 20 + 8] == initial[y * 20:y * 20 + 8]
                    for x in range(8, 20):
                        expected = 2 if new_page == 1 and y == 16 and 9 <= x <= 18 else 0
                        assert actual[y * 20 + x] == expected, (old_page, new_page, x, y)

    for color in (0, 1):
        for x, y in ((2, 0), (19, 9)):
            cpu = Harness(rom, sym, "StatsScreen_PlaceDot", color=color)
            cpu.hl = sym["wTilemap"][1] + y * 20 + x
            target = cpu.hl
            cpu.mem[target - 20:target + 2] = bytes([0x55]) * 22
            bank = cpu.bank
            cpu.run()
            assert cpu.hl == target + 1 and cpu.bank == bank
            assert cpu.mem[target - 20:target] == bytes([0x55]) * 20
            assert cpu.mem[target + 1] == 0x55
            assert cpu.mem[target] == (0x80 if color else 0xe8)
            assert len(cpu.glyphs) == color
    print(f"{rom_path.name}: bounded final-ROM checks PASS: battle restore "
          "(2 VRAM-bank entries), page attributes (45 CGB + 1 DMG cases), dot (4 cases). "
          "External calls modeled; emulator behavior remains untested.")
    print("Hangul PNG -> 2816 complete 8x16 glyphs -> 45056 font/ROM bytes PASS")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("usage: verify_stats_transitions.py ROM SYM")
    verify(Path(sys.argv[1]), Path(sys.argv[2]))
