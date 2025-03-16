#!/bin/bash

# Configuration Variables
PRESTASHOP_DIR="/var/www/html/prestashop"  # Path to your PrestaShop installation directory
MODULE_NAME="helloworld"                   # Module name
MODULE_DIR="$PRESTASHOP_DIR/modules/$MODULE_NAME" # Full path to module directory
MODULE_PHP="$MODULE_DIR/$MODULE_NAME.php"  # Main PHP file
MODULE_ICON="$MODULE_DIR/logo.png"         # Icon for the module (16x16 pixels)
MODULE_XML="$MODULE_DIR/config.xml"        # Config XML file

# Step 1: Create the Module Folder
echo "Creating module folder: $MODULE_DIR"
mkdir -p "$MODULE_DIR"

# Step 2: Create the Main PHP File
echo "Creating the main PHP file: $MODULE_PHP"

cat <<EOL > "$MODULE_PHP"
<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class HelloWorld extends Module
{
    public function __construct()
    {
        $this->name = '$MODULE_NAME';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->need_instance = 0;

        parent::__construct();

        $this->displayName = $this->l('Hello World');
        $this->description = $this->l('Displays Hello World on the site header.');
    }

    public function install()
    {
        return parent::install() && $this->registerHook('displayHeader');
    }

    public function hookDisplayHeader($params)
    {
        // Display "Hello World" in the header
        $this->context->controller->addCSS($this->_path.'views/css/helloworld.css', 'all');
        $this->context->smarty->assign('helloworld_message', 'Hello World');
        return $this->display(__FILE__, 'views/templates/hook/helloworld.tpl');
    }
}
EOL

echo "Main PHP file created successfully."

# Step 3: Create the Icon File (16x16 pixels)
echo "Creating a placeholder icon: $MODULE_ICON"
# Create a basic 16x16 pixel PNG icon (you can replace this with your own icon)
convert -size 16x16 xc:white -gravity center -draw "text 0,0 'HW'" "$MODULE_ICON"

echo "Icon file created successfully."

# Step 4: Create the config.xml File
echo "Creating config.xml file: $MODULE_XML"

cat <<EOL > "$MODULE_XML"
<?xml version="1.0" encoding="UTF-8" ?>
<module>
    <name>$MODULE_NAME</name>
    <displayName>Hello World</displayName>
    <description>Displays Hello World on the site header.</description>
    <version>1.0.0</version>
    <author>Your Name</author>
    <tab>front_office_features</tab>
    <active>1</active>
    <is_configurable>0</is_configurable>
    <need_instance>0</need_instance>
</module>
EOL

echo "Config.xml file created successfully."

# Step 5: Create the Template File
echo "Creating the template file for displaying 'Hello World'"

mkdir -p "$MODULE_DIR/views/templates/hook"
cat <<EOL > "$MODULE_DIR/views/templates/hook/helloworld.tpl"
<div style="text-align: center; font-size: 20px; color: #4CAF50;">
    <strong>{$helloworld_message}</strong>
</div>
EOL

echo "Template file created successfully."

# Step 6: Create the CSS File (Optional)
echo "Creating the CSS file to style the 'Hello World' message"

mkdir -p "$MODULE_DIR/views/css"
cat <<EOL > "$MODULE_DIR/views/css/helloworld.css"
div {
    margin-top: 20px;
    font-family: Arial, sans-serif;
    font-weight: bold;
    color: #333;
}
EOL

echo "CSS file created successfully."

# Final message
echo "Hello World module created successfully at $MODULE_DIR"
