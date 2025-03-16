#!/bin/bash

# Define MySQL Database Configuration
DB_HOST="localhost"
DB_USER="root"  # Replace with your MySQL username
DB_PASSWORD="${MYSQL_PASSWORD:-'your_mysql_password'}"  # Default to environment variable if set
DB_NAME="prestashop_db"  # Replace with your PrestaShop database name
BACKUP_DIR="/path/to/backups"  # Replace with the path where you want to store backups
CACHE_DIR="/var/www/html/prestashop/var/cache"  # Adjust the path to your PrestaShop directory
LOG_FILE="/var/log/prestashop_backup_restore.log"  # Path to the log file

# Function to Log Messages
log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - $1" | tee -a $LOG_FILE
}

# Check if the script is run as root (for cache clearance permission)
if [ "$(id -u)" -ne 0 ]; then
    log_message "This script must be run as root for cache clearance."
    exit 1
fi

# Function to Back Up the Database
backup_database() {
    # Create the backup directory if it doesn't exist
    mkdir -p $BACKUP_DIR

    # Create the backup file name with a timestamp
    BACKUP_FILE="$BACKUP_DIR/prestashop_backup_$(date +%Y%m%d%H%M%S).sql"

    # Run MySQL dump to back up the database
    log_message "Backing up the database..."
    mysqldump -h $DB_HOST -u $DB_USER -p"$DB_PASSWORD" $DB_NAME > $BACKUP_FILE

    if [ $? -eq 0 ]; then
        log_message "Database backup successful. Backup saved to $BACKUP_FILE"
    else
        log_message "Error during database backup."
        exit 1
    fi
}

# Function to Restore the Database
restore_database() {
    # Ask for the backup file to restore
    echo "Enter the path to the backup file you want to restore:"
    read BACKUP_FILE

    # Check if the backup file exists
    if [ ! -f "$BACKUP_FILE" ]; then
        log_message "Backup file does not exist. Exiting."
        echo "Backup file does not exist. Exiting."
        exit 1
    fi

    # Restore the database from the backup file
    log_message "Restoring the database from $BACKUP_FILE..."
    mysql -h $DB_HOST -u $DB_USER -p"$DB_PASSWORD" $DB_NAME < $BACKUP_FILE

    if [ $? -eq 0 ]; then
        log_message "Database restoration successful."
    else
        log_message "Error during database restoration."
        exit 1
    fi

    # Step 3: Clear PrestaShop cache after restore
    log_message "Clearing PrestaShop cache..."
    if [ -d "$CACHE_DIR" ]; then
        rm -rf $CACHE_DIR/prod/* $CACHE_DIR/dev/*

        if [ $? -eq 0 ]; then
            log_message "Cache cleared successfully."
        else
            log_message "Error clearing cache."
        fi
    else
        log_message "Cache directory $CACHE_DIR does not exist."
        echo "Cache directory does not exist."
    fi
}

# Main Menu
echo "Please choose an option:"
echo "1. Backup PrestaShop Database"
echo "2. Restore PrestaShop Database"
echo "3. Exit"
read -p "Enter your choice: " choice

case $choice in
    1)
        backup_database
        ;;
    2)
        restore_database
        ;;
    3)
        log_message "Exiting script."
        echo "Exiting script."
        exit 0
        ;;
    *)
        log_message "Invalid option selected. Exiting."
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac
