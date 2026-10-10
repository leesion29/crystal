"""Execute the linked glyph uploader with a bounded, cycle-counted SM83 subset.

This is not an emulator: no interrupts/PPU fetches or full menu execution.
The sole production caller disables interrupts. VRAM writes must be in VBlank
or with LCD disabled, and the original VRAM bank must be restored.
Usage: python tools/verify_hangul_upload_timing.py ROM SYM
"""
import hashlib
import sys
from pathlib import Path
from verify_following_sprites import symbols


class UploadCPU:
    def __init__(self, code, source, phase, speed, vbk, enabled=True):
        self.code = code
        self.source = source
        self.phase = phase
        self.speed = speed
        self.enabled = enabled
        self.vbk = vbk
        self.pc = self.cycles = 0
        self.a = self.bc = self.de = 0
        self.hl = 0x8800
        self.z = self.c = False
        self.stack = []
        self.writes = []

    def byte(self):
        result = self.code[self.pc]
        self.pc += 1
        return result

    def word(self):
        low = self.byte()
        return low | self.byte() << 8

    def line(self, offset=0):
        # PPU advances at 456 dots per line; double-speed CPU has two T per dot.
        return ((self.phase + self.cycles + offset) // (456 * self.speed)) % 154

    def read_io(self, address):
        if address == 0x40:
            return 0x80 if self.enabled else 0
        if address == 0x4f:
            return 0xfe | self.vbk
        if address == 0x44:
            line = self.line(8)
            # LY returns to zero four dots into the last VBlank scanline.
            dot = ((self.phase + self.cycles + 8) // self.speed) % 456
            return 0 if line == 153 and dot >= 4 else line
        raise AssertionError(f'unmodeled IO read {address:02x}')

    def run(self):
        for _ in range(30000):
            op = self.byte()
            if op == 0xf0:  # LDH A,[a8]
                self.a = self.read_io(self.byte())
                self.cycles += 12
            elif op == 0xe0:  # LDH [a8],A
                assert self.byte() == 0x4f
                self.vbk = self.a & 1
                self.cycles += 12
            elif op == 0xcb:
                assert self.byte() == 0x7f  # BIT 7,A
                self.z = not bool(self.a & 0x80)
                self.cycles += 8
            elif op == 0xfe:  # CP d8
                value = self.byte()
                self.z, self.c = self.a == value, self.a < value
                self.cycles += 8
            elif op in (0x18, 0x20, 0x28, 0x30, 0x38):
                displacement = self.byte()
                take = {0x18: True, 0x20: not self.z, 0x28: self.z,
                        0x30: not self.c, 0x38: self.c}[op]
                self.cycles += 12 if take else 8
                if take:
                    self.pc += displacement - 256 if displacement >= 128 else displacement
                    assert 0 <= self.pc < len(self.code)
            elif op == 0xf5:
                self.stack.append((self.a, self.z, self.c))
                self.cycles += 16
            elif op == 0xf1:
                self.a, self.z, self.c = self.stack.pop()
                self.cycles += 12
            elif op == 0xaf:
                self.a = 0
                self.z, self.c = True, False
                self.cycles += 4
            elif op in (0x11, 0x01):
                value = self.word()
                if op == 0x11:
                    self.de = value
                else:
                    self.bc = value
                self.cycles += 12
            elif op == 0x1a:
                index = self.de - self.source
                assert 0 <= index < 32
                self.a = (index * 37 + 11) & 255
                self.cycles += 8
            elif op == 0x13:
                self.de += 1
                self.cycles += 8
            elif op == 0x22:
                assert not self.enabled or 144 <= self.line(4) <= 153, (
                    'VRAM write outside VBlank', self.phase, self.cycles)
                assert self.vbk == 0
                self.writes.append((self.hl, self.a))
                self.hl += 1
                self.cycles += 8
            elif op == 0x0b:  # Also accepts the pre-fix loop for comparison.
                self.bc = (self.bc - 1) & 65535
                self.cycles += 8
            elif op == 0x78:
                self.a = self.bc >> 8
                self.cycles += 4
            elif op == 0xb1:
                self.a |= self.bc & 255
                self.z, self.c = self.a == 0, False
                self.cycles += 4
            elif op == 0xc9:
                self.cycles += 16
                assert not self.stack
                assert self.bc == 0 and self.de == self.source + 32
                assert self.hl == 0x8820
                assert self.writes == [(0x8800 + i, (i * 37 + 11) & 255)
                                       for i in range(32)]
                return self.cycles
            else:
                raise AssertionError(f'unsupported SM83 opcode {op:02x}')
        raise AssertionError(('uploader did not return within bound', self.phase,
                              self.speed, self.pc, self.cycles))


def verify(rom_path, sym_path):
    rom, sym = rom_path.read_bytes(), symbols(sym_path)
    bank, address = sym['HDMATransfer_HangulFontToVRAM']
    start = bank * 0x4000 + address - 0x4000
    # This uploader is the last routine before a separate font bank section.
    # Decoder stops at RET, rejecting unknown instructions along every tested path.
    code = rom[start:start + 256]
    source = sym['wHangulFontGfx'][1]
    # Independently exercise the normal-speed deadline and a deliberately unsafe
    # late-start mutant. A checker which accepts the mutant cannot claim safety.
    early = UploadCPU(code, source, 150 * 456, 1, 1)
    assert early.run() < 1000 and early.vbk == 1
    threshold = code.index(bytes((0xfe, 151))) + 1
    unsafe = bytearray(code)
    unsafe[threshold] = 154
    try:
        UploadCPU(unsafe, source, 152 * 456 + 400, 1, 1).run()
    except AssertionError as error:
        assert error.args[0][0] == 'VRAM write outside VBlank', error
    else:
        raise AssertionError('unsafe late-VBlank mutant was accepted')
    cases = 0
    maximum = 0
    for speed in (1, 2):
        # Every four-T CPU phase in/near VBlank, plus samples throughout the frame.
        phases = set(range(143 * 456 * speed, 154 * 456 * speed, 4))
        phases.update(range(0, 143 * 456 * speed, 256))
        for vbk in (0, 1):
            for phase in sorted(phases):
                cpu = UploadCPU(code, source, phase, speed, vbk)
                maximum = max(maximum, cpu.run())
                assert cpu.vbk == vbk
                cases += 1
            cpu = UploadCPU(code, source, 0, speed, vbk, enabled=False)
            assert cpu.run() < 1000 and cpu.vbk == vbk
            cases += 1
    # Back-to-back cache misses: retain PPU phase across calls. The deliberately
    # modeled inter-call overhead is not a measured full-menu rendering time.
    for speed in (1, 2):
        phase = 144 * 456 * speed
        elapsed = 0
        for _ in range(54):
            cpu = UploadCPU(code, source, phase + elapsed, speed, 1)
            elapsed += cpu.run() + 1000
        print(f'{rom_path.name}: 54 modeled uploads, speed x{speed}: '
              f'{elapsed / (4194304 * speed):.3f}s (not menu runtime)')
    print(f'{rom_path.name}: {cases} cycle-counted phase/bank/LCD cases PASS; '
          f'max call {maximum} T-cycles; SHA256 {hashlib.sha256(rom).hexdigest()}')


if __name__ == '__main__':
    verify(Path(sys.argv[1]), Path(sys.argv[2]))
