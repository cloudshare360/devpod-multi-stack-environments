#!/bin/sh
set -e

on_exit () {
	[ $? -eq 0 ] && exit
	echo 'ERROR: Feature "Terraform, tflint, and TFGrunt" (ghcr.io/devcontainers/features/terraform) failed to install! Look at the documentation at ${documentation} for help troubleshooting this error.'
}

trap on_exit EXIT

set -a
. ../devcontainer-features.builtin.env
. ./devcontainer-features.env
set +a

echo ===========================================================================

echo 'Feature       : Terraform, tflint, and TFGrunt'
echo 'Description   : Installs the Terraform CLI and optionally TFLint and Terragrunt. Auto-detects latest version and installs needed dependencies.'
echo 'Id            : ghcr.io/devcontainers/features/terraform'
echo 'Version       : 1.4.2'
echo 'Documentation : https://github.com/devcontainers/features/tree/main/src/terraform'
echo 'Options       :'
echo '    CUSTOMDOWNLOADSERVER=""
    HTTPPROXY=""
    INSTALLSENTINEL="false"
    INSTALLTERRAFORMDOCS="false"
    INSTALLTFSEC="false"
    TERRAGRUNT="latest"
    TFLINT="latest"
    VERSION="latest"'
echo 'Environment   :'
printenv
echo ===========================================================================

chmod +x ./install.sh
./install.sh
