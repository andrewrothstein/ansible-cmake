#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/Kitware/CMake/releases/download

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}-${arch}"
    local file="cmake-${ver}-${platform}.${archive_type}"
    local url=$MIRROR/v$ver/$file
    printf "      # %s\n" $url
    printf "      %s: sha256:%s\n" $platform $(grep -e "$file\$" $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local checksums="cmake-${ver}-SHA-256.txt"
    local url=$MIRROR/v$ver/$checksums

    local lchecksums=$DIR/$checksums
    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums win64 x64 zip
    dl $ver $lchecksums win32 x86 zip
    dl $ver $lchecksums macos universal
    dl $ver $lchecksums Linux x86_64
}

dl_ver ${1:-3.19.6}
