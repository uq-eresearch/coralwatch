#!/bin/bash
set -e

CORALWATCH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_DIR=${1:-$CORALWATCH_DIR/target/docker}

rm -rf $DOCKER_DIR
mkdir -p $DOCKER_DIR
if [ ! -f $CORALWATCH_DIR/target/coralwatch.war ]; then
  mvn -f $CORALWATCH_DIR/pom.xml clean package
fi

wget -P $DOCKER_DIR https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/liferay.tar.gz
wget -P $DOCKER_DIR https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/setenv.sh
wget -P $DOCKER_DIR https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/jdk1.6.0_29.tar.gz
wget -P $DOCKER_DIR https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/coralwatch.sh

cp $CORALWATCH_DIR/Dockerfile $DOCKER_DIR
cp $CORALWATCH_DIR/target/coralwatch.war $DOCKER_DIR

cd $CORALWATCH_DIR
cp -R ../coralwatch-theme/docroot/_diffs $DOCKER_DIR/coralwatch-theme

ls -la $DOCKER_DIR
ls -la $DOCKER_DIR/coralwatch-theme
ls -la $DOCKER_DIR/coralwatch-theme/
ls -la $DOCKER_DIR/coralwatch-theme/templates
