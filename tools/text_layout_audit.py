"""Audit current Korean text consumers; emit reversible, prose-preserving fixes.

Use docs/text_commands.md plus the current home/text.asm consumer, not English
row counts. Reference layouts require identical wording and variable order.
The tool emits patches; only apply_patch writes project files.
"""
import argparse
import collections
import difflib
import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / '.verification/text-layout-20261011/baseline'
HANGUL = re.compile('[가-힣]')
LABEL = re.compile(r'^(\.?[A-Za-z_][\w.]*)::?(?:[^\n]*)$', re.M)
ROW = re.compile(r'^\s*(text|line|cont|para|next|page|db)\s+"([^"]*)"\s*(?:;.*)?$')
LAYOUT = {'text', 'text_start', 'line', 'cont', 'para', 'next', 'page'}
TERMINAL = {'done', 'prompt', 'text_end'}


def has_korean(statements):
    return any(HANGUL.search(v) for c,v in statements if c in LAYOUT or c=='db')


def read(path):
    return path.read_text(encoding='utf-8-sig')


def split_blocks(source):
    labels = list(LABEL.finditer(source))
    scope = ''
    for i, label in enumerate(labels):
        name = label[1]
        if name.startswith('.'):
            name = scope + name
        else:
            scope = name
        end = labels[i+1].start() if i+1 < len(labels) else len(source)
        body = source[label.end():end]
        lines = body.splitlines(keepends=True)
        start = next((i for i, line in enumerate(lines) if re.match(r'^\s*(?:text(?:_start|_ram|_buffer|_decimal|_bcd|_today)?)(?:\s|$)', line)), None)
        if start is None:
            continue
        stop = next((i+1 for i in range(start, len(lines)) if lines[i].strip().split(';')[0].strip() in TERMINAL), None)
        if stop is None:
            continue
        content = ''.join(lines[start:stop])
        # Blocks containing executable assembly are not dialogue data.
        if re.search(r'^\s*(?:ld|call|jp|jr|ret|text_asm|text_far)\b', content, re.M):
            continue
        statements = []
        unsupported = []
        for line in content.splitlines():
            stripped = line.strip()
            if not stripped or stripped.startswith(';'):
                continue
            if match := ROW.fullmatch(line):
                statements.append([match[1], match[2]])
            elif match := re.fullmatch(r'(text_\w+|done|prompt|sound_\w+)\s*(.*?)(?:\s*;.*)?', stripped):
                statements.append([match[1], match[2]])
            else:
                unsupported.append(stripped)
        yield {'label': name, 'start': label.end()+sum(map(len, lines[:start])),
               'end': label.end()+sum(map(len, lines[:stop])),
               'body': content, 'statements': statements, 'unsupported': unsupported,
               'line': source.count('\n', 0, label.start())+1}


def wording(statements):
    # Preserve all non-layout tokens, text command arguments and terminators.
    chunks = []
    for cmd, value in statements:
        if cmd in LAYOUT or cmd == 'db':
            chunks.append(value.replace('#MON', '포켓몬').replace('#GEAR', '포켓기어').replace('<……>', '……'))
        elif cmd not in TERMINAL:
            chunks.append(f'{{{cmd}:{value}}}')
    return re.sub(r'\s+', '', ''.join(chunks))


def width(text):
    sizes = {'<PLAYER>':7, '<RIVAL>':7, '<PLAY_G>':8, '<USER>':16,
             '<TARGET>':16, '<ENEMY>':18, '<MOM>':5, '<RED>':5, '<GREEN>':5,
             '#MON':7, '#GEAR':8, '<PKMN>':2, '<POKE>':2, '<……>':2,
             '<PC>':2, '<ROCKET>':6, '<TM>':2, '<TRAINER>':7}
    for token, size in sizes.items():
        text = text.replace(token, 'X'*size)
    if '{d:' in text:
        import region_translation
        constants = region_translation.numeric_constants() | {'NUM_UNOWN':'26', 'NUM_POKEMON':'251'}
        text = re.sub(r'\{d:(\w+)\}', lambda m: constants[m[1]], text)
    text = text.replace('@', '')
    text = re.sub(r'<(?:LINE|NEXT|PARA|CONT|_CONT|SCROLL|DONE|PROMPT|LF)>', '', text)
    return len(text)


