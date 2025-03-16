#!/bin/bash

# Configuration Variables
PRESTASHOP_DIR="/var/www/html/prestashop"  # Path to your PrestaShop directory
DB_NAME="prestashop_db"                    # Set your PrestaShop database name
DB_USER="root"                             # Set your MySQL database username
DB_PASS="${DB_PASS:-'your_password'}"      # Fallback to environment variable if set
CARRIER_NAME="Free Shipping"               # Name for the free shipping carrier
CARRIER_REFERENCE="free_shipping"         # Carrier reference for Free Shipping
LOG_FILE="/var/log/prestashop_carrier_creation.log"  # Log file location

# Function to log messages with timestamp
log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - $1" | tee -a $LOG_FILE
}

# Function to execute MySQL queries
execute_mysql() {
    local query="$1"
    mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$query"
    if [ $? -ne 0 ]; then
        log_message "MySQL Error: $query"
        exit 1
    fi
}

# Step 1: Create Free Shipping Carrier
log_message "Creating 'Free Shipping' carrier in the database..."

# Create the carrier
execute_mysql "INSERT INTO ps_carrier (id_reference, name, active, deleted, shipping_handling, shipping_method, is_free)
VALUES ('$CARRIER_REFERENCE', '$CARRIER_NAME', 1, 0, 1, 1, 1);"

# Get the newly created carrier ID
CARRIER_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -s -N -e "SELECT id_carrier FROM ps_carrier WHERE reference = '$CARRIER_REFERENCE';")
if [ -z "$CARRIER_ID" ]; then
    log_message "Error: Could not retrieve the Carrier ID for Free Shipping."
    exit 1
fi
log_message "Free Shipping carrier created successfully. Carrier ID: $CARRIER_ID."

# Step 2: Assign Free Shipping Carrier to Products
log_message "Assigning Free Shipping carrier to products that don't require shipping..."

# Get all products that should not require shipping (e.g., non-physical products, digital products, services)
# This query assumes you mark products that don't require shipping in the ps_product table.
# Here, we assume products with weight=0 are treated as non-shippable.
execute_mysql "UPDATE ps_product
SET id_carrier = $CARRIER_ID
WHERE weight = 0 AND active = 1;"

log_message "Assigned Free Shipping carrier to all non-shippable products successfully."

# Step 3: Verify the changes
log_message "Verifying the Free Shipping carrier assignment..."

# Verify if the carrier assignment is correct
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "
SELECT p.id_product, p.reference, c.name AS carrier_name
FROM ps_product p
JOIN ps_carrier c ON p.id_carrier = c.id_carrier
WHERE c.id_carrier = $CARRIER_ID;" | tee -a $LOG_FILE

log_message "Carrier assignment verification successful."

# Final output
log_message "Shipping for non-shippable products has been successfully updated to Free Shipping."
log_message "Process complete."
