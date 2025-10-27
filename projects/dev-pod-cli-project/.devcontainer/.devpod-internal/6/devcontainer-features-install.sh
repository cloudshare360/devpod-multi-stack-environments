#!/bin/sh
set -e

on_exit () {
	[ $? -eq 0 ] && exit
	echo 'ERROR: Feature "Rust" (ghcr.io/devcontainers/features/rust) failed to install! Look at the documentation at ${documentation} for help troubleshooting this error.'
}

trap on_exit EXIT

set -a
. ../devcontainer-features.builtin.env
. ./devcontainer-features.env
set +a

echo ===========================================================================

echo 'Feature       : Rust'
echo 'Description   : Installs Rust, common Rust utilities, and their required dependencies'
echo 'Id            : ghcr.io/devcontainers/features/rust'
echo 'Version       : 1.5.0'
echo 'Documentation : https://github.com/devcontainers/features/tree/main/src/rust'
echo 'Options       :'
echo '    COMPONENTS="rust-analyzer,rust-src,rustfmt,clippy"
    PROFILE="default"
    TARGETS=""
    VERSION="latest"'
echo 'Environment   :'
printenv
echo ===========================================================================

chmod +x ./install.sh
./install.sh
