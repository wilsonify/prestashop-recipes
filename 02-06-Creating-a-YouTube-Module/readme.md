# Creating a YouTube Video Display Module for PrestaShop

## Problem Statement
You want to create a PrestaShop module that allows you to display YouTube videos on your homepage and provides the option to define which video is displayed.

## Solution Overview
For many businesses, YouTube is an excellent platform to showcase videos related to services, products, tutorials, or promotions. Integrating YouTube videos on your website can significantly boost engagement and interest in your offerings. In this guide, we’ll walk through creating a PrestaShop module that allows you to display a YouTube video on your homepage and customize which video is shown.

We'll leverage the skills acquired in previous modules, such as module creation, adding a configuration link, and using hooks.

## How It Works

### 1. Set Up the Module Folder
To simplify the development process, we will start by duplicating the **HelloWorld** module that we created in a previous recipe. By copying the folder and renaming it to **youtube**, we can transform it into the new module with minimal effort.

Here’s how the directory structure will look:

/modules /youtube - youtube.php - logo.png - config.xml - views/ - templates/ - hook/ - displayHome.tpl

### 2. Rename and Modify the Main PHP File
After renaming the module folder, we need to modify the main PHP file (`youtube.php`) to reflect the new module name and functionality. Open the `youtube.php` file and change all references of `HelloWorld` to `YouTube`.

**Example of updated constructor in `youtube.php`:**

```php
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
```

### 3. Create the Configuration Options

Next, we’ll provide a configuration option where the admin can specify the YouTube video ID to display. This will be handled via the getContent() method, where the admin can input a YouTube video ID in the module’s settings.

Example of the getContent() method:

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

This code creates a form where the admin can input a YouTube video ID. Upon submission, the video ID is saved in the configuration and can be retrieved later for displaying the video.

### 4. Display the Video on the Homepage

To display the YouTube video on the homepage, we’ll create a custom hook method. The video will be embedded by generating an iframe based on the YouTube video ID saved in the configuration.

Example of the hookDisplayHome() method:

```php
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
```

This method retrieves the saved YouTube video ID from the configuration and generates an iframe to display the video on the homepage. If no video ID is configured, it returns an empty string.

### 5. Hook the Module to the Homepage

To display the video on your homepage, you need to hook the module to the correct hook (in this case, displayHome). You can do this manually via the Back Office or automatically in your module’s install method.

Example of the install() method:

```php
public function install()
{
    if (parent::install() && $this->registerHook('displayHome')) {
        return true;
    }
    return false;
}
```
This will register the module with the displayHome hook, ensuring the video is displayed on the homepage.

## Conclusion

By following the steps above, we’ve created a PrestaShop module that enables you to display a YouTube video on your homepage and customize which video is shown via the Back Office. This module provides a great way to integrate your YouTube content into your PrestaShop store, enhancing your site’s interactivity and engagement.

With this foundation, you can further customize the module to add features such as video autoplay, styling options, or even a gallery of multiple videos to display dynamically on your site.