def inspect(block):
    issues = []
    row, col, text_mode = 0, 0, False
    for cmd, value in block['statements']:
        if text_mode and (cmd == 'text_start' or cmd not in LAYOUT|TERMINAL and cmd!='db'):
            issues.append(f'TX command {cmd} entered without preceding string @')
        if text_mode and cmd == 'text_end':
            issues.append('TX_END consumed as string @; missing command terminator')
        if cmd in ('line', 'next', 'cont', 'para', 'page'):
            if cmd == 'line':
                if row == 1:
                    issues.append('line repeats bottom row: overwrites preceding line')
                row = 1
            elif cmd == 'next':
                row += 1
                if row > 1:
                    issues.append('next leaves the two-line dialogue box')
            elif cmd in ('para', 'page'):
                row = 0
            else:
                row = 1
            col = 0
        if cmd in LAYOUT or cmd == 'db':
            # A subsequent text resumes the current BC cursor after RAM/number.
            if cmd == 'text' and text_mode:
                issues.append('text resumes string without @ before new TX_START')
            col += width(value)
            text_mode = not value.endswith('@')
            if col > 18:
                issues.append(f'width {col}/18: {cmd} {value}')
        elif cmd in TERMINAL:
            text_mode = False
        elif cmd in ('text_ram', 'text_buffer'):
            # Bounds traced at producers, not byte lengths of Hangul encoding.
            limits = {
                ('DisabledMoveText','wStringBuffer1'):7,
                ('_OPT_MaryText1','wStringBuffer1'):5,
                ('_OakPCText3','wStringBuffer3'):3,
                ('_OakPCText3','wStringBuffer4'):3,
                ('_SeerNoLocationText','wSeerCaughtLevelString'):3,
            }
            bound = limits.get((block['label'],value))
            if bound is None:
                if value.endswith('TrademonSpeciesName'):bound=5
                elif value.endswith('TrademonSenderName') or value=='wPlayerName':bound=7
                else:bound=10  # Other nickname/general buffers: conservative.
            col += bound
            text_mode = False
        elif cmd in ('text_decimal', 'text_bcd'):
            digits = re.findall(r'\d+', value)
            if digits:
                col += int(digits[-1])
            text_mode = False
        elif cmd == 'text_today':
            # TextCommand_DAY still emits SUN..WEDNES + DAY, max 9 columns.
            col += 9
            text_mode = False
        elif cmd == 'text_low':
            row, col = 1, 0
            text_mode = False
        elif cmd in ('text_waitbutton', 'text_promptbutton', 'text_pause', 'text_dots') or cmd.startswith('sound_'):
            text_mode = False
        if col > 18 and cmd not in LAYOUT and cmd != 'db' and cmd not in TERMINAL:
            issues.append(f'dynamic width {col}/18 after {cmd} {value}')
    return list(dict.fromkeys(issues))


def inventory():
    tracked = subprocess.check_output(['git','ls-files','*.asm'], cwd=ROOT).decode().splitlines()
    history = subprocess.check_output(['git','log','a024806..HEAD','--format=','--name-only','--','*.asm'], cwd=ROOT).decode().splitlines()
    changed = subprocess.check_output(['git','diff','--name-only','--','*.asm'], cwd=ROOT).decode().splitlines()
    files = []
    for path in tracked:
        if path.startswith(('constants/', 'gfx/', 'ram/', 'macros/', 'vc/')):
            continue
        source = read(ROOT/path)
        if re.search(r'"[^"\n]*[가-힣][^"\n]*"', source):
            files.append({'file':path, 'uncommitted':path in changed,
                          'in_post_fork_history':path in history,
                          'sha256':hashlib.sha256((ROOT/path).read_bytes()).hexdigest()})
    return files


