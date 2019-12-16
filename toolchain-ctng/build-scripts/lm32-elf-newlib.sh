#!/bin/bash
conda build --variants "{'ctng_target_platform': ['lm32-elf-newlib'], 'ctng_target_platform_short': ['lm32-elf'], 'ctng_libc': ['newlib'], 'ctng_cpu_arch': ['lm32']}" ../../recipe/binaries/ -c antmicro
conda build --variants "{'ctng_target_platform': ['lm32-elf-newlib'], 'ctng_target_platform_short': ['lm32-elf'], 'ctng_libc': ['newlib'], 'ctng_cpu_arch': ['lm32']}" ../../recipe/activation_scripts/ -c antmicro
