CoralWatch Liferay theme
====================================================================================================

This folder contains files for a Liferay theme using the CoralWatch style.

The contents of this folder are mostly to be used in the context of a Liferay SDK. Currently this is build against the Liferay 5.2.3 SDK, putting the contents as "coralwatch-theme" into the "themes" folder of the SDK should work.

Note that the theme hides all portal elements from the front page, including the log in box. Use with caution.

Instructions for building theme with the Liferay Plugins SDK.
----------------------------------------------------------------------------------------------------

The following instructions are based on the Liferay Portal 6.1 - Developers Guide (see https://www.liferay.com/documentation/liferay-portal/6.1/development/-/ai/installing-the-sdk).

Download liferay-plugins-sdk-5.2.3.zip from http://sourceforge.net/projects/lportal/files/Liferay%20Portal/5.2.3/liferay-plugins-sdk-5.2.3.zip/download.

Extract the ZIP file somewhere:

    uqcbroo2@gs709-0898:~
    $ mkdir /opt/liferay-plugins-sdk-5.2.3

    uqcbroo2@gs709-0898:~
    $ unzip -d /opt/liferay-plugins-sdk-5.2.3/ liferay-plugins-sdk-5.2.3.zip

Configure a build properties file:

    uqcbroo2@gs709-0898:~
    $ cd /opt/liferay-plugins-sdk-5.2.3/

    uqcbroo2@gs709-0898:/opt/liferay-plugins-sdk-5.2.3
    $ cp build.properties build.$USER.properties

    uqcbroo2@gs709-0898:/opt/liferay-plugins-sdk-5.2.3
    $ diff -uw build.properties build.uqcbroo2.properties
    --- build.properties    2009-05-15 14:29:20.000000000 +1000
    +++ build.uqcbroo2.properties   2014-03-31 14:45:16.231147878 +1000
    @@ -62,7 +62,7 @@
         #
         # Specify the paths to an unzipped Tomcat 6.0.x bundle.
         #
    -    app.server.dir=${project.dir}/../bundles/tomcat-6.0.18
    +    app.server.dir=/opt/liferay/tomcat-6.0.18
         app.server.classes.portal.dir=${app.server.portal.dir}/WEB-INF/classes
         app.server.lib.global.dir=${app.server.dir}/lib/ext
         app.server.lib.portal.dir=${app.server.portal.dir}/WEB-INF/lib

Copy the coralwatch theme over to the 'themes' directory of the plugins SDK.

    uqcbroo2@gs709-0898:/opt/liferay-plugins-sdk-5.2.3
    $ cp ~/code/coralwatch/coralwatch-theme themes

Run an ant build, which will package the theme as a WAR file. It will also deploy the theme by copying this WAR file to the 'deploy' directory under the nominated Liferay server.

    uqcbroo2@gs709-0898:/opt/liferay-plugins-sdk-5.2.3
    $ ant

Additional step for fckstyles.xml
----------------------------------------------------------------------------------------------------

The fckstyles.xml should be copied into the Liferay installation. It should be tomcat-5.5.27/webapps/ROOT/html/js/editor/fckeditor/fckstyles.xml -- afterwards the server needs a restart. This file changes the styles available in the menu of the integrated HTML editor component.
