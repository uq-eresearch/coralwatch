This is the CoralWatch website application. It is based on Java, Restlet, Freemarker, 
Maven and other tools. To use it you will need at least working JDK (>=1.6) and Maven 
(>=2.0.9) installations. An IDE with Maven support can be useful (e.g. Eclipse with the
m2eclipse plugin, or recent IDEA or NetBeans releases with native Maven support).

Since the application uses the Restlet framework extensions by the eResearch group, you
need to have access to the Artifactory installation with the group's repositories. See
http://maenad.itee.uq.edu.au/wiki/Artifactory for details.

Alternatively you can install those dependencies manually using the repository at 
http://sf.net/projects/metadata-net, but this is not recommended unless access to the
Artifactory repositories is not possible.

The application can be started from the command line by issuing a "mvn jetty:run"
command. This should download all dependencies and start the application on this URL:
http://localhost:8080/coralwatch

The application can also be started using the embedded Restlet engine by executing the
main method of the org.coralwatch.app.CoralwatchApplication class. This can be useful 
particularly in IDEs since it allows for easier integration with the log output and
debugging. The port used by default is configured in the "coralwatch.properties" file
located in the "src/main/resources" directory. You can override any value in there by
creating a file "local/coralwatch.properties" and setting values in this file. Note
that the application will be at the root level if started this way, e.g. if the server
runs on port 8181 the URL will be http://localhost:8181/ (no "coralwatch" in the URL).
