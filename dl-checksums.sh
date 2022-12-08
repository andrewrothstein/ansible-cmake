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
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep -e "$file\$" $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local checksums="cmake-${ver}-SHA-256.txt"
    local url=$MIRROR/v$ver/$checksums

    local lchecksums=$DIR/$checksums
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums windows i386 zip
    dl $ver $lchecksums windows x86_64 zip
    dl $ver $lchecksums macos universal
    dl $ver $lchecksums linux x86_64
    dl $ver $lchecksums linux aarch64
}

dl_ver ${1:-3.25.1}
