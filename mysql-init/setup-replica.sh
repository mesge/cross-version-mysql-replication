#!/bin/bash

# Wait for the primary to be available
until mysql -h mysql-primary -u replicator -pnotprodpassword -e "SELECT 1"; do
    echo "Waiting for primary to be available..."
    sleep 5
done

# Get the binary log file and position from the primary
MASTER_LOG_FILE=$(mysql -h mysql-primary -u root -pnotprodpassword -e "SHOW MASTER STATUS\G" | grep 'File:' | awk '{print $2}')
MASTER_LOG_POS=$(mysql -h mysql-primary -u root -pnotprodpassword -e "SHOW MASTER STATUS\G" | grep 'Position:' | awk '{print $2}')

# Set up replication
mysql -u root -pnotprodpassword <<EOF

CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='mysql-primary',
    SOURCE_USER='replicator',
    SOURCE_PASSWORD='notprodpassword',
    SOURCE_LOG_FILE='$MASTER_LOG_FILE',
    SOURCE_LOG_POS=$MASTER_LOG_POS;

START REPLICA;
EOF

# Create the users table on the primary
mysql -h mysql-primary -u root -pnotprodpassword --database testdb -e "CREATE TABLE users (id INT, name VARCHAR(255))\G"
