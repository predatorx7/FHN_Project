#!/usr/bin/env bash

source ./secrets/key.properties;

keytool -exportcert -alias $keyAlias -keystore ./secrets/vr-films-production-keystore.jks | openssl sha1 -binary | openssl base64;
