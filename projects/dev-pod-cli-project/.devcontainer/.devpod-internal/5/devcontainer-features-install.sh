#!/bin/sh
set -e

on_exit () {
	[ $? -eq 0 ] && exit
	echo 'ERROR: Feature "PHP" (ghcr.io/devcontainers/features/php) failed to install! Look at the documentation at ${documentation} for help troubleshooting this error.'
}

trap on_exit EXIT

set -a
. ../devcontainer-features.builtin.env
. ./devcontainer-features.env
set +a

echo ===========================================================================

echo 'Feature       : PHP'
echo 'Description   : '
echo 'Id            : ghcr.io/devcontainers/features/php'
echo 'Version       : 1.1.4'
echo 'Documentation : https://github.com/devcontainers/features/tree/main/src/php'
echo 'Options       :'
echo '    INSTALLCOMPOSER="true"
    VERSION="8.3"'
echo 'Environment   :'
printenv
echo ===========================================================================

chmod +x ./install.sh
./install.sh
