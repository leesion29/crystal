"""Read-only inventory, explicit-plan patch generation, and preservation checks.

Translation choices live in a reviewed JSON plan. This tool does not choose or
generate wording. `patch` emits an apply_patch input; it never writes ASM files.
"""
import argparse
import collections
import difflib
import hashlib
import json
import re
import subprocess
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASELINE_REF = 'HEAD'
BASELINE_DIR = None
LITERAL_PLAN = []
LABEL = re.compile(r'^([A-Za-z_][\w.]*)::?[^\n]*$', re.M)
STRING = re.compile(r'^(\s*(?:text|line|cont|para|next|db)\s+)"([^"]*)"(.*)$', re.M)
HANGUL = re.compile(r'[가-힣]')
REGIONS = {
    'route32': ['maps/Route32.asm', 'maps/Route32Pokecenter1F.asm',
                'maps/Route32RuinsOfAlphGate.asm',
                'data/phone/text/ralph_overworld.asm', 'data/phone/text/liz_overworld.asm'],
    'route33': ['maps/Route33.asm', 'data/phone/text/anthony_overworld.asm'],
    'azalea': ['maps/AzaleaTown.asm', 'maps/AzaleaPokecenter1F.asm',
               'maps/AzaleaMart.asm', 'maps/AzaleaGym.asm', 'maps/KurtsHouse.asm',
               'maps/CharcoalKiln.asm', 'data/text/common_1.asm'],
    'well': ['maps/SlowpokeWellB1F.asm', 'maps/SlowpokeWellB2F.asm'],
    'ilex': ['maps/IlexForest.asm', 'maps/IlexForestAzaleaGate.asm',
             'maps/Route34IlexForestGate.asm'],
}
COMMON_LABELS = {'_WhichApricornText', '_HowManyShouldIMakeText'}


def read(path):
    return path.read_text(encoding='utf-8-sig')


def baseline(path):
    if BASELINE_DIR is not None:
        return read(BASELINE_DIR / path)
    return subprocess.check_output(['git', 'show', BASELINE_REF + ':' + path], cwd=ROOT).decode('utf-8-sig')


def blocks(source):
    labels = list(LABEL.finditer(source))
    result = {}
    for i, label in enumerate(labels):
        end = labels[i+1].start() if i+1 < len(labels) else len(source)
        body = source[label.end():end]
        if re.search(r'^\s*text\s+"', body, re.M) or (re.search(r'^\s*text_start\s*$', body, re.M) and STRING.search(body)):
            result[label[1]] = (label.end(), end, body)
    return result


def rows(body):
    return [m[2] for m in STRING.finditer(body)]


def normalized(body):
    return re.sub(r'\s+', '', ''.join(rows(body)).replace('<……>', '……'))


@lru_cache(None)
def numeric_constants():
    result = {}
    for path in list((ROOT / 'constants').glob('*.asm')) + list((ROOT / 'maps').glob('*.asm')):
        for name, value in re.findall(r'^DEF\s+(\w+)\s+EQU\s+(\d+)\s*(?:;.*)?$', read(path), re.M):
            if name in result:
                assert result[name] == value, ('conflicting numeric constant', name)
            result[name] = value
    return result


def expand_digits(row):
    return re.sub(r'\{d:(\w+)\}', lambda m: numeric_constants()[m[1]], row)


def inventory(region):
    for path in REGIONS[region]:
        found = blocks(read(ROOT / path))
        if path in COMMON_FILTERS:
            found = {k:v for k,v in found.items() if k in COMMON_FILTERS[path]}
        print('\nFILE', path, 'blocks', len(found), 'Korean',
              sum(bool(HANGUL.search(v[2])) for v in found.values()))
        for label, (_, _, body) in found.items():
            if HANGUL.search(body):
                continue
            print(label, '| C:', ' / '.join(rows(body)))
            for ref in ('original-gold', 'oldgold'):
                refpath = ROOT.parent / ref / path
                candidate = blocks(read(refpath)).get(label) if refpath.exists() else None
                if candidate and HANGUL.search(candidate[2]):
                    print('  ', ref, '|', ' / '.join(rows(candidate[2])))
                    break


