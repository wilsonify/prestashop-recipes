# Backing Up and Restoring Your PrestaShop Database

## Problem
You need to back up your PrestaShop database to prevent data loss, migrate your website, or create restore points before making significant changes. Additionally, you may need to restore your database from a backup in case of data corruption or accidental deletion.

## Solution
PrestaShop provides two primary methods for backing up your database:
1. Using the PrestaShop Back Office.
2. Using phpMyAdmin.

Restoring a backup can also be done through phpMyAdmin or command-line tools if necessary.

## How It Works
### Backing Up the Database
#### Method 1: Using the PrestaShop Back Office
1. **Log in to the Back Office** – Navigate to **Advanced Parameters → DB Backup**.
2. **Generate a Backup** – Click on "Add new backup" to create a new backup file.
3. **Download the Backup** – Once the process is complete, download the generated SQL file to a safe location.

#### Method 2: Using phpMyAdmin
If the Back Office is inaccessible, you can back up the database manually using phpMyAdmin:
1. **Access phpMyAdmin** – Open phpMyAdmin via your hosting control panel or local server (e.g., WAMP, XAMPP).
2. **Select Your Database** – Locate and open the PrestaShop database.
3. **Export the Database**:
   - Click on the **Export** tab.
   - Choose "Quick" export method.
   - Select **SQL** format and click "Go" to download the backup file.

### Restoring the Database
#### Using phpMyAdmin
1. **Access phpMyAdmin** – Log in and select the database you want to restore.
2. **Import the Backup**:
   - Click on the **Import** tab.
   - Click "Choose File" and select the backup SQL file.
   - Click "Go" to restore the database.

#### Using MySQL Command Line (Advanced Users)
1. Open a terminal or command prompt.
2. Run the following command to restore the database:
   ```sh
   mysql -u your_username -p your_database_name < backup_file.sql
   ```
3. Enter your MySQL password when prompted.

After restoring the database, clear PrestaShop’s cache by deleting the `/var/cache/prod` and `/var/cache/dev` directories.

By following these steps, you can efficiently back up and restore your PrestaShop database to ensure data integrity and security.

