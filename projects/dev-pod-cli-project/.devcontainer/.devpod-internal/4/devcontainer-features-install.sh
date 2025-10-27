#!/bin/sh
set -e

on_exit () {
	[ $? -eq 0 ] && exit
	echo 'ERROR: Feature "Kubectl, Helm, and Minikube" (ghcr.io/devcontainers/features/kubectl-helm-minikube) failed to install! Look at the documentation at ${documentation} for help troubleshooting this error.'
}

trap on_exit EXIT

set -a
. ../devcontainer-features.builtin.env
. ./devcontainer-features.env
set +a

echo ===========================================================================

echo 'Feature       : Kubectl, Helm, and Minikube'
echo 'Description   : Installs latest version of kubectl, Helm, and optionally minikube. Auto-detects latest versions and installs needed dependencies.'
echo 'Id            : ghcr.io/devcontainers/features/kubectl-helm-minikube'
echo 'Version       : 1.2.2'
echo 'Documentation : https://github.com/devcontainers/features/tree/main/src/kubectl-helm-minikube'
echo 'Options       :'
echo '    HELM="latest"
    MINIKUBE="latest"
    VERSION="latest"'
echo 'Environment   :'
printenv
echo ===========================================================================

chmod +x ./install.sh
./install.sh