def scan(use_baseline=False):
    files = inventory()
    refs = {}
    for source in ('original-gold', 'oldgold'):
        index = collections.defaultdict(list)
        for folder in ('maps', 'data/text', 'data/phone/text'):
            for path in (ROOT.parent/source/folder).glob('*.asm'):
                for block in split_blocks(read(path)):
                    if not block['unsupported'] and has_korean(block['statements']):
                        index[wording(block['statements'])].append((str(path.relative_to(ROOT.parent/source)).replace('\\','/'), block))
        refs[source] = index
    entries = []
    count = collections.Counter()
    for item in files:
        path = item['file']
        source = read((BASE/path) if use_baseline else (ROOT/path))
        for block in split_blocks(source):
            if not has_korean(block['statements']):
                continue
            key = wording(block['statements'])
            candidates = []
            ref_source = None
            for candidate_source in ('original-gold', 'oldgold'):
                candidates = refs[candidate_source].get(key, [])
                if candidates:
                    ref_source = candidate_source
                    break
            match = next((c for c in candidates if c[0] == path and c[1]['label'] == block['label']), None)
            if match is None:
                match = next((c for c in candidates if c[1]['label'].lstrip('_') == block['label'].lstrip('_')), None)
            if match is None and len(candidates) == 1:
                match = candidates[0]
            record = {'file':path, 'label':block['label'], 'line':block['line'],
                      'before':block['body'], 'statements':block['statements'],
                      'issues':inspect(block), 'unsupported':block['unsupported']}
            if match:
                record['reference'] = {'source':ref_source,'file':match[0], 'label':match[1]['label'],
                                       'statements':match[1]['statements'], 'issues':inspect(match[1])}
            count['dialogue_blocks'] += 1
            count['reference_matched'] += bool(match)
            count['layout_mismatch'] += bool(match and [s for s in block['statements'] if s[0] not in TERMINAL] != [s for s in match[1]['statements'] if s[0] not in TERMINAL])
            count['potential_issues'] += bool(record['issues'])
            entries.append(record)
        item['dialogue_blocks'] = sum(e['file'] == path for e in entries)
    return {'state':'analysis', 'criterion':'docs/text_commands.md + home/text.asm + actual consumer',
            'files':files, 'counts':dict(count), 'blocks':entries}


def render(statements):
    output = []
    for cmd, value in statements:
        if cmd == 'para':
            output.append('\n')
        if cmd in LAYOUT and cmd != 'text_start' or cmd == 'db':
            output.append(f'\t{cmd} "{value}"\n')
        else:
            output.append('\t' + cmd + (' '+value if value else '') + '\n')
    return ''.join(output)


def reference_edits(report):
    result = []
    for entry in report['blocks']:
        ref = entry.get('reference')
        if not ref or entry['unsupported']:
            continue
        before = entry['statements']
        after = [s for s in ref['statements'] if s[0] not in TERMINAL]
        after += [s for s in before if s[0] in TERMINAL]
        # Fixed reference wording plus the current Crystal variables, numbers,
        # waits/sounds and terminal. Whitespace and layout controls may differ.
        if wording(before) != wording(after):
            continue
        if before == after:
            continue
        if ref['issues']:
            continue  # Resolve overflows with the actual caller, not a guess.
        if [s for s in before if s[0] not in LAYOUT|TERMINAL and s[0] != 'db'] != [s for s in after if s[0] not in LAYOUT|TERMINAL and s[0] != 'db']:
            continue
        result.append({'file':entry['file'], 'label':entry['label'],
                       'reason':'restore corresponding Korean reference rows and page/scroll controls',
                       'reference':{k:v for k,v in ref.items() if k not in ('statements','issues')},
                       'before':entry['before'], 'after':render(after)})
    return result


