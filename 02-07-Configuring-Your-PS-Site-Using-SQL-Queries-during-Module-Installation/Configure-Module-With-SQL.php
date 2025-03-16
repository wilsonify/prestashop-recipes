<?php
// Define the module name and folder paths
$moduleName = 'yourmodule';
$moduleDir = __DIR__ . '/modules/' . $moduleName;

// 1. Create the Module Folder Structure
$directories = [
    $moduleDir,
    $moduleDir . '/views/templates/hook',
];

// Create directories
foreach ($directories as $dir) {
    if (!file_exists($dir)) {
        mkdir($dir, 0777, true);
        echo "Created directory: $dir\n";
    }
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
        // Call the parent install method
        if (!parent::install()) {
            return false;
        }

        // Execute SQL queries from install.sql
        $sqlFile = dirname(__FILE__) . '/' . self::INSTALL_SQL_FILE;
        if (file_exists($sqlFile)) {
            $sqlQueries = file_get_contents($sqlFile);
            $queries = explode(";\n", $sqlQueries); // Split by semicolon

            foreach ($queries as $query) {
                if (!empty($query)) {
                    // Replace PREFIX_ with actual database prefix
                    $query = str_replace('PREFIX_', _DB_PREFIX_, $query);
                    if (!Db::getInstance()->execute($query)) {
                        return false; // If any query fails, return false
                    }
                }
            }
        }

        return true;
    }

    public function uninstall()
    {
        // Clean up by dropping the custom table
        if (!parent::uninstall()) {
            return false;
        }

        // Drop custom table
        $sql = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'my_custom_table`';
        if (!Db::getInstance()->execute($sql)) {
            return false;
        }

        return true;
    }
}
PHP;

file_put_contents($moduleDir . '/yourmodule.php', $modulePhpContent);
echo "Created yourmodule.php file in $moduleDir\n";

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

file_put_contents($moduleDir . '/install.sql', $installSqlContent);
echo "Created install.sql file in $moduleDir\n";

// 4. Create the Template File (displayHome.tpl) (optional)
$templateContent = <<<'HTML'
<div class="yourmodule-content">
    <h3>Your Custom Module</h3>
    <p>This is your custom module content.</p>
</div>
HTML;

file_put_contents($moduleDir . '/views/templates/hook/displayHome.tpl', $templateContent);
echo "Created displayHome.tpl template file in $moduleDir/views/templates/hook\n";

// 5. Add a logo image (logo.png) for the module (optional)
$logoImagePath = $moduleDir . '/logo.png';
// Add a basic logo for the module (you can replace this with a custom logo)
imagepng(imagecreatetruecolor(100, 100), $logoImagePath);
echo "Created placeholder logo.png file in $moduleDir\n";

// 6. Output success message
echo "Module '$moduleName' has been successfully created and is ready for installation!\n";

