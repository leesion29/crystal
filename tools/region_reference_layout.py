"""Serialize explicitly reviewed reference choices; no prose generation or writes.

Only whitespace/line placement changes. Tokens and unsupported consumers require
explicit rows in the authored plan. Output remains a development review draft.
"""
import json
import re
import sys
from pathlib import Path
import region_translation as t


def width(s):
    return len(s.replace('<PLAYER>', '1234567').replace('<RIVAL>', '1234567'))


def pack(words, count):
    # Dynamic programming uses only word boundaries, with an 18-column limit.
    def solve(index, left):
        key = index, left
        if key in cache:
            return cache[key]
        if index == len(words):
            return [''] * left
        if not left:
            return None
        options = []
        for end in range(index + 1, len(words) + 1):
            line = ' '.join(words[index:end])
            if width(line) > 18:
                break
            options.append((end, line))
        target = sum(width(w) + 1 for w in words[index:]) / left
        for end, line in sorted(options, key=lambda item: abs(width(item[1]) - target)):
            tail = solve(end, left - 1)
            if tail is not None:
                cache[key] = [line] + tail
                return cache[key]
        cache[key] = None
        return None
    cache = {}
    return solve(0, count)


def pages(body):
    return [t.rows(p) for p in re.split(r'(?m)(?=^[ \t]*para[ \t]+)', body)
            if t.rows(p)]


def layout(body, reference):
    raise RuntimeError(
        'Fixed English row/page slots are retired: preserve Korean reference '
        'layout and review the actual consumer. See docs/text_commands.md and '
        'tools/verify_korean_text_layout.py. Historical rows are not a reapply plan.'
    )
    assert not re.search(r'@|<[^>]+>|\{d:', ''.join(t.rows(reference))), 'requires explicit token/digit layout'
    current, gold = pages(body), pages(reference)
    if len(current) == len(gold):
        result = []
        for slots, wording in zip(current, gold):
            packed = pack(' '.join(wording).split(), len(slots))
            assert packed is not None and any(packed), 'page capacity'
            result.extend(packed)
    else:
        words = ' '.join(t.rows(reference)).split()
        # Partition reference words without changing them. Every existing page
        # has at least one word; keep its original command/row count.
        result = []
        for i, slots in enumerate(current):
            remaining_slots = sum(len(p) for p in current[i:])
            target = max(1, round(len(words) * len(slots) / remaining_slots))
            if i == len(current) - 1:
                target = len(words)
            limit = len(words) - (len(current) - i - 1)
            packed = None
            for count in sorted(range(1, limit + 1), key=lambda n: abs(n-target)):
                packed = pack(words[:count], len(slots))
                if packed is not None:
                    words = words[count:]
                    break
            assert packed is not None and any(packed), 'page capacity'
            result.extend(packed)
        assert not words
    assert re.sub(r'\s+', '', ''.join(result)) == t.normalized(reference)
    return result


selection = json.loads(Path(sys.argv[1]).read_text(encoding='utf-8'))
entries, issues = [], []
for choice in selection:
    path = choice['file']
    original = t.blocks(t.read(t.ROOT / path))
    ref_file = choice.get('ref_file', path)
    source = choice.get('source', 'original-gold')
    refs = t.blocks(t.read(t.ROOT.parent / source / ref_file))
    selected = choice.get('labels', [k for k in original if k not in choice.get('exclude', [])])
    for label in selected:
        candidate = refs.get(label)
        if not candidate or not t.HANGUL.search(candidate[2]):
            continue
        if t.HANGUL.search(original[label][2]):
            continue
        try:
            rows = layout(original[label][2], candidate[2])
            entries.append({'file': path, 'label': label, 'source': source,
                            'ref_file': ref_file, 'rows': rows,
                            'state': 'development-needs-human-review'})
        except AssertionError as error:
            issues.append([path, label, str(error)])
print(json.dumps({'entries': entries, 'explicit_layout_required': issues}, ensure_ascii=False))
