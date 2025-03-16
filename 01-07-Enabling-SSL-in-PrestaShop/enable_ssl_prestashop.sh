#!/bin/bash

# Define paths and variables
APACHE_CONF="/etc/apache2"
CERTS_DIR="/etc/ssl/certs"
KEYS_DIR="/etc/ssl/private"
PRESTASHOP_DIR="/var/www/html/prestashop"
APACHE_SSL_CONF="$APACHE_CONF/sites-available/default-ssl.conf"
APACHE_SITES_CONF="$APACHE_CONF/sites-available/000-default.conf"
DB_NAME="prestashop_db"           # Set your PrestaShop database name
DB_USER="root"                    # Set your database username
DB_PASS="your_password"           # Set your database password

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

# 2. Generate SSL Certificate and Key (Self-Signed)
echo "Generating SSL certificate and key..."

# Generate a private key if it doesn't exist
if [ ! -f "$KEYS_DIR/server.key" ]; then
    sudo openssl genrsa -out "$KEYS_DIR/server.key" 2048
    if [ $? -ne 0 ]; then
        echo "Error generating private key."
        exit 1
    fi
else
    echo "Private key already exists at $KEYS_DIR/server.key."
fi

# Generate a CSR (Certificate Signing Request)
if [ ! -f "$CERTS_DIR/server.csr" ]; then
    sudo openssl req -new -key "$KEYS_DIR/server.key" -out "$CERTS_DIR/server.csr" -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=localhost"
    if [ $? -ne 0 ]; then
        echo "Error generating CSR."
        exit 1
    fi
else
    echo "CSR already exists at $CERTS_DIR/server.csr."
fi

# Self-sign the certificate (valid for 365 days)
if [ ! -f "$CERTS_DIR/server.crt" ]; then
    sudo openssl x509 -req -days 365 -in "$CERTS_DIR/server.csr" -signkey "$KEYS_DIR/server.key" -out "$CERTS_DIR/server.crt"
    if [ $? -ne 0 ]; then
        echo "Error generating the certificate."
        exit 1
    fi
else
    echo "Certificate already exists at $CERTS_DIR/server.crt."
fi

echo "SSL certificate and key generated successfully."

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

# Restart Apache to apply SSL changes
echo "Restarting Apache to apply SSL changes..."
sudo systemctl restart apache2

# 4. Enable SSL in PrestaShop Database
echo "Enabling SSL in PrestaShop database..."

# Enable SSL in the PrestaShop database by setting PS_SSL_ENABLED to 1
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED';"
if [ $? -eq 0 ]; then
    echo "SSL enabled in PrestaShop database."
else
    echo "Failed to enable SSL in PrestaShop database."
    exit 1
fi

# Enable "Force HTTPS on all pages" by setting the appropriate value in the database
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED';"
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='1' WHERE name='PS_FORCE_SSL';"
if [ $? -eq 0 ]; then
    echo "Force HTTPS enabled in PrestaShop database."
else
    echo "Failed to enable Force HTTPS in PrestaShop database."
    exit 1
fi

# 5. Test the Setup
echo "Test your PrestaShop site at https://localhost/prestashop to ensure SSL is enabled."
