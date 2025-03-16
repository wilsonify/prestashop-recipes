#!/bin/bash

# Configuration Variables
PRESTASHOP_DIR="/var/www/html/prestashop"        # Path to your PrestaShop directory
DB_NAME="prestashop_db"                          # Set your PrestaShop database name
DB_USER="root"                                   # Set your MySQL database username
DB_PASS="your_password"                          # Set your MySQL database password
BASE_URL="http://localhost/prestashop"           # Base URL of your PrestaShop website
NEW_STORE_NAME="New Store"                       # New store name
NEW_STORE_DOMAIN="newstore.local"                # Domain for the new store
STORE_ID=2                                        # Store ID to be created (adjust accordingly)

# Enable MultiStore in PrestaShop Database
echo "Enabling MultiStore feature in PrestaShop database..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='1' WHERE name='PS_MULTISTORE';"
if [ $? -eq 0 ]; then
    echo "MultiStore enabled successfully."
else
    echo "Failed to enable MultiStore."
    exit 1
fi

# Insert a new store into the ps_shop table
echo "Adding a new store to the MultiStore network..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "INSERT INTO ps_shop (id_shop_group, name, active, deleted, id_shop_category) VALUES (1, '$NEW_STORE_NAME', 1, 0, 1);"
if [ $? -eq 0 ]; then
    echo "New store '$NEW_STORE_NAME' added successfully."
else
    echo "Failed to add new store."
    exit 1
fi

# Retrieve the ID of the new store
NEW_STORE_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -s -N -e "SELECT id_shop FROM ps_shop WHERE name = '$NEW_STORE_NAME';")
if [ -z "$NEW_STORE_ID" ]; then
    echo "Failed to retrieve the new store ID."
    exit 1
fi
echo "Store ID: $NEW_STORE_ID"

# Set up the new store’s URL and domain
echo "Configuring the new store's domain and URL..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_shop_url SET domain='$NEW_STORE_DOMAIN', domain_ssl='$NEW_STORE_DOMAIN', physical_uri='/', virtual_uri='' WHERE id_shop=$NEW_STORE_ID;"
if [ $? -eq 0 ]; then
    echo "New store URL and domain set successfully."
else
    echo "Failed to update the store URL and domain."
    exit 1
fi

# Configure the store for multi-currency and language support (Optional)
echo "Setting up default language and currency for the new store..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='en' WHERE name='PS_LANG_DEFAULT';"
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='USD' WHERE name='PS_CURRENCY_DEFAULT';"
if [ $? -eq 0 ]; then
    echo "Language and currency set to default for new store."
else
    echo "Failed to update language and currency."
    exit 1
fi

# Set the theme for the new store (Optional)
echo "Setting the theme for the new store..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "INSERT INTO ps_theme (name, is_default) VALUES ('classic', 1);"
if [ $? -eq 0 ]; then
    echo "Theme set successfully for new store."
else
    echo "Failed to set the theme for the new store."
    exit 1
fi

# Verify MultiStore and new store setup in PrestaShop Admin
echo "MultiStore has been enabled and a new store '$NEW_STORE_NAME' has been created."
echo "You can now log into the PrestaShop Back Office to manage your stores: $BASE_URL/admin"
