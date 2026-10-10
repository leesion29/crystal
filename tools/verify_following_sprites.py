"""Verify MBC3 placement and every following/menu-icon asset in a linked ROM.

Run from the project root with: python tools/verify_following_sprites.py ROM SYM
The decoder follows home/decompress.asm and tools/lz/uncomp.c.
"""

import re
import struct
import sys
from pathlib import Path


def decompress(data):
    pos = 0
    output = bytearray()

    def take():
        nonlocal pos
        if pos >= len(data):
            raise ValueError("truncated compressed data")
        value = data[pos]
        pos += 1
        return value

    while True:
        control = take()
        if control == 0xff:
            if pos != len(data):
                raise ValueError("bytes after compression terminator")
            return bytes(output)
        command = control >> 5
        count = control & 31
        if command == 7:
            command = (control >> 2) & 7
            if command == 7:
                raise ValueError("invalid long command")
            count = ((control & 3) << 8) | take()
        count += 1
        if len(output) + count > 384:
            raise ValueError("following sprite exceeds 24 tiles")
        if command == 0:
            output.extend(take() for _ in range(count))
        elif command in (1, 2):
            pattern = bytes(take() for _ in range(command))
            output.extend(pattern[i % command] for i in range(count))
        elif command == 3:
            output.extend(bytes(count))
        else:
            offset = take()
            if offset & 128:
                ref = len(output) - (offset & 127) - 1
            else:
                ref = (offset << 8) | take()
            for i in range(count):
                index = ref - i if command == 6 else ref + i
                if not 0 <= index < len(output):
                    raise ValueError("invalid compression back-reference")
                value = output[index]
                if command == 5:
                    value = int(f"{value:08b}"[::-1], 2)
                output.append(value)


def symbols(path):
    result = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = re.fullmatch(r"([0-9a-fA-F]+):([0-9a-fA-F]+) (.+)", line)
        if match:
            bank, addr, name = match.groups()
            result[name] = (int(bank, 16), int(addr, 16))
    return result


def check_decoder():
    # Independent fixtures for all seven commands, a long command and failures.
    literal = bytes([2]) + b"abc"
    fixtures = [
        (b"\xff", b""),
        (literal + b"\xff", b"abc"),
        (b"\x21B\xff", b"BB"),
        (b"\x43CD\xff", b"CDCD"),
        (b"\x62\xff", bytes(3)),
        (literal + b"\x82\x00\x00\xff", b"abcabc"),
        (literal + b"\xa2\x00\x00\xff", b"abc\x86\x46\xc6"),
        (literal + b"\xc2\x00\x02\xff", b"abccba"),
        (literal + b"\x82\x80\xff", b"abcccc"),
        (b"\xed\x7f\xff", bytes(384)),
    ]
    for data, expected in fixtures:
        assert decompress(data) == expected, "decoder fixture"
    for data in (b"\x00", b"\xfc\x00", b"\x80\x00\x00\xff",
                 b"\xff\x00", b"\xed\x80\xff"):
        try:
            decompress(data)
        except ValueError:
            continue
        raise AssertionError("decoder accepted invalid fixture")


def verify(rom_path, sym_path):
    check_decoder()
    root = Path(__file__).resolve().parent.parent
    rom = rom_path.read_bytes()
    sym = symbols(sym_path)
    assert rom[0x147] == 0x10, "MBC3+timer+RAM+battery header changed"
    assert len(rom) == 2 * 1024 * 1024, "ROM exceeds standard MBC3 capacity"
    assert rom[0x148:0x14a] == bytes([6, 3]), "ROM/RAM size header mismatch"
    assert rom[0x14d] == (-sum(rom[0x134:0x14d]) - 25) & 255, "header checksum"
    assert int.from_bytes(rom[0x14e:0x150], "big") == (
        sum(rom) - sum(rom[0x14e:0x150])
    ) & 65535, "global checksum"
    for name, (bank, addr) in sym.items():
        if 0x4000 <= addr < 0x8000:
            assert 1 <= bank <= 0x7f, f"unsupported ROMX bank: {name}"

    def read(name, length):
        bank, addr = sym[name]
        assert 1 <= bank <= 0x7f and 0x4000 <= addr < 0x8000, name
        assert addr + length <= 0x8000, f"asset crosses ROM bank: {name}"
        offset = bank * 0x4000 + addr - 0x4000
        return rom[offset:offset + length]

    source = (root / "gfx/following_sprites.asm").read_text(encoding="utf-8")
    assets = dict(re.findall(r'(\w+)::\s+INCBIN "([^"]+)"', source))
    pointer_source = (root / "gfx/following_sprite_pointers.asm").read_text(encoding="utf-8")
    table = None
    pointer_count = 0
    referenced = set()
    for line in pointer_source.splitlines():
        label = re.fullmatch(r"(\w+)::", line.strip())
        if label:
            table = label[1]
            pointer_count = 0
        pointer = re.fullmatch(r"\s*dba (\w+)", line)
        null = re.fullmatch(r"\s*db 0, 0, 0", line)
        if pointer or null:
            data = read(table, 3 * (pointer_count + 1))[-3:]
            if pointer:
                name = pointer[1]
                bank, addr = sym[name]
                assert data == bytes([bank]) + struct.pack("<H", addr), name
                referenced.add(name)
            else:
                assert data == bytes(3), "unused species pointer changed"
            pointer_count += 1
    assert referenced == assets.keys(), "pointer/asset populations differ"
    for name, filename in assets.items():
        compressed = (root / filename).read_bytes()
        raw = (root / filename.removesuffix(".lz")).read_bytes()
        png = (root / (filename.removesuffix(".2bpp.lz") + ".png")).read_bytes()
        assert png[:8] == b"\x89PNG\r\n\x1a\n" and png[12:16] == b"IHDR", name
        assert struct.unpack(">II", png[16:24]) == (16, 96), f"sprite dimensions: {name}"
        assert len(raw) == 384, name
        assert decompress(compressed) == raw, f"compression round trip: {name}"
        assert read(name, len(compressed)) == compressed, f"ROM asset: {name}"
        # GetIcon loads four tiles at offsets 0 and 12 tiles.
        assert len(raw[0:64]) == len(raw[192:256]) == 64, name
        assert any(raw[:64]) and any(raw[192:256]), f"empty icon frame: {name}"
    print(f"{rom_path.name}: headers/checksums/ROMX banks PASS; "
          f"{len(assets)} assets, pointers, compression and icon frames PASS")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("usage: verify_following_sprites.py ROM SYM")
    verify(Path(sys.argv[1]), Path(sys.argv[2]))
