#!/bin/bash

# Define paths (adjust these paths to fit your setup)
WAMP_PATH="C:/wamp"
APACHE_PATH="$WAMP_PATH/bin/apache/Apache2.4.41"
OPENSSL_PATH="C:/Program Files/OpenSSL-Win64/bin"
APACHE_CONF="$APACHE_PATH/conf"
APACHE_SSL_CONF="$APACHE_PATH/conf/extra/httpd-ssl.conf"
CERTS_DIR="$APACHE_PATH/conf"
CERT_KEY="$CERTS_DIR/server.key"
CERT_CSR="$CERTS_DIR/server.csr"
CERT_CRT="$CERTS_DIR/server.crt"

# 1. Check if OpenSSL is installed
echo "Checking if OpenSSL is installed..."

if ! command -v openssl &> /dev/null
then
    echo "OpenSSL is not installed. Please install OpenSSL from https://slproweb.com/products/Win32OpenSSL.html"
    exit 1
else
    echo "OpenSSL is already installed."
fi

# 2. Configure OpenSSL
echo "Configuring OpenSSL..."
if [ ! -f "$APACHE_CONF/openssl.cnf" ]; then
    echo "OpenSSL configuration file not found. Please ensure OpenSSL is properly installed."
    exit 1
fi

# Set the OPENSSL_CONF environment variable
export OPENSSL_CONF="$APACHE_CONF/openssl.cnf"

# 3. Generate SSL Certificate
echo "Generating SSL certificate..."

cd "$OPENSSL_PATH"

# Generate a private key
openssl genrsa -out "$CERT_KEY" 2048
if [ $? -ne 0 ]; then
    echo "Error generating private key."
    exit 1
fi

# Generate CSR
openssl req -new -key "$CERT_KEY" -out "$CERT_CSR"
if [ $? -ne 0 ]; then
    echo "Error generating CSR."
    exit 1
fi

# Self-sign the certificate
openssl x509 -req -days 365 -in "$CERT_CSR" -signkey "$CERT_KEY" -out "$CERT_CRT"
if [ $? -ne 0 ]; then
    echo "Error generating the certificate."
    exit 1
fi

echo "SSL certificate generated successfully."

# 4. Configure Apache to use SSL
echo "Configuring Apache to use SSL..."

# Enable SSL module in Apache
sed -i "s/#LoadModule ssl_module modules\/mod_ssl.so/LoadModule ssl_module modules\/mod_ssl.so/" "$APACHE_CONF/httpd.conf"

# Include SSL configuration in Apache
sed -i "s/#Include conf\/extra\/httpd-ssl.conf/Include conf\/extra\/httpd-ssl.conf/" "$APACHE_CONF/httpd.conf"

# Set certificate paths in Apache SSL configuration
echo "Setting SSL certificate paths in Apache SSL configuration..."
sed -i "s|SSLCertificateFile .*|SSLCertificateFile \"$CERTS_DIR/server.crt\"|" "$APACHE_SSL_CONF"
sed -i "s|SSLCertificateKeyFile .*|SSLCertificateKeyFile \"$CERTS_DIR/server.key\"|" "$APACHE_SSL_CONF"

# Ensure Apache listens on port 443
if ! grep -q "Listen 443" "$APACHE_CONF/httpd.conf"; then
    echo "Listen 443" >> "$APACHE_CONF/httpd.conf"
fi

# 5. Restart Apache to apply changes
echo "Restarting Apache to apply SSL changes..."
cd "$WAMP_PATH"
wampmanager.exe -restart

if [ $? -eq 0 ]; then
    echo "Apache restarted successfully with SSL enabled."
else
    echo "Error restarting Apache."
    exit 1
fi

# 6. Enable SSL in PrestaShop
echo "Enabling SSL in PrestaShop..."

# Update PrestaShop database to enable SSL
php -r "require 'C:/wamp/www/prestashop/config/config.inc.php';" -e "Configuration::updateValue('PS_SSL_ENABLED', 1);"

echo "SSL enabled in PrestaShop."

# 7. Test the setup
echo "Test your local PrestaShop site at https://localhost/prestashop"
