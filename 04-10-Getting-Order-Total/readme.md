# Order Total Calculation

## Problem
When processing orders in our application, it is crucial to determine the total cost accurately. Without a structured approach, calculating the order total could lead to inconsistencies, incorrect pricing, and potential financial discrepancies.

## Solution
To ensure accurate and efficient order total calculation, the `Cart` class provides a dedicated method: `getOrderTotal()`. This method centralizes the logic for computing the total cost of an order, including applied discounts, taxes, and shipping fees.

The `getOrderTotal()` method is located in the `classes/Cart.php` file and ensures that all relevant pricing factors are considered when determining the final amount.

## How It Works
The `getOrderTotal()` method has the following signature:

```php
public function getOrderTotal(bool $withTaxes = true, int $type = Cart::BOTH): float
```

### Parameters:
- **`$withTaxes` (bool, optional, default = `true`)**: Determines whether taxes should be included in the total.
- **`$type` (int, optional, default = `Cart::BOTH`)**: Specifies which elements to include in the calculation, such as products, shipping, or both.

### Return Value:
This function returns the total order amount as a floating-point number.

## Example Usage
Here’s how you can use the `getOrderTotal()` method in your code:

```php
require_once 'classes/Cart.php';

$cart = new Cart($cartId);
$orderTotal = $cart->getOrderTotal();

echo "Order Total: $" . number_format($orderTotal, 2) . "\n";
```

## Why This Matters
- **Consistency**: Centralizing the total calculation ensures uniform pricing across different parts of the application.
- **Accuracy**: Includes all applicable charges such as taxes, shipping fees, and discounts.
- **Maintainability**: Reduces redundant pricing calculations scattered throughout the codebase.

For further details, refer to the `Cart.php` class implementation in `classes/Cart.php`.