def transformed(source, entries):
    found = blocks(source)
    edits = []
    for entry in entries:
        start, end, body = found[entry['label']]
        replacements = entry['rows']
        assert not HANGUL.search(body), ('existing Korean', entry['label'])
        matches = list(STRING.finditer(body))
        assert len(matches) == len(replacements), (entry['label'], len(matches), len(replacements))
        for match, text in reversed(list(zip(matches, replacements))):
            assert '"' not in text and '\n' not in text
            body = body[:match.start(2)] + text + body[match.end(2):]
        edits.append((start, end, body))
    for start, end, body in sorted(edits, reverse=True):
        source = source[:start] + body + source[end:]
    return source


def patch(plan, region):
    print('*** Begin Patch')
    for path in REGIONS[region]:
        entries = [e for e in plan if e['file'] == path]
        if not entries:
            continue
        before = read(ROOT / path)
        original = baseline(path) if BASELINE_DIR is not None else before
        after = transformed(original, entries)
        if before == after:
            continue
        assert before == original, ('overlapping edit', path)
        print('*** Update File: ' + str(ROOT / path).replace('\\', '/'))
        delta = list(difflib.unified_diff(before.splitlines(), after.splitlines(), n=3))[2:]
        for line in delta:
            print('@@' if line.startswith('@@') else line)
    print('*** End Patch')


def verify(plan, region, preflight=False):
    from verify_landmark_names import charmap, encode
    mapping = charmap()
    counts = collections.Counter()
    for path in REGIONS[region]:
        before = baseline(path)
        entries = [e for e in plan if e['file'] == path]
        expected = transformed(before, entries)
        if LITERAL_PLAN:
            from goldenrod_literals import transform_literals
            expected = transform_literals(expected, [e for e in LITERAL_PLAN if e['file'] == path])
        after = expected if preflight else read(ROOT / path)
        assert expected == after, ('unplanned edit', path)
        original, current = blocks(before), blocks(after)
        if path in COMMON_FILTERS:
            original = {k:v for k,v in original.items() if k in COMMON_FILTERS[path]}
        counts['preserved'] += sum(bool(HANGUL.search(v[2])) for v in original.values())
        for entry in entries:
            label, provenance = entry['label'], entry['source']
            body = current[label][2]
            old = original[label][2]
            # Preserve directives, control sequences and non-string code exactly.
            assert STRING.sub(lambda m: m[1] + '""' + m[3], body) == STRING.sub(
                lambda m: m[1] + '""' + m[3], old), label
            tokens = lambda b: re.findall(r'<[^>]+>|@|\{d:\w+\}', ''.join(rows(b)))
            assert tokens(body) == tokens(old), ('tokens', label)
            for page in re.split(r'(?m)(?=^\s*para\s+)', body):
                page_rows = rows(page)
                if page_rows:
                    assert any(s.strip() for s in page_rows), ('empty page', label)
            if provenance in ('original-gold', 'oldgold'):
                reference = ROOT.parent / provenance / entry.get('ref_file', path)
                refbody = blocks(read(reference))[entry.get('ref_label', label)][2]
                refwording = normalized(refbody)
                for token in entry.get('reference_ignore_tokens', []):
                    assert token == '@', ('unsupported reference token omission', label, token)
                    refwording = refwording.replace(token, '')
                for token, value in entry.get('reference_token_aliases', {}).items():
                    assert (token, value) == ('<PLAYER>군', '<PLAY_G>'), ('unsupported reference alias', label)
                    refwording = refwording.replace(token, value)
                assert expand_digits(normalized(body)) == expand_digits(refwording), ('reuse differs', label)
            for row in rows(body):
                row = expand_digits(row)
                encode(row, mapping)  # Do not let RGBDS's warning silently emit raw ASCII.
                width = re.sub(r'<PLAYER>|<RIVAL>', '1234567', row).replace('<PLAY_G>', '12345678').replace('#MON', '포켓몬').replace('#GEAR', '포켓기어')
                width = width.replace('@', '').replace('<……>', '……')
                assert len(width) <= 18, ('width', label, width, len(width))
            counts[provenance] += 1
        remaining = [k for k,v in original.items() if not HANGUL.search(v[2]) and k not in {e['label'] for e in entries}]
        print(path, 'changed', len(entries), 'remaining', remaining)
    print(region, dict(counts))


