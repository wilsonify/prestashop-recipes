# Displaying a New Product Field on the Product Page

## Problem Overview

You’ve successfully created a new column in the PrestaShop database and added the corresponding field to the `Product` class. Now, you want to display this new field on the product page in your PrestaShop store.

## Solution

To display the new field on the product page, you need to make some changes to the `product.tpl` template file. If necessary, you can also modify the `ProductController.php` file to add extra information or improve the readability of the code in the template.

### Example: Displaying the `booking_dates` Field

Let’s assume that you’ve created a `booking_dates` field in the `products` table and updated the `Product` class accordingly. We’ll walk through the steps to display this field on the product page.

### Step 1: Update the `product.tpl` Template

The main task is to edit the `product.tpl` file, which is responsible for rendering the product details on the product page. In this file, you will insert the code to display the `booking_dates` field wherever it fits within your layout.

Here’s an example of the code you would add to `themes/your_theme/product.tpl` (excluding HTML for formatting):

**Listing 4-10: Displaying the `booking_dates` Field in `product.tpl`**

```smarty
{if isset($product->booking_dates)}
    <div class="product-booking-dates">
        <h3>{l s='Booking Dates'}</h3>
        <p>{$product->booking_dates}</p>
    </div>
{/if}
```

    This code checks if the booking_dates field is set for the current product.
    If the field exists, it displays the booking dates inside a <div> element.
    You can place this code in any part of the product.tpl file where you want the booking dates to be displayed (e.g., below the product description or next to the product price).

### Step 2: Modify the ProductController.php (Optional)

If you need to add additional logic or make the template more legible (such as retrieving extra information or formatting the booking_dates field), you can modify the ProductController.php file.

The ProductController.php file handles the logic for displaying the product page. You may need to assign additional variables to the Smarty template before rendering the page.

Here’s an example of how you might do that:

Example: Modifying ProductController.php

public function initContent()
{
    parent::initContent();
    
    // Assuming 'booking_dates' is part of the Product object
    $product = new Product((int)Tools::getValue('id_product'));
    
    if (Validate::isLoadedObject($product)) {
        $this->context->smarty->assign('booking_dates', $product->booking_dates);
    }
}

    In this example, we load the product using the product ID and assign the booking_dates field to the Smarty template variable.
    This ensures that the booking_dates field is available in product.tpl when the page is rendered.

### Step 3: Test and Customize

After completing the above steps:

    Refresh your cache in the PrestaShop Back Office to ensure the changes take effect.
    Navigate to a product page on your store, and verify that the booking_dates field is displayed correctly.
    Style the display (if needed) using CSS to ensure the new field matches the look and feel of your site.

## Conclusion

By editing the product.tpl template file and, if necessary, the ProductController.php file, you can easily display custom fields like booking_dates on the product page in PrestaShop. This solution allows you to add additional product information without modifying the core files, ensuring that your changes are maintainable and update-safe.

Feel free to extend this method to display other custom fields or make further customizations to suit your needs.
