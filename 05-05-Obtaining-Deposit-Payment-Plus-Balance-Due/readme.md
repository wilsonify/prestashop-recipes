# Calculating and Displaying Deposit and Balance Due in Cart Summary

## Problem
You need to calculate and display the **total amount due**, which consists of both the **deposit payment** and the **balance due** for products in a booking system.

## Solution
To achieve this, we will modify the **getOrderTotal()** method in the `Cart.php` file. This modification will:
- Add a new constant `Cart::ONLY_DEPOSIT_DUE`.
- Update the method to return the combined **deposit payment** and **balance due** when this constant is passed as an argument.

## Implementation Steps

### Step 1: Locate the `Cart.php` File
1. Navigate to:
   ```
   classes/Cart.php
   ```
2. Open the file and find the **getOrderTotal()** method.

### Step 2: Define the New Constant
At the beginning of the `Cart` class, add the following constant:
```php
const ONLY_DEPOSIT_DUE = 12;
```
This constant will be used to request the sum of deposit and balance due.

### Step 3: Modify `getOrderTotal()` to Calculate Deposit and Balance Due
Inside the `getOrderTotal()` method, introduce a variable to store the combined deposit and balance due:
```php
$deposit_due = 0;
```
Then, modify the `foreach` loop to calculate this value:
```php
foreach ($this->getProducts() as $product) {
    $product_total = $product['price'] * $product['quantity'];
    $deposit_paid = !empty($product['deposit_amount']) ? $product['deposit_amount'] * $product['quantity'] : 0;
    $balance_due = $product_total - $deposit_paid;
    $deposit_due += ($deposit_paid + $balance_due);
}
```
### Step 4: Return the Combined Amount
At the end of the method, return the total amount when the `ONLY_DEPOSIT_DUE` constant is used:
```php
if ($type == self::ONLY_DEPOSIT_DUE) {
    return $deposit_due;
}
```

## Why This Matters
- **Complete Payment Overview**: Clearly displays both deposit and balance due in the Cart Summary.
- **Enhances Transparency**: Customers understand how much they have paid and what remains.
- **Seamless Checkout Integration**: Works with various payment modules like PayPal and Stripe.

After implementing these changes, you can display the deposit and balance due using:
```php
$this->getOrderTotal(true, Cart::ONLY_DEPOSIT_DUE);
```
This ensures that the checkout page accurately reflects both the **initial deposit** and the **remaining balance**.
