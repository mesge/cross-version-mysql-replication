-- Create a database for replication
CREATE DATABASE IF NOT EXISTS testdb;

-- Create a replication user with mysql_native_password
CREATE USER 'replicator'@'%' IDENTIFIED WITH mysql_native_password BY 'notprodpassword';
GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'%';

CREATE USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT PROCESS, REPLICATION SLAVE, REPLICATION CLIENT, RELOAD, LOCK TABLES, EXECUTE, SELECT, UPDATE, INSERT, DELETE ON *.* TO 'user'@'%';

FLUSH PRIVILEGES;
