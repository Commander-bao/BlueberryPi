#!/bin/bash -e

TARGET_DIR=$1
shift

OS_RELEASE="${TARGET_DIR}/etc/os-release"

function add_build_info()
{
    [ -f "$OS_RELEASE" ] && sed -i "/^BUILD_ID=/d" "$OS_RELEASE"

    echo "Adding build-info to /etc/os-release..."
    echo "BUILD_INFO=\"$(whoami)@$(hostname) $(date)${@:+ - $@}\"" >> \
        "$OS_RELEASE"
}

echo "Executing $(basename $0)..."

add_build_info $@

exit 0
