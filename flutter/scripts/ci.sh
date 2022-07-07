#!/usr/bin/env bash

# This command is meant to be run from project root

# WARNING! Do not remove this script, or change its behavior, unless you have
# verified that it will not break the flutter/flutter analysis run of this
# repository: https://github.com/flutter/flutter/blob/master/dev/bots/test.dart

set -e # abort CI if an error happens

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly REPO_DIR="$(dirname "$SCRIPT_DIR")"

# The tool expects to be run from the repo root.
cd "$REPO_DIR"

./scripts/code_health_checkup.sh

# resets to the original state
cd - > /dev/null;

