#!/bin/bash

${CONDA_PATH}/bin/python ${TRAVIS_BUILD_DIR}/.travis-output.py /tmp/output.log conda build ${CONDA_BUILD_ARGS}

conda build --variants "{'ctng_target_platform': ['lm32-elf-nostdc'], 'ctng_target_platform_short': ['lm32-elf'], 'ctng_libc': ['nostdc'], 'ctng_cpu_arch': ['lm32']}" toolchain-ctng/recipe/activation_scripts/ -c antmicro
