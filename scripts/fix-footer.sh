#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
from pathlib import Path

replacements = {
    'nalc/Visit/index.html': '<footer><div class="wrap"><div class="footer-links"><a href="/">Home</a><a href="../index.html">NALC Home</a><a href="../Visit/index.html" aria-current="page">Visits</a><a href="../Visit/testimonials/index.html">Testimonials</a></div><div class="footer-meta">© 2026 New Age Learning Centre (NALC), Miao · Sub Divisional Library, Miao · Arunachal Pradesh, India</div></div></footer>',
    'nalc/Visit/testimonials/index.html': '<footer><div class="container"><div class="footer-links"><a href="/">Home</a><a href="../../index.html">NALC Home</a><a href="../index.html">Visits</a><a href="./index.html" aria-current="page">Testimonials</a><a href="../../index.html#award">PM Award</a><a href="https://x.com/NalcMiao" target="_blank" rel="noopener">X / Twitter</a></div><p class="footer-meta">New Age Learning Centre (NALC), Miao · Sub Divisional Library · Changlang, Arunachal Pradesh, India</p><p style="margin:.4rem 0 0;opacity:.65;font-size:.82rem;">© 2026 NALC Miao · Official website: miaolibrary.in</p></div></footer>'
}

for filename, footer in replacements.items():
    p = Path(filename)
    s = p.read_text(encoding='utf-8')
    a = s.lower().find('<footer')
    b = s.lower().find('</footer>', a)
    if a < 0 or b < 0:
        raise RuntimeError(f'Footer not found: {filename}')
    p.write_text(s[:a] + footer + s[b + len('</footer>'):], encoding='utf-8')

for filename in replacements:
    s = Path(filename).read_text(encoding='utf-8')
    a = s.lower().find('<footer')
    b = s.lower().find('</footer>', a)
    footer = s[a:b + len('</footer>')]
    assert 'href="#"' not in footer
    assert 'href="https://miaolibrary.in/nalc.html"' not in footer
print('Footer correction verified.')
PY
