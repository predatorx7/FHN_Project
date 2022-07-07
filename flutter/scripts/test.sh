#!/usr/bin/env bash

set -e

flutter test --no-pub --coverage $(ls test/*_test.dart | grep -v _legacy_)