def emit_patch(before, after, path):
    print('*** Update File: '+str(ROOT/path).replace('\\','/'))
    for line in list(difflib.unified_diff(before.splitlines(), after.splitlines(), n=3))[2:]:
        print('@@' if line.startswith('@@') else line)


def replace_entry(source, entry):
    if entry.get('whole_label'):
        labels = list(LABEL.finditer(source))
        found = [i for i,m in enumerate(labels) if m[1] == entry['label']]
        assert len(found) == 1, entry['label']
        i = found[0]
        start = labels[i].end()
        end = labels[i+1].start() if i+1 < len(labels) else len(source)
        assert source[start:end] == entry['before'], ('conditional baseline divergence',entry['label'])
        return source[:start] + entry['after'] + source[end:]
    blocks = [b for b in split_blocks(source) if b['label'] == entry['label']]
    assert len(blocks) == 1, ('ambiguous/missing label',entry['file'],entry['label'])
    block = blocks[0]
    assert block['body'] == entry['before'], ('baseline divergence',entry['file'],entry['label'])
    return source[:block['start']] + entry['after'] + source[block['end']:]


def reference_patch(report, batch):
    edits = reference_edits(report)
    paths = sorted({e['file'] for e in edits})[batch*10:(batch+1)*10]
    entries = [e for e in edits if e['file'] in paths]
    assert entries, ('empty batch',batch)
    print('*** Begin Patch')
    for path in paths:
        original = read(BASE/path)
        assert read(ROOT/path) == original, ('overlapping file edit',path)
        updated = original
        for entry in entries:
            if entry['file'] == path:
                updated = replace_entry(updated,entry)
        emit_patch(original,updated,path)
    print('*** Add File: '+str(ROOT/f'data/translation/text-layout-repairs-{batch:02d}.json').replace('\\','/'))
    print('+[')
    for i, entry in enumerate(entries):
        print('+'+json.dumps(entry,ensure_ascii=False)+(',' if i+1<len(entries) else ''))
    print('+]')
    print('*** End Patch')


def verify_repairs():
    entries = []
    for path in sorted((ROOT/'data/translation').glob('text-layout-repairs-*.json')):
        entries += json.loads(read(path))
    files = inventory()
    for item in files:
        path = item['file']
        original = read(BASE/path)
        expected = original
        for entry in [e for e in entries if e['file'] == path]:
            def full_statements(body):
                result = []
                for line in body.splitlines():
                    if match := ROW.fullmatch(line):
                        result.append([match[1],match[2]])
                    elif line.strip() and not line.strip().startswith(';'):
                        words = line.strip().split(None,1)
                        result.append([words[0],words[1] if len(words)>1 else ''])
                return {'statements':result}
            before = full_statements(entry['before'])
            after = full_statements(entry['after'])
            before_word=wording(before['statements']);after_word=wording(after['statements'])
            if entry.get('allow_string_terminator'):
                assert (path,entry['label'])==('data/text/common_1.asm','_OakTimeWhatHoursText')
                assert before['statements']==[['text','뭐야!'],['text_end','']]
                assert after['statements']==[['text','뭐야!@'],['text_end','']]
                after_word=after_word.replace('@','')
            assert before_word == after_word, ('changed prose/variable',path,entry['label'])
            assert [s for s in before['statements'] if s[0] not in LAYOUT and s[0]!='db'] == [s for s in after['statements'] if s[0] not in LAYOUT and s[0]!='db'], ('changed non-layout command',path,entry['label'])
            expected = replace_entry(expected,entry)
        assert read(ROOT/path) == expected, ('unplanned edits outside text layout',path)
    print(len(files),'Korean ASM files checked;',len({e['file'] for e in entries}),'changed files;',len(entries),'layout repairs; prose/variables/terminators/waits/non-text source preservation PASS')


