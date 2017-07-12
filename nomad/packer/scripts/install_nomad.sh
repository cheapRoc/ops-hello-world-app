#!/usr/bin/env bash

set -o errexit
set -o xtrace
set -o pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get install -y unzip

# Pull down Nomad
curl -o /tmp/nomad.zip https://releases.hashicorp.com/nomad/0.6.0-rc1/nomad_0.6.0-rc1_linux_amd64.zip

# Unzip archive and install
unzip /tmp/nomad.zip
mv nomad /usr/local/bin/nomad
