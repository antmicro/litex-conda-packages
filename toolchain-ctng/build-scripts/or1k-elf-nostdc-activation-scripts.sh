#!/bin/bash
conda build --variants "{'ctng_target_platform': ['or1k-elf-nostdc'], 'ctng_target_platform_short': ['or1k-elf'], 'ctng_libc': ['nostdc'], 'ctng_cpu_arch': ['openrisc']}" ../../recipe/binaries/ -c antmicro
conda build --variants "{'ctng_target_platform': ['or1k-elf-nostdc'], 'ctng_target_platform_short': ['or1k-elf'], 'ctng_libc': ['nostdc'], 'ctng_cpu_arch': ['openrisc']}" ../../recipe/activation_scripts/ -c antmicro
