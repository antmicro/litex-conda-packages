#!/bin/bash

pwd
ls *
for i in *; do
    ls $i
done

./configure --prefix="$PREFIX" \
    --disable-udev
make
make install

