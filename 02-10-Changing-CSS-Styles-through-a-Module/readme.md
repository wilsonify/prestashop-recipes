# Changing CSS Styles in PrestaShop Without Editing CSS Files

## Problem Statement

You want to change the CSS styles of your PrestaShop website through the Back Office without directly editing the `.css` files.

In PrestaShop, CSS files are integral for controlling the visual design of your website. 

However, directly editing `.css` files can be challenging for non-technical users. 

The typical challenges include:

- **Risk of Errors**: Making mistakes while editing CSS can cause layout issues or break elements on your site.
- **Difficulty in Debugging**: If an issue arises, it may be hard to pinpoint the exact line of code that’s causing the problem, especially if multiple CSS files are involved.
- **Overwriting Customizations**: When PrestaShop or theme updates occur, custom changes in `.css` files can get overwritten, leading to loss of custom styling.
- **Need for Technical Knowledge**: Many users, especially those with little web development experience, may struggle with understanding or writing CSS, limiting their ability to customize their site.

Therefore, the problem is not just about changing CSS; 

it's about providing an easy, accessible, and safe way for non-developers to update their site’s visual style 
without risking their layout or facing the complexity of CSS code.


## Solution Overview
Instead of manually editing CSS files, which can be error-prone and time-consuming, you can use the CSS Editing module. This module allows you to modify your website’s CSS styles directly from the PrestaShop Back Office, providing a user-friendly interface for making visual customizations without needing to interact with code.

### Installation
To get started, download and install the **CSS Editing** module by following the steps below.

1. Download the module from the following link:  
   [Download CSS Editing Module](https://dh42.com/wp-content/uploads/2015/05/cssmodule.zip)

2. Once downloaded, navigate to the **Modules** section in your PrestaShop Back Office:
   - Go to **Modules** > **Module Manager** > **Upload a Module**.
   - Upload the `.zip` file you downloaded.

3. After successful installation, the CSS Editing module will be available in your module list.

### How It Works
After installing the module, you can use it to easily change the CSS styles of your PrestaShop site. The module adds a simple interface in the Back Office where you can directly add or modify CSS rules without needing to access or edit the `.css` files manually.

### Example Usage
1. Navigate to the **Modules** section in the PrestaShop Back Office and find the **CSS Editing** module.
2. Click on the **Configure** button to open the module’s interface.
3. Use the provided text area to add custom CSS rules. These rules will be applied to your PrestaShop site immediately.

### Benefits
- **No Direct File Editing**: Allows you to make changes without needing access to your theme's `.css` files.
- **Easy Customization**: Quickly tweak visual styles, such as colors, fonts, or layout adjustments, directly in the Back Office.
- **Safety**: Avoid the risk of overwriting or corrupting critical theme files.

### Visual Example
Once the module is installed, you’ll see an interface that looks like this:

![CSS Editing Module Installed](path/to/your/screenshot.png)

You can use this interface to add custom styles like:
```css
/* Example of custom CSS */
.header { 
    background-color: #333; 
}
```

## Conclusion

Using the CSS Editing module is a simple and efficient way to customize the appearance of your PrestaShop website without directly editing CSS files. This method provides flexibility, ease of use, and safety, especially for those who prefer a more visual approach to styling their site.