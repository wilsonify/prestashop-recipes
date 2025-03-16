# Calculating and Displaying Balance Due in Cart Summary

## Problem
You need to calculate the **balance due** for a product or service and display it in the **Cart Summary**. The balance due represents the remaining amount a customer must pay after making an initial deposit.

## Solution
To implement this, we will modify the **getOrderTotal()** method inside the `Cart.php` file. Specifically, we will:
- Introduce a new variable `$balance_due`.
- Modify the `foreach` loop inside `getOrderTotal()` to compute the balance due.

## Implementation Steps
### Step 1: Locate the `Cart.php` File
1. Navigate to:
   ```
   classes/Cart.php
   ```
2. Open the file and find the **getOrderTotal()** method.

### Step 2: Initialize the Balance Due Variable
At the beginning of `getOrderTotal()`, add the following line:
```php
$balance_due = 0;
```

### Step 3: Modify the `foreach` Loop
Edit the `foreach` loop to calculate the balance due by subtracting the deposit amount:
```php
foreach ($this->getProducts() as $product) {
    $product_total = $product['price'] * $product['quantity'];
    $deposit_paid = !empty($product['deposit_amount']) ? $product['deposit_amount'] * $product['quantity'] : 0;
    $balance_due += ($product_total - $deposit_paid);
}
```

### Step 4: Return the Balance Due
Modify the return statement to handle the balance due calculation when required:
```php
if ($type == self::REMAINING_BALANCE) {
    return $balance_due;
}
```

## Why This Matters
- **Clear Payment Breakdown**: Customers can easily see the remaining amount they need to pay.
- **Seamless Checkout Process**: Works with payment modules like PayPal and Stripe.
- **Flexible and Transparent Pricing**: Enhances the user experience by clearly displaying the deposit and balance due.

After implementing these changes, you can display the balance due in the Cart Summary using:
```php
$this->getOrderTotal(true, Cart::REMAINING_BALANCE);
```
This ensures that the checkout page accurately reflects both deposits and outstanding balances.
