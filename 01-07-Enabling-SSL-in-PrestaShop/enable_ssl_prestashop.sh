#!/bin/bash

# Define paths and variables
APACHE_CONF="/etc/apache2"
CERTS_DIR="/etc/ssl/certs"
KEYS_DIR="/etc/ssl/private"
PRESTASHOP_DIR="/var/www/html/prestashop"
APACHE_SSL_CONF="$APACHE_CONF/sites-available/default-ssl.conf"
DB_NAME="prestashop_db"           # Set your PrestaShop database name
DB_USER="root"                    # Set your database username
DB_PASS="${DB_PASS:-'your_password'}"  # Fallback to environment variable if set

# Log file to track script activity
LOG_FILE="/var/log/prestashop_ssl_setup.log"

# Function to log messages with timestamps
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

# 2. Generate SSL Certificate and Key (Self-Signed)
log_message "Generating SSL certificate and key..."

# Ensure private key and certificate directories exist with proper permissions
sudo mkdir -p "$KEYS_DIR" "$CERTS_DIR"
sudo chmod 700 "$KEYS_DIR"

# Generate private key if it doesn't exist
if [ ! -f "$KEYS_DIR/server.key" ]; then
    sudo openssl genrsa -out "$KEYS_DIR/server.key" 2048
    if [ $? -ne 0 ]; then
        log_message "Error generating private key. Exiting."
        exit 1
    fi
else
    log_message "Private key already exists at $KEYS_DIR/server.key."
fi

# Generate CSR (Certificate Signing Request) if it doesn't exist
if [ ! -f "$CERTS_DIR/server.csr" ]; then
    sudo openssl req -new -key "$KEYS_DIR/server.key" -out "$CERTS_DIR/server.csr" -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=localhost"
    if [ $? -ne 0 ]; then
        log_message "Error generating CSR. Exiting."
        exit 1
    fi
else
    log_message "CSR already exists at $CERTS_DIR/server.csr."
fi

# Self-sign the certificate if it doesn't exist (valid for 365 days)
if [ ! -f "$CERTS_DIR/server.crt" ]; then
    sudo openssl x509 -req -days 365 -in "$CERTS_DIR/server.csr" -signkey "$KEYS_DIR/server.key" -out "$CERTS_DIR/server.crt"
    if [ $? -ne 0 ]; then
        log_message "Error generating the certificate. Exiting."
        exit 1
    fi
else
    log_message "Certificate already exists at $CERTS_DIR/server.crt."
fi

log_message "SSL certificate and key generated successfully."

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

# Restart Apache to apply SSL changes
log_message "Restarting Apache to apply SSL changes..."
sudo systemctl restart apache2
if [ $? -ne 0 ]; then
    log_message "Error restarting Apache. Exiting."
    exit 1
fi

# 4. Enable SSL in PrestaShop Database
log_message "Enabling SSL in PrestaShop database..."

# Check if the database is accessible before running queries
if ! mysql -u "$DB_USER" -p"$DB_PASS" -e "SHOW DATABASES;" &>/dev/null; then
    log_message "Error connecting to the database. Exiting."
    exit 1
fi

# Enable SSL in PrestaShop
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED';"
if [ $? -ne 0 ]; then
    log_message "Failed to enable SSL in PrestaShop database. Exiting."
    exit 1
fi

# Enable Force SSL in PrestaShop
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "UPDATE ps_configuration SET value='1' WHERE name='PS_FORCE_SSL';"
if [ $? -ne 0 ]; then
    log_message "Failed to enable Force HTTPS in PrestaShop database. Exiting."
    exit 1
fi

log_message "SSL and Force HTTPS enabled in PrestaShop."

# 5. Test the Setup
log_message "Test your PrestaShop site at https://localhost/prestashop to ensure SSL is enabled."

log_message "SSL setup completed successfully."
