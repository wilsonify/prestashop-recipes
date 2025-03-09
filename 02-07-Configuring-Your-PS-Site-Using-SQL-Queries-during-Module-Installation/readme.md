# Executing SQL Queries During Module Installation

## Problem Statement
You want to execute SQL queries during the installation process of your PrestaShop module. This is useful for tasks such as creating new tables, inserting default data, or modifying the database schema to support the module's functionality.

## Solution Overview
To execute SQL queries during the installation of your module, you can modify the `install()` method of your module. We'll use an SQL file (e.g., `install.sql`) that contains the SQL queries to be executed. A constant will be defined in your module to reference this SQL file, allowing you to easily manage and execute the queries.

In this guide, we will demonstrate how to integrate SQL queries into the installation process of your PrestaShop module.

## How It Works

### 1. Define the Constant for the SQL File
To begin, we'll create a constant in your module's main PHP file to refer to the SQL file that contains the queries to be executed. This allows you to centralize and easily manage the SQL queries.

In your module’s main PHP file, define the constant `INSTALL_SQL_FILE` as follows:

```php
const INSTALL_SQL_FILE = 'install.sql';
```
This constant will point to the SQL file that contains the queries we want to run during the installation process.

### 2. Prepare the SQL File

Next, you need to create the install.sql file. This file will contain the SQL queries that you want to execute during the module’s installation process.

Here’s an example of what the install.sql file might look like:

-- Create a custom table
CREATE TABLE IF NOT EXISTS `PREFIX_my_custom_table` (
    `id_my_custom_table` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    PRIMARY KEY (`id_my_custom_table`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert default data
INSERT INTO `PREFIX_my_custom_table` (`name`, `description`) VALUES
('Sample Data 1', 'This is the first sample data entry'),
('Sample Data 2', 'This is the second sample data entry');

In this example, we're creating a custom table my_custom_table and inserting some sample data into it. The PREFIX_ placeholder is used because PrestaShop automatically adds its table prefix during installation.

### 3. Modify the install() Method

Once the constant and SQL file are ready, we need to modify the install() method of your module to execute the SQL queries from the install.sql file.

Here’s how you can modify the install() method to load and execute the queries from the SQL file:

```public function install()
{
    // Call the parent install method to ensure the module installs correctly
    if (!parent::install()) {
        return false;
    }

    // Get the path to the SQL file
    $sqlFile = dirname(__FILE__) . '/' . self::INSTALL_SQL_FILE;

    // Check if the SQL file exists
    if (file_exists($sqlFile)) {
        // Read the content of the SQL file
        $sqlQueries = file_get_contents($sqlFile);

        // Execute the SQL queries
        $queries = explode(";\n", $sqlQueries); // Split the queries by semicolon
        foreach ($queries as $query) {
            if (!empty($query)) {
                // PrestaShop automatically adds the table prefix to queries
                $query = str_replace('PREFIX_', _DB_PREFIX_, $query);
                if (!Db::getInstance()->execute($query)) {
                    // If any query fails, return false
                    return false;
                }
            }
        }
    }

    return true;
}
```

### 4. Explanation of the Code:

    Parent Install Method: The parent::install() method is called first to ensure that the module is properly installed, including any PrestaShop default installation steps.
    SQL File Path: The path to the install.sql file is determined using dirname(__FILE__), ensuring that the SQL file is located in the module’s root directory.
    Execute SQL Queries: The contents of the SQL file are read using file_get_contents(). The queries are then split by the semicolon (;) and executed one by one using Db::getInstance()->execute().
    Prefix Replacement: The table prefix (_DB_PREFIX_) is automatically added to any table names in the SQL file. The str_replace() function ensures that PREFIX_ is replaced with the actual table prefix used in the PrestaShop installation.

### 5. Handling Errors

If any query fails, the install() method will return false, and the module installation process will be halted. This ensures that your module does not install incomplete or corrupted data.

### 6. Uninstalling the Module

If you want to clean up after uninstallation, you can implement the uninstall() method to remove the tables or data that were added during the installation process.

Example:

```php
public function uninstall()
{
    if (!parent::uninstall()) {
        return false;
    }

    // Clean up by dropping the custom table
    $sql = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'my_custom_table`';
    if (!Db::getInstance()->execute($sql)) {
        return false;
    }

    return true;
}
```

## Conclusion

By following these steps, you can easily execute SQL queries during the installation process of your PrestaShop module. Using an external SQL file keeps your module’s installation process clean and organized, especially when dealing with complex database operations like creating tables or inserting default data.

This approach is scalable, as you can easily add more queries to the install.sql file without modifying the core PHP logic. Moreover, it ensures that your module behaves predictably during installation and uninstallation.