def wrap_words(value):
    rows, current = [], ''
    for word in value.split():
        trial = (current+' '+word).strip()
        if width(trial) <= 18:
            current = trial
        else:
            assert current and width(word) <= 18, ('cannot wrap without splitting a word',value,word)
            rows.append(current)
            current = word
    if current:
        rows.append(current)
    return rows


def merge_patch(batch):
    selections = json.loads(read(ROOT/'data/translation/text-layout-merge-selection.json'))
    paths = sorted(selections)[batch*10:(batch+1)*10]
    assert paths, ('empty batch',batch)
    entries = []
    print('*** Begin Patch')
    for path in paths:
        before = read(ROOT/path)
        after = before
        blocks = {b['label']:b for b in split_blocks(before)}
        for label, grouping in selections[path].items():
            block = blocks[label]
            assert not block['unsupported'], label
            assert all(cmd in LAYOUT|TERMINAL for cmd,value in block['statements']), ('dynamic text needs explicit layout',label)
            pages = []
            for cmd,value in block['statements']:
                if cmd in TERMINAL:
                    continue
                if cmd in ('text','para'):
                    pages.append([])
                assert pages, label
                pages[-1].append(value)
            assert sum(grouping) == len(pages), (path,label,len(pages),grouping)
            result, index = [], 0
            for size in grouping:
                value = ' '.join(v for page in pages[index:index+size] for v in page)
                rows = wrap_words(value)
                assert rows, label
                for i,row in enumerate(rows):
                    result.append(['text' if not result else 'para' if i==0 else 'line' if i==1 else 'cont',row])
                index += size
            result += [s for s in block['statements'] if s[0] in TERMINAL]
            assert wording(result) == wording(block['statements']), ('prose difference',label)
            entry = {'file':path,'label':label,'reason':'reviewed semantic paragraphs; remove English-slot fragments and blank padding rows',
                     'before':block['body'],'after':render(result)}
            if entry['before'] != entry['after']:
                entries.append(entry)
                after = replace_entry(after,entry)
        if before != after:
            emit_patch(before,after,path)
    print('*** Add File: '+str(ROOT/f'data/translation/text-layout-repairs-{20+batch:02d}.json').replace('\\','/'))
    print('+[')
    for i, entry in enumerate(entries):
        print('+'+json.dumps(entry,ensure_ascii=False)+(',' if i+1<len(entries) else ''))
    print('+]')
    print('*** End Patch')


