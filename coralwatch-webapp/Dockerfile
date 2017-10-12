FROM openjdk:7-jdk

RUN addgroup --system --gid 500 liferay && \
	adduser --system --uid 500 --gid 500 liferay

ADD liferay.tar.gz /opt

ADD coralwatch.war /opt/liferay/deploy

RUN chown liferay:liferay /opt/liferay/deploy/coralwatch.war

USER liferay

CMD ["/opt/liferay/tomcat-6.0.18/bin/catalina.sh", "run"]

WORKDIR /home/liferay

RUN mkdir -p /opt/liferay/tomcat-6.0.18/temp

ADD setenv.sh /opt/liferay/tomcat-6.0.18/bin/setenv.sh

EXPOSE 8080

