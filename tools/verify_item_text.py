"""Source/assembled item-text checks. Not emulator or rendered-display evidence.

Usage: python tools/verify_item_text.py [ROM SYM]
The local pre-edit snapshot additionally protects original controls and layout.
"""
import json
import re
import sys
from pathlib import Path

from verify_following_sprites import symbols
from verify_landmark_names import charmap, encode
from verify_tmhm_text import CPU, read_names

ROOT = Path(__file__).resolve().parent.parent


def read(path):
    return (ROOT / path).read_text(encoding="utf-8")


def descriptions(text):
    blocks = {}
    for label, body in re.findall(r"^(\w+Desc):\n(.*?)(?=^\w+Desc:|\Z)", text, re.M | re.S):
        blocks[label] = re.findall(r'^\s*(db|next)\s+"([^"]*)"', body, re.M)
    return blocks


def skeleton(text):
    text = re.sub(r'^\s*(?:DEF LIST_ENTRY_MAX_BYTES.*|PURGE LIST_ENTRY_MAX_BYTES)\n', '', text, flags=re.M)
    return re.sub(r'"[^"]*"', '"STRING"', text).strip()


def verify(rom_path=None, sym_path=None):
    mapping = charmap()
    size = int(re.search(r"DEF STRING_BUFFER_LENGTH EQU (\d+)", read("constants/script_constants.asm"))[1])
    assert size == 25
    name_source = read("data/items/names.asm")
    desc_source = read("data/items/descriptions.asm")
    names = re.findall(r'\bli "([^"]*)"', name_source)
    blocks = descriptions(desc_source)
    pointers = re.findall(r'^\s*dw (\w+Desc)', desc_source, re.M)
    assert len(names) == 256 and len(pointers) == 255
    encoded_names = [encode(name + "@", mapping) for name in names]
    assert max(map(len, encoded_names)) == size
    # GetNthString is a byte scanner. The project's complete glyph mapping
    # avoids the terminator in both payload bytes; prove this for this table.
    assert all(0x50 not in data[:-1] for data in encoded_names)
    assert "DEF LIST_ENTRY_MAX_BYTES = STRING_BUFFER_LENGTH" in name_source
    encoded_descriptions = {}
    for label, lines in blocks.items():
        assert 1 <= len(lines) <= 2, label
        assert lines[0][0] == "db" and all(op == "next" for op, _ in lines[1:])
        assert lines[-1][1].endswith("@"), label
        assert sum(text.count("@") for _, text in lines) == 1, label
        for _, text in lines:
            assert len(text.rstrip("@")) <= 18, ("description width", label, text)
        encoded_descriptions[label] = b"".join(
            (mapping["<NEXT>"] if op == "next" else b"") + encode(text, mapping)
            for op, text in lines)
    baseline_path = ROOT / ".verification/items-20261010/baseline.json"
    baseline = json.loads(baseline_path.read_text(encoding="utf-8")) if baseline_path.exists() else None
    if baseline:
        assert skeleton(name_source) == skeleton(baseline["namesSource"])
        assert skeleton(desc_source) == skeleton(baseline["descSource"])
        expected = baseline["names"][:]
        for index, name in baseline["expectedNames"].items():
            expected[int(index)-1] = name
        assert names == expected
        for label, old_lines in baseline["desc"]["blocks"].items():
            expected_lines = baseline["expectedDescriptions"].get(label, old_lines)
            assert blocks[label] == [(line["op"], line["s"]) for line in expected_lines], label
    wram = read("ram/wram.asm")
    assert "wMonOrItemNameBuffer:: ds STRING_BUFFER_LENGTH" in wram
    assert "wQueuedScriptBank:: db\nwQueuedScriptAddr:: dw" in wram
    assert "wMenuScrollPosition:: ds 4\nwListPointer:: dw\nwUnusedNamesPointer:: dw\nwItemAttributesPointer:: dw" in wram
    ai = read("engine/battle/ai/items.asm").split("PrintText_UsedItemOn:", 1)[1].split("EnemyUsedOnText:", 1)[0]
    assert "ld de, wStringBuffer1\n\tld hl, wMonOrItemNameBuffer\n\tcall CopyName2" in ai
    tm = read("engine/items/tmhm.asm")
    assert tm.count("ld bc, TMHM_MOVE_NAME_BUFFER_LENGTH") == 2
    preservation = "original controls/table order checked against snapshot" if baseline else "snapshot unavailable; no baseline-preservation claim"
    print(f"Source PASS: 256 names (max {size} bytes), {len(blocks)} description blocks / 255 pointers, 18-column bounds, buffer consumers; {preservation}.")
    if not rom_path:
        return
    rom_path, sym_path = Path(rom_path), Path(sym_path)
    rom, sym = rom_path.read_bytes(), symbols(sym_path)
    assert len(rom) == 2 * 1024 * 1024
    assert read_names(rom, sym, "ItemNames", 256) == encoded_names
    cpu = CPU(rom, sym)
    start = sym["wStringBuffer1"][1]
    for i in range(1, 5):
        assert sym[f"wStringBuffer{i+1}"][1] - sym[f"wStringBuffer{i}"][1] == size
    assert sym["wBattleMenuCursorPosition"][1] - sym["wStringBuffer5"][1] == size
    assert sym["wQueuedScriptAddr"][1] == sym["wQueuedScriptBank"][1] + 1
    scratch = sym["wMenuScrollPosition"][1]
    for label, offset in (("wListPointer", 4), ("wUnusedNamesPointer", 6), ("wItemAttributesPointer", 8)):
        assert sym[label] == (0, scratch + offset)
    assert scratch == sym["wOverworldMapBlocksEnd"][1]
    desc_bank, table = sym["ItemDescriptions"]
    assert desc_bank == sym["PrintItemDescription"][0]
    cpu.bank = desc_bank
    for index, label in enumerate(pointers):
        address = sym[label][1]
        assert sym[label][0] == desc_bank and 1 <= desc_bank <= 127
        assert cpu.read(table+2*index) | cpu.read(table+2*index+1) << 8 == address
        data = encoded_descriptions[label]
        assert bytes(cpu.read(address+i) for i in range(len(data))) == data, label
    lookups = 0
    for index, expected in enumerate(encoded_names, 1):
        # The two reserved gaps and trailing unused IDs are not valid TM/HMs.
        if index > 190 and not re.fullmatch(r"(?:기술머신|비전머신)\d{2}", names[index-1]):
            continue
        cpu.mem[start-1:start+size+1] = bytes([0xcc]) * (size+2)
        cpu.mem[sym["wNamedObjectIndex"][1]] = index
        cpu.setpair(0, 0x1234)
        cpu.setpair(4, 0x9876)
        cpu.run("GetItemName", caller_bank=127)
        assert cpu.mem[start:start+len(expected)] == expected, index
        assert cpu.mem[start-1] == cpu.mem[start+size] == 0xcc, index
        assert (cpu.pair(0), cpu.pair(4)) == (0x1234, 0x9876)
        assert cpu.pair(2) == start and cpu.bank == 127
        assert cpu.mem[sym["wNamedObjectIndex"][1]] == index
        lookups += 1
    # Exercise every name against every full-size name destination.
    destinations = [f"wStringBuffer{i}" for i in range(1, 6)] + ["wMonOrItemNameBuffer"]
    for data in encoded_names:
        cpu.mem[0xc000:0xc000+len(data)] = data
        for label in destinations:
            dest = sym[label][1]
            cpu.mem[dest-1:dest+size+1] = bytes([0xcc]) * (size+2)
            cpu.setpair(2, 0xc000)
            cpu.setpair(4, dest)
            cpu.run("CopyName2", caller_bank=127)
            assert cpu.mem[dest:dest+len(data)] == data, label
            assert cpu.mem[dest-1] == cpu.mem[dest+size] == 0xcc, label
    class TextBoundary(Exception):
        pass
    def boundary(target):
        if target in (sym["PlaceString"][1], sym["PrintText"][1]):
            raise TextBoundary
        return False
    cpu.special = boundary
    for index in range(1, 191):
        cpu.mem[sym["wCurSpecies"][1]] = index
        cpu.setpair(2, sym["wTilemap"][1]+281)
        try:
            cpu.run("PrintItemDescription")
            raise AssertionError("missing PlaceString boundary")
        except TextBoundary:
            assert cpu.pair(2) == sym[pointers[index-1]][1]
            assert cpu.pair(4) == sym["wTilemap"][1]+281
            assert cpu.bank == desc_bank
    dest = sym["wMonOrItemNameBuffer"][1]
    for index in range(1, 191):
        cpu.mem[dest-1:dest+size+1] = bytes([0xcc]) * (size+2)
        cpu.mem[sym["wCurEnemyItem"][1]] = index
        try:
            cpu.run("PrintText_UsedItemOn")
            raise AssertionError("missing PrintText boundary")
        except TextBoundary:
            data = encoded_names[index-1]
            assert cpu.mem[dest:dest+len(data)] == data
            # The following byte is StringBuffer1, legitimately written by
            # GetItemName before this copy. Check its complete source instead.
            assert cpu.mem[dest-1] == 0xcc
            assert cpu.mem[start:start+len(data)] == data
            assert dest + size == start
            assert cpu.pair(4) == sym["EnemyUsedOnText"][1]
    # Use the saved full symbol file, not truncated console symbol output.
    previous_path = ROOT / ".verification/tmhm-20261010/pokecrystal.sym"
    if previous_path.exists():
        previous = symbols(previous_path)
        for label, location in previous.items():
            if (label.startswith("s") and 0xa000 <= location[1] < 0xc000) or label in ("wUnusedMapBuffer", "wUnusedMapBufferEnd", "wMonOrItemNameBuffer"):
                assert sym[label] == location, ("protected layout", label)
    if baseline:
        for label in ("wMenuScrollPosition", "wListPointer", "wUnusedNamesPointer", "wItemAttributesPointer", "wQueuedScriptBank", "wQueuedScriptAddr"):
            assert sym[label][0] == 0 and 0xc000 <= sym[label][1] < 0xd000
    map_text = rom_path.with_suffix(".map").read_text(encoding="utf-8")
    for section in ("Menu Pointer Scratch", "Queued Script Scratch"):
        assert section in map_text
    assert "WRAMX bank #1:" in map_text
    print(f"{rom_path.name}: PASS {lookups} assembled GetItemName calls (real TM/HM farcalls), 1536 guarded copies, 190 description selections, 190 AI item-name copies; exact ROM text/pointers, SRAM and buffer guards. Text rendering is stubbed, not emulator evidence.")


if __name__ == "__main__":
    assert len(sys.argv) in (1, 3), "usage: verify_item_text.py [ROM SYM]"
    verify(*sys.argv[1:])
