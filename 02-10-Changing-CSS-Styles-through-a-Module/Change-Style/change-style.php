<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class CustomCss extends Module
{
    const CUSTOM_CSS = 'CUSTOM_CSS';

    public function __construct()
    {
        $this->name = 'customcss';
        $this->tab = 'front_office_features';
        $this->version = '1.1.0'; // Updated version
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
        Configuration::deleteByName(self::CUSTOM_CSS);

        return true;
    }

    public function getContent()
    {
        // Display the settings form to the admin
        if (Tools::isSubmit('submit_customcss')) {
            // Get the custom CSS from the form
            $customCss = Tools::getValue('custom_css');
            // Sanitize input to remove unwanted characters and prevent injection attacks
            $customCss = $this->sanitizeCss($customCss);

            // If valid, save to configuration
            if ($this->validateCss($customCss)) {
                Configuration::updateValue(self::CUSTOM_CSS, $customCss);
                $this->_html .= $this->displayConfirmation($this->l('Settings updated successfully.'));
            } else {
                $this->_html .= $this->displayError($this->l('Invalid CSS code.'));
            }
        }

        // Fetch the saved CSS from the configuration
        $customCss = Configuration::get(self::CUSTOM_CSS);

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
        // Retrieve the custom CSS from the configuration
        $customCss = Configuration::get(self::CUSTOM_CSS);

        if ($customCss) {
            // Save the custom CSS to a file or inject it into the header
            $this->injectCssIntoHeader($customCss);
        }
    }

    /**
     * Sanitize the CSS code to remove any dangerous characters
     *
     * @param string $css
     * @return string
     */
    private function sanitizeCss($css)
    {
        // Replace line breaks and whitespace with valid characters
        return preg_replace('/\s+/', ' ', $css);
    }

    /**
     * Validate the custom CSS (e.g., basic checks)
     *
     * @param string $css
     * @return bool
     */
    private function validateCss($css)
    {
        // A very basic CSS validation could check for common CSS rules and declarations
        return preg_match('/^[a-zA-Z0-9\s{}:;,.#-]*$/', $css); // Only allows basic CSS characters
    }

    /**
     * Inject the custom CSS into the page header
     *
     * @param string $css
     */
    private function injectCssIntoHeader($css)
    {
        // Create a temporary CSS file and include it in the header (for better security and performance)
        $cssFile = _PS_MODULE_DIR_ . $this->name . '/views/css/custom.css';

        // If the custom CSS file doesn't exist or is outdated, create it
        if (!file_exists($cssFile) || md5($css) !== md5(file_get_contents($cssFile))) {
            file_put_contents($cssFile, $css);
        }

        // Add the CSS file to the page
        $this->context->controller->addCSS($this->_path . 'views/css/custom.css');
    }
}
