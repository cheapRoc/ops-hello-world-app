#!/usr/bin/env bash

set -o errexit
set -o xtrace
set -o pipefail

#PACKAGE=/tmp/helloworld_1.0_all.deb

export DEBIAN_FRONTEND=noninteractive

# Install Tomcat. For the purposes of brevity, omit much of the configuration.
apt-get install -y tomcat8 nginx unzip curl

# Edit Tomcat configuratino to bind to loopback. For brevity, this
# configuration is not packaged, but should be.
sed -i \
    '/<Connector port="8080"/a address="127.0.0.1" ' \
    /etc/tomcat8/server.xml

# Disable default nginx site configuration
rm /etc/nginx/sites-enabled/default

# Copy nginx configuration into place. For brevity, this configuration is
# not packaged, but should be.
mv /tmp/tomcat /etc/nginx/sites-available/tomcat
ln -s /etc/nginx/sites-available/tomcat /etc/nginx/sites-enabled/tomcat

# Nomad will supervise the tomcat/java process
systemctl disable tomcat8

# Move tomcat bootstrap script into place for Nomad
mv /tmp/run-tomcat.sh /usr/local/sbin