def reviewed_patch():
    """Finite reviewed corrections, not a blanket English-to-Korean reflow."""
    entries = []
    files = {}
    def add(path, block, after, reason, whole=False):
        if block['body'] == after:
            return
        entry = {'file':path,'label':block['label'],'before':block['body'],
                 'after':after,'reason':reason}
        if whole:
            entry['whole_label'] = True
        entries.append(entry)
        files[path] = replace_entry(files.get(path,read(ROOT/path)),entry)

    for e in scan()['blocks']:
        if not e['unsupported'] and any(c in ('line','cont','next') and not v for c,v in e['statements']):
            st = [s for s in e['statements'] if not (s[0] in ('line','cont','next') and not s[1])]
            add(e['file'],{'label':e['label'],'body':e['before']},render(st),
                'remove empty English-slot padding; retain intentional empty para/waits')
    groups = {
        ('data/phone/text/todd_overworld.asm','ToddAskNumber2Text'):[2],
        ('maps/Route34.asm','YoungsterSamuelMobileText'):[1,2],
        ('maps/NewBarkTown.asm','Text_ItsDangerousToGoAlone'):[1,2],
        ('maps/KurtsHouse.asm','KurtsHouseKurtMakingBallsMustWaitText'):[1,2,2,2,1,2,1,1],
    }
    for (path,label),sizes in groups.items():
        block = next(b for b in split_blocks(files.get(path,read(ROOT/path))) if b['label']==label)
        pages = []
        for c,v in block['statements']:
            if c in ('text','para'):pages.append([])
            if c in LAYOUT:pages[-1].append(v)
        assert sum(sizes)==len(pages),(label,len(pages))
        result,index=[],0
        for size in sizes:
            rows=wrap_words(' '.join(v for p in pages[index:index+size] for v in p))
            for i,row in enumerate(rows):
                result.append(['text' if not result else 'para' if i==0 else 'line' if i==1 else 'cont',row])
            index+=size
        result += [s for s in block['statements'] if s[0] in TERMINAL]
        add(path,block,render(result),'reviewed sentence continuity and maximum PLAYER width')
    path='data/text/common_1.asm'
    for label in ('_EnemyWithdrewText','_EnemyUsedOnText'):
        block=next(b for b in split_blocks(files.get(path,read(ROOT/path))) if b['label']==label)
        st=[s[:] for s in block['statements']]
        assert st[0]==['text','<ENEMY>는(은)'] and st[1]==['line','@']
        st[0][1]='<ENEMY>'
        st[1][1]='는(은) @'
        add(path,block,render(st),'trainer class+name can fill 18 columns; put suffix on following line')
    path='maps/GoldenrodGameCorner.asm'
    for label in ('GoldenrodGameCornerPharmacistText','GoldenrodGameCornerPokefanM1Text',
                  'GoldenrodGameCornerPokefanM2Text','GoldenrodGameCornerPokefanFText'):
        source=files.get(path,read(ROOT/path))
        labels=list(LABEL.finditer(source));i=next(i for i,m in enumerate(labels) if m[1]==label)
        body=source[labels[i].end():labels[i+1].start()]
        assert body.count('\nelse\n')==1
        head,tail=body.split('\nelse\n')
        oldtail,ending=tail.split('\nendc',1)
        if label.endswith('PokefanFText'):
            aftertail='\tpara "자신이 예상을 하기 쉽기때문에"\n\tline "슬롯머신보다 좋아해"\n\n\tpara "하지만 배율은 훨씬 낮단다"\n\tdone\n'
        else:
            ref=next(b for b in split_blocks(read(ROOT.parent/'original-gold'/path)) if b['label']==label)
            st=[s[:] for s in ref['statements']]
            if label.endswith('PokefanM2Text'):
                # Crystal's active branch does not contain Gold's first line.
                assert st.pop(0)==['text','슬롯머신으로도 이길 수 없고']
                st[0][0]='text'
            aftertail=render(st)
        # Verify BOTH branches, including code directives and terminal counts.
        before_prose=re.sub(r'\s+','',''.join(m[2] for m in map(ROW.fullmatch,oldtail.splitlines()) if m))
        after_prose=re.sub(r'\s+','',''.join(m[2] for m in map(ROW.fullmatch,aftertail.splitlines()) if m))
        assert before_prose==after_prose,label
        after=head+'\nelse\n'+aftertail+'\nendc'+ending
        add(path,{'label':label,'body':body},after,'review active non-AU branch; restore reference rows without changing branch/prose',True)
    print('*** Begin Patch')
    for path,after in sorted(files.items()):emit_patch(read(ROOT/path),after,path)
    print('*** Add File: '+str(ROOT/'data/translation/text-layout-repairs-30.json').replace('\\','/'))
    print('+[')
    for i,e in enumerate(entries):print('+'+json.dumps(e,ensure_ascii=False)+(',' if i+1<len(entries) else ''))
    print('+]')
    print('*** End Patch')


