#!/bin/bash

# Configuration Variables
PRESTASHOP_DIR="/var/www/html/prestashop"  # Path to your PrestaShop directory
DB_NAME="prestashop_db"                    # Set your PrestaShop database name
DB_USER="root"                             # Set your MySQL database username
DB_PASS="your_password"                    # Set your MySQL database password
CARRIER_NAME="Free Shipping"               # Name for the free shipping carrier
CARRIER_REFERENCE="free_shipping"         # Carrier reference for Free Shipping

# Step 1: Create Free Shipping Carrier
echo "Creating 'Free Shipping' carrier in the database..."

# Create the carrier
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "INSERT INTO ps_carrier (id_reference, name, active, deleted, shipping_handling, shipping_method, is_free)
VALUES ('$CARRIER_REFERENCE', '$CARRIER_NAME', 1, 0, 1, 1, 1);"

if [ $? -eq 0 ]; then
    echo "Free Shipping carrier created successfully."
else
    echo "Failed to create Free Shipping carrier."
    exit 1
fi

# Get the newly created carrier ID
CARRIER_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -s -N -e "SELECT id_carrier FROM ps_carrier WHERE reference = '$CARRIER_REFERENCE';")

if [ -z "$CARRIER_ID" ]; then
    echo "Error: Could not retrieve the Carrier ID for Free Shipping."
    exit 1
fi

# Step 2: Assign Free Shipping Carrier to Products
echo "Assigning Free Shipping carrier to products that don't require shipping..."

# Get all products that should not require shipping (e.g., non-physical products, digital products, services)
# This query assumes you mark products that don't require shipping in the ps_product table.
# Here, we assume products with weight=0 are treated as non-shippable.
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "
UPDATE ps_product
SET id_carrier = $CARRIER_ID
WHERE weight = 0 AND active = 1;"

if [ $? -eq 0 ]; then
    echo "Assigned Free Shipping carrier to all non-shippable products successfully."
else
    echo "Failed to assign Free Shipping carrier."
    exit 1
fi

# Step 3: Verify the changes
echo "Verifying the Free Shipping carrier assignment..."

# Verify if the carrier assignment is correct
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "
SELECT p.id_product, p.reference, c.name AS carrier_name
FROM ps_product p
JOIN ps_carrier c ON p.id_carrier = c.id_carrier
WHERE c.id_carrier = $CARRIER_ID;"

if [ $? -eq 0 ]; then
    echo "Carrier assignment verification successful."
else
    echo "Carrier assignment verification failed."
    exit 1
fi

# Final output
echo "Shipping for non-shippable products has been successfully disabled."
