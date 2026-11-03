#!/bin/bash
set -euo pipefail
GH_REPO=justacalico/zhenzhong
mkdir -p public/app public/flatpak

RUN_ID="${GITHUB_RUN_ID:-}"
if [ -z "$RUN_ID" ]; then
  RUN_ID=$(gh api "repos/$GH_REPO/actions/workflows/build.yml/runs?head_sha=$CI_COMMIT_SHA&per_page=5" \
    -q '.workflow_runs[0].id' 2>/dev/null || true)
fi

if [ -n "$RUN_ID" ]; then
  gh run download "$RUN_ID" -R "$GH_REPO" -n web -D /tmp/art-web || true
  gh run download "$RUN_ID" -R "$GH_REPO" -n linux -D /tmp/art-linux || true
  gh run download "$RUN_ID" -R "$GH_REPO" -n linux-arm64 -D /tmp/art-arm || true
fi

if [ -f /tmp/art-web/zhenzhong-landing.tar.gz ]; then
  tar -xzf /tmp/art-web/zhenzhong-landing.tar.gz -C public
fi
if [ -f /tmp/art-web/zhenzhong-web.tar.gz ]; then
  tar -xzf /tmp/art-web/zhenzhong-web.tar.gz -C public/app
fi

REPO_TMP=$(mktemp -d)
for pair in "/tmp/art-linux:x86_64" "/tmp/art-arm:aarch64"; do
  dir="${pair%%:*}"
  if ls "$dir"/flatpak-repo-*.tar.gz >/dev/null 2>&1; then
    mkdir -p "$REPO_TMP/extract"
    tar -xzf "$dir"/flatpak-repo-*.tar.gz -C "$REPO_TMP/extract"
    ostree --repo=public/flatpak init --mode=archive-z2 2>/dev/null || true
    ostree --repo=public/flatpak pull-local "$REPO_TMP/extract" || true
    rm -rf "$REPO_TMP/extract"
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
