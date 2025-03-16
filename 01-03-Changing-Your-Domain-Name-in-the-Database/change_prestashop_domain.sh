#!/bin/bash

# Define variables
DB_HOST="localhost"
DB_USER="root"
DB_PASSWORD="your_mysql_root_password"
DB_NAME="prestashop_db"  # Replace with your PrestaShop database name
NEW_DOMAIN="localhost:8181/prestashop"  # The new domain you want to set
PS_CONFIGURATION_TABLE="ps_configuration"
CACHE_DIR="/var/www/html/prestashop/var/cache"  # Adjust the path to your PrestaShop directory

# Check if the script is run as root (for cache clearing permission)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root for cache clearance."
  exit 1
fi

# Step 1: Update the domain in the ps_configuration table
echo "Updating the PrestaShop domain in the database..."
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "UPDATE $PS_CONFIGURATION_TABLE SET value='$NEW_DOMAIN' WHERE name='PS_SHOP_DOMAIN';"
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "UPDATE $PS_CONFIGURATION_TABLE SET value='$NEW_DOMAIN' WHERE name='PS_SHOP_DOMAIN_SSL';"

# Step 2: Clear PrestaShop cache
echo "Clearing PrestaShop cache..."
rm -rf $CACHE_DIR/prod/* $CACHE_DIR/dev/*

# Step 3: Provide feedback
echo "Domain has been updated to $NEW_DOMAIN."
echo "Cache has been cleared."

# Step 4: Additional instructions (Optional)
echo "Please restart your web server (Apache or Nginx) for changes to take effect."
echo "You should now be able to access PrestaShop at $NEW_DOMAIN."
