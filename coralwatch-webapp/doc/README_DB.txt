To use the CoralWatch application with a MySQL database you need to:
- Create a database in Mysql named "coralwatch" use the "CREATE DATABASE coralwatch;" in the
  command line
- Execute the following command to grant access coralwatch database user:
    GRANT ALL ON coralwatch.* TO 'coralwatchuser'@'localhost' IDENTIFIED BY 'coralwatchuser' WITH GRANT OPTION;
- create a file "local/coralwatch.properties" in the project's root directory containing the line:
    persistenceUnitName=coralwatch-mysql

If you want to run against a non-local copy of MySQL or use different credentials, you will need
to edit the "persistence.xml" file which can be found in the "META-INF" folder. This folder can
be found in the root of the deployment or in the src/main/resources folder.
