# Problem: Editing the Maintenance Template in PrestaShop

## Overview

When your PrestaShop store is in maintenance mode, visitors will typically see a default maintenance page that indicates the site is temporarily offline. However, you may want to customize the text displayed on this page to provide more specific information or a personalized message to your customers. For instance, you might want to include a message about when the store will be back online or provide additional details about ongoing maintenance.

## Why This Is a Problem

By default, PrestaShop’s maintenance page has a simple message that may not fully reflect the tone or details you'd like to communicate with your visitors during maintenance periods. Editing the template allows you to personalize the message and provide a better user experience, keeping your customers informed about the status of your store.

### Benefits of Customizing the Maintenance Page:
- **Personalized Message**: You can add a custom message, such as expected downtime, upcoming product launches, or general information about maintenance.
- **Improved User Experience**: A friendly and informative maintenance page keeps customers engaged, even when the store is down.
- **Brand Consistency**: Customizing the template ensures the maintenance page aligns with your store's design and messaging.

## Solution

To customize the maintenance page, we need to edit the `maintenance.tpl` template file in PrestaShop. This file is located in your theme directory, and by modifying it, you can change the content that appears when the store is in maintenance mode.

### Step-by-Step Guide to Editing the Maintenance Template

1. **Locate the Template File**:
   - Navigate to your PrestaShop installation directory.
   - Go to the **themes/your_theme/** folder (replace `your_theme` with the actual theme you’re using).
   - Locate the `maintenance.tpl` file. This is the file responsible for rendering the maintenance page.

2. **Edit the Template File**:
   - Open the `maintenance.tpl` file with a text or code editor.
   - The code inside this file is straightforward, and you can modify the text to suit your needs. Below is an example of the default structure of the file.

```html
   <!DOCTYPE html>
   <html lang="{$language_code|escape:'html':'UTF-8'}">
   <head>
       <meta charset="utf-8">
       <title>{$meta_title|escape:'html':'UTF-8'}</title>
       {if isset($meta_description)}
           <meta name="description" content="{$meta_description|escape:'html':'UTF-8'}">
       {/if}
   </head>
   <body>
       <h1>{$meta_title}</h1>
       <p>{$meta_description}</p>
   </body>
   </html>
```

3. Modify the Text:
   - Within the maintenance.tpl file, 
   - you’ll find placeholders for the page title ({$meta_title}) and description ({$meta_description}). You can edit these directly, 
   - or you can update the values in the Back Office under Preferences → Maintenance for dynamic content.

   - Example of customization:
```
<h1>Our Store is Temporarily Closed for Maintenance</h1>
<p>We're currently updating our website. We apologize for the inconvenience and will be back shortly.</p>
<p>Thank you for your patience!</p>
```

4. Save the Changes:
    Once you’ve made your changes, save the file and upload it back to your server if you edited it locally. 

5. Verify the Changes:
    Visit your store while it’s in maintenance mode to confirm that your custom message is being displayed correctly.
   
Example of Customizing the Maintenance Page:

Here’s an example of a customized maintenance.tpl file with a friendly maintenance message:

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
</body>
</html>
```

How It Works

The maintenance.tpl file is a simple HTML template that PrestaShop uses to display when the store is in maintenance mode. By editing this file, you can:

    Change the heading (e.g., "We’re Currently Undergoing Maintenance").
    Modify the description text to give more details about the maintenance, such as the expected downtime or other relevant information.
    Add any extra HTML, such as images or links to social media pages, to keep your visitors engaged.

Conclusion

Customizing the maintenance.tpl file allows you to provide a more personalized and informative maintenance page for your visitors. This can help ensure that your customers have a positive experience even when the store is offline for maintenance.