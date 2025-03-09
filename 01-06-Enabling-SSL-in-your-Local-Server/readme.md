# Enabling SSL on Your Local PrestaShop Server

## Problem
You need to enable SSL (Secure Sockets Layer) on your local server to secure data transmission and test HTTPS functionality before deploying your PrestaShop store to a live environment.

## Solution
SSL ensures secure communication between the client and the server by encrypting data. To enable SSL on your local server, you must generate an SSL certificate and configure your web server to use HTTPS.

## How It Works
Follow these steps to enable SSL on a WAMP-based local server:

### 1. Install OpenSSL
Download and install **Win32 OpenSSL** from the official website: [https://slproweb.com/products/Win32OpenSSL.html](https://slproweb.com/products/Win32OpenSSL.html). Choose the "Light" version if you prefer a minimal installation.

### 2. Configure OpenSSL
- Open **System Properties** → **Advanced System Settings** → **Environment Variables**.
- Add a new **System Variable**:
  - **Variable Name:** `OPENSSL_CONF`
  - **Variable Value:** Path to `openssl.conf` (e.g., `C:\wamp\bin\apache\Apache2.4.41\conf\openssl.cnf`).

### 3. Generate an SSL Certificate
Open the Command Prompt and navigate to the OpenSSL bin directory:
```sh
cd C:\Program Files\OpenSSL-Win64\bin
```
Generate a private key:
```sh
openssl genrsa -out server.key 2048
```
Generate a Certificate Signing Request (CSR):
```sh
openssl req -new -key server.key -out server.csr
```
Self-sign the certificate (valid for one year):
```sh
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

### 4. Configure Apache to Use SSL
Edit the Apache configuration file (`httpd.conf`) to enable SSL:
- Locate and uncomment the following lines:
  ```apache
  LoadModule ssl_module modules/mod_ssl.so
  Include conf/extra/httpd-ssl.conf
  ```
- Open `httpd-ssl.conf` and set the certificate paths:
  ```apache
  SSLCertificateFile "C:/wamp/bin/apache/Apache2.4.41/conf/server.crt"
  SSLCertificateKeyFile "C:/wamp/bin/apache/Apache2.4.41/conf/server.key"
  ```
- Ensure Apache listens on port 443 by adding:
  ```apache
  Listen 443
  ```

### 5. Restart Apache
Restart the Apache service in WAMP to apply changes.

### 6. Enable SSL in PrestaShop
- Log in to PrestaShop Back Office.
- Navigate to **Shop Parameters → General**.
- Set **Enable SSL** to "Yes" and save changes.

Your local PrestaShop installation is now secured with SSL.
