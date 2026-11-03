#!/bin/bash
set -euo pipefail
flutter test --coverage
python3 - <<'PY'
lines = open('coverage/lcov.info').read().split('end_of_record')
keep = [s for s in lines if 'lib/l10n/app_localizations' not in s]
open('coverage/lcov.info', 'w').write('end_of_record'.join(keep))
lf = lh = 0
for l in open('coverage/lcov.info'):
    if l.startswith('LF:'): lf += int(l[3:])
    if l.startswith('LH:'): lh += int(l[3:])
print(f'coverage: {lh}/{lf}')
assert lf > 0 and lh == lf, f'coverage {lh}/{lf} != 100%'
PY
