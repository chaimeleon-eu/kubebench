#!/bin/bash

TEST_DIR="${HOME}/persistent-home/tests"
BS=1M
COUNT=1000

shopt -s nullglob
array=(*)

for i in "${arr[@]}"; do 
    dd if=/dev/urandom of=${TEST_DIR}/${i} oflag=direct bs="${BS}" count="${COUNT}"
done