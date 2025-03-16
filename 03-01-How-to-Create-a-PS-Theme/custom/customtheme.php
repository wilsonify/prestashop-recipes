<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class CustomTheme extends Module
{
    const CUSTOM_THEME_SETTINGS = 'CUSTOM_THEME_SETTINGS';

    public function __construct()
    {
        $this->name = 'customtheme';
        $this->tab = 'front_office_features';
        $this->version = '1.1.0'; // Updated version
        $this->author = 'Your Name';
        $this->need_instance = 0;

        parent::__construct();

        $this->displayName = $this->l('Custom Theme Builder');
        $this->description = $this->l('Easily customize your PrestaShop theme without editing core files.');
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
        Configuration::deleteByName(self::CUSTOM_THEME_SETTINGS);

        return true;
    }

    public function getContent()
    {
        // Handle form submissions to update theme settings
        if (Tools::isSubmit('submit_customtheme')) {
            $customColors = Tools::getValue('custom_colors');
            $fontFamily = Tools::getValue('font_family');
            $logoImage = $_FILES['logo_image'];

            // Validate logo upload
            $logoPath = $this->uploadLogo($logoImage);
            if ($logoPath === false) {
                $this->_html .= $this->displayError($this->l('Invalid logo file uploaded.'));
                return $this->_html;
            }

            // Save the custom theme settings to the database
            Configuration::updateValue(self::CUSTOM_THEME_SETTINGS, json_encode([
                'colors' => $customColors,
                'font' => $fontFamily,
                'logo' => $logoPath,
            ]));

            $this->_html .= $this->displayConfirmation($this->l('Theme settings updated successfully.'));
        }

        // Get current settings
        $themeSettings = json_decode(Configuration::get(self::CUSTOM_THEME_SETTINGS), true);
        $customColors = isset($themeSettings['colors']) ? $themeSettings['colors'] : '';
        $fontFamily = isset($themeSettings['font']) ? $themeSettings['font'] : '';
        $logo = isset($themeSettings['logo']) ? $themeSettings['logo'] : '';

        $this->_html = '
        <form method="post" enctype="multipart/form-data">
            <label for="custom_colors">' . $this->l('Custom Colors (Hex Values)') . '</label>
            <input type="text" name="custom_colors" value="' . htmlentities($customColors) . '" />

            <label for="font_family">' . $this->l('Font Family') . '</label>
            <input type="text" name="font_family" value="' . htmlentities($fontFamily) . '" />

            <label for="logo_image">' . $this->l('Upload Logo') . '</label>
            <input type="file" name="logo_image" accept="image/*" />

            <br>
            <input type="submit" name="submit_customtheme" value="' . $this->l('Save Settings') . '" class="button" />
        </form>';

        return $this->_html;
    }

    public function hookDisplayHeader()
    {
        // Get the custom theme settings
        $themeSettings = json_decode(Configuration::get(self::CUSTOM_THEME_SETTINGS), true);

        // If custom theme settings exist, inject them into the page header
        if ($themeSettings) {
            // Apply custom CSS
            $customCss = '';
            if (!empty($themeSettings['colors'])) {
                $customCss .= "body { background-color: {$themeSettings['colors']}; }\n";
            }
            if (!empty($themeSettings['font'])) {
                $customCss .= "body { font-family: {$themeSettings['font']}; }\n";
            }

            if ($customCss) {
                // Use an external CSS file for better caching instead of inline CSS
                $this->injectCustomCss($customCss);
            }

            // If a custom logo is uploaded, update it in the header
            if (!empty($themeSettings['logo'])) {
                $this->context->smarty->assign('logo_url', _PS_BASE_URL_ . '/img/' . $themeSettings['logo']);
            }
        }
    }

    /**
     * Handles the logo upload and returns the file path or false if invalid.
     *
     * @param array $file
     * @return string|false
     */
    private function uploadLogo($file)
    {
        // Check if file is provided and it's a valid image
        if ($file['error'] == 0) {
            $allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
            if (in_array($file['type'], $allowedTypes)) {
                $uploadDir = _PS_IMG_DIR_ . 'custom/';
                if (!file_exists($uploadDir)) {
                    mkdir($uploadDir, 0777, true);
                }

                // Generate a unique file name to prevent conflicts
                $fileName = uniqid('logo_', true) . '.' . pathinfo($file['name'], PATHINFO_EXTENSION);
                $filePath = $uploadDir . $fileName;

                if (move_uploaded_file($file['tmp_name'], $filePath)) {
                    return 'custom/' . $fileName; // Return relative path
                }
            }
        }

        return false; // Return false if the file is not valid
    }

    /**
     * Inject custom CSS into a file to be included in the page header
     *
     * @param string $css
     */
    private function injectCustomCss($css)
    {
        $cssFile = _PS_MODULE_DIR_ . $this->name . '/views/css/custom_theme.css';

        // If the CSS file doesn't exist or the contents are different, rewrite the file
        if (!file_exists($cssFile) || md5($css) !== md5(file_get_contents($cssFile))) {
            file_put_contents($cssFile, $css);
        }

        // Add the CSS file to the header
        $this->context->controller->addCSS($this->_path . 'views/css/custom_theme.css');
    }
}
