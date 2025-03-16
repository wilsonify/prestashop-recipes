<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class Helloworld extends Module
{
    // Module constructor
    public function __construct()
    {
        $this->name = 'helloworld';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Your Name';

        // Add the text variable for storing the module text
        $this->text = Configuration::get('HELLOWORLD_TEXT'); // Retrieve text from the database

        parent::__construct();

        // Module description and configuration settings
        $this->displayName = $this->l('Hello World');
        $this->description = $this->l('A module to display custom text on the site.');
    }

    // Installation method to register the module and hook
    public function install()
    {
        return parent::install() && $this->registerHook('displayTop');
    }

    // Uninstallation method to clean up configuration settings
    public function uninstall()
    {
        Configuration::deleteByName('HELLOWORLD_TEXT');
        return parent::uninstall();
    }

    // Display method for the front-end (hook to display the custom text)
    public function hookDisplayTop($params)
    {
        return '<p>' . $this->text . '</p>'; // Display the custom text in the top section
    }

    // Configure method for the back-office settings page
    public function getContent()
    {
        // Check if the form is submitted to update the custom text
        if (Tools::isSubmit('submit_helloworld')) {
            $text = Tools::getValue('HELLOWORLD_TEXT');
            Configuration::updateValue('HELLOWORLD_TEXT', $text); // Save the new custom text in the database
        }

        // Create the configuration form
        $output = '<form method="post" action="' . $_SERVER['REQUEST_URI'] . '">';
        $output .= '<label for="HELLOWORLD_TEXT">' . $this->l('Custom Text: ') . '</label>';
        $output .= '<input type="text" name="HELLOWORLD_TEXT" value="' . $this->text . '" />';
        $output .= '<input type="submit" name="submit_helloworld" value="' . $this->l('Save') . '" />';
        $output .= '</form>';

        return $output; // Return the form HTML
    }
}

