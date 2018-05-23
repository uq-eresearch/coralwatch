FROM ubuntu:xenial

RUN addgroup --system --gid 500 liferay && \
	adduser --system --uid 500 --gid 500 liferay

ADD jdk1.6.0_29.tar.gz /opt

ENV JAVA_HOME=/opt/jdk1.6.0_29

ADD liferay.tar.gz /opt

COPY coralwatch-theme/templates/init_custom.vm2 /opt/liferay/tomcat-6.0.18/webapps/coralwatch-theme/
COPY coralwatch-theme/templates/portal_normal.vm /opt/liferay/tomcat-6.0.18/webapps/coralwatch-theme/


ADD coralwatch.sh /opt/liferay/tomcat-6.0.18/bin

ADD setenv.sh /opt/liferay/tomcat-6.0.18/bin/setenv.sh

RUN mkdir -p /opt/liferay/tomcat-6.0.18/temp

RUN chown -R liferay:liferay /opt/liferay

USER liferay



WORKDIR /opt/liferay/tomcat-6.0.18/webapps


