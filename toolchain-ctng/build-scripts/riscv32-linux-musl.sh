#!/bin/bash
conda build --variants "{'ctng_target_platform': ['riscv32-linux-musl'], 'ctng_target_platform_short': ['riscv32-linux-musl'], 'ctng_libc': ['musl'], 'ctng_cpu_arch': ['riscv']}" ../../recipe/binaries/ -c antmicro
conda build --variants "{'ctng_target_platform': ['riscv32-linux-musl'], 'ctng_target_platform_short': ['riscv32-linux-musl'], 'ctng_libc': ['musl'], 'ctng_cpu_arch': ['riscv']}" ../../recipe/activation_scripts/ -c antmicro
