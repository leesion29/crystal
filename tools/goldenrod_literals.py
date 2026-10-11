"""Explicit scoped display literals: immutable-source, consumer and ROM checks.

No wording generation. Selectors and expected originals come from the authored
plan. ROM verification checks actual strings and menu header bytes at symbols.
"""
import argparse
import difflib
import json
import re
from pathlib import Path
import region_translation as t
from verify_landmark_names import charmap, encode
from verify_following_sprites import symbols

LABEL = re.compile(r'^(\.?[A-Za-z_][\w.]*)(?::[^\n]*|[ \t]*(?:;[^\n]*)?)$', re.M)
QUOTED = re.compile(r'"([^"\n]*)"')


def segment(source, symbol):
    current = None
    labels = []
    for m in LABEL.finditer(source):
        name = m[1]
        if name.startswith('.'):
            assert current, ('orphan local label', name)
            full = current + name
        else:
            current = name
            full = name
        labels.append((full, m.start(), m.end()))
    selected = [(i, start) for i, (name, start, _) in enumerate(labels) if name == symbol]
    assert len(selected) == 1, ('literal selector', symbol, selected)
    i, start = selected[0]
    end = labels[i+1][1] if i+1 < len(labels) else len(source)
    return start, end, source[start:end]


def transform_literals(source, entries):
    edits = []
    for e in entries:
        start, end, body = segment(source, e['symbol'])
        matches = list(QUOTED.finditer(body))
        assert [m[1] for m in matches] == e['original'], ('literal original', e['symbol'])
        assert len(matches) == len(e['rows'])
        for m, row in reversed(list(zip(matches, e['rows']))):
            assert '"' not in row and '\n' not in row
            body = body[:m.start(1)] + row + body[m.end(1):]
        edits.append((start, end, body))
    for start, end, body in sorted(edits, reverse=True):
        source = source[:start] + body + source[end:]
    return source


def validate(entries, mapping):
    counts = {}
    for e in entries:
        for old, row in zip(e['original'], e['rows']):
            tokens = lambda s: re.findall(r'@|\{d:\w+\}|<[^>]+>', s)
            removed = e.get('printable_japanese_tokens', [])
            assert set(removed) <= {'<WO>', '<GA>'}
            assert tokens(row) == [x for x in tokens(old) if x not in removed], ('literal controls', e['symbol'])
            row = t.expand_digits(row)
            data = encode(row, mapping)
            old_numbers = re.findall(r'\d+', t.expand_digits(old))
            if old_numbers:
                assert old_numbers == re.findall(r'\d+', row), ('changed number/price', e['symbol'])
            assert len(row.rstrip('@')) <= e['width'], ('literal width', e['symbol'], row)
            if e['prefix'] and e['prefix'][0] == 128:
                assert data[-1] == 0x50 and 0x50 not in data[:-1], ('embedded menu terminator', row)
            if e.get('raw_byte_terminator'):
                # GetBuenasPassword.RawString scans bytes, not Hangul escapes.
                assert data[-1] == 0x50 and 0x50 not in data[:-1], ('embedded raw terminator', row)
                assert len(data) <= 25, ('wStringBuffer1 overflow', row)
        assert e['source'] in ('original-gold', 'oldgold', 'new')
        if e['source'] != 'new':
            refs = e.get('references') or [dict(file=e['ref_file'], value=s) for s in e['reference_strings']]
            assert len(refs) == len(e['rows'])
            for refspec in refs:
                ref = t.read(t.ROOT.parent / e['source'] / refspec['file'])
                wording = refspec['value']
                assert '"' + wording + '"' in ref, ('missing literal reference', e['symbol'], wording)
            # Name-only reuse may retain Crystal's prices and menu padding.
            for row, refspec in zip(e['rows'], refs):
                wording = refspec['value']
                pattern = e.get('reference_mode', 'exact')
                if pattern == 'name-with-crystal-price':
                    assert re.sub(r'[\d\s¥₩@-]', '', t.expand_digits(row)) == re.sub(r'[\d\s¥₩@-]', '', t.expand_digits(wording))
                elif pattern == 'name-only':
                    assert row.rstrip('@').split()[0] == wording.rstrip('@')
                else:
                    assert re.sub(r'\s+', '', row) == re.sub(r'\s+', '', wording)
        sources = e.get('row_sources', [e['source']] * len(e['rows']))
        assert len(sources) == len(e['rows'])
        if e['source'] == 'new' and 'row_references' in e:
            assert len(e['row_references']) == len(e['rows'])
            for row, source, ref in zip(e['rows'], sources, e['row_references']):
                if source != 'new':
                    assert ref is not None
                    assert '"' + ref['value'] + '"' in t.read(t.ROOT.parent / source / ref['file'])
                    assert row == ref['value']
        for source in sources:
            counts[source] = counts.get(source, 0) + 1
    print('Literal character/width/terminator/source checks PASS:', counts)


def rom_check(entries, rom_path, sym_path):
    mapping, sym = charmap(), symbols(sym_path)
    rom = rom_path.read_bytes()
    for e in entries:
        bank, address = sym[e['symbol']]
        expected = bytes(e['prefix']) + b''.join(encode(t.expand_digits(row), mapping) for row in e['rows'])
        offset = address if bank == 0 else bank*0x4000 + address - 0x4000
        assert address + len(expected) <= (0x4000 if bank == 0 else 0x8000)
        assert rom[offset:offset+len(expected)] == expected, ('literal ROM bytes', e['symbol'])
    print(rom_path.name, sum(len(e['rows']) for e in entries), 'assembled display literals/menu prefixes PASS')


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('action', choices=['preflight', 'patch', 'verify', 'rom'])
    p.add_argument('--plan', type=Path, required=True)
    p.add_argument('--text-plan', type=Path)
    p.add_argument('--baseline-dir', type=Path)
    p.add_argument('--rom', type=Path)
    p.add_argument('--sym', type=Path)
    args = p.parse_args()
    plan = json.loads(args.plan.read_text(encoding='utf-8'))
    texts = json.loads(args.text_plan.read_text(encoding='utf-8')) if args.text_plan else []
    t.BASELINE_DIR = args.baseline_dir
    if args.action == 'rom':
        rom_check(plan, args.rom, args.sym)
    elif args.action == 'preflight':
        validate(plan, charmap())
        for path in {e['file'] for e in plan}:
            transform_literals(t.transformed(t.baseline(path), [e for e in texts if e['file'] == path]), [e for e in plan if e['file'] == path])
    else:
        if args.action == 'patch':
            print('*** Begin Patch')
        for path in sorted({e['file'] for e in plan}):
            original = t.baseline(path)
            before = t.transformed(original, [e for e in texts if e['file'] == path])
            after = transform_literals(before, [e for e in plan if e['file'] == path])
            current = t.read(t.ROOT / path)
            if args.action == 'verify':
                assert current == after, ('unplanned source edit', path)
            elif current != after:
                assert current == before, ('overlapping source edit', path)
                print('*** Update File: ' + str(t.ROOT / path).replace('\\', '/'))
                for line in list(difflib.unified_diff(before.splitlines(), after.splitlines(), n=3))[2:]:
                    print('@@' if line.startswith('@@') else line)
        if args.action == 'patch':
            print('*** End Patch')
        else:
            validate(plan, charmap())
            print('Scoped literal files and non-string code preservation PASS')
