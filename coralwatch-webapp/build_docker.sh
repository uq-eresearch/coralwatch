#!/bin/bash
set -e

mvn clean package
mkdir target/docker
wget -P target/docker https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/liferay.tar.gz
wget -P target/docker https://swift.rc.nectar.org.au:8888/v1/AUTH_96387d3104434db5bdd0a74e17e503f5/docker/setenv.sh
cp Dockerfile target/docker
cp target/coralwatch.war target/docker
( cd target/docker && docker build -t coralwatch . )


