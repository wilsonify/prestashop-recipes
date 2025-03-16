#!/bin/bash

# Define paths
APACHE_CONF="/etc/apache2"
CERTS_DIR="/etc/ssl/certs"
KEYS_DIR="/etc/ssl/private"
PRESTASHOP_DIR="/var/www/html/prestashop"
APACHE_SSL_CONF="$APACHE_CONF/sites-available/default-ssl.conf"
APACHE_SITES_CONF="$APACHE_CONF/sites-available/000-default.conf"

# 1. Check if OpenSSL is installed
echo "Checking if OpenSSL is installed..."

if ! command -v openssl &> /dev/null
then
    echo "OpenSSL is not installed. Installing OpenSSL..."
    sudo apt update
    sudo apt install openssl -y
else
    echo "OpenSSL is already installed."
fi

# 2. Generate SSL Certificate and Key
echo "Generating SSL certificate..."

# Generate a private key
sudo openssl genrsa -out "$KEYS_DIR/server.key" 2048
if [ $? -ne 0 ]; then
    echo "Error generating private key."
    exit 1
fi

# Generate CSR (Certificate Signing Request)
sudo openssl req -new -key "$KEYS_DIR/server.key" -out "$CERTS_DIR/server.csr" -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=localhost"
if [ $? -ne 0 ]; then
    echo "Error generating CSR."
    exit 1
fi

# Self-sign the certificate (valid for 365 days)
sudo openssl x509 -req -days 365 -in "$CERTS_DIR/server.csr" -signkey "$KEYS_DIR/server.key" -out "$CERTS_DIR/server.crt"
if [ $? -ne 0 ]; then
    echo "Error generating the certificate."
    exit 1
fi

echo "SSL certificate generated successfully."

# 3. Configure Apache to use SSL
echo "Configuring Apache to use SSL..."

# Enable SSL module and default SSL site in Apache
sudo a2enmod ssl
sudo a2ensite default-ssl.conf

# Configure SSL in the Apache SSL config file
sudo sed -i "s|#SSLCertificateFile.*|SSLCertificateFile $CERTS_DIR/server.crt|" "$APACHE_SSL_CONF"
sudo sed -i "s|#SSLCertificateKeyFile.*|SSLCertificateKeyFile $KEYS_DIR/server.key|" "$APACHE_SSL_CONF"

# Ensure Apache listens on port 443 (HTTPS)
if ! grep -q "Listen 443" "$APACHE_CONF/ports.conf"; then
    echo "Listen 443" | sudo tee -a "$APACHE_CONF/ports.conf" > /dev/null
fi

# 4. Restart Apache to apply SSL changes
echo "Restarting Apache to apply SSL changes..."
sudo systemctl restart apache2

# 5. Enable SSL in PrestaShop
echo "Enabling SSL in PrestaShop..."

# Update PrestaShop database to enable SSL
# You need to adjust this step according to your PrestaShop database setup
DB_NAME="prestashop_db" # Set your PrestaShop database name
DB_USER="root"           # Set your database username
DB_PASS="your_password"  # Set your database password

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED';"
if [ $? -eq 0 ]; then
    echo "SSL enabled in PrestaShop."
else
    echo "Failed to enable SSL in PrestaShop."
    exit 1
fi

# 6. Test the setup
echo "Test your local PrestaShop site at https://localhost/prestashop"
