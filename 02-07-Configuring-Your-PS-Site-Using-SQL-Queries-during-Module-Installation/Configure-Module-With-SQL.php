<?php

// Define the module name and folder paths
$moduleName = 'yourmodule';
$moduleDir = __DIR__ . '/modules/' . $moduleName;

// Function to create directories with proper permissions and error handling
function createDirectories($directories)
{
    foreach ($directories as $dir) {
        if (!file_exists($dir)) {
            // Try to create directory with 0755 permissions
            if (!mkdir($dir, 0755, true)) {
                logError("Error: Could not create directory $dir");
                return false;
            }
            echo "Created directory: $dir\n";
        }
    }
    return true;
}

// Function to create files with content and error handling
function createFile($filePath, $content)
{
    if (file_exists($filePath)) {
        echo "Warning: $filePath already exists, skipping file creation.\n";
        return false;
    }

    if (file_put_contents($filePath, $content) === false) {
        logError("Error: Failed to create file $filePath");
        return false;
    }

    echo "Created file: $filePath\n";
    return true;
}

// Function to log errors to a log file for debugging purposes
function logError($message)
{
    file_put_contents(__DIR__ . '/error_log.txt', date('Y-m-d H:i:s') . ' - ' . $message . PHP_EOL, FILE_APPEND);
}

// 1. Create the Module Folder Structure
$directories = [
    $moduleDir,
    $moduleDir . '/views/templates/hook',
];

if (!createDirectories($directories)) {
    exit; // Exit script if folder creation fails
}

// 2. Create the Main Module PHP File (yourmodule.php)
$modulePhpContent = <<<'PHP'
<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class YourModule extends Module
{
    const INSTALL_SQL_FILE = 'install.sql';

    public function __construct()
    {
        $this->name = 'yourmodule';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->displayName = $this->l('Your Module');
        $this->description = $this->l('This module executes SQL queries during installation.');

        parent::__construct();
    }

    public function install()
    {
        if (!parent::install() || !$this->executeInstallSQL()) {
            return false;
        }
        return true;
    }

    private function executeInstallSQL()
    {
        $sqlFile = dirname(__FILE__) . '/' . self::INSTALL_SQL_FILE;
        if (file_exists($sqlFile)) {
            $sqlQueries = file_get_contents($sqlFile);
            $queries = explode(";\n", $sqlQueries); // Split by semicolon

            foreach ($queries as $query) {
                if (!empty($query)) {
                    // Replace PREFIX_ with actual database prefix
                    $query = str_replace('PREFIX_', _DB_PREFIX_, $query);
                    if (!Db::getInstance()->execute($query)) {
                        logError('SQL execution failed: ' . $query);
                        return false; // If any query fails, return false
                    }
                }
            }
        } else {
            logError('SQL file not found: ' . $sqlFile);
            return false;
        }

        return true;
    }

    public function uninstall()
    {
        if (!parent::uninstall()) {
            return false;
        }

        // Drop custom table (example of clean-up)
        $sql = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'my_custom_table`';
        if (!Db::getInstance()->execute($sql)) {
            logError('Failed to drop table during uninstallation: ' . $sql);
            return false;
        }

        return true;
    }
}
PHP;

if (!createFile($moduleDir . '/yourmodule.php', $modulePhpContent)) {
    exit;
}

// 3. Create the SQL File (install.sql)
$installSqlContent = <<<'SQL'
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
SQL;

if (!createFile($moduleDir . '/install.sql', $installSqlContent)) {
    exit;
}

// 4. Create Template File (displayHome.tpl) (optional)
$templateContent = <<<'HTML'
<div class="yourmodule-content">
    <h3>Your Custom Module</h3>
    <p>This is your custom module content.</p>
</div>
HTML;

if (!createFile($moduleDir . '/views/templates/hook/displayHome.tpl', $templateContent)) {
    exit;
}

// 5. Add a logo image (logo.png) for the module (optional)
$logoImagePath = $moduleDir . '/logo.png';
if (!file_exists($logoImagePath)) {
    $logoImage = imagecreatetruecolor(100, 100);
    $white = imagecolorallocate($logoImage, 255, 255, 255);
    imagefill($logoImage, 0, 0, $white);
    imagestring($logoImage, 5, 10, 40, 'YourModule', $black = imagecolorallocate($logoImage, 0, 0, 0));
    imagepng($logoImage, $logoImagePath);
    imagedestroy($logoImage);
    echo "Created placeholder logo.png file in $moduleDir\n";
} else {
    echo "Logo image already exists at $logoImagePath\n";
}

// 6. Output success message
echo "Module '$moduleName' has been successfully created and is ready for installation!\n";

