#!/bin/bash
set -euo pipefail
version="${1:?version required}"
build_number="$(date +%s | cut -c4-10)"
sed -i "s/^version: .*/version: ${version}+${build_number}/" pubspec.yaml
