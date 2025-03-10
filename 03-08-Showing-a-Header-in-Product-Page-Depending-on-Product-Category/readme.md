# Dynamic Header Text Based on Product Category in PrestaShop

## Problem

By default, PrestaShop displays a static header for product pages, regardless of the category. However, you may want to show different header texts depending on the product's category to create a more personalized shopping experience and improve user engagement.

## Solution

To achieve this, we will modify the `product.tpl` file in the active theme. By adding conditional logic, we can dynamically change the header text based on the product category.

## How It Works

### Step 1: Locate the Product Header in `product.tpl`

In your active theme, open the `product.tpl` file and locate the `<div>` element with the class `page-product-heading`. This is where the product header is displayed.

### Step 2: Add Conditional Logic for Category-Based Headers

Modify the contents of the `page-product-heading` `<div>` to include category-based conditions. Example:

```smarty
<div class="page-product-heading">
    {if isset($category) && $category->id == 3}
        <h1>Exclusive Deals on Electronics</h1>
    {elseif isset($category) && $category->id == 5}
        <h1>Fresh Arrivals in Fashion</h1>
    {else}
        <h1>{$product->name}</h1>
    {/if}
</div>
```

### Step 3: Retrieve Category Information in the Controller (If Needed)

If the `$category` variable is not available in `product.tpl`, ensure it is passed from `ProductController.php`:

```php
public function initContent()
{
    parent::initContent();
    
    $id_category = (int)Tools::getValue('id_category', 0);
    $category = new Category($id_category, $this->context->language->id);
    
    $this->context->smarty->assign('category', $category);
}
```

## Conclusion

By implementing this solution, PrestaShop will now display dynamic headers based on the product category. This enhances the user experience by providing more relevant and contextualized information for different product types.

