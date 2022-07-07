#!/usr/bin/env bash

# This command is meant to be run from project root

# WARNING! Do not remove this script, or change its behavior, unless you have
# verified that it will not break the flutter/flutter analysis run of this
# repository: https://github.com/flutter/flutter/blob/master/dev/bots/test.dart

set -e

DEVEL="$HOME/devel"

mkdir -p $DEVEL

# Install Flutter locally for faster builds
function install_flutter() {
    if [ -d "$FLUTTER_ROOT" ]; then
        echo "We have flutter installed and available in PATH"
        return 0;
    elif [ -d "$DEVEL/flutter" ]; then
        echo "We have flutter installed locally but not available in PATH"
    else
        echo "We don't have flutter installed, install it"
        git clone https://github.com/flutter/flutter.git -b stable $DEVEL/flutter;
    fi

    FLUTTER_ROOT="$DEVEL/flutter";
    export FLUTTER_ROOT;

    echo "Flutter sdk root set to $FLUTTER_ROOT"

    return 0;
}

function test_flutter_installation() {
    $FLUTTER_ROOT/bin/flutter doctor;

    $FLUTTER_ROOT/bin/flutter precache;

    return 0;
}

function export_flutter_bin() {
    export PATH="$PATH:$FLUTTER_ROOT/bin"
}

install_flutter
test_flutter_installation
export_flutter_bin
