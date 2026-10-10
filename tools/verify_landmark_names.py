"""Source checks; optionally check assembled landmark routines with ROM SYM.

Without ROM arguments, copy/conversion checks are models, not CPU execution.
With ROM arguments, the bounded SM83 harness executes the assembled routines;
PlaceString is stubbed, so neither mode is emulator/display evidence.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def source(path):
    return (ROOT / path).read_text(encoding="utf-8")


def charmap():
    mapping = {}
    for path in ("constants/charmap.asm", "constants/charmap_hangul_poc.asm",
                 "constants/charmap_hangul_complete.asm"):
        depth = 0
        for line in source(path).splitlines():
            if line.strip() == "pushc":
                depth += 1
            if line.strip() == "popc":
                depth -= 1
            if depth:
                continue
            match = re.match(r'\s*charmap "([^"]+)",\s*([^;]+)', line)
            if match:
                values = []
                for value in match[2].split(","):
                    value = value.strip()
                    values.append(0x17 if value == "HANGUL_POC_ESCAPE" else
                                  int(value[1:], 16) if value.startswith("$") else int(value))
                mapping[match[1]] = bytes(values)
    return mapping


def encode(text, mapping):
    keys = sorted(mapping, key=len, reverse=True)
    result = bytearray()
    while text:
        key = next((key for key in keys if text.startswith(key)), None)
        assert key is not None, ("unmapped character", text)
        result.extend(mapping[key])
        text = text[len(key):]
    return bytes(result)


def copy_model(data):
    result = bytearray()
    cursor = 0
    while True:
        value = data[cursor]
        count = 3 if value == 0x17 else 1
        result.extend(data[cursor:cursor + count])
        cursor += count
        if value == 0x50:
            return bytes(result)


def convert_model(data):
    result = bytearray(data)
    cursor = 0
    while result[cursor] != 0x50:
        if result[cursor] == 0x17:
            cursor += 3
        elif result[cursor] in (0x1f, 0x25):
            result[cursor] = 0x22  # <LF>; only the first break is converted.
            break
        else:
            cursor += 1
    return bytes(result)


def verify(rom_path=None, sym_path=None):
    mapping = charmap()
    assert mapping["<LF>"] == bytes([0x22])
    size = int(re.search(r"DEF STRING_BUFFER_LENGTH EQU (\d+)",
                         source("constants/script_constants.asm"))[1])
    assert size >= 23  # The longest landmark still requires 23 bytes.
    # This source-only calculation uses the existing map/symbols, not a new link.
    map_path, symbols_path = ROOT / "pokecrystal.map", ROOT / "pokecrystal.sym"
    if map_path.exists() and symbols_path.exists():
        from verify_following_sprites import symbols
        baseline = symbols(symbols_path)
        old_size = baseline["wStringBuffer2"][1] - baseline["wStringBuffer1"][1]
        bank_map = map_path.read_text(encoding="utf-8").split("WRAMX bank #1:", 1)[1].split("WRAMX bank #2:", 1)[0]
        free = int(re.search(r"TOTAL EMPTY: \$([0-9a-fA-F]+)", bank_map)[1], 16)
        # A changed allocation can relocate scratch out of bank 1. Only a
        # fresh link is authoritative for capacity; do not extrapolate this map.
        growth = max(0, size-old_size) * 5
        # The seer scratch union remains smaller than its unchanged mon buffer.
        old_seer_size = baseline["wSeerCaughtGender"][1] + 1 - baseline["wSeerAction"][1]
        old_location_size = baseline["wSeerTimeOfDay"][1] - baseline["wSeerCaughtLocation"][1]
        union_size = int(re.search(r'SECTION: .*?\(\$([0-9a-fA-F]+) bytes\) \["Miscellaneous WRAM 1"\]', bank_map)[1], 16)
        assert old_seer_size + size-old_location_size <= union_size
        print(f"Existing link-map: shared-buffer growth {growth}, bank-1 free {free} bytes; seer fits its union. Fresh link required after allocation changes.")
    data_source = source("data/maps/landmarks.asm")
    names = dict(re.findall(r'^(\w+Name):\s+db "([^"]*)"', data_source, re.M))
    assert len(names) == 102
    assert names["BattleTowerName"] == "배틀 타워@"
    encoded = {label: encode(text, mapping) for label, text in names.items()}
    for label, data in encoded.items():
        assert len(data) <= size and data[-1] == 0x50, (label, len(data))
        assert f"assert @ - {label} <= STRING_BUFFER_LENGTH" in data_source, label
    copier = source("engine/overworld/landmarks.asm").split("GetLandmarkName::", 1)[1].split("INCLUDE", 1)[0]
    assert "ld d, h\n\tld e, l\n\tld hl, wStringBuffer1\n\tcall CopyName2" in copier
    assert "ld c, 18" not in copier
    wram = source("ram/wram.asm")
    for label in [f"wStringBuffer{i}" for i in range(1, 6)] + ["wSeerCaughtLocation"]:
        assert f"{label}:: ds STRING_BUFFER_LENGTH" in wram, label
    assert "wTMHMMoveNameBackup:: ds TMHM_MOVE_NAME_BUFFER_LENGTH" in wram
    seer = source("engine/events/poke_seer.asm")
    assert "farcall GetLandmarkName\n\tld de, wStringBuffer1\n\tld hl, wSeerCaughtLocation\n\tcall CopyName2" in seer
    converter = source("engine/pokegear/townmap_convertlinebreakcharacters.asm")
    assert "cp HANGUL_POC_ESCAPE\n\tjr z, .hangul\n\tcp '@'" in converter
    assert "\tinc hl\n\tinc hl\n\tinc hl\n\tjr .loop" in converter
    cases = list(encoded.values())
    # Payload bytes identical to @, <BSP> and <WBR> must remain opaque.
    for bank in (0x1f, 0x25, 0x50):
        for glyph in (0x1f, 0x25, 0x50):
            cases.append(bytes([0x17, bank, glyph, 0x1f, 0x80, 0x50]))
    for data in cases:
        assert copy_model(data + bytes([0xcc]) * size) == data
        converted = convert_model(data)
        assert len(converted) == len(data) and copy_model(converted) == converted
    print(f"Source PASS: {len(names)} mapped/terminated/bounded names (max {max(map(len, encoded.values()))}/{size} bytes), assembly assertions, all destination buffers, seer copy and Hangul-aware converter; {len(cases)} model cases. No assembled/runtime claim.")
    if rom_path is None:
        return
    from verify_following_sprites import symbols
    from verify_tmhm_text import CPU
    rom, sym = Path(rom_path).read_bytes(), symbols(Path(sym_path))
    start = sym["wStringBuffer1"][1]
    assert sym["wStringBuffer2"][1] - start == size
    assert sym["wSeerTimeOfDay"][1] - sym["wSeerCaughtLocation"][1] == size
    bank, table = sym["Landmarks"]
    labels = re.findall(r"^\s*landmark\s+-?\d+,\s*-?\d+,\s*(\w+)", data_source, re.M)
    cpu = CPU(rom, sym)
    cpu.bank = bank
    for label, data in encoded.items():
        name_bank, address = sym[label]
        assert name_bank == bank
        assert bytes(cpu.read(address + i) for i in range(len(data))) == data, label
    for index, label in enumerate(labels):
        cpu.mem[start-1:start+size+1] = bytes([0xcc]) * (size+2)
        cpu.setpair(0, 0x1234)
        cpu.setpair(2, 0x5600 + index)
        cpu.setpair(4, 0x9abc)
        cpu.run("GetLandmarkName")
        expected = encoded[label]
        assert cpu.mem[start:start+len(expected)] == expected, label
        assert cpu.mem[start-1] == cpu.mem[start+size] == 0xcc, label
        assert (cpu.pair(0), cpu.pair(2), cpu.pair(4)) == (0x1234, 0x5600+index, 0x9abc)
        assert cpu.bank == bank
    for data in cases:
        cpu.mem[0xc000:0xc000+len(data)] = data
        for label in [f"wStringBuffer{i}" for i in range(1, 6)] + ["wSeerCaughtLocation"]:
            destination = sym[label][1]
            cpu.mem[destination-1:destination+size+1] = bytes([0xcc]) * (size+2)
            cpu.setpair(2, 0xc000)
            cpu.setpair(4, destination)
            cpu.run("CopyName2", caller_bank=bank)
            assert cpu.mem[destination:destination+len(data)] == data, label
            assert cpu.mem[destination-1] == cpu.mem[destination+size] == 0xcc, label
        cpu.mem[start:start+len(data)] = data
        cpu.mem[start-1] = cpu.mem[start+size] = 0xcc
        assert sym["PlaceString"][0] == 0
        cpu.special = lambda target: target == sym["PlaceString"][1]
        cpu.run("TownMap_ConvertLineBreakCharacters")
        assert cpu.mem[start:start+len(data)] == convert_model(data)
        assert cpu.mem[start-1] == cpu.mem[start+size] == 0xcc
    print(f"{Path(rom_path).name}: assembled {len(labels)} landmark lookups and {len(cases)} copy/conversion cases PASS; register/bank and buffer guards PASS. PlaceString modeled; not emulator evidence.")


if __name__ == "__main__":
    assert len(sys.argv) in (1, 3), "usage: verify_landmark_names.py [ROM SYM]"
    verify(*sys.argv[1:])
