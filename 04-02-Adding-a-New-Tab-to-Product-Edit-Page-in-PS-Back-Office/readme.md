# Adding a New Tab to the Product Edit Page in PrestaShop

## Problem Overview

In PrestaShop, you might want to extend the product editing page by adding a custom tab. This could be useful for displaying additional product fields, showing custom product information, or integrating other features that are not natively included in the default PrestaShop setup.

The challenge is to modify the product edit page to accommodate this new tab, which involves either directly modifying PrestaShop's core files or developing a module to handle the functionality.

In this guide, we will cover two solutions to achieve this:
1. **Direct file modification**: This solution involves editing PrestaShop core files to add the new tab (presented in this recipe).
2. **Module development**: This solution focuses on creating a custom module to add a new tab to the product edit page (demonstrated in Recipe 4-3).

## Solution 1: Direct File Modification

For this solution, we will modify the PrestaShop core files to manually add the new tab to the product edit page in the Back Office.

### Step 1: Locate the AdminProductsController.php File

The file that controls the product edit page is located in the `controllers/admin` directory. To add a new tab, we need to modify the `AdminProductsController.php` file.

Path to the file:

controllers/admin/AdminProductsController.php


### Step 2: Modify the Controller to Add a New Tab

In the `AdminProductsController.php` file, you will need to locate the `__construct()` method. This method is where PrestaShop defines the available tabs on the product edit page.

1. **Open the file** and find the following lines:

   ```php
   $this->available_tabs_lang = array(
       'General' => $this->l('General'),
       'Prices' => $this->l('Prices'),
       'SEO' => $this->l('SEO'),
       'Shipping' => $this->l('Shipping'),
       // Add more predefined tabs here
   );

    Add Your New Tab
    To add a new tab, you need to append it to the $this->available_tabs_lang array. You can name the new tab and assign a label for it.

    Example: Let's say you want to add a "Custom Info" tab:

    $this->available_tabs_lang = array(
        'General' => $this->l('General'),
        'Prices' => $this->l('Prices'),
        'SEO' => $this->l('SEO'),
        'Shipping' => $this->l('Shipping'),
        'Custom Info' => $this->l('Custom Information'), // New tab
    );

### Step 3: Define the Content for the New Tab

After adding the new tab to the available_tabs_lang array, you will need to define what content is displayed when this tab is selected. To do this, locate the section of the controller that handles tab content and add logic to display your custom content.

For example:

```
if ($tab == 'Custom Info') {
    $this->content = $this->renderCustomTabContent($id_product);
}
```

You will need to create a new function, such as renderCustomTabContent(), that handles how the content is displayed. This might include retrieving additional product data from the database or rendering a custom form.

### Step 4: Add Template for the New Tab

The content displayed in the tab should be rendered using a template file. You can create a new template in the themes/default/template/controllers/products directory (or your custom theme directory) and render it in your new function.

For example:

```
public function renderCustomTabContent($id_product)
{
    $this->context->smarty->assign(array(
        'product_id' => $id_product,
        'custom_info' => 'Your custom data or form here',
    ));
    
    return $this->context->smarty->fetch(_PS_THEME_DIR_.'template/controllers/products/custom_info.tpl');
}
```

This code assigns any necessary variables to the template and fetches the template to display it within the new tab.

### Step 5: Test the New Tab

After saving the modifications to the AdminProductsController.php file, clear PrestaShop's cache and log in to the Back Office. Navigate to the product edit page, and you should see the new "Custom Info" tab.

Click on the new tab, and verify that the correct content is being displayed.

## Alternative Solution 2: Using a Custom Module (Recipe 4-3)

While directly modifying core files works, it is generally not recommended because it can cause issues during future PrestaShop updates. A better approach is to encapsulate the customization in a module that can be easily installed and managed.

In Recipe 4-3, we will demonstrate how to create a module that adds a custom tab to the product edit page in the PrestaShop Back Office. This solution will be more maintainable and flexible.

## Conclusion

In this guide, we showed you how to add a new tab to the product edit page in the PrestaShop Back Office. By directly modifying the AdminProductsController.php file, you can add a new tab and customize its content to display additional information or custom fields. While this method works, we recommend using a module-based approach for better maintainability and flexibility, which will be covered in Recipe 4-3.

Make sure to test your changes thoroughly, especially when editing core files, to avoid any potential conflicts with future PrestaShop updates.