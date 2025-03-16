#!/bin/bash

# Exit on error
set -e

# Set variables
PRESTASHOP_VERSION="$PRESTASHOP_VERSION"
PRESTASHOP_URL="https://github.com/PrestaShop/PrestaShop/releases/download/$PRESTASHOP_VERSION/prestashop_$PRESTASHOP_VERSION.zip"
DOWNLOAD_DIR="/tmp/prestashop"
INSTALL_DIR="/var/www/html/prestashop"
DB_HOST="localhost"
DB_NAME="prestashop_db"
DB_USER="prestashop_user"
DB_PASSWORD="your_database_password"  # Consider using a more secure method, like environment variables
FTP_SERVER="ftp.example.com"
FTP_USER="ftp_user"
FTP_PASSWORD="ftp_password"

# Step 1: Check if PRESTASHOP_VERSION is set
if [ -z "$PRESTASHOP_VERSION" ]; then
    echo "Error: PRESTASHOP_VERSION is not set."
    exit 1
fi

# Step 2: Download PrestaShop
echo "Downloading PrestaShop package..."
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"
wget "$PRESTASHOP_URL" -O prestashop.zip

# Step 3: Extract PrestaShop
echo "Extracting PrestaShop..."
unzip -q prestashop.zip -d "$DOWNLOAD_DIR"

# Step 4: Upload files to the server (Ensure SSH and SCP work properly)
echo "Uploading files to the server..."
scp -r "$DOWNLOAD_DIR"/* user@server:"$INSTALL_DIR"

# Step 5: Securely handle MySQL commands (avoid prompting for password interactively)
echo "Creating MySQL database..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Step 6: Install PrestaShop
echo "PrestaShop installation is now ready!"
echo "Visit the installation page in your browser to complete the installation:"
echo "http://your-server-ip/prestashop/install"

# Step 7: Clean up
echo "Cleaning up temporary files..."
rm -rf "$DOWNLOAD_DIR"

echo "PrestaShop installation script completed successfully!"
