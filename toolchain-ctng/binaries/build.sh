#!/bin/bash

# Identify OS
UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    CYGWIN*)    OS=Cygwin;;
    *)          OS="${UNAME_OUT}"
                echo "Unknown OS: ${OS}"
                exit;;
esac
echo "Build started for ${OS}..."

if [[ $OS == "Linux" ]]; then
    # How to build with multiple jobs
    export MAKE_J="nproc"
elif [[ $OS == "Mac" ]]; then
    # Copy MUSL patches associated only with MacOS
    if [[ $ctng_target_platform == *"-musl" ]]; then
        cp ${SRC_DIR}/patches/musl/macos/* ${SRC_DIR}/patches/musl/git-ac304227
    fi

    # Set number of max opened files
    ulimit -n 2048

    # Add include dir to CPATH and choose proper libtool
    export CPATH="${SRC_DIR}/../_build_env/include"
    export LIBTOOL="${SRC_DIR}/../_build_env/bin/libtool"

    # How to build with multiple jobs
    export MAKE_J="sysctl -n hw.physicalcpu"
fi

# Unset these env variables - required by crostool-ng
unset LD_LIBRARY_PATH LIBRARY_PATH LPATH CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH CFLAGS CXXFLAGS CC CXX CPPFLAGS LDFLAGS LDFLAGS_ALL CRT_OBJS LDSO_OBJS LIBC_OBJS CFLAGS_ALL CFLAGS_NOSSP CC LIBS CCAS CCASFLAGS CPP

# Build toolchain from previously prepared config
ct-ng version
export DEFCONFIG="${SRC_DIR}/crosstool_configs/${ctng_target_platform}.config"
ct-ng defconfig
ct-ng build.`${MAKE_J}`

