#!/bin/sh
set -e

on_exit () {
	[ $? -eq 0 ] && exit
	echo 'ERROR: Feature "Java (via SDKMAN!)" (ghcr.io/devcontainers/features/java) failed to install! Look at the documentation at ${documentation} for help troubleshooting this error.'
}

trap on_exit EXIT

set -a
. ../devcontainer-features.builtin.env
. ./devcontainer-features.env
set +a

echo ===========================================================================

echo 'Feature       : Java (via SDKMAN!)'
echo 'Description   : Installs Java, SDKMAN! (if not installed), and needed dependencies.'
echo 'Id            : ghcr.io/devcontainers/features/java'
echo 'Version       : 1.6.3'
echo 'Documentation : https://github.com/devcontainers/features/tree/main/src/java'
echo 'Options       :'
echo '    ADDITIONALVERSIONS=""
    ANTVERSION="latest"
    GRADLEVERSION="latest"
    GROOVYVERSION="latest"
    INSTALLANT="false"
    INSTALLGRADLE="true"
    INSTALLGROOVY="false"
    INSTALLMAVEN="true"
    JDKDISTRO="ms"
    MAVENVERSION="latest"
    VERSION="21"'
echo 'Environment   :'
printenv
echo ===========================================================================

chmod +x ./install.sh
./install.sh
