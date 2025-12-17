#!/bin/bash

set -eEux -o pipefail

root="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")" && cd -- "${root}"

for TARGET in \
    aarch64-linux-musl aarch64_be-linux-musl \
    arm-linux-musleabi arm-linux-musleabihf armeb-linux-musleabi armeb-linux-musleabihf \
    mips-linux-musl mips-linux-muslsf mipsel-linux-musl mipsel-linux-muslsf \
    x86_64-linux-musl \
; do

echo "TARGET = ${TARGET}" > config.mak
cat << _EOF_ >> config.mak

BINUTILS_VER = 2.44
GCC_VER = 15.2.0
MUSL_VER = 1.2.5
GMP_VER = 6.3.0
MPC_VER = 1.3.1
MPFR_VER = 4.2.2
LINUX_VER = 5.8.5

COMMON_CONFIG += --with-debug-prefix-map=\$(CURDIR)=
COMMON_CONFIG += CFLAGS="-g0 -Os" CXXFLAGS="-g0 -Os" LDFLAGS="-s"
COMMON_CONFIG += --disable-nls

GCC_CONFIG += --enable-languages=c,c++
GCC_CONFIG += --disable-libquadmath
GCC_CONFIG += --disable-decimal-float
GCC_CONFIG += --disable-libitm
GCC_CONFIG += --disable-fixed-point
GCC_CONFIG += --disable-lto

_EOF_

nice make install | tee "$(basename -- "${BASH_SOURCE[0]}" .sh).log"

done
