# PrestaShop Custom Field Persistence in Add to Cart

## Problem

In default PrestaShop behavior, 
custom field values entered by customers are not automatically saved when they 
click the **Add to Cart** button. Instead, 
users must first manually save these customizations before adding the product 
to the cart, introducing an unnecessary middle step. 

This extra step creates a poor user experience, 
increases friction in the purchase process, 
and may lead to lost sales due to user frustration or confusion.

## Solution

To streamline this process, 
we need to modify multiple PrestaShop files responsible for handling the "Add to Cart" operation. 

The changes ensure that custom field values are directly sent from the front end to the back end 
without requiring a separate save action.

### Files to Modify

1. **themes/your_theme/js/modules/blockcart/ajax-cart.js**
   - This JavaScript file manages AJAX-based cart interactions when a product is added.
   - We modify it to capture the custom field value from the **product.tpl** template and send it to the server when the user clicks **Add to Cart**.

2. **override/controllers/front/ProductController.php**
   - This back-end file processes product data when it is added to the cart.
   - We modify it to receive the custom field value from the AJAX request and store it accordingly.

## How It Works

### Step 1: Modify `ajax-cart.js`

We need to enhance the JavaScript function responsible for adding products to the cart. Locate the following function in `themes/your_theme/js/modules/blockcart/ajax-cart.js` around line 280:

```javascript
// Add a product to the cart via AJAX
add: function(idProduct, idCombination, addedFromProductPage, callerElement, quantity, wishlist) {
    if (addedFromProductPage && !checkCustomizations()) {
        if (contentOnly) {
            var productUrl = window.document.location.href + '';
            var data = productUrl.replace('content_only=1', '');
            window.parent.document.location.href = data;
            return;
        }

        if (!!$.prototype.fancybox) {
            $.fancybox.open([
                {
                    type: 'inline',
                    autoScale: true,
                    minHeight: 30,
                    content: '<p class="fancybox-error">' + fieldRequired + '</p>'
                }
            ], {
                padding: 0
            });
        } else {
            alert(fieldRequired);
        }
        return;
    }
```

#### Enhancement: Capture Custom Fields

Before the first `if` statement, insert the following code to capture custom field values:

```javascript
// Capture custom field values from the product page
var customFieldValue = $('#custom_field').val();
```

Modify the AJAX request to include this value:

```javascript
$.ajax({
    type: 'POST',
    url: baseUri + '?controller=cart',
    data: {
        id_product: idProduct,
        id_product_attribute: idCombination,
        custom_field: customFieldValue, // Send custom field value
        ajax: true,
        token: static_token
    },
    dataType: 'json',
    success: function(jsonData) {
        // Handle success
    }
});
```

### Step 2: Modify `ProductController.php`

Next, update `override/controllers/front/ProductController.php` to process the custom field data sent via AJAX.

Locate the function that handles product additions to the cart and modify it as follows:

```php
public function process() {
    if (Tools::getValue('add')) {
        $id_product = (int)Tools::getValue('id_product');
        $id_product_attribute = (int)Tools::getValue('id_product_attribute');
        $custom_field = Tools::getValue('custom_field'); // Retrieve custom field data

        // Ensure the cart exists
        $this->context->cart->updateQty(1, $id_product, $id_product_attribute);

        // Store custom field value in session or database as needed
        $this->context->cookie->__set('custom_field_'.$id_product, $custom_field);
    }
}
```

## Why This Works

1. **Capturing User Input:** The JavaScript modification ensures that when the **Add to Cart** button is clicked, the custom field value is included in the AJAX request.
2. **Processing on the Server:** The back-end modification retrieves and processes the custom field data, ensuring it is stored properly for later use (e.g., in orders or session data).
3. **Seamless User Experience:** The need for a separate "Save" action is eliminated, making the purchasing process smoother and more intuitive.

## Conclusion

By implementing these modifications, we enhance PrestaShop's default behavior, improving usability and potentially increasing conversion rates. These changes ensure that custom field values are saved automatically when the **Add to Cart** button is clicked, without requiring an additional step from the customer.

