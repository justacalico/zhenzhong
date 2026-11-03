This is 震中 (Zhenzhong), a FOSS Mahjongg solitaire game in Flutter, like KDE's KMahjongg.

- Refactor rather than duplicating code.
- Goal is an A+ codebase: small focused files, no god files.
- 100% line coverage is required; run `scripts/check-coverage.sh`.
- Every screen needs golden tests; regenerate with `flutter test --update-goldens`.
- Game logic lives in `lib/game/` and is pure Dart with no widget dependencies.
- All user-facing strings go through `lib/l10n/` ARB files (en_GB template, zh, ru, ga). Never hardcode strings.
- Commits must be conventional so cocogitto can bump versions.
