#!/usr/bin/env bash
#
# Generate test coverage
#
cd ../coverage || exit
genhtml lcov.info -o coverage --no-function-coverage -s -p "$(pwd)"
