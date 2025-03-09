# Migrating Your PrestaShop Website

## Problem
You need to move your PrestaShop website from one hosting provider or server to another while ensuring minimal downtime and data integrity.

## Solution
Migrating a PrestaShop installation involves transferring both the database and the website files while updating configurations if necessary. This process ensures that your store functions correctly on the new server.

## How It Works
Follow these steps to successfully migrate your PrestaShop store:

### 1. Back Up Your Database
Use either the PrestaShop Back Office or phpMyAdmin to create a backup of your database:
- **PrestaShop Back Office:** Navigate to **Advanced Parameters → DB Backup** and generate a backup.
- **phpMyAdmin:** Open phpMyAdmin, select your database, click **Export**, and save the SQL file.

### 2. Create a New Database on the New Server
- Log in to your new hosting control panel or phpMyAdmin.
- Create a new database with the same name as the old one.
- Import the database backup using the **Import** option in phpMyAdmin.

### 3. Transfer Your PrestaShop Files
- Connect to your old server via FTP and download your entire PrestaShop folder.
- Upload the files to the new server using FTP.

### 4. Update Configuration Files
Edit the `app/config/parameters.php` file in your PrestaShop folder to reflect the new database details:
```php
'database_host' => 'new_server_host',
'database_name' => 'new_database_name',
'database_user' => 'new_database_user',
'database_password' => 'new_database_password'
```

### 5. Update the Shop URL (If Needed)
If your domain is changing, update the domain in the database:
- Open phpMyAdmin on the new server.
- Locate the `ps_configuration` table.
- Update the `PS_SHOP_DOMAIN` and `PS_SHOP_DOMAIN_SSL` values with the new domain.

### 6. Clear Cache and Test
- Delete the `/var/cache/prod` and `/var/cache/dev` directories.
- Verify the migration by visiting your website and testing functionality.

Following these steps will ensure a smooth migration of your PrestaShop store. 
