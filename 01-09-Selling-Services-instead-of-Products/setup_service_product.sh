#!/bin/bash

# Configuration Variables
PRESTASHOP_DIR="/var/www/html/prestashop"        # Path to your PrestaShop directory
DB_NAME="prestashop_db"                          # Set your PrestaShop database name
DB_USER="root"                                   # Set your MySQL database username
DB_PASS="your_password"                          # Set your MySQL database password
PRODUCT_NAME="Tour of Havana in an American Classic Car"  # Service product name
PRODUCT_REFERENCE="Havana_Tour_2025"             # Unique product reference
SERVICE_PRICE="60.00"                            # Base price for the service
SERVICE_COMBINATION_PRICE="15.00"                # Additional price for a specific combination (e.g., guided tour)
PRODUCT_DESCRIPTION="A guided tour in an American classic car, exploring the best of Havana."  # Service description

# Step 1: Create a new standard product (service) in the database
echo "Creating service product in PrestaShop..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "INSERT INTO ps_product (id_category_default, reference, price, active) VALUES (1, '$PRODUCT_REFERENCE', '$SERVICE_PRICE', 1);"

if [ $? -eq 0 ]; then
    echo "Service product '$PRODUCT_NAME' created successfully."
else
    echo "Failed to create the service product."
    exit 1
fi

# Step 2: Set product description
echo "Setting product description..."

PRODUCT_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -s -N -e "SELECT id_product FROM ps_product WHERE reference = '$PRODUCT_REFERENCE';")

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "INSERT INTO ps_product_lang (id_product, id_lang, description) VALUES ($PRODUCT_ID, 1, '$PRODUCT_DESCRIPTION');"

if [ $? -eq 0 ]; then
    echo "Product description set successfully."
else
    echo "Failed to set the product description."
    exit 1
fi

# Step 3: Disable shipping for the service (treat as non-physical product)
echo "Disabling shipping for the service product..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "INSERT INTO ps_product_carrier (id_product, id_carrier, id_reference, delivery_time) VALUES ($PRODUCT_ID, 1, 'service_shipping', '');"

if [ $? -eq 0 ]; then
    echo "Shipping disabled for service product."
else
    echo "Failed to disable shipping."
    exit 1
fi

# Step 4: Create combinations for the service (e.g., guided tour)
echo "Creating combinations for the service product..."

# Example combination: "Guided Tour" option with additional price
COMBINATION_NAME="Guided Tour"
COMBINATION_PRICE="$SERVICE_COMBINATION_PRICE"

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "INSERT INTO ps_product_attribute (id_product, reference, price) VALUES ($PRODUCT_ID, '${PRODUCT_REFERENCE}_Guided_Tour', $COMBINATION_PRICE);"

if [ $? -eq 0 ]; then
    echo "Combination 'Guided Tour' created successfully."
else
    echo "Failed to create combination."
    exit 1
fi

# Step 5: Modify product settings (make it a service)
echo "Customizing product settings for service..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_product SET weight=0, online_only=1 WHERE id_product=$PRODUCT_ID;"

if [ $? -eq 0 ]; then
    echo "Product customized successfully for service."
else
    echo "Failed to customize the product for service."
    exit 1
fi

# Step 6: Enable the product in the catalog
echo "Enabling service product in the catalog..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_product SET active=1 WHERE id_product=$PRODUCT_ID;"

if [ $? -eq 0 ]; then
    echo "Service product '$PRODUCT_NAME' enabled successfully in the catalog."
else
    echo "Failed to enable the product in the catalog."
    exit 1
fi

# Final output
echo "Service product '$PRODUCT_NAME' has been set up successfully and is ready for sale!"
echo "Visit the PrestaShop back office to verify the product details and combinations: http://your-prestashop-site/admin"
