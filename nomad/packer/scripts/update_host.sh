#!/usr/bin/env bash

set -o errexit
set -o xtrace
set -o pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
