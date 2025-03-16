# Product Information Retrieval

## Problem
When working with products in our application, 
we often need to retrieve essential details like the product name and quantity. 

However, accessing this information can be cumbersome if we do not have a standardized approach. 

Manually fetching product data from various sources or querying databases repeatedly can lead to inconsistencies, 
performance issues, and increased maintenance effort.

## Solution
To simplify this process, 
we provide dedicated static methods within the `Product` class to fetch product details efficiently. 

These methods ensure consistency and re-usability while reducing code duplication.

To retrieve product information, 
use the following static methods from the `Product` class, 
located in `classes/Product.php`:

- `getProductName($productId)`: Retrieves the name of a product based on its unique identifier.
- `getQuantity($productId)`: Returns the available quantity of a product in stock.

## How It Works
The `getProductName()` method has the following signature:

```php
public static function getProductName(int $productId): string
```

This function accepts a product ID as an integer and returns the corresponding product name as a string.

Similarly, the `getQuantity()` method retrieves the stock quantity:

```php
public static function getQuantity(int $productId): int
```

This function returns the quantity of the specified product as an integer.

## Example Usage
Here's an example of how to use these methods in your code:

```php
require_once 'classes/Product.php';

$productId = 101;

$productName = Product::getProductName($productId);
$productQuantity = Product::getQuantity($productId);

echo "Product Name: " . $productName . "\n";
echo "Available Quantity: " . $productQuantity . "\n";
```

By using these static methods, 
you can efficiently retrieve product details without redundant database queries, 
ensuring cleaner and more maintainable code.

## Why This Matters
- **Improved Maintainability**: Centralizing data retrieval in the `Product` class avoids scattered SQL queries throughout the codebase.
- **Performance Optimization**: Reduces redundant queries and potential inconsistencies in product data.
- **Code Reusability**: Encourages best practices by providing a single source of truth for product information.

For further details, check the `Product.php` class implementation in `classes/Product.php`.
