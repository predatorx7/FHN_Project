#!/usr/bin/env bash

set -e

flutter analyze --no-current-package --no-fatal-infos lib test/
