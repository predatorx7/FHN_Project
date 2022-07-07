#!/usr/bin/env bash

if [ "$(basename $HOME)" == root ]; then
    echo "ERROR: Cannot run for root"
    exit 1
fi

if [ ! -d "$HOME" ]; then
    echo "\$HOME does not exist. Cannot work without a home."
    exit 1
fi

DEFAULT_SHELL="$(basename $SHELL)"

usage_body="Wizard offers gradle-like commands for easy Flutter app development.

USAGE: wizard <command>

Available commands:
    runDebug         Runs development build in debugging mode (For developers)
    runProd          Runs production build in debugging mode (For developers)
    buildProdAnd     Build release binaries for android (For production users/testers)
    buildProdIos     Build release binaries for iOS (For production users/testers)
    buildStagAnd     Build staging binaries for android (For internal testers)
    buildStagIos     Build staging binaries for iOS (For internal testers)
    buildProdArchAnd Build release archive for android (For archiving)
    buildProdArchIos Build release archive for iOS (For archiving)
    deps             Get/Update dependencies
    upgradeDeps      Upgrade dependencies
    runGen           Run code generators
    clean            Clean all build files
    help             Show this help
'$DEFAULT_SHELL' is your default shell, $USER
*Some commands may require 'dart-sdk' installed and in environment path"

command=$1
SHELL_CONFIG_FILE=""

# Determine shellrc file
case "${DEFAULT_SHELL}" in
zsh)
    SHELL_CONFIG_FILE=$HOME/.zshrc
    ;;
bash)
    # Determine machine.
    case "$(uname -s)" in
    Linux*) SHELL_CONFIG_FILE=$HOME/.bashrc ;;
    Darwin*)
        SHELL_CONFIG_FILE=$HOME/.bash_profile
        ;;
    *)
        echo "Machine ${unameOut} not supported"
        exit 1
        ;;
    esac
    ;;
*)
    echo "Shell not supported"
    exit 1
    ;;
esac

if [[ ! -f "$SHELL_CONFIG_FILE" ]]; then
    echo "$SHELL_CONFIG_FILE does not exist. Creating it now.."
    touch "$SHELL_CONFIG_FILE"
fi

function usage() {
    echo "$usage_body"
}

function run_debug() {
    ./scripts/run_but_echo.sh flutter run --flavor development --target lib/main_devel.dart;
}

function run_prod() {
    ./scripts/run_but_echo.sh flutter run --flavor production;
}

function build_prod_android() {
    ./scripts/run_but_echo.sh flutter build apk --flavor production --release --split-per-abi;
}

function build_stag_android() {
    ./scripts/run_but_echo.sh flutter build apk --flavor staging --target lib/main_stag.dart  --split-per-abi;
}

function  build_prod_arc_android() {
    ./scripts/run_but_echo.sh flutter build appbundle --flavor production --release;
}

function build_prod_ios() {
    ./scripts/run_but_echo.sh flutter build ipa --flavor production --release;
}

function build_stag_ios() { 
    ./scripts/run_but_echo.sh flutter build ipa --flavor staging --target lib/main_stag.dart;
}

function  build_prod_arc_ios() {
    build_prod_ios
}

function run_generators() {
    ./scripts/run_but_echo.sh flutter pub get;
    ./scripts/run_but_echo.sh flutter pub run build_runner build --delete-conflicting-outputs;
}

function switchToLatest() {
    cd "$(dirname "$0")"
    git checkout --quiet master 2>/dev/null
    git pull --quiet origin master 2>/dev/null
    latesttag=$(git describe --tags)
    echo switching to ${latesttag}
    git checkout --quiet ${latesttag} 2>/dev/null
}

function obtain_deps() {
    flutter pub get;
}

function update_deps() {
    flutter pub upgrade;
}

function cleanup() {
    echo "cleaning"
    flutter clean;
}

case "$command" in
runDebug)
    run_debug
    ;;
runProd)
    run_prod
    ;;
buildProdAnd)
    build_prod_android
    ;;
buildProdIos)
    build_prod_ios
    ;;
buildStagAnd)
    build_stag_android
    ;;
buildStagIos)
    build_stag_ios;
    ;;
buildProdArchAnd)
    build_prod_arc_android
    ;;
buildProdArchIos)
    build_prod_arc_ios
    ;;
deps)
    obtain_deps
    ;;
runGen)
    run_generators
    ;;
upgradeDeps)
    update_deps
    ;;
clean)
    cleanup
    ;;
help) usage ;;
*)
    echo -e "ERROR: Unknown argument\n"
    usage
    ;;
esac
