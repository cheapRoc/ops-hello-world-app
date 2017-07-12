#!/bin/bash

set -o errexit
set -o xtrace
set -o pipefail

PACKAGE=helloworld_${VERSION}_all.deb

DEB_MANTA_URL=https://us-east.manta.joyent.com/justin.reagor/public/helloworld/${PACKAGE}

curl -o /tmp/${PACKAGE} ${DEB_MANTA_URL}

dpkg --install /tmp/${PACKAGE}

/usr/lib/jvm/default-java/bin/java \
  -Djava.util.logging.config.file=/var/lib/tomcat8/conf/logging.properties \
  -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
  -Djava.awt.headless=true \
  -Xmx128m \
  -XX:+UseConcMarkSweepGC \
  -Djava.endorsed.dirs=/usr/share/tomcat8/endorsed \
  -classpath /usr/share/tomcat8/bin/bootstrap.jar:/usr/share/tomcat8/bin/tomcat-juli.jar \
  -Dcatalina.base=/var/lib/tomcat8 \
  -Dcatalina.home=/usr/share/tomcat8 \
  -Djava.io.tmpdir=/tmp/tomcat8-tomcat8-tmp \
  org.apache.catalina.startup.Bootstrap run
