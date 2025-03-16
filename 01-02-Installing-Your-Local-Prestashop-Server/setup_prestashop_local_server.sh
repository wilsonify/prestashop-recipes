#!/bin/bash

# Exit on any error
set -e

# Variables (ensure these are set via environment variables or modify directly)
PRESTASHOP_URL="https://download.prestashop.com/download/old/prestashop_1.7.8.6.zip"
PRESTASHOP_DIR="/var/www/html/prestashop"
MYSQL_DB_NAME="prestashop_db"
MYSQL_USER="prestashop_user"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-'prestashop_password'}"  # Use environment variable or fallback value
APACHE_USER="www-data"

# Step 1: Update and Install Required Packages
echo "Updating and installing required packages..."
sudo apt update -y
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysqli php-zip php-gd php-json php-curl unzip wget

# Check if Apache and MySQL are running
if ! systemctl is-active --quiet apache2; then
  echo "Apache2 is not running. Starting Apache2..."
  sudo systemctl start apache2
fi

if ! systemctl is-active --quiet mysql; then
  echo "MySQL is not running. Starting MySQL..."
  sudo systemctl start mysql
fi

# Step 2: Download PrestaShop
echo "Downloading PrestaShop..."
cd /tmp
wget "$PRESTASHOP_URL" -O prestashop.zip

# Step 3: Extract PrestaShop
echo "Extracting PrestaShop files..."
sudo mkdir -p "$PRESTASHOP_DIR"
sudo unzip -q prestashop.zip -d "$PRESTASHOP_DIR"

# Step 4: Set Permissions for PrestaShop Files
echo "Setting permissions for PrestaShop..."
sudo chown -R "$APACHE_USER:$APACHE_USER" "$PRESTASHOP_DIR"
sudo chmod -R 755 "$PRESTASHOP_DIR"

# Step 5: Set Up MySQL Database for PrestaShop
echo "Setting up MySQL database for PrestaShop..."
# Use root password securely via environment variable (e.g., MYSQL_ROOT_PASSWORD)
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  echo "Error: MYSQL_ROOT_PASSWORD is not set."
  exit 1
fi

sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME;"
sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DB_NAME.* TO '$MYSQL_USER'@'localhost';"
sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Step 6: Enable Apache Mod Rewrites for PrestaShop SEO
echo "Enabling mod_rewrite for Apache..."
sudo a2enmod rewrite
sudo systemctl restart apache2

# Step 7: Configure Apache for PrestaShop
echo "Configuring Apache for PrestaShop..."
sudo tee /etc/apache2/sites-available/prestashop.conf > /dev/null <<EOL
<VirtualHost *:80>
    DocumentRoot $PRESTASHOP_DIR
    ServerName localhost

    <Directory $PRESTASHOP_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Step 8: Enable the New Apache Configuration and Restart Apache
echo "Enabling Apache site configuration..."
sudo a2ensite prestashop.conf
sudo systemctl restart apache2

# Step 9: Clean up
echo "Cleaning up temporary files..."
rm -f /tmp/prestashop.zip

# Final Instructions
echo "PrestaShop local server setup is complete!"
echo "You can now access PrestaShop by navigating to http://localhost in your web browser."
echo "Go to phpMyAdmin at http://localhost/phpmyadmin to manage your database."
echo "Please complete the installation of PrestaShop by following the on-screen instructions in the browser."
