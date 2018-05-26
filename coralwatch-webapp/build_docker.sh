#!/bin/bash
set -e

CORALWATCH_WEBAPP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_DIR=${1:-$CORALWATCH_WEBAPP/target/docker}
CORALWATCH_DIR="$( dirname "$CORALWATCH_WEBAPP" )"

rm -rf $DOCKER_DIR
mkdir -p $DOCKER_DIR
if [ ! -f $CORALWATCH_WEBAPP/target/coralwatch.war ]; then
  mvn -f $CORALWATCH_WEBAPP/pom.xml clean package
fi

curl https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/liferay.tar.gz | tar xz --directory=$DOCKER_DIR
wget -P $DOCKER_DIR https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/setenv.sh
wget -P $DOCKER_DIR https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/jdk1.6.0_29.tar.gz
wget -P $DOCKER_DIR https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/coralwatch.sh

cp $CORALWATCH_WEBAPP/Dockerfile $DOCKER_DIR
cp $CORALWATCH_WEBAPP/target/coralwatch.war $DOCKER_DIR
cp -R $CORALWATCH_DIR/coralwatch-theme/docroot/_diffs/* $DOCKER_DIR/liferay/tomcat-6.0.18/webapps/coralwatch-theme

( cd $DOCKER_DIR && docker build -t coralwatch . )
