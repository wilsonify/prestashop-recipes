<?php
// Define the module name and folder paths
$moduleName = 'youtube';
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

// 2. Create the Main Module PHP File (youtube.php)
$modulePhpContent = <<<'PHP'
<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class Youtube extends Module
{
    public function __construct()
    {
        $this->name = 'youtube';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->displayName = $this->l('YouTube Video Display');
        $this->description = $this->l('Display a YouTube video on your homepage.');

        parent::__construct();
    }

    public function install()
    {
        return parent::install() && $this->registerHook('displayHome');
    }

    public function uninstall()
    {
        Configuration::deleteByName('YOUTUBE_VIDEO_ID');
        return parent::uninstall();
    }

    public function getContent()
    {
        if (Tools::isSubmit('submit_youtube')) {
            $videoId = Tools::getValue('YOUTUBE_VIDEO_ID');
            Configuration::updateValue('YOUTUBE_VIDEO_ID', $videoId);
        }

        $videoId = Configuration::get('YOUTUBE_VIDEO_ID');
        $output = '<form method="post" action="' . $_SERVER['REQUEST_URI'] . '">';
        $output .= '<label for="YOUTUBE_VIDEO_ID">' . $this->l('YouTube Video ID') . ': </label>';
        $output .= '<input type="text" name="YOUTUBE_VIDEO_ID" value="' . $videoId . '" />';
        $output .= '<input type="submit" name="submit_youtube" value="' . $this->l('Save') . '" />';
        $output .= '</form>';

        return $output;
    }

    public function hookDisplayHome($params)
    {
        $videoId = Configuration::get('YOUTUBE_VIDEO_ID');

        if ($videoId) {
            return '<div class="youtube-video">
                        <iframe width="560" height="315" src="https://www.youtube.com/embed/' . $videoId . '" frameborder="0" allowfullscreen></iframe>
                    </div>';
        }

        return ''; // No video to display if the video ID is empty
    }
}
PHP;

file_put_contents($moduleDir . '/youtube.php', $modulePhpContent);
echo "Created youtube.php file in $moduleDir\n";

// 3. Create the Configuration XML File (config.xml)
$configXmlContent = <<<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<module>
    <name>youtube</name>
    <displayName><![CDATA[YouTube Video Display]]></displayName>
    <description><![CDATA[Display a YouTube video on your homepage.]]></description>
    <version>1.0.0</version>
    <author>Your Name</author>
    <tab>front_office_features</tab>
</module>
XML;

file_put_contents($moduleDir . '/config.xml', $configXmlContent);
echo "Created config.xml file in $moduleDir\n";

// 4. Create Template File (displayHome.tpl)
$templateContent = <<<'HTML'
<div class="youtube-video">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/{$videoId}" frameborder="0" allowfullscreen></iframe>
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
