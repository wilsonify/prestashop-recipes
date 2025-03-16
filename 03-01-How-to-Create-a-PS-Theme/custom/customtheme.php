<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class CustomTheme extends Module
{
    public function __construct()
    {
        $this->name = 'customtheme';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
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
        Configuration::deleteByName('CUSTOM_THEME_SETTINGS');
        return true;
    }

    public function getContent()
    {
        // Handle form submissions to update theme settings
        if (Tools::isSubmit('submit_customtheme')) {
            $customColors = Tools::getValue('custom_colors');
            $fontFamily = Tools::getValue('font_family');
            $logo = Tools::getValue('logo_image');

            // Save the custom theme settings to the database
            Configuration::updateValue('CUSTOM_THEME_SETTINGS', json_encode([
                'colors' => $customColors,
                'font' => $fontFamily,
                'logo' => $logo,
            ]));

            $this->_html .= '<div class="conf confirm">' . $this->l('Theme settings updated successfully.') . '</div>';
        }

        // Get current settings
        $themeSettings = json_decode(Configuration::get('CUSTOM_THEME_SETTINGS'), true);
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
            <input type="file" name="logo_image" />

            <br>
            <input type="submit" name="submit_customtheme" value="' . $this->l('Save Settings') . '" class="button" />
        </form>';

        return $this->_html;
    }

    public function hookDisplayHeader()
    {
        // Get the custom theme settings
        $themeSettings = json_decode(Configuration::get('CUSTOM_THEME_SETTINGS'), true);

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
                $this->context->controller->addCSS('data:text/css,' . urlencode($customCss));
            }

            // If a custom logo is uploaded, update it in the header
            if (!empty($themeSettings['logo'])) {
                $this->context->smarty->assign('logo_url', _PS_BASE_URL_ . '/img/' . $themeSettings['logo']);
            }
        }
    }
}
