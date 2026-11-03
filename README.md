# 震中 Zhenzhong

[![pipeline](https://gitlab.com/HttpAnimations/zhenzhong/badges/main/pipeline.svg)](https://gitlab.com/HttpAnimations/zhenzhong/-/pipelines)
[![release](https://gitlab.com/HttpAnimations/zhenzhong/-/badges/release.svg)](https://gitlab.com/HttpAnimations/zhenzhong/-/releases)
[![license](https://img.shields.io/badge/license-AGPL--3.0-blue)](LICENSE)
[![pages](https://img.shields.io/badge/landing-page-green)](https://httpanimations.gitlab.io/zhenzhong/)

A free and open source Mahjongg solitaire game, in the spirit of KDE's KMahjongg. Clear the board by matching pairs of free tiles, one pair at a time.

![Game board](test/goldens/app_desktop.png)

## Highlights

- Classic turtle layout with the full 144-tile set: suits, winds, dragons, flowers and seasons
- Tiles are only free when uncovered with an open side, just like the real game
- Hint, undo and shuffle so you never have to rage-quit
- Play on Linux, Windows, macOS, Android, iOS or right in the browser
- Your own language: Traditional English, 简体中文, Русский, Gaeilge
- No ads, no accounts, no tracking. AGPL-3.0

## Play online

- Landing page: https://httpanimations.gitlab.io/zhenzhong/
- Web version: https://httpanimations.gitlab.io/zhenzhong/app/

## Download

Get the latest builds for every platform on the [releases page](https://gitlab.com/HttpAnimations/zhenzhong/-/releases).

### Linux (Flatpak)

```
curl -fLO https://httpanimations.gitlab.io/zhenzhong/flatpak/key.gpg
flatpak remote-add --if-not-exists --gpg-import=key.gpg zhenzhong https://httpanimations.gitlab.io/zhenzhong/flatpak
flatpak install zhenzhong gitlab.httpanimations.zhenzhong
```

Or grab the one-click [zhenzhong.flatpakref](https://httpanimations.gitlab.io/zhenzhong/zhenzhong.flatpakref).

### iOS (AltStore)

Add this source to AltStore:

```
https://gitlab.com/HttpAnimations/zhenzhong/-/raw/main/repos/altstore.json
```

## Screenshots

![How to play](test/goldens/app_help.png)
![Settings](test/goldens/app_settings.png)
