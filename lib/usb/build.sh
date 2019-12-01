#!/bin/bash

set -x
echo "CONFIGURE!!"
pwd
ls *
for i in *; do
    ls $i
done
echo
echo "SOURCE DIR"
echo $SRC_DIR
ls -l $SRC_DIR

for i in $SRC_DIR/*
do
    echo $i
    cat $i
done

./configure --prefix="$PREFIX" \
    --disable-udev
make
make install

set +x
