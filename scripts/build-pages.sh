#!/bin/bash
set -euo pipefail
FLUTTER_VER=3.47.7
mkdir -p /tmp/flutter-sdk
if [ ! -x /tmp/flutter-sdk/bin/flutter ]; then
  curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VER}-stable.tar.xz -o /tmp/flutter.tar.xz
  tar -xJf /tmp/flutter.tar.xz -C /tmp/flutter-sdk --strip-components=1
fi
export PATH="/tmp/flutter-sdk/bin:$PATH"
git config --global --add safe.directory /tmp/flutter-sdk
mkdir -p public/app
cd landing && flutter pub get && flutter build web --release --base-href /"$CI_PROJECT_NAME"/ && cd ..
cp -r landing/build/web/. public/
flutter pub get
flutter build web --release --base-href /"$CI_PROJECT_NAME"/app/
cp -r build/web/. public/app/
mkdir -p public/flatpak
REPO_TMP=$(mktemp -d)
if [ -n "${GITHUB_RUN_ID:-}" ]; then
  for arch in x86_64 aarch64; do
    if gh run download "$GITHUB_RUN_ID" -R justacalico/zhenzhong -n "linux$([ $arch = aarch64 ] && echo -arm64 || echo '')" -p 'flatpak-repo-*' -D "$REPO_TMP/$arch" 2>/dev/null; then
      tar -xzf "$REPO_TMP/$arch"/flatpak-repo-*.tar.gz -C "$REPO_TMP/$arch"
    fi
  done
fi
for arch in x86_64 aarch64; do
  if [ -d "$REPO_TMP/$arch/repo" ]; then
    ostree --repo=public/flatpak init --mode=archive-z2 2>/dev/null || true
    ostree --repo=public/flatpak pull-local "$REPO_TMP/$arch/repo" 2>/dev/null || true
  elif [ -d "$REPO_TMP/$arch" ]; then
    ostree --repo=public/flatpak init --mode=archive-z2 2>/dev/null || true
    ostree --repo=public/flatpak pull-local "$REPO_TMP/$arch" 2>/dev/null || true
  fi
done
if [ -n "${FLATPAK_GPG_KEY:-}" ]; then
  mkdir -p .gpg && chmod 700 .gpg
  echo "$FLATPAK_GPG_KEY" | base64 -d | gpg --batch --homedir .gpg --import 2>/dev/null || true
  KEYID=$(gpg --batch --homedir .gpg --list-keys --with-colons | awk -F: '/^pub/{print $5; exit}')
  if [ -n "$KEYID" ]; then
    gpg --homedir .gpg --export "$KEYID" > public/flatpak/key.gpg
    flatpak build-update-repo --gpg-sign="$KEYID" --gpg-homedir="$(pwd)/.gpg" public/flatpak 2>/dev/null || true
    GPGKEY_B64=$(base64 -w0 public/flatpak/key.gpg)
    cat > public/zhenzhong.flatpakref <<REF
[Flatpak Ref]
Name=gitlab.httpanimations.zhenzhong
Branch=stable
Url=https://httpanimations.gitlab.io/$CI_PROJECT_NAME/flatpak
SuggestRemoteName=zhenzhong
GPGKey=$GPGKEY_B64
RuntimeRepo=https://dl.flathub.org/repo/flathub.flatpakrepo
REF
  fi
fi
ls public public/app public/flatpak
