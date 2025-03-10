# Adding New Fields to PrestaShop Products

## Problem Overview

In some cases, you may want to extend the functionality of your PrestaShop store by adding new fields to your product pages. For example, you might want to add a "Booking Dates" field to track when a product or service is booked or purchased. This new field will allow you to easily manage booking information directly from the product editing page in the Back Office.

The challenge here is to customize PrestaShop to store and display this additional information. This requires modifications to the database schema, the Product class, and the product templates in the Back Office.

## Solution

To achieve this, we'll go through the following steps:

1. **Add a new field to the PrestaShop database** — We will modify the `product` and `product_shop` tables to accommodate the new "Booking Dates" field.
   
2. **Override the Product class** — We'll modify the `Product` class located in `classes/Product.php` to ensure that the new field is properly handled in the backend.

3. **Edit the Product template** — We’ll update the `informations.tpl` template file to display the new field on the product editing page in the Back Office.

## How It Works

### Step 1: Modify the Database

We need to add the new field (`booking_dates`) to both the `product` and `product_shop` tables in the PrestaShop database. You can do this using a database migration or directly through SQL.

```sql
ALTER TABLE ps_product ADD COLUMN booking_dates VARCHAR(255) NULL;
ALTER TABLE ps_product_shop ADD COLUMN booking_dates VARCHAR(255) NULL;
```

This will create a new column booking_dates in the product and product_shop tables to store the dates when a product is booked.
### Step 2: Override the Product Class

Next, we will override the Product class to handle the new field. By overriding this class, we can ensure that the "Booking Dates" field is available to PrestaShop when managing products.

    Copy the Product Class
    Copy the classes/Product.php file to the override/classes directory. This will allow us to customize the class without modifying the core files of PrestaShop.
        Original file path: classes/Product.php
        Override path: override/classes/Product.php

    Modify the Product Class
    Open the override/classes/Product.php file and change the class definition to extend ProductCore. This will ensure that we inherit all the default behavior of the Product class while adding our custom functionality.

    Example:

    <?php
    class Product extends ProductCore
    {
        public $booking_dates;

        public function __construct($id_product = null, $id_lang = null, $id_shop = null)
        {
            parent::__construct($id_product, $id_lang, $id_shop);
        }

        public static function getBookingDates($id_product)
        {
            return Db::getInstance()->getValue('SELECT booking_dates FROM '._DB_PREFIX_.'product WHERE id_product = '.(int)$id_product);
        }
    }
    ?>

    In this example:
        We added a public $booking_dates property to the Product class.
        We also added a getBookingDates() method to retrieve the booking dates for a product from the database.

### Step 3: Modify the Product Template

To display the new "Booking Dates" field on the product edit page in the Back Office, we need to update the informations.tpl template file.

    Locate the Template File
    The informations.tpl file can be found in the following path:
        Original file path: your_admin_folder/themes/default/template/controllers/products/informations.tpl

    In this file, we will add the necessary HTML and Smarty code to display the new field.

    Add the New Field to the Template
    Modify the informations.tpl file to add the new "Booking Dates" field. This will allow you to input and display booking information directly from the product page.

    Example:

    <div class="form-group">
        <label for="booking_dates">{l s='Booking Dates'}</label>
        <input type="text" name="booking_dates" id="booking_dates" value="{$product.booking_dates|escape:'html':'UTF-8'}" class="form-control" />
    </div>

    In this code:
        A new input field for "Booking Dates" is added to the product edit form.
        The {$product.booking_dates} Smarty variable is used to display the current value of the booking_dates field for the product.

### Step 4: Save the New Field

To ensure the new field is saved in the database, we need to hook into the product save process.

    Modify the Product Save Logic
    Update the Product class to save the new field when the product is saved.

    Example:

    public function save()
    {
        if (isset($this->booking_dates)) {
            Db::getInstance()->update('product', array('booking_dates' => pSQL($this->booking_dates)), 'id_product = '.(int)$this->id);
        }
        parent::save();
    }

    Save the Data
    The modified save() function ensures that when a product is updated, the new "Booking Dates" field is stored in the database.



Once the above changes are implemented, you will be able to see a new "Booking Dates" field in the product editing page in the PrestaShop Back Office. This field will allow you to track the booking dates for each product, and the data will be stored in the product and product_shop tables of the database.

The customization involves:

    Adding a new column to the product tables in the database to store the booking dates.
    Overriding the Product class to handle the new field.
    Modifying the Back Office template to display and input the new data.

## Conclusion

By following this guide, you can easily extend PrestaShop to include custom fields, such as "Booking Dates," for your products. This approach helps you store and manage additional product information without disrupting the core functionality of PrestaShop. The process involves database modifications, class overrides, and template edits, all of which are necessary for adding custom fields to the Back Office.