#!/bin/bash

# Define MySQL Database Configuration
DB_HOST="localhost"
DB_USER="root"  # Replace with your MySQL username
DB_PASSWORD="your_mysql_password"  # Replace with your MySQL password
DB_NAME="prestashop_db"  # Replace with your PrestaShop database name
BACKUP_DIR="/path/to/backups"  # Replace with the path where you want to store backups
CACHE_DIR="/var/www/html/prestashop/var/cache"  # Adjust the path to your PrestaShop directory

# Function to Back Up the Database
backup_database() {
    # Create the backup directory if it doesn't exist
    mkdir -p $BACKUP_DIR

    # Create the backup file name with a timestamp
    BACKUP_FILE="$BACKUP_DIR/prestashop_backup_$(date +%Y%m%d%H%M%S).sql"

    # Run MySQL dump to back up the database
    echo "Backing up the database..."
    mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_FILE

    if [ $? -eq 0 ]; then
        echo "Database backup successful. Backup saved to $BACKUP_FILE"
    else
        echo "Error during database backup."
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
        echo "Backup file does not exist. Exiting."
        exit 1
    fi

    # Restore the database from the backup file
    echo "Restoring the database..."
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $BACKUP_FILE

    if [ $? -eq 0 ]; then
        echo "Database restoration successful."
    else
        echo "Error during database restoration."
        exit 1
    fi

    # Step 3: Clear PrestaShop cache after restore
    echo "Clearing PrestaShop cache..."
    rm -rf $CACHE_DIR/prod/* $CACHE_DIR/dev/*

    if [ $? -eq 0 ]; then
        echo "Cache cleared successfully."
    else
        echo "Error clearing cache."
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
        echo "Exiting script."
        exit 0
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac
