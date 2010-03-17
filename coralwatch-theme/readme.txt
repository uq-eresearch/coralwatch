This folder contains files for a Liferay theme using the CoralWatch style.

The contents of this folder are mostly to be used in the context of a Liferay SDK. Currently this is build against the Liferay 5.2.3 SDK, putting the contents as "coralwatch-theme" into the "themes" folder of the SDK should work.

The fckstyles.xml should be copied into the Liferay installation. It should be tomcat-5.5.27/webapps/ROOT/html/js/editor/fckeditor/fckstyles.xml -- afterwards the server needs a restart. This file changes the styles available in the menu of the integrated HTML editor component.

Note that the theme hides all portal elements from the front page, including the log in box. Use with caution.

