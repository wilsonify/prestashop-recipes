#!/bin/bash

# Define variables
DB_HOST="localhost"
DB_USER="root"
DB_PASSWORD="${MYSQL_PASSWORD:-'your_mysql_root_password'}"  # Default to environment variable, if set
DB_NAME="prestashop_db"  # Replace with your PrestaShop database name
NEW_DOMAIN="localhost:8181/prestashop"  # The new domain you want to set
PS_CONFIGURATION_TABLE="ps_configuration"
CACHE_DIR="/var/www/html/prestashop/var/cache"  # Adjust the path to your PrestaShop directory
LOG_FILE="/var/log/prestashop_domain_update.log"

# Check if the script is run as root (for cache clearance permission)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root for cache clearance." | tee -a $LOG_FILE
  exit 1
fi

# Ensure MySQL password is provided either via environment variable or argument
if [ -z "$DB_PASSWORD" ]; then
  echo "Error: MySQL root password is not provided!" | tee -a $LOG_FILE
  exit 1
fi

# Ensure the new domain is set
if [ -z "$NEW_DOMAIN" ]; then
  echo "Error: New domain is not set!" | tee -a $LOG_FILE
  exit 1
fi

# Step 1: Update the domain in the ps_configuration table
echo "Updating the PrestaShop domain in the database..." | tee -a $LOG_FILE
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "UPDATE $PS_CONFIGURATION_TABLE SET value='$NEW_DOMAIN' WHERE name='PS_SHOP_DOMAIN';" 2>>$LOG_FILE
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "UPDATE $PS_CONFIGURATION_TABLE SET value='$NEW_DOMAIN' WHERE name='PS_SHOP_DOMAIN_SSL';" 2>>$LOG_FILE

if [ $? -eq 0 ]; then
  echo "Domain successfully updated in the database to $NEW_DOMAIN." | tee -a $LOG_FILE
else
  echo "Error: Failed to update domain in the database." | tee -a $LOG_FILE
  exit 1
fi

# Step 2: Clear PrestaShop cache
echo "Clearing PrestaShop cache..." | tee -a $LOG_FILE

# Check if the cache directory exists
if [ ! -d "$CACHE_DIR" ]; then
  echo "Error: Cache directory $CACHE_DIR does not exist!" | tee -a $LOG_FILE
  exit 1
fi

rm -rf $CACHE_DIR/prod/* $CACHE_DIR/dev/* 2>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo "Cache successfully cleared." | tee -a $LOG_FILE
else
  echo "Error: Failed to clear the cache." | tee -a $LOG_FILE
  exit 1
fi

# Step 3: Provide feedback
echo "Domain has been updated to $NEW_DOMAIN." | tee -a $LOG_FILE
echo "Cache has been cleared." | tee -a $LOG_FILE

# Step 4: Additional instructions (Optional)
echo "Please restart your web server (Apache or Nginx) for changes to take effect." | tee -a $LOG_FILE
echo "You should now be able to access PrestaShop at $NEW_DOMAIN." | tee -a $LOG_FILE


