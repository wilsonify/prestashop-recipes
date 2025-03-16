#!/bin/bash

# Configuration Variables
PRESTASHOP_DIR="/var/www/html/prestashop"  # Path to your PrestaShop installation directory
MODULE_NAME="helloworld"                   # Module name
MODULE_DIR="$PRESTASHOP_DIR/modules/$MODULE_NAME" # Full path to module directory
MODULE_PHP="$MODULE_DIR/$MODULE_NAME.php"  # Main PHP file
MODULE_ICON="$MODULE_DIR/logo.png"         # Icon for the module (16x16 pixels)
MODULE_XML="$MODULE_DIR/config.xml"        # Config XML file
LOG_FILE="/var/log/prestashop_module_creation.log"  # Log file for tracking

# Function to log messages with timestamp
log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - $1" | tee -a $LOG_FILE
}

# Function to create a directory and handle errors
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1" && log_message "Created directory: $1"
    else
        log_message "Directory already exists: $1"
    fi
}

# Step 1: Create the Module Folder
log_message "Creating module folder: $MODULE_DIR"
create_dir "$MODULE_DIR"

# Step 2: Create the Main PHP File
log_message "Creating the main PHP file: $MODULE_PHP"

if [ ! -f "$MODULE_PHP" ]; then
    cat <<EOL > "$MODULE_PHP"
<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class HelloWorld extends Module
{
    public function __construct()
    {
        \$this->name = '$MODULE_NAME';
        \$this->tab = 'front_office_features';
        \$this->version = '1.0.0';
        \$this->author = 'Your Name';
        \$this->need_instance = 0;

        parent::__construct();

        \$this->displayName = \$this->l('Hello World');
        \$this->description = \$this->l('Displays Hello World on the site header.');
    }

    public function install()
    {
        return parent::install() && \$this->registerHook('displayHeader');
    }

    public function hookDisplayHeader(\$params)
    {
        // Display "Hello World" in the header
        \$this->context->controller->addCSS(\$this->_path.'views/css/helloworld.css', 'all');
        \$this->context->smarty->assign('helloworld_message', 'Hello World');
        return \$this->display(__FILE__, 'views/templates/hook/helloworld.tpl');
    }
}
EOL
    log_message "Main PHP file created successfully."
else
    log_message "Main PHP file already exists: $MODULE_PHP"
fi

# Step 3: Create the Icon File (16x16 pixels)
log_message "Creating a placeholder icon: $MODULE_ICON"
# Check if the icon file exists before creating it
if [ ! -f "$MODULE_ICON" ]; then
    convert -size 16x16 xc:white -gravity center -draw "text 0,0 'HW'" "$MODULE_ICON" && log_message "Icon file created successfully."
else
    log_message "Icon file already exists: $MODULE_ICON"
fi

# Step 4: Create the config.xml File
log_message "Creating config.xml file: $MODULE_XML"

if [ ! -f "$MODULE_XML" ]; then
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
    log_message "Config.xml file created successfully."
else
    log_message "Config.xml file already exists: $MODULE_XML"
fi

# Step 5: Create the Template File
log_message "Creating the template file for displaying 'Hello World'"

create_dir "$MODULE_DIR/views/templates/hook"
TEMPLATE_FILE="$MODULE_DIR/views/templates/hook/helloworld.tpl"
if [ ! -f "$TEMPLATE_FILE" ]; then
    cat <<EOL > "$TEMPLATE_FILE"
<div style="text-align: center; font-size: 20px; color: #4CAF50;">
    <strong>{$helloworld_message}</strong>
</div>
EOL
    log_message "Template file created successfully."
else
    log_message "Template file already exists: $TEMPLATE_FILE"
fi

# Step 6: Create the CSS File (Optional)
log_message "Creating the CSS file to style the 'Hello World' message"

create_dir "$MODULE_DIR/views/css"
CSS_FILE="$MODULE_DIR/views/css/helloworld.css"
if [ ! -f "$CSS_FILE" ]; then
    cat <<EOL > "$CSS_FILE"
div {
    margin-top: 20px;
    font-family: Arial, sans-serif;
    font-weight: bold;
    color: #333;
}
EOL
    log_message "CSS file created successfully."
else
    log_message "CSS file already exists: $CSS_FILE"
fi

# Final message
log_message "Hello World module created successfully at $MODULE_DIR"
