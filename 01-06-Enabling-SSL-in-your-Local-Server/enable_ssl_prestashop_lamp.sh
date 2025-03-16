#!/bin/bash

# Define paths and variables
APACHE_CONF="/etc/apache2"
CERTS_DIR="/etc/ssl/certs"
KEYS_DIR="/etc/ssl/private"
PRESTASHOP_DIR="/var/www/html/prestashop"
APACHE_SSL_CONF="$APACHE_CONF/sites-available/default-ssl.conf"
APACHE_SITES_CONF="$APACHE_CONF/sites-available/000-default.conf"
LOG_FILE="/var/log/prestashop_ssl_setup.log"

# Database credentials (preferably set through environment variables for security)
DB_NAME="prestashop_db"
DB_USER="root"
DB_PASS="${DB_PASS:-'your_password'}"  # Fallback to environment variable

# Function to log messages with timestamp
log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - $1" | tee -a $LOG_FILE
}

# 1. Check if OpenSSL is installed
log_message "Checking if OpenSSL is installed..."

if ! command -v openssl &> /dev/null
then
    log_message "OpenSSL is not installed. Installing OpenSSL..."
    sudo apt update && sudo apt install openssl -y
    if [ $? -ne 0 ]; then
        log_message "Error installing OpenSSL. Exiting."
        exit 1
    fi
else
    log_message "OpenSSL is already installed."
fi

# 2. Generate SSL Certificate and Key
log_message "Generating SSL certificate..."

# Ensure private keys and certificate directories exist with proper permissions
sudo mkdir -p "$KEYS_DIR" "$CERTS_DIR"
sudo chmod 700 "$KEYS_DIR"

# Generate a private key
sudo openssl genrsa -out "$KEYS_DIR/server.key" 2048
if [ $? -ne 0 ]; then
    log_message "Error generating private key. Exiting."
    exit 1
fi

# Generate CSR (Certificate Signing Request)
sudo openssl req -new -key "$KEYS_DIR/server.key" -out "$CERTS_DIR/server.csr" -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=localhost"
if [ $? -ne 0 ]; then
    log_message "Error generating CSR. Exiting."
    exit 1
fi

# Self-sign the certificate (valid for 365 days)
sudo openssl x509 -req -days 365 -in "$CERTS_DIR/server.csr" -signkey "$KEYS_DIR/server.key" -out "$CERTS_DIR/server.crt"
if [ $? -ne 0 ]; then
    log_message "Error generating the certificate. Exiting."
    exit 1
fi

log_message "SSL certificate generated successfully."

# 3. Configure Apache to use SSL
log_message "Configuring Apache to use SSL..."

# Enable SSL module and default SSL site in Apache if not already enabled
if ! apache2ctl -M | grep -q "ssl_module"; then
    sudo a2enmod ssl
fi

if ! apache2ctl -S | grep -q "default-ssl.conf"; then
    sudo a2ensite default-ssl.conf
fi

# Configure SSL in the Apache SSL config file
sudo sed -i "s|#SSLCertificateFile.*|SSLCertificateFile $CERTS_DIR/server.crt|" "$APACHE_SSL_CONF"
sudo sed -i "s|#SSLCertificateKeyFile.*|SSLCertificateKeyFile $KEYS_DIR/server.key|" "$APACHE_SSL_CONF"

# Ensure Apache listens on port 443 (HTTPS)
if ! grep -q "Listen 443" "$APACHE_CONF/ports.conf"; then
    echo "Listen 443" | sudo tee -a "$APACHE_CONF/ports.conf" > /dev/null
fi

# 4. Restart Apache to apply SSL changes
log_message "Restarting Apache to apply SSL changes..."
sudo systemctl restart apache2
if [ $? -ne 0 ]; then
    log_message "Error restarting Apache. Exiting."
    exit 1
fi

# 5. Enable SSL in PrestaShop
log_message "Enabling SSL in PrestaShop..."

# Update PrestaShop database to enable SSL
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED';"
if [ $? -eq 0 ]; then
    log_message "SSL enabled in PrestaShop."
else
    log_message "Failed to enable SSL in PrestaShop. Exiting."
    exit 1
fi

# 6. Test the setup
log_message "Test your local PrestaShop site at https://localhost/prestashop"

# Final success message
log_message "SSL setup completed successfully."