def verify_rom(plan, rom_path, sym_path):
    from verify_following_sprites import symbols
    from verify_landmark_names import charmap, encode
    mapping, sym = charmap(), symbols(sym_path)
    rom = rom_path.read_bytes()
    checked = references = 0
    control = {'text': b'\x00', 'line': mapping['<LINE>'],
               'para': mapping['<PARA>'], 'cont': mapping['<CONT>'],
               'next': mapping['<NEXT>']}
    for entry in plan:
        body = blocks(read(ROOT / entry['file']))[entry['label']][2]
        expected = assemble_text(body, mapping, sym, entry['label'])
        bank, address = sym[entry['label']]
        assert 1 <= bank <= 0x7f and address + len(expected) <= 0x8000, entry['label']
        offset = bank * 0x4000 + address - 0x4000
        assert rom[offset:offset+len(expected)] == expected, ('assembled text', entry['label'])
        checked += 1
    for path in {e['file'] for e in plan if e['file'].startswith('maps/')}:
        map_bank = sym[Path(path).stem + '_MapScripts'][0]
        source = read(ROOT / path)
        for target in re.findall(r'^\s*(?:writetext|jumptext|jumptextfaceplayer)\s+(\w+)', source, re.M):
            assert sym[target][0] == map_bank, ('cross-bank map text', path, target)
            references += 1
    print(rom_path.name, checked, 'assembled text blocks/encoding PASS;',
          references, 'same-bank map-text references PASS; SHA256',
          hashlib.sha256(rom).hexdigest())


def assemble_text(body, mapping, sym, label):
    control = {'text': b'\x00', 'line': mapping['<LINE>'],
               'para': mapping['<PARA>'], 'cont': mapping['<CONT>'],
               'next': mapping['<NEXT>']}
    expected = bytearray()
    active = True
    for line in body.splitlines():
        stripped = line.strip()
        if stripped == 'if DEF(_CRYSTAL_AU)':
            assert active, ('nested conditional', label)
            active = False  # Both declared builds do not define _CRYSTAL_AU.
            continue
        if stripped == 'else':
            assert not active, ('unsupported conditional', label)
            active = True
            continue
        if stripped == 'endc':
            assert active, ('unsupported conditional', label)
            continue
        if not active:
            continue
        match = re.fullmatch(r'\s*(text|line|para|cont|next)\s+"([^"]*)"\s*(?:;.*)?', line)
        if match:
            expected.extend(control[match[1]])
            expected.extend(__import__('verify_landmark_names').encode(expand_digits(match[2]), mapping))
        elif stripped in ('done', 'prompt'):
            expected.extend(mapping['<DONE>' if stripped == 'done' else '<PROMPT>'])
            break
        elif stripped == 'text_start':
            expected.append(0)
        elif match := re.fullmatch(r'text_ram\s+(\w+)', stripped):
            expected.append(1)
            expected.extend(sym[match[1]][1].to_bytes(2, 'little'))
        elif stripped and not stripped.startswith(';'):
            raise AssertionError(('unsupported text command', label, line))
    return expected


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=['inventory', 'patch', 'verify', 'preflight', 'rom'])
    parser.add_argument('region')
    parser.add_argument('--scope', type=Path)
    parser.add_argument('--baseline-dir', type=Path)
    parser.add_argument('--plan', type=Path)
    parser.add_argument('--literals', type=Path)
    parser.add_argument('--baseline-ref', default='HEAD')
    parser.add_argument('--rom', type=Path)
    parser.add_argument('--sym', type=Path)
    args = parser.parse_args()
    BASELINE_REF = args.baseline_ref
    BASELINE_DIR = args.baseline_dir
    if args.literals:
        LITERAL_PLAN = json.loads(args.literals.read_text(encoding='utf-8'))
    COMMON_FILTERS = {'data/text/common_1.asm': COMMON_LABELS}
    if args.scope:
        scope = json.loads(args.scope.read_text(encoding='utf-8'))
        REGIONS = scope['regions']
        COMMON_FILTERS = {p:set(labels) for p,labels in scope.get('labels', {}).items()}
    assert args.region == 'all' or args.region in REGIONS, ('unknown region', args.region)
    if args.action == 'inventory':
        for region in REGIONS if args.region == 'all' else [args.region]:
            inventory(region)
    else:
        plan = json.loads(args.plan.read_text(encoding='utf-8'))
        if args.action == 'rom':
            if args.region != 'all':
                plan = [e for e in plan if e['file'] in REGIONS[args.region]]
            verify_rom(plan, args.rom, args.sym)
        else:
            for region in REGIONS if args.region == 'all' else [args.region]:
                if args.action == 'preflight':
                    verify(plan, region, preflight=True)
                else:
                    (patch if args.action == 'patch' else verify)(plan, region)
