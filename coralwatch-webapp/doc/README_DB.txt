== Using PostgreSQL on localhost with standard credentials ===

To use PostgreSQL with the standard settings you need to:
- Create a database called "coralwatch". Usually this means calling "createdb coralwatch" on the
  shell as postgres user
- Create a user "coralwatch" with password "coralwatch" and grant full access to the "coralwatch"
  database
- create a file "local/coralwatch.properties" in the project's root directory containing the line:
    persistenceUnitName=coralwatch-pgsql
    
A common sequence of commands on a Ubuntu installation looks like this (with abbreviated prompt):

    uqpbecke$ sudo su postgres
    postgres$ createdb coralwatch
    postgres$ psql coralwatch
    Welcome to psql 8.3.7, the PostgreSQL interactive terminal.
    
    Type:  \copyright for distribution terms
           \h for help with SQL commands
           \? for help with psql commands
           \g or terminate with semicolon to execute query
           \q to quit
    
    coralwatch=# create user coralwatch password 'coralwatch';
    CREATE ROLE
    coralwatch=# grant all on database coralwatch to coralwatch;
    GRANT

== Using MySQL on localhost with standard credentials ===

To use the CoralWatch application with a MySQL database you need to:
- Create a database in Mysql named "coralwatch" use the "CREATE DATABASE coralwatch;" in the
  command line
- Execute the following command to grant access coralwatch database user:
    GRANT ALL ON coralwatch.* TO 'coralwatchuser'@'localhost' IDENTIFIED BY 'coralwatchuser' WITH GRANT OPTION;
- create a file "local/coralwatch.properties" in the project's root directory containing the line:
    persistenceUnitName=coralwatch-mysql

=== Advanced configuration ===

If you want to run against a non-local database or use different credentials, you will need
to edit the "persistence.xml" file which can be found in the "META-INF" folder. This folder can
be found in the root of the deployment or in the src/main/resources folder.

If you want to use another database you will need to also add a dependency to the matching JDBC
driver in the "pom.xml" file.