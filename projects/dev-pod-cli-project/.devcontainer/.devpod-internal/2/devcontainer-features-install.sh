#!/bin/sh
set -e

on_exit () {
	[ $? -eq 0 ] && exit
	echo 'ERROR: Feature "Dotnet CLI" (ghcr.io/devcontainers/features/dotnet) failed to install! Look at the documentation at ${documentation} for help troubleshooting this error.'
}

trap on_exit EXIT

set -a
. ../devcontainer-features.builtin.env
. ./devcontainer-features.env
set +a

echo ===========================================================================

echo 'Feature       : Dotnet CLI'
echo 'Description   : This Feature installs the latest .NET SDK, which includes the .NET CLI and the shared runtime. Options are provided to choose a different version or additional versions.'
echo 'Id            : ghcr.io/devcontainers/features/dotnet'
echo 'Version       : 2.4.0'
echo 'Documentation : https://github.com/devcontainers/features/tree/main/src/dotnet'
echo 'Options       :'
echo '    ADDITIONALVERSIONS=""
    ASPNETCORERUNTIMEVERSIONS=""
    DOTNETRUNTIMEVERSIONS=""
    INSTALLUSINGAPT="true"
    VERSION="8.0"
    WORKLOADS=""'
echo 'Environment   :'
printenv
echo ===========================================================================

chmod +x ./install.sh
./install.sh
