#!/bin/bash
conda build --variants "{'ctng_target_platform': ['or1k-linux-musl'], 'ctng_target_platform_short': ['or1k-linux-musl'], 'ctng_libc': ['musl'], 'ctng_cpu_arch': ['openrisc']}" ../../recipe/binaries/ -c antmicro
conda build --variants "{'ctng_target_platform': ['or1k-linux-musl'], 'ctng_target_platform_short': ['or1k-linux-musl'], 'ctng_libc': ['musl'], 'ctng_cpu_arch': ['openrisc']}" ../../recipe/activation_scripts/ -c antmicro
