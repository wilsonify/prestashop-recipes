# Calculating and Displaying Deposit Value in Cart Summary

## Problem
You want to calculate the **deposit value** for a product or service and display it in the **Cart Summary** during checkout. By default, PrestaShop does not separate deposits from the total order price, making it necessary to modify the **getOrderTotal()** method in the `Cart` class.

## Solution
To implement deposit calculations, we will modify the `getOrderTotal()` method inside the `Cart.php` file. This method is responsible for computing the total order value and is extensively used throughout the checkout process, including by payment modules such as **Bank Wire, PayPal, Stripe**, and others.

### Steps:
1. Open the `Cart.php` file located in:
   ```
   classes/Cart.php
   ```
2. Locate the `getOrderTotal()` method.
3. Modify it to include deposit calculations.
4. Introduce **three new constant variables** for handling deposit amounts.

## How It Works
At the beginning of the `Cart` class, you will find several **constant variable declarations** (around **line 144** in `Cart.php`). These constants are used to calculate different components of the total order amount.

### Existing Constant Variables:
```php
const ONLY_PRODUCTS = 1;
const ONLY_DISCOUNTS = 2;
const BOTH = 3;
const BOTH_WITHOUT_SHIPPING = 4;
const ONLY_SHIPPING = 5;
const ONLY_WRAPPING = 6;
const ONLY_PRODUCTS_WITHOUT_SHIPPING = 7;
const ONLY_PHYSICAL_PRODUCTS_WITHOUT_SHIPPING = 8;
```

### Adding New Constants for Deposit Calculation
To separate deposit payments, add the following constants:
```php
const ONLY_DEPOSIT = 9;
const REMAINING_BALANCE = 10;
const FULL_PAYMENT = 11;
```
- **ONLY_DEPOSIT (9):** Retrieves only the deposit amount.
- **REMAINING_BALANCE (10):** Retrieves the amount due after the deposit.
- **FULL_PAYMENT (11):** Retrieves the full product price as usual.

### Modifying `getOrderTotal()` to Support Deposits
Within the `getOrderTotal()` function, you’ll need to implement logic that:
- Identifies if a product has a deposit set.
- Calculates the deposit percentage or fixed amount.
- Returns the deposit value when `ONLY_DEPOSIT` is requested.

#### Example Modification in `getOrderTotal()`:
```php
public function getOrderTotal($withTaxes = true, $type = Cart::BOTH)
{
    if ($type == self::ONLY_DEPOSIT) {
        return $this->getDepositAmount();
    }
    if ($type == self::REMAINING_BALANCE) {
        return $this->getOrderTotal($withTaxes, self::BOTH) - $this->getDepositAmount();
    }
    return parent::getOrderTotal($withTaxes, $type);
}
```

### Implementing `getDepositAmount()`
You'll need a helper function to retrieve deposit values:
```php
private function getDepositAmount()
{
    $deposit = 0;
    foreach ($this->getProducts() as $product) {
        if (!empty($product['deposit_amount'])) {
            $deposit += $product['deposit_amount'] * $product['quantity'];
        }
    }
    return $deposit;
}
```

## Why This Matters
- **Enhanced Checkout Flexibility**: Allows customers to pay deposits upfront and balances later.
- **Seamless Payment Module Integration**: Works with existing payment methods like PayPal and Stripe.
- **Customizable Pricing Logic**: Enables more transparent and structured payment models.

After implementing these changes, you can call `getOrderTotal(Cart::ONLY_DEPOSIT)` anywhere in your templates to display the deposit amount in the Cart Summary.