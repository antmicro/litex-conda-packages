#!/bin/bash
conda build --variants "{'ctng_target_platform': ['riscv32-elf-nostdc'], 'ctng_target_platform_short': ['riscv32-elf'], 'ctng_libc': ['nostdc'], 'ctng_cpu_arch': ['riscv']}" ../../recipe/binaries/ -c antmicro
conda build --variants "{'ctng_target_platform': ['riscv32-elf-nostdc'], 'ctng_target_platform_short': ['riscv32-elf'], 'ctng_libc': ['nostdc'], 'ctng_cpu_arch': ['riscv']}" ../../recipe/activation_scripts/ -c antmicro
