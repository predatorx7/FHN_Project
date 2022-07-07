#!/usr/bin/env bash

_SEPARATOR="-----------------------------"
printf "\n\n$_SEPARATOR\nRunning CODE HEALTH CHECK-UPs\n$_SEPARATOR\n\n"

./scripts/run_but_echo.sh ./scripts/packages_up.sh;
./scripts/run_but_echo.sh ./scripts/format.sh;
./scripts/run_but_echo.sh ./scripts/analyze.sh;
./scripts/run_but_echo.sh ./scripts/test.sh;
