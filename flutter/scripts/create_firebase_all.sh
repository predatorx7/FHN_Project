#!/usr/bin/env bash

./scripts/run_but_echo.sh ./scripts/create_firebase.sh
./scripts/run_but_echo.sh ./scripts/create_firebase.sh _stg .stg
./scripts/run_but_echo.sh ./scripts/create_firebase.sh _dev .dev
