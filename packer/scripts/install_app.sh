#!/usr/bin/env bash

set -o errexit
set -o xtrace
set -o pipefail

PACKAGE=/tmp/helloworld_1.0_all.deb

export DEBIAN_FRONTEND=noninteractive

# Install Tomcat. For the purposes of brevity, omit much of the configuration.
apt-get install -y tomcat8 nginx

# Edit Tomcat configuratino to bind to loopback. For brevity, this
# configuration is not packaged, but should be.
sed -i \
	'/<Connector port="8080"/a \t\t\t\taddress="127.0.0.1" ' \
	/etc/tomcat8/server.xml

# Copy nginx configuration into place. For brevity, this configuration is
# not packaged, but should be.
mv /tmp/tomcat /etc/nginx/sites-available/tomcat
ln -s /etc/nginx/sites-available/tomcat /etc/nginx/sites-enabled/tomcat

# Install our package. For simplicity we copy the package in rather 
# than configuring an APT repository, though this is straightforward
# to host on Manta once it is created using Package Cloud, Aptly or
# similar tools.
dpkg --install "${PACKAGE}"
rm "${PACKAGE}"
