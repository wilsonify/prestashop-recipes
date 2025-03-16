#!/bin/bash

# Configuration Variables
PRESTASHOP_DIR="/var/www/html/prestashop"        # Path to your PrestaShop directory
DB_NAME="prestashop_db"                          # Set your PrestaShop database name
DB_USER="root"                                   # Set your MySQL database username
DB_PASS="${DB_PASS:-'your_password'}"            # Fallback to environment variable if set
BASE_URL="http://localhost/prestashop"           # Base URL of your PrestaShop website
NEW_STORE_NAME="New Store"                       # New store name
NEW_STORE_DOMAIN="newstore.local"                # Domain for the new store
STORE_ID=2                                        # Store ID to be created (adjust accordingly)

# Log file to track script activity
LOG_FILE="/var/log/prestashop_multistore_setup.log"

# Function to log messages with timestamps
log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - $1" | tee -a $LOG_FILE
}

# Function to execute MySQL commands and check for errors
execute_mysql() {
    local query="$1"
    mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$query"
    if [ $? -ne 0 ]; then
        log_message "MySQL Error: $query"
        exit 1
    fi
}

# 1. Enable MultiStore feature in PrestaShop Database
log_message "Enabling MultiStore feature in PrestaShop database..."
execute_mysql "UPDATE ps_configuration SET value='1' WHERE name='PS_MULTISTORE';"
log_message "MultiStore enabled successfully."

# 2. Check if the new store already exists and insert if necessary
log_message "Checking if store '$NEW_STORE_NAME' exists..."
EXISTING_STORE_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -s -N -e "SELECT id_shop FROM ps_shop WHERE name = '$NEW_STORE_NAME';")

if [ -z "$EXISTING_STORE_ID" ]; then
    log_message "Adding a new store to the MultiStore network..."
    execute_mysql "INSERT INTO ps_shop (id_shop_group, name, active, deleted, id_shop_category) VALUES (1, '$NEW_STORE_NAME', 1, 0, 1);"
    NEW_STORE_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -s -N -e "SELECT id_shop FROM ps_shop WHERE name = '$NEW_STORE_NAME';")
    log_message "New store '$NEW_STORE_NAME' added successfully with ID: $NEW_STORE_ID."
else
    log_message "Store '$NEW_STORE_NAME' already exists with ID: $EXISTING_STORE_ID."
    NEW_STORE_ID="$EXISTING_STORE_ID"
fi

# 3. Set up the new store’s URL and domain
log_message "Configuring the new store's domain and URL..."
execute_mysql "UPDATE ps_shop_url SET domain='$NEW_STORE_DOMAIN', domain_ssl='$NEW_STORE_DOMAIN', physical_uri='/', virtual_uri='' WHERE id_shop=$NEW_STORE_ID;"
log_message "New store URL and domain set successfully."

# 4. Configure the store for multi-currency and language support
log_message "Setting up default language and currency for the new store..."
execute_mysql "UPDATE ps_configuration SET value='en' WHERE name='PS_LANG_DEFAULT';"
execute_mysql "UPDATE ps_configuration SET value='USD' WHERE name='PS_CURRENCY_DEFAULT';"
log_message "Language and currency set to default for new store."

# 5. Set the theme for the new store
log_message "Setting the theme for the new store..."
execute_mysql "INSERT INTO ps_theme (name, is_default) VALUES ('classic', 1);"
log_message "Theme set successfully for new store."

# 6. Verify MultiStore and new store setup in PrestaShop Admin
log_message "MultiStore has been enabled and a new store '$NEW_STORE_NAME' has been created."
log_message "You can now log into the PrestaShop Back Office to manage your stores: $BASE_URL/admin"

# Final message indicating successful completion
log_message "PrestaShop MultiStore setup completed successfully."