def final_patch():
    entries=[]
    paths={}
    specs={
        ('data/text/common_1.asm','_EnemyWithdrewText'):[
            ['text','<ENEMY>'],['line','는(은) @'],['text_buffer','5'],
            ['text',''],['cont','를(을) 도로 불러 들였다!'],['prompt','']],
        ('maps/Route32.asm','Route32CooltrainerMText_AideIsWaiting'):[
            ['text','<PLAYER>'],['line','(이)란 사람이 그댄가?'],
            ['cont','그대를 찾아다니는'],['cont','안경쓴 사내가 있었다'],
            ['para','포켓몬센터에서'],['line','그대를 기다리고 있을 것이다'],
            ['cont','그곳에 가 보거라!'],['done','']],
    }
    path='maps/KurtsHouse.asm';label='KurtsHouseKurtMakingBallsMustWaitText'
    ref=next(b for b in split_blocks(read(ROOT.parent/'original-gold'/path)) if b['label']==label)
    st=[s[:] for s in ref['statements']]
    index=st.index(['para','그런가 <PLAYER>(이)라고 하는가'])
    st[index:index+1]=[['para','그런가 <PLAYER>'],['line','(이)라고 하는가']]
    st[index+2][0]='cont'
    specs[(path,label)]=st
    for (path,label),st in specs.items():
        block=next(b for b in split_blocks(read(ROOT/path)) if b['label']==label)
        assert wording(block['statements'])==wording(st),label
        assert not inspect({'label':label,'statements':st}),(label,inspect({'label':label,'statements':st}))
        entry={'file':path,'label':label,'before':block['body'],'after':render(st),
               'reason':'reference layout with only the necessary maximum-name overflow adjustment'}
        entries.append(entry)
        paths[path]=replace_entry(paths.get(path,read(ROOT/path)),entry)
    print('*** Begin Patch')
    for path,after in sorted(paths.items()):emit_patch(read(ROOT/path),after,path)
    print('*** Add File: '+str(ROOT/'data/translation/text-layout-repairs-31.json').replace('\\','/'))
    print('+[')
    for i,e in enumerate(entries):print('+'+json.dumps(e,ensure_ascii=False)+(',' if i+1<len(entries) else ''))
    print('+]')
    print('*** End Patch')


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('action', choices=['scan', 'inventory-patch', 'details', 'reference-patch', 'merge-patch', 'reviewed-patch', 'final-patch', 'verify'])
    p.add_argument('--batch',type=int,default=0)
    p.add_argument('--filter',default='')
    args = p.parse_args()
    if args.action == 'final-patch':
        final_patch()
        raise SystemExit(0)
    if args.action == 'reviewed-patch':
        reviewed_patch()
        raise SystemExit(0)
    if args.action == 'verify':
        verify_repairs()
        raise SystemExit(0)
    if args.action == 'merge-patch':
        merge_patch(args.batch)
        raise SystemExit(0)
    report = scan(use_baseline=args.action=='reference-patch')
    if args.action == 'scan':
        print(json.dumps({'files':len(report['files']), 'counts':report['counts'],
                          'file_groups':dict(collections.Counter(e['file'].split('/')[0] for e in report['files']))},ensure_ascii=False))
        for e in report['blocks']:
            if e['issues'] or e['unsupported']:
                print(e['file'], e['label'], e['issues'], e['unsupported'])
    elif args.action == 'inventory-patch':
        report.pop('blocks')
        print('*** Begin Patch')
        print('*** Add File: '+str(ROOT / 'data/translation/text-layout-inventory.json').replace('\\','/'))
        for line in json.dumps(report,ensure_ascii=False,indent=2).splitlines():
            print('+'+line)
        print('*** End Patch')
    elif args.action == 'reference-patch':
        reference_patch(report,args.batch)
    else:
        for entry in report['blocks']:
            if (args.filter and args.filter in entry['file']+' '+entry['label']) or (not args.filter and (entry['issues'] or entry['unsupported'])):
                print(entry['file'],entry['label'],entry['issues'],entry['unsupported'])
                print(' | '.join(c+':'+v for c,v in entry['statements']))
                if entry.get('reference'):
                    print('REF',entry['reference']['source'],entry['reference']['file'],entry['reference']['label'])
                    print(' | '.join(c+':'+v for c,v in entry['reference']['statements']))
