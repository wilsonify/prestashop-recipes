<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class CustomCss extends Module
{
    public function __construct()
    {
        $this->name = 'customcss';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->need_instance = 0;

        parent::__construct();

        $this->displayName = $this->l('Custom CSS Editor');
        $this->description = $this->l('Easily add custom CSS styles to your PrestaShop store without editing the .css files.');
    }

    public function install()
    {
        if (parent::install() && $this->registerHook('displayHeader')) {
            return true;
        }
        return false;
    }

    public function uninstall()
    {
        if (!parent::uninstall()) {
            return false;
        }
        // Clean up any configurations or custom data if needed
        Configuration::deleteByName('CUSTOM_CSS');
        return true;
    }

    public function getContent()
    {
        // If the form is submitted, save the custom CSS to the database
        if (Tools::isSubmit('submit_customcss')) {
            $customCss = Tools::getValue('custom_css');
            Configuration::updateValue('CUSTOM_CSS', $customCss);
            $this->_html .= '<div class="conf confirm">' . $this->l('Settings updated successfully.') . '</div>';
        }

        // Fetch existing custom CSS if any
        $customCss = Configuration::get('CUSTOM_CSS');
        $this->_html = '
        <form method="post">
            <label for="custom_css">' . $this->l('Custom CSS') . '</label>
            <textarea name="custom_css" id="custom_css" rows="10" style="width:100%;">' . htmlentities($customCss) . '</textarea>
            <br>
            <input type="submit" name="submit_customcss" value="' . $this->l('Save') . '" class="button" />
        </form>';

        return $this->_html;
    }

    public function hookDisplayHeader()
    {
        // Fetch the custom CSS from the configuration
        $customCss = Configuration::get('CUSTOM_CSS');

        // If custom CSS exists, inject it into the page's header
        if ($customCss) {
            $this->context->controller->addCSS($this->_path . 'views/css/custom.css');
            $this->context->controller->addJs($this->_path . 'views/js/custom.js');
            // Embed the custom CSS directly into the page
            $this->context->controller->addCSS('data:text/css,' . urlencode($customCss));
        }
    }
}
