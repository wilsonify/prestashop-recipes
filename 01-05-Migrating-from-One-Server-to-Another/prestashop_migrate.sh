#!/bin/bash

# Define variables for the source (old) server and the target (new) server
SOURCE_DB_HOST="old_server_host"  # Old server database host
SOURCE_DB_NAME="prestashop_db"   # Old database name
SOURCE_DB_USER="old_db_user"     # Old database username
SOURCE_DB_PASSWORD="old_db_password"  # Old database password
SOURCE_FTP_USER="old_ftp_user"   # Old FTP username
SOURCE_FTP_PASSWORD="old_ftp_password"  # Old FTP password
SOURCE_FTP_HOST="old_ftp_host"   # Old FTP host

TARGET_DB_HOST="new_server_host"  # New server database host
TARGET_DB_NAME="prestashop_db"    # New database name (same as the old one)
TARGET_DB_USER="new_db_user"      # New database username
TARGET_DB_PASSWORD="new_db_password"  # New database password
TARGET_FTP_USER="new_ftp_user"    # New FTP username
TARGET_FTP_PASSWORD="new_ftp_password"  # New FTP password
TARGET_FTP_HOST="new_ftp_host"    # New FTP host

# Define paths
BACKUP_DIR="/path/to/backups"  # Directory to store backups
LOCAL_BACKUP_FILE="$BACKUP_DIR/prestashop_backup_$(date +%Y%m%d%H%M%S).sql"
LOCAL_FILES_DIR="/tmp/prestashop_files"  # Temporary local directory for PrestaShop files

# 1. Back Up the Database from the Old Server
echo "Backing up the database from the old server..."
mysqldump -h $SOURCE_DB_HOST -u $SOURCE_DB_USER -p$SOURCE_DB_PASSWORD $SOURCE_DB_NAME > $LOCAL_BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "Database backup successful. Backup file saved to $LOCAL_BACKUP_FILE"
else
    echo "Error during database backup. Exiting."
    exit 1
fi

# 2. Transfer PrestaShop Files from Old Server via FTP
echo "Transferring PrestaShop files from the old server..."
mkdir -p $LOCAL_FILES_DIR

# Use FTP to download the files from the old server
ftp -n $SOURCE_FTP_HOST <<EOF
user $SOURCE_FTP_USER $SOURCE_FTP_PASSWORD
binary
cd /path/to/prestashop  # Replace with the path to your PrestaShop directory on the old server
mget *
bye
EOF

# Check if files were downloaded successfully
if [ $? -eq 0 ]; then
    echo "PrestaShop files transferred successfully."
else
    echo "Error during file transfer. Exiting."
    exit 1
fi

# 3. Create a New Database on the New Server and Import the Backup
echo "Creating a new database and importing the backup on the new server..."

mysql -h $TARGET_DB_HOST -u $TARGET_DB_USER -p$TARGET_DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $TARGET_DB_NAME"

# Import the backup file to the new database
mysql -h $TARGET_DB_HOST -u $TARGET_DB_USER -p$TARGET_DB_PASSWORD $TARGET_DB_NAME < $LOCAL_BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "Database imported successfully to the new server."
else
    echo "Error during database import. Exiting."
    exit 1
fi

# 4. Update the Configuration Files on the New Server
echo "Updating configuration files with the new database details..."

# Update the database credentials in the PrestaShop config file (parameters.php)
sed -i "s/'database_host' => '.*'/'database_host' => '$TARGET_DB_HOST'/g" $LOCAL_FILES_DIR/app/config/parameters.php
sed -i "s/'database_name' => '.*'/'database_name' => '$TARGET_DB_NAME'/g" $LOCAL_FILES_DIR/app/config/parameters.php
sed -i "s/'database_user' => '.*'/'database_user' => '$TARGET_DB_USER'/g" $LOCAL_FILES_DIR/app/config/parameters.php
sed -i "s/'database_password' => '.*'/'database_password' => '$TARGET_DB_PASSWORD'/g" $LOCAL_FILES_DIR/app/config/parameters.php

# 5. Update the Shop URL in the Database (If Needed)
echo "Updating shop domain in the database..."
mysql -h $TARGET_DB_HOST -u $TARGET_DB_USER -p$TARGET_DB_PASSWORD $TARGET_DB_NAME -e "
    UPDATE ps_configuration SET value = 'http://new_domain.com' WHERE name = 'PS_SHOP_DOMAIN';
    UPDATE ps_configuration SET value = 'http://new_domain.com' WHERE name = 'PS_SHOP_DOMAIN_SSL';
"

# 6. Clear PrestaShop Cache
echo "Clearing PrestaShop cache on the new server..."
rm -rf $LOCAL_FILES_DIR/var/cache/prod/* $LOCAL_FILES_DIR/var/cache/dev/*

# 7. Transfer Files to the New Server via FTP
echo "Uploading PrestaShop files to the new server..."
ftp -n $TARGET_FTP_HOST <<EOF
user $TARGET_FTP_USER $TARGET_FTP_PASSWORD
binary
cd /path/to/prestashop  # Replace with the path to your PrestaShop directory on the new server
mput *
bye
EOF

if [ $? -eq 0 ]; then
    echo "Files uploaded successfully to the new server."
else
    echo "Error during file upload. Exiting."
    exit 1
fi

# Final Steps: Test the Migration
echo "Migration completed. Please visit your site and test functionality."
