#!/bin/bash

# Set variables
PRESTASHOP_VERSION="$PRESTASHOP_VERSION"
PRESTASHOP_URL="https://github.com/PrestaShop/PrestaShop/releases/download/$PRESTASHOP_VERSION/prestashop_$PRESTASHOP_VERSION.zip"
DOWNLOAD_DIR="/tmp/prestashop"
INSTALL_DIR="/var/www/html/prestashop"
DB_HOST="localhost"
DB_NAME="prestashop_db"
DB_USER="prestashop_user"
DB_PASSWORD="your_database_password"
FTP_SERVER="ftp.example.com"
FTP_USER="ftp_user"
FTP_PASSWORD="ftp_password"

# Step 1: Download PrestaShop
echo "Downloading PrestaShop package..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
wget $PRESTASHOP_URL

# Step 2: Extract PrestaShop
echo "Extracting PrestaShop..."
unzip prestashop_*.zip -d $DOWNLOAD_DIR

# Step 3: Upload files to the server
echo "Uploading files to the server..."
scp -r $DOWNLOAD_DIR/* user@server:$INSTALL_DIR

# Step 4: Create MySQL database
echo "Creating MySQL database..."
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u root -p -e "CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

# Step 5: Run the PrestaShop installation script
echo "Running the PrestaShop installation..."
# You can also run the installation via the browser by visiting the server IP or domain name:
# http://your-server-ip/prestashop/install
# This requires the user to manually complete the installation process in the browser.

# Step 6: Clean up
echo "Cleaning up temporary files..."
rm -rf $DOWNLOAD_DIR

echo "PrestaShop installation script completed!"
