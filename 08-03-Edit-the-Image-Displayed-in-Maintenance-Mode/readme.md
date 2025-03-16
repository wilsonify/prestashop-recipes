# Problem: Editing the Maintenance Template to Resize or Change the Image

## Overview

When your PrestaShop store is in maintenance mode, you may want to not only change the text on the page but also modify the image displayed to fit the design of your store. Whether you're resizing an image to make it fit within the layout or replacing it with a different image, this process will help you improve the appearance and professionalism of your maintenance page.

## Why This Is a Problem

By default, the maintenance page may display an image that isn't properly sized or centered. If you want the page to look more polished or have a specific branding, you need to adjust the image's dimensions and positioning. 

### Benefits of Customizing the Image:
- **Enhanced User Experience**: A properly sized and centered image improves the overall look of the maintenance page.
- **Branding**: Changing the image allows you to display your logo or a custom maintenance image that aligns with your brand identity.
- **Better Layout Control**: Resizing the image ensures it fits the design without breaking the layout or overflowing.

## Solution

To resize or change the image displayed on the maintenance page, you need to edit the `maintenance.tpl` file located in your theme’s folder. This file controls how the page is displayed when the site is in maintenance mode.

### Step-by-Step Guide to Editing the Maintenance Template

1. **Locate the Template File**:
   - Go to the PrestaShop installation directory.
   - Navigate to the `themes/your_theme/` folder (replace `your_theme` with the name of your active theme).
   - Find the `maintenance.tpl` file. This file is responsible for rendering the maintenance page content.

2. **Open the Template File**:
   - Open the `maintenance.tpl` file with a text editor or code editor.
   - You’ll find the HTML structure of the maintenance page, including the image that is displayed.

3. **Identify the Image Section**:
   - Inside the `maintenance.tpl` file, look for the HTML `<div>` tag or `<img>` tag that contains the image.
   - For example, you might see something like this:

```html
   <div class="maintenance-image">
       <img src="{$img_url}" alt="Maintenance Image">
   </div>
```

This is the section where the image is displayed. 
You can either change the image source or adjust the image’s CSS styling to resize it.

4. **Resize or Replace the Image**:
  - To Replace the Image: Simply change the src attribute to point to the new image’s location.

```<img src="path_to_your_new_image.jpg" alt="Maintenance Image">```

  - To Resize the Image:
      You can apply inline CSS or modify the theme’s CSS file to set the image size.
      Add a style attribute to the <img> tag like this:

```
<img src="{$img_url}" alt="Maintenance Image" style="max-width: 100%; height: auto;">
```

This will make the image responsive, 
resizing it based on the container’s width while maintaining its aspect ratio.

  - Alternatively, you can control the image size via CSS by targeting the .maintenance-image class:

```css
.maintenance-image img {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 0 auto; /* To center the image */
}
```

5. Save the Changes:
        After making the necessary edits, save the file.
        If you edited the file locally, upload it back to your server to apply the changes.

6. Verify the Changes:
        Visit your site while it's in maintenance mode to check that the image is properly resized and displayed as intended.

Example of Customizing the Maintenance Image:

Here’s an example of a customized maintenance.tpl file with an image resized and centered:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Site Maintenance</title>
    <meta name="description" content="Our store is currently undergoing maintenance. We will be back shortly.">
</head>
<body>
    <h1>We’re Currently Undergoing Maintenance</h1>
    <p>Our website is temporarily down for updates. We’re working hard to improve your shopping experience and will be back online soon.</p>
    <p>Thank you for your patience!</p>
    <p>Estimated downtime: 1-2 hours.</p>

    <!-- Maintenance Image -->
    <div class="maintenance-image" style="text-align: center;">
        <img src="path_to_your_custom_image.jpg" alt="Maintenance Image" style="max-width: 100%; height: auto;">
    </div>
</body>
</html>
```

### How It Works

The image is now properly resized to fit within the container by setting max-width: 100%; height: auto;. This ensures the image doesn’t overflow and is responsive.
The text-align: center; CSS property centers the image within its parent container, ensuring a balanced layout.

### Conclusion

By editing the maintenance.tpl file, you can easily resize or change the image displayed on the maintenance page. This allows you to maintain a professional and consistent appearance even when your site is temporarily unavailable. Customizing this image helps reinforce your brand identity and ensures that visitors have a pleasant experience during maintenance periods.