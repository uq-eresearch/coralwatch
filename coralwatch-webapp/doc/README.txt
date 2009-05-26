


Before building the application, you will need to prepare the database:
- Create a database in Mysql named "coralwatch" use the "CREATE DATABASE coralwatch;" in the
  command line
- Execute the following command to grant access coralwatch database user:
    GRANT ALL ON coralwatch.* TO 'coralwatchuser'@'localhost' IDENTIFIED BY 'coralwatchuser' WITH GRANT OPTION;