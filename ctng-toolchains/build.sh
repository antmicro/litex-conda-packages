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
    if [[ $TOOLCHAIN_VARIANT == *"-musl" ]]; then
        cp ${SRC_DIR}/patches/musl/macos/* ${SRC_DIR}/patches/musl/git-ac304227
    fi

    if [[ ! -f "/usr/local/bin/bash" ]]; then
        ln -s `which bash` /usr/local/bin/bash
    fi

    if [[ ! -f "/usr/local/bin/objcopy" ]]; then
        ln -s `which gobjcopy` /usr/local/bin/objcopy
    fi

    # Set number of max opened files
    ulimit -n 2048

    # How to build with multiple jobs
    export MAKE_J="sysctl -n hw.physicalcpu"
fi

# Unset these env variables - required by crostool-ng
unset LD_LIBRARY_PATH LIBRARY_PATH LPATH CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH CFLAGS CXXFLAGS CC CXX CPPFLAGS LDFLAGS LDFLAGS_ALL CRT_OBJS LDSO_OBJS LIBC_OBJS CFLAGS_ALL CFLAGS_NOSSP CC LIBS CCAS CCASFLAGS CPP CXX

# Build toolchain from previously prepared config
ct-ng version
export DEFCONFIG="${SRC_DIR}/crosstool_configs/${TOOLCHAIN_VARIANT}.config"
ct-ng defconfig
ct-ng V=2 build.`${MAKE_J}`

# Everything put in ${PREFIX}
# will be included in output conda package
ls -l "${SRC_DIR}/toolchain/"
cd "${SRC_DIR}/toolchain/"*
cp -r * "${PREFIX}/"

# Make sure that toolchain has correct permissions
cd "${PREFIX}"
chmod -R u+w *

# Add symbolic links without "unknown" vendor part
for UNKNOWN_EXE in $(ls $PREFIX/bin/*-unknown-*); do
	EXE="$(echo $UNKNOWN_EXE | sed -e"s/-unknown//g")"
    	echo $EXE
	if [ ! -e "$EXE" ]; then
		ln -sv "$UNKNOWN_EXE" "$EXE"
	fi
done

