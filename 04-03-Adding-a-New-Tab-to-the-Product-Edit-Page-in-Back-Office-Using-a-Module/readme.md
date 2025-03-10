# Adding a New Tab to the Product Edit Page through a PrestaShop Module

## Problem Overview

You want to add a new tab to the product edit page in your PrestaShop Back Office. This new tab could display additional product fields or information (e.g., a "Bookings" tab). However, instead of modifying core files directly, you want to achieve this by creating a custom module.

## Solution

In this guide, we will walk you through the process of creating a PrestaShop module that adds a new tab to the product edit page in the Back Office. This solution will be related to "Bookings," but the process can be adapted for any other custom tab or information you want to display.

### Step 1: Create the Module Folder and Files

1. **Create a new folder** for your module in the `modules` directory:
    - Path: `modules/bookings/`
   
2. **Create the necessary files** for the module:
    - `bookings.php` — the main module file.
    - `logo.png` or `logo.gif` — the logo for the module.

### Step 2: Define the Module in bookings.php

In the `bookings.php` file, we will define the module's basic properties and functionality. Start by defining the `__construct()` method as shown below.

**Listing 4-7. `__construct()` Method of the Bookings Module**

```php
<?php
if (!defined('_PS_VERSION_')) exit;

class Bookings extends Module
{
    public function __construct()
    {
        $this->name = 'bookings';
        $this->tab = 'front_office_features';  // Module tab in the Back Office
        $this->version = '1.0.0';
        $this->author = 'Arnaldo Perez Castano';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = array('min' => '1.6', 'max' => _PS_VERSION_);
        $this->bootstrap = true;
        
        parent::__construct();
        
        $this->displayName = $this->l('Bookings');
        $this->description = $this->l('Add Bookings Tab to product edit page');
        $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');
    }
}
```

This sets up the basic structure of the module, including the name, version, author, and description. The __construct() method is essential for initializing the module.
Step 3: Implement Install and Uninstall Methods

Next, define the install() and uninstall() methods to ensure the module installs and uninstalls correctly.

Listing 4-8. Install() and Uninstall() Methods for the Bookings Module

public function install()
{
    if (!parent::install() || !$this->registerHook('displayAdminProductsExtra')) {
        return false;
    }
    return true;
}

public function uninstall()
{
    if (!parent::uninstall()) {
        return false;
    }
    return true;
}

    The install() method registers a hook (displayAdminProductsExtra) that will allow us to add content to the product edit page.
    The uninstall() method ensures that the module is uninstalled properly.

Step 4: Define the Hook to Display the New Tab

The displayAdminProductsExtra hook will allow us to insert the new tab into the product edit page. In the hook method, we will load the product and assign data to the template.

Listing 4-9. hookDisplayAdminProductsExtra() Method

public function hookDisplayAdminProductsExtra($params)
{
    $product = new Product((int)Tools::getValue('id_product'));
    if (Validate::isLoadedObject($product)) {
        $this->context->smarty->assign(array(
            'bookings' => $product->booking_dates  // Assuming 'booking_dates' field exists
        ));
        return $this->display(__FILE__, 'bookings.tpl');
    }
}

    In this method, we load the product using the id_product from the request.
    We use Validate::isLoadedObject($product) to ensure the product is valid.
    We assign the booking_dates field to the Smarty template (bookings.tpl), which will display the data in the new tab.

Step 5: Create the Template for the New Tab

Now, we need to create the template file (bookings.tpl) that will display the "Bookings" data. This template file should be located in the module’s folder.

Example contents for bookings.tpl:

<div class="panel">
    <h3>{$bookings}</h3>
    <p>{l s='Manage the bookings for this product here.'}</p>
</div>

This template will simply display the booking_dates information in a basic HTML structure, but you can customize it further based on your needs.
Step 6: Test the New Tab

After completing the above steps:

    Install the module from the Modules and Services section in PrestaShop Back Office.
    Navigate to the product edit page, and you should see the new "Bookings" tab.
    Ensure the tab displays the booking information correctly (or any other custom information you are showing).

Step 7: Use the actionProductUpdate Hook for Data Processing

A useful hook you may want to implement when dealing with a custom tab is the actionProductUpdate hook. This hook is triggered whenever a product is updated and allows you to fetch data from your custom tab and process it accordingly.

Example use of actionProductUpdate:

public function hookActionProductUpdate($params)
{
    $product = $params['product'];
    $booking_dates = Tools::getValue('booking_dates');
    if ($booking_dates) {
        // Process the booking_dates, e.g., save to the database
    }
}

This hook can be useful if you need to save or process data entered in your custom tab.
Conclusion

By following this guide, you've learned how to add a new tab to the product edit page in PrestaShop through a custom module. This method is more maintainable and flexible than modifying core files, as it allows you to install and uninstall the feature easily.

This solution involves creating a module with the necessary hooks and templates, and utilizing PrestaShop’s displayAdminProductsExtra hook to display the new tab. Additionally, we've introduced the actionProductUpdate hook for handling updates to the product’s data.

For further customization, you can extend this module by adding more fields, integrating with external services, or handling more complex product data.
