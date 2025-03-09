# Enabling SSL in Your PrestaShop Website

## Problem
You want to enable SSL (Secure Sockets Layer) on your PrestaShop website to secure data transmission, protect customer information, and improve trust and security.

## Solution
SSL ensures secure communication by encrypting data between the client and the server. To enable SSL in PrestaShop, your server must support HTTPS, and you must activate SSL within the PrestaShop Back Office settings.

## How It Works

### 1. Ensure Your Hosting Supports SSL
Before enabling SSL, confirm that your hosting provider supports HTTPS and has an SSL certificate installed. If your site does not have an SSL certificate, obtain one from a trusted Certificate Authority (CA) or use a free option like Let's Encrypt.

### 2. Activate SSL in PrestaShop
Follow these steps to enable SSL in PrestaShop:

1. Log in to the **PrestaShop Back Office**.
2. Navigate to **Shop Parameters → General**.
3. Find the option **Enable SSL** and click **"Yes"**.
4. Click **"Save"** to apply the changes.

### 3. Handle SSL Warnings (If Using a Self-Signed Certificate)
If you are using a self-signed SSL certificate (such as one generated for local development), browsers may display a security warning when accessing your website. This warning occurs because self-signed certificates are not trusted by default.

To bypass the warning:
- In **Chrome**, click **Advanced → Proceed to [your site] (unsafe)**.
- In **Firefox**, add an exception by clicking **Advanced → Accept the Risk and Continue**.
- In **Edge**, click **Advanced → Continue to [your site] (unsafe)**.

For a production website, always use a trusted SSL certificate to avoid these warnings.

### 4. Verify HTTPS is Working Correctly
After enabling SSL, check if your store is correctly using HTTPS by:
- Visiting your website and ensuring the URL starts with **https://**.
- Looking for a padlock icon in the browser’s address bar.
- Using online SSL validation tools such as [SSL Labs SSL Test](https://www.ssllabs.com/ssltest/).

### 5. Force HTTPS for All Traffic (Optional)
To ensure all visitors use HTTPS, enable the **"Force HTTPS on all pages"** option in **Shop Parameters → General**. This will automatically redirect HTTP traffic to HTTPS, improving security.

By following these steps, your PrestaShop website will be secured with SSL, protecting customer data and enhancing trust. 

