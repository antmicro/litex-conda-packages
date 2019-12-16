#!/bin/bash

source .travis/common.sh
set -e

${CONDA_PATH}/bin/python ${TRAVIS_BUILD_DIR}/.travis-output.py /tmp/output.log conda build --no-test --variants "{'ctng_target_platform': ['or1k-elf-nostdc'], 'ctng_target_platform_short': ['or1k-elf'], 'ctng_libc': ['nostdc'], 'ctng_cpu_arch': ['openrisc']}" toolchain-ctng/binaries ${CONDA_BUILD_ARGS}
