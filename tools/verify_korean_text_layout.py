"""Build-aware Korean layout and preservation audit (no emulator claim).

This checks every inventoried Korean dialogue in normal/debug and AU branches,
raw item/Pokedex layouts using their own consumers, and negative fixtures.
Artifact byte verification is available only after a successful fresh build.
"""
import argparse
import collections
import hashlib
import json
import re
from pathlib import Path
import text_layout_audit as a
import region_translation as t
from verify_landmark_names import charmap, encode
from verify_following_sprites import symbols


def selected_source(source, debug=False, au=False):
    """Keep line positions; resolve only the actual named build conditionals."""
    stack=[]
    result=[]
    active=True
    for line in source.splitlines(keepends=True):
        s=line.strip()
        if match:=re.fullmatch(r'if\s+(!?)DEF\((_DEBUG|_CRYSTAL_AU)\)',s):
            condition=debug if match[2]=='_DEBUG' else au
            if match[1]:condition=not condition
            stack.append((active,condition,True))
            active=active and condition
            result.append('\n')
        elif s.startswith('if '):
            stack.append((active,True,False))
            result.append(line if active else '\n')
        elif s=='else' and stack:
            parent,condition,known=stack[-1]
            if known:
                active=parent and not condition
                result.append('\n')
            else:result.append(line if active else '\n')
        elif s=='endc' and stack:
            parent,_,known=stack.pop()
            result.append('\n' if known or not active else line)
            active=parent
        else:result.append(line if active else '\n')
    return ''.join(result)


def selftest():
    def issues(st):return a.inspect({'label':'fixture','statements':st})
    cases=[
        ([['text','하나'],['line','둘'],['cont','셋'],['prompt','']],False),
        ([['text','첫 장'],['para','두번째 장'],['done','']],False),
        ([['text','하나'],['line','둘'],['line','셋'],['done','']],True),
        ([['text','하나'],['next','둘'],['next','셋'],['done','']],True),
        ([['text','가'*19],['done','']],True),
        ([['text','<ENEMY>는(은)'],['prompt','']],True),
        ([['text','하나'],['text','둘'],['done','']],True),
        ([['text','하나@'],['text_ram','wStringBuffer1'],['text','!'],['done','']],False),
        ([['text','1234567890@'],['text_ram','wStringBuffer1'],['text','!'],['done','']],True),
        ([['text','값'],['text_ram','wStringBuffer1'],['text','!'],['done','']],True),
        ([['text','뭐야!'],['text_end','']],True),
        ([['text','뭐야!@'],['text_end','']],False),
    ]
    for st,expected in cases:assert bool(issues(st))==expected,(st,issues(st))
    s='X:\nif DEF(_CRYSTAL_AU)\n\ttext "가"\n\tdone\nelse\n\ttext "나"\n\tdone\nendc\n'
    assert next(a.split_blocks(selected_source(s)))['statements'][0][1]=='나'
    assert next(a.split_blocks(selected_source(s,au=True)))['statements'][0][1]=='가'
    print('12 positive/negative layout fixtures and both conditional branches PASS')


def active_dialogues(debug=False,au=False):
    for item in a.inventory():
        for b in a.split_blocks(selected_source(a.read(a.ROOT/item['file']),debug,au)):
            if a.has_korean(b['statements']):
                assert not b['unsupported'],(item['file'],b['label'],b['unsupported'])
                yield item['file'],b


