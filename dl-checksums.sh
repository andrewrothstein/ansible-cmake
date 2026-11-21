#!/usr/bin/env sh
set -e
DIR=$(mktemp -d)
trap 'rm -rf "$DIR"' EXIT
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
    local sum
    sum=$(awk -v f="$file" '$2 == f || $2 == "*" f {print $1}' "$lchecksums")
    if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'
    then
        echo "bad or missing checksum for $file: '$sum'" >&2
        exit 1
    fi
    printf "    # %s\n" "$url"
    printf "    %s: sha256:%s\n" "$platform" "$sum"
}

dl_ver() {
    local ver=$1
    local checksums="cmake-${ver}-SHA-256.txt"
    local url=$MIRROR/v$ver/$checksums

    local lchecksums=$DIR/$checksums
    curl -fsSL --proto '=https' --tlsv1.2 -o "$lchecksums" "$url"

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums windows i386 zip
    dl $ver $lchecksums windows x86_64 zip
    dl $ver $lchecksums macos universal
    dl $ver $lchecksums linux x86_64
    dl $ver $lchecksums linux aarch64
}

dl_ver ${1:-4.5.1}
