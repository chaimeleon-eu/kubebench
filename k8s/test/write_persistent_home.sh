#!/bin/bash

TEST_DIR="${HOME}/persistent-home/tests"
FILE="${TEST_DIR}/$(hostname)" 
BS=1M
COUNT=10000

mkdir -p "${TEST_DIR}"
echo "Writing file ${FILE} with dd from urandom with bs '${BS}' and count '${COUNT}'"
dd if=/dev/urandom of="${FILE}" oflag=direct bs="${BS}" count="${COUNT}" 2>&1 