def static_check(preservation=True):
    if preservation:a.verify_repairs()
    selftest()
    counts={}
    unresolved={}
    for debug,au in ((False,False),(True,False),(False,True)):
        key='AU-source' if au else 'debug' if debug else 'normal'
        n=0
        for path,b in active_dialogues(debug,au):
            n+=1
            found=a.inspect(b)
            if found:unresolved[(path,b['label'])]=found
        counts[key]=n
    # A radio segment is automatically scheduled, not a normal A-button box.
    # Do not hide this by injecting a blocking cont/para command.
    assert set(unresolved)=={('data/text/common_1.asm','_BenFernText1')},unresolved
    print('Build-conditional dialogue counts:',counts)
    print('Known deferred radio geometry issue:',unresolved)
    mapping=charmap()
    rows=0
    for item in a.inventory():
        for line in a.read(a.ROOT/item['file']).splitlines():
            for value in re.findall(r'"([^"\n]*[가-힣][^"\n]*)"',line.split(';')[0]):
                constants=t.numeric_constants() | {'NUM_UNOWN':'26','NUM_POKEMON':'251'}
                value=re.sub(r'\{d:(\w+)\}',lambda m:constants[m[1]],value)
                encode(value,mapping)
                rows+=1
    dex_pages=0
    for path in (a.ROOT/'data/pokemon/dex_entries').glob('*.asm'):
        # This project's DisplayDexEntry displays Gold's ONE 3-line page.
        source=a.read(path)
        strings=[m[2] for line in source.splitlines() if (m:=a.ROW.fullmatch(line))]
        description=strings[1:]
        assert len(description)==3,path
        assert all(a.width(x)<=18 for x in description),(path,description)
        assert not re.search(r'^\s*page\s',source,re.M),path
        assert len(re.findall(r'^\s*next\s',source,re.M))==2,path
        assert description[-1].endswith('@'),path
        dex_pages+=1
    item_rows=0
    for line in a.read(a.ROOT/'data/items/descriptions.asm').splitlines():
        if m:=a.ROW.fullmatch(line):
            assert m[1] in ('db','next'),line
            assert a.width(m[2])<=18,line
            encode(m[2],mapping)
            item_rows+=1
    # Prevent accidental edits to user-maintained names and font assets.
    protected={'data/moves/names.asm':'3c84dffc763cb2e3234c630c853949ebad60dfc0c21288751f7ae5d000fa7ee5',
               'gfx/font/font_hangul.1bpp':'fdb3539a5a1e5309195799ba83aca2f9f721de84829e7ba64a802bb0b705d479'}
    if preservation:
        for path,digest in protected.items():assert hashlib.sha256((a.ROOT/path).read_bytes()).hexdigest()==digest,path
    print(rows,'Korean literal encodings;',dex_pages,'18x3 Pokedex pages;',item_rows,
          '18-column item rows; names/font preservation PASS')


def payload(b,mapping,sym):
    opcodes={'text_start':0,'text_low':5,'text_promptbutton':6,'text_scroll':7,
             'text_pause':10,'sound_dex_fanfare_50_79':11,'text_waitbutton':13,
             'sound_dex_fanfare_20_49':14,'sound_item':15,'sound_caught_mon':16,
             'sound_dex_fanfare_80_109':17,'sound_fanfare':18,
             'sound_slot_machine_start':19,'text_today':21,'text_end':80}
    controls={'text':b'\0','line':mapping['<LINE>'],'next':mapping['<NEXT>'],
              'cont':mapping['<CONT>'],'para':mapping['<PARA>'],'page':b'\x50'}
    out=bytearray()
    def address(value):
        match=re.fullmatch(r'(\w+)(?:\s*\+\s*(\d+))?',value.strip())
        assert match,value
        return (sym[match[1]][1]+int(match[2] or 0)).to_bytes(2,'little')
    constants=t.numeric_constants() | {'NUM_UNOWN':'26','NUM_POKEMON':'251'}
    for c,v in b['statements']:
        if c in controls:
            out.extend(controls[c]);out.extend(encode(re.sub(r'\{d:(\w+)\}',lambda m:constants[m[1]],v),mapping))
        elif c in ('done','prompt'):out.extend(mapping['<DONE>' if c=='done' else '<PROMPT>'])
        elif c=='text_ram':out.append(1);out.extend(address(v))
        elif c=='text_decimal':
            addr,bytes_,digits=map(str.strip,v.split(','))
            out.append(9);out.extend(address(addr));out.append((int(bytes_)<<4)|int(digits))
        elif c=='text_buffer':out.extend((20,int(v)))
        elif c=='text_dots':out.extend((12,int(v)))
        elif c in opcodes:out.append(opcodes[c])
        else:raise AssertionError(('unhandled byte encoding',b['label'],c,v))
    return out


def rom_check(rom_path,sym_path):
    rom=rom_path.read_bytes();sym=symbols(sym_path);mapping=charmap()
    n=0
    for path,b in active_dialogues(debug='_debug' in rom_path.stem):
        expected=payload(b,mapping,sym)
        bank,addr=sym[b['label']]
        offset=addr if bank==0 else bank*0x4000+addr-0x4000
        assert rom[offset:offset+len(expected)]==expected,(path,b['label'],'ROM bytes')
        n+=1
    print(rom_path.name,n,'Korean command/encoding/terminal byte sequences PASS')


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('rom',type=Path,nargs='?');p.add_argument('sym',type=Path,nargs='?')
    p.add_argument('--layout-only',action='store_true',help='current source scan without the task snapshot/hash freeze')
    args=p.parse_args()
    static_check(preservation=not args.layout_only)
    if args.rom:
        assert args.sym
        rom_check(args.rom,args.sym)
