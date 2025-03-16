#!/bin/bash

# Define MySQL Database Configuration (use environment variables for security)
SOURCE_DB_HOST="old_server_host"
SOURCE_DB_NAME="prestashop_db"
SOURCE_DB_USER="old_db_user"
SOURCE_DB_PASSWORD="${SOURCE_DB_PASSWORD:-'old_db_password'}"  # Default to env var if set
SOURCE_FTP_USER="old_ftp_user"
SOURCE_FTP_PASSWORD="${SOURCE_FTP_PASSWORD:-'old_ftp_password'}"  # Default to env var if set
SOURCE_FTP_HOST="old_ftp_host"

TARGET_DB_HOST="new_server_host"
TARGET_DB_NAME="prestashop_db"
TARGET_DB_USER="new_db_user"
TARGET_DB_PASSWORD="${TARGET_DB_PASSWORD:-'new_db_password'}"  # Default to env var if set
TARGET_FTP_USER="new_ftp_user"
TARGET_FTP_PASSWORD="${TARGET_FTP_PASSWORD:-'new_ftp_password'}"  # Default to env var if set
TARGET_FTP_HOST="new_ftp_host"

# Define paths
BACKUP_DIR="/path/to/backups"
LOCAL_BACKUP_FILE="$BACKUP_DIR/prestashop_backup_$(date +%Y%m%d%H%M%S).sql"
LOCAL_FILES_DIR="/tmp/prestashop_files"
LOG_FILE="/var/log/prestashop_migration.log"

# Function to log messages with timestamp
log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - $1" | tee -a $LOG_FILE
}

# Check if running as root (for FTP operations and file permissions)
if [ "$(id -u)" -ne 0 ]; then
    log_message "This script must be run as root."
    exit 1
fi

# 1. Back Up the Database from the Old Server
log_message "Backing up the database from the old server..."
mysqldump -h $SOURCE_DB_HOST -u $SOURCE_DB_USER -p"$SOURCE_DB_PASSWORD" $SOURCE_DB_NAME > $LOCAL_BACKUP_FILE

if [ $? -eq 0 ]; then
    log_message "Database backup successful. Backup file saved to $LOCAL_BACKUP_FILE"
else
    log_message "Error during database backup. Exiting."
    exit 1
fi

# 2. Transfer PrestaShop Files from Old Server via FTP
log_message "Transferring PrestaShop files from the old server..."
mkdir -p $LOCAL_FILES_DIR

# Using lftp for better handling and retries
lftp -f "
open ftp://$SOURCE_FTP_USER:$SOURCE_FTP_PASSWORD@$SOURCE_FTP_HOST
cd /path/to/prestashop  # Adjust the PrestaShop directory
mget *
bye
"

if [ $? -eq 0 ]; then
    log_message "PrestaShop files transferred successfully."
else
    log_message "Error during file transfer. Exiting."
    exit 1
fi

# 3. Create a New Database on the New Server and Import the Backup
log_message "Creating a new database and importing the backup on the new server..."
mysql -h $TARGET_DB_HOST -u $TARGET_DB_USER -p"$TARGET_DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $TARGET_DB_NAME"
mysql -h $TARGET_DB_HOST -u $TARGET_DB_USER -p"$TARGET_DB_PASSWORD" $TARGET_DB_NAME < $LOCAL_BACKUP_FILE

if [ $? -eq 0 ]; then
    log_message "Database imported successfully to the new server."
else
    log_message "Error during database import. Exiting."
    exit 1
fi

# 4. Update the Configuration Files on the New Server
log_message "Updating configuration files with the new database details..."

# Update database credentials in PrestaShop config file (parameters.php)
sed -i "s/'database_host' => '.*'/'database_host' => '$TARGET_DB_HOST'/g" $LOCAL_FILES_DIR/app/config/parameters.php
sed -i "s/'database_name' => '.*'/'database_name' => '$TARGET_DB_NAME'/g" $LOCAL_FILES_DIR/app/config/parameters.php
sed -i "s/'database_user' => '.*'/'database_user' => '$TARGET_DB_USER'/g" $LOCAL_FILES_DIR/app/config/parameters.php
sed -i "s/'database_password' => '.*'/'database_password' => '$TARGET_DB_PASSWORD'/g" $LOCAL_FILES_DIR/app/config/parameters.php

# 5. Update the Shop URL in the Database (If Needed)
log_message "Updating shop domain in the database..."
mysql -h $TARGET_DB_HOST -u $TARGET_DB_USER -p"$TARGET_DB_PASSWORD" $TARGET_DB_NAME -e "
    UPDATE ps_configuration SET value = 'http://new_domain.com' WHERE name = 'PS_SHOP_DOMAIN';
    UPDATE ps_configuration SET value = 'http://new_domain.com' WHERE name = 'PS_SHOP_DOMAIN_SSL';
"

# 6. Clear PrestaShop Cache on the New Server
log_message "Clearing PrestaShop cache on the new server..."
if [ -d "$LOCAL_FILES_DIR/var/cache" ]; then
    rm -rf $LOCAL_FILES_DIR/var/cache/prod/* $LOCAL_FILES_DIR/var/cache/dev/*
    if [ $? -eq 0 ]; then
        log_message "Cache cleared successfully."
    else
        log_message "Error clearing cache."
    fi
else
    log_message "Cache directory not found on the new server."
fi

# 7. Transfer Files to the New Server via FTP
log_message "Uploading PrestaShop files to the new server..."
lftp -f "
open ftp://$TARGET_FTP_USER:$TARGET_FTP_PASSWORD@$TARGET_FTP_HOST
cd /path/to/prestashop  # Adjust the PrestaShop directory on the new server
mput *
bye
"

if [ $? -eq 0 ]; then
    log_message "Files uploaded successfully to the new server."
else
    log_message "Error during file upload. Exiting."
    exit 1
fi

# Final Steps: Test the Migration
log_message "Migration completed. Please visit your site and test functionality."
