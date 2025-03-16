#!/bin/bash

# Configuration Variables
PRESTASHOP_DIR="/var/www/html/prestashop"        # Path to your PrestaShop directory
DB_NAME="prestashop_db"                          # Set your PrestaShop database name
DB_USER="root"                                   # Set your MySQL database username
DB_PASS="${DB_PASS:-'your_password'}"            # Fallback to environment variable if set
PRODUCT_NAME="Tour of Havana in an American Classic Car"  # Service product name
PRODUCT_REFERENCE="Havana_Tour_2025"             # Unique product reference
SERVICE_PRICE="60.00"                            # Base price for the service
SERVICE_COMBINATION_PRICE="15.00"                # Additional price for a specific combination (e.g., guided tour)
PRODUCT_DESCRIPTION="A guided tour in an American classic car, exploring the best of Havana."  # Service description

# Log file for script activity
LOG_FILE="/var/log/prestashop_service_product_creation.log"

# Function to log messages with timestamps
log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - $1" | tee -a $LOG_FILE
}

# Function to execute MySQL commands and handle errors
execute_mysql() {
    local query="$1"
    mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$query"
    if [ $? -ne 0 ]; then
        log_message "MySQL Error: $query"
        exit 1
    fi
}

# Step 1: Create a new standard product (service) in the database
log_message "Creating service product in PrestaShop..."
execute_mysql "INSERT INTO ps_product (id_category_default, reference, price, active) VALUES (1, '$PRODUCT_REFERENCE', '$SERVICE_PRICE', 1);"
log_message "Service product '$PRODUCT_NAME' created successfully."

# Step 2: Set product description
log_message "Setting product description..."

PRODUCT_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -s -N -e "SELECT id_product FROM ps_product WHERE reference = '$PRODUCT_REFERENCE';")
execute_mysql "INSERT INTO ps_product_lang (id_product, id_lang, description) VALUES ($PRODUCT_ID, 1, '$PRODUCT_DESCRIPTION');"
log_message "Product description set successfully."

# Step 3: Disable shipping for the service (treat as non-physical product)
log_message "Disabling shipping for the service product..."
execute_mysql "INSERT INTO ps_product_carrier (id_product, id_carrier, id_reference, delivery_time) VALUES ($PRODUCT_ID, 1, 'service_shipping', '');"
log_message "Shipping disabled for service product."

# Step 4: Create combinations for the service (e.g., guided tour)
log_message "Creating combinations for the service product..."

COMBINATION_NAME="Guided Tour"
COMBINATION_PRICE="$SERVICE_COMBINATION_PRICE"
execute_mysql "INSERT INTO ps_product_attribute (id_product, reference, price) VALUES ($PRODUCT_ID, '${PRODUCT_REFERENCE}_Guided_Tour', $COMBINATION_PRICE);"
log_message "Combination 'Guided Tour' created successfully."

# Step 5: Modify product settings (make it a service)
log_message "Customizing product settings for service..."
execute_mysql "UPDATE ps_product SET weight=0, online_only=1 WHERE id_product=$PRODUCT_ID;"
log_message "Product customized successfully for service."

# Step 6: Enable the product in the catalog
log_message "Enabling service product in the catalog..."
execute_mysql "UPDATE ps_product SET active=1 WHERE id_product=$PRODUCT_ID;"
log_message "Service product '$PRODUCT_NAME' enabled successfully in the catalog."

# Final message indicating successful setup
log_message "Service product '$PRODUCT_NAME' has been set up successfully and is ready for sale!"
log_message "Visit the PrestaShop back office to verify the product details and combinations: http://your-prestashop-site/admin"
