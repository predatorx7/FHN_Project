#!/usr/bin/env bash

set -e

flutter packages get;

if [ "$__BUILD_TARGET_OS" == "iOS" ]; then
    cd ios;
    pod install;
fi
