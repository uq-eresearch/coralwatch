FROM ubuntu:xenial

RUN addgroup --system --gid 500 liferay && \
	adduser --system --uid 500 --gid 500 liferay

ADD jdk1.6.0_29.tar.gz /opt

ENV JAVA_HOME=/opt/jdk1.6.0_29

ADD liferay.tar.gz /opt

ADD coralwatch.war /opt/liferay

RUN ls -la /opt/liferay

ADD coralwatch.sh /opt/liferay/tomcat-6.0.18/bin

ADD setenv.sh /opt/liferay/tomcat-6.0.18/bin/setenv.sh

RUN mkdir -p /opt/liferay/tomcat-6.0.18/temp

RUN chown -R liferay:liferay /opt/liferay

USER liferay

CMD ["/bin/bash", "/opt/liferay/tomcat-6.0.18/bin/coralwatch.sh"]

WORKDIR /opt/liferay/tomcat-6.0.18/bin

EXPOSE 8080
