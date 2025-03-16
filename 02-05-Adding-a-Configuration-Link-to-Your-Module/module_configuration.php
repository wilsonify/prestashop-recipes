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
        $this->version = '1.1.0';
        $this->author = 'Your Name';
        $this->need_instance = 0;

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
        if (parent::install() && $this->registerHook('displayTop')) {
            // Set a default value for HELLOWORLD_TEXT if it's not already in the database
            if (!Configuration::get('HELLOWORLD_TEXT')) {
                Configuration::updateValue('HELLOWORLD_TEXT', 'Hello, World!');
            }
            return true;
        }

        return false;
    }

    // Uninstallation method to clean up configuration settings
    public function uninstall()
    {
        // Clean up configuration settings
        Configuration::deleteByName('HELLOWORLD_TEXT');
        return parent::uninstall();
    }

    // Display method for the front-end (hook to display the custom text)
    public function hookDisplayTop($params)
    {
        return '<p>' . Tools::safeOutput($this->text) . '</p>'; // Display the custom text in the top section
    }

    // Configuration form method for the back-office settings page
    public function getContent()
    {
        $output = '';

        // Handle form submission and validate input
        if (Tools::isSubmit('submit_helloworld')) {
            $text = Tools::getValue('HELLOWORLD_TEXT');
            // Validate input to prevent XSS or invalid data
            if (!Validate::isString($text) || strlen($text) > 255) {
                $output .= $this->displayError($this->l('Invalid text. Please make sure it is a valid string and not too long.'));
            } else {
                Configuration::updateValue('HELLOWORLD_TEXT', $text);
                $output .= $this->displayConfirmation($this->l('Settings updated successfully.'));
            }
        }

        // Create the configuration form
        $helper = new HelperForm();
        $helper->show_toolbar = false;
        $helper->identifier = $this->name;
        $helper->submit_action = 'submit_helloworld';
        $helper->fields_value['HELLOWORLD_TEXT'] = Tools::getValue('HELLOWORLD_TEXT', $this->text);

        $helper->tpl_vars = array(
            'fields_value' => $helper->fields_value,
            'currentIndex' => AdminController::$currentIndex,
            'token' => Tools::getAdminTokenLite('AdminModules'),
        );

        $output .= $helper->generateForm(array(
            array(
                'form' => array(
                    'legend' => array(
                        'title' => $this->l('Configuration'),
                        'icon' => 'icon-cogs'
                    ),
                    'input' => array(
                        array(
                            'type' => 'text',
                            'label' => $this->l('Custom Text:'),
                            'name' => 'HELLOWORLD_TEXT',
                            'size' => 40,
                            'required' => true,
                        ),
                    ),
                    'submit' => array(
                        'title' => $this->l('Save'),
                        'class' => 'btn btn-default pull-right'
                    )
                )
            )
        ));

        return $output;
    }
}
