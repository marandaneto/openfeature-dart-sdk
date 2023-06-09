#!/bin/sh

set -e
set -x

# https://dart.dev/tools/dart-tool

# get current package's dependencies
dart pub get
# static code analyzer
dart analyze --fatal-infos
# tests, add: chrome later
dart test -p "vm" --chain-stack-traces
# formatting
dart format --set-exit-if-changed ./
# pub score
pana
# dry publish
dart pub publish --dry-run
