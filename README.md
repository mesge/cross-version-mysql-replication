# Cross Version MySQL Replication Stack

This is a docker compose stack that sets up binlog replication between a MySQL
5.7 primary and MySQL 8 replica. It can be a used a component in a dev
environment for experimenting with MySQL cross version replication.

## How to use

Start the stack

```
docker compose up -d
```

Connect to MySQL 8 Replica
```
mysql -h 127.0.0.1 -u root -pnotprodpassword -P 3307 --database testdb
```

Connect to MySQL 5.7 primary
```
mysql -h 127.0.0.1 -u root -pnotprodpassword -P 3306 --database testdb
```

Make sure you're using a mysql 8 CLI.

```
brew install mysql-client@8.4
```

## Test Replication

There is a precreated table named `users`

Its structure:
```SQL
CREATE TABLE `users` (
  `id` int DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
```

Insert a record on the primary

```
mysql -h 127.0.0.1 -u root -pnotprodpassword -P 3306 --database testdb -e 'insert into users (id,name) values (1, "test")'
```

Read it from the replica

```
mysql -h 127.0.0.1 -u root -pnotprodpassword -P 3307 --database testdb -e "select * from users\G"
```
