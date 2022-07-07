#!/usr/bin/env bash

# STAGING: ./scripts/create_firebase.sh _dev .dev
# STAGING: ./scripts/create_firebase.sh _stg .stg
# PRODUCTION: ./scripts/create_firebase.sh

FIREBASE_FOLDER=lib/src/config/firebase
APP_ID="com.magnificsoftware.shopping"
FILE_TRAIL=$1
ID_TRAIL=$2

_APP_ID="${APP_ID}${ID_TRAIL}"
_FIREBASE_CONFIG="${FIREBASE_FOLDER}/firebase_options${FILE_TRAIL}.dart"

_RUN="flutterfire configure -i ${_APP_ID} \
-a ${_APP_ID} \
-o ${_FIREBASE_CONFIG} \
--no-apply-gradle-plugins \
--no-app-id-json"

./scripts/run_but_echo.sh $_RUN
