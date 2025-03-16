# Product Categories and Features Retrieval

## Problem
When dealing with products in our application, 
it is often necessary to retrieve both product categories and features. 

Without a standardized approach, 
fetching this information can lead to redundant queries, 
inconsistent data handling, and increased code complexity.

## Solution
To streamline this process, 
the `Product` class provides dedicated static methods that allow efficient retrieval of product categories and features. 

These methods ensure consistency, 
improve maintainability, and enhance performance by centralizing data access.

To retrieve this information, 
use the following static methods from the `Product` class, located in `classes/Product.php`:

- `getProductCategories()`: Retrieves a list of product categories.
- `getFrontFeaturesStatic()`: Returns the key features of a product for display on the front end.

## How It Works
The `getProductCategories()` method has the following signature:

```php
public static function getProductCategories(): array
```

This function returns an array of product categories, allowing for easy categorization and organization of products.

Similarly, the `getFrontFeaturesStatic()` method retrieves product features:

```php
public static function getFrontFeaturesStatic(int $productId): array
```

This function accepts a product ID and returns an array containing key product features.

## Example Usage
Here's an example of how to use these methods in your code:

```php
require_once 'classes/Product.php';

$categories = Product::getProductCategories();
$productId = 101;
$productFeatures = Product::getFrontFeaturesStatic($productId);

echo "Product Categories: " . implode(", ", $categories) . "\n";
echo "Product Features: " . implode(", ", $productFeatures) . "\n";
```

## Why This Matters
- **Improved Maintainability**: Centralized data retrieval avoids scattered queries throughout the codebase.
- **Performance Optimization**: Reduces redundant queries and ensures consistent data handling.
- **Code Reusability**: Encourages best practices by providing a single source of truth for product information.


