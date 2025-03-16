# Adding Deposit and Balance Due to Cart Summary

## Problem
You need to display both the **deposit payment** and the **balance due** values in the **Cart Summary**.

## Solution
To achieve this, we will modify the **getSummaryDetails()** method in the `Cart.php` file. This modification will:
- Extract and calculate the deposit and balance due values.
- Integrate these values into the Smarty variables used in the Cart Summary.

## Implementation Steps

### Step 1: Locate the `Cart.php` File
1. Navigate to:
   ```
   classes/Cart.php
   ```
2. Open the file and find the **getSummaryDetails()** method.

### Step 2: Initialize Deposit and Balance Due Variables
Inside the `getSummaryDetails()` method, introduce two new variables:
```php
$deposit_due = 0;
$balance_due = 0;
```

### Step 3: Modify the Calculation Logic
Locate the section where cart totals are calculated and update the loop to extract deposit and balance values:
```php
foreach ($this->getProducts() as $product) {
    $product_total = $product['price'] * $product['quantity'];
    $deposit_paid = !empty($product['deposit_amount']) ? $product['deposit_amount'] * $product['quantity'] : 0;
    $balance_due += ($product_total - $deposit_paid);
    $deposit_due += $deposit_paid;
}
```

### Step 4: Assign the Values to Smarty Variables
After calculating the deposit and balance due, add them to the Smarty array:
```php
$summary['deposit_due'] = $deposit_due;
$summary['balance_due'] = $balance_due;
```

### Step 5: Update the Cart Summary Template
Modify the relevant template file (`cart-summary.tpl`) in your theme to display the new values:
```html
<p>Deposit Paid: {$deposit_due|escape:'html':'UTF-8'}</p>
<p>Balance Due: {$balance_due|escape:'html':'UTF-8'}</p>
```

## Why This Matters
- **Improved Transparency**: Clearly shows customers what they have paid and what remains.
- **Enhanced User Experience**: Helps users understand their booking costs at checkout.
- **Seamless Payment Integration**: Works with payment gateways like PayPal and Stripe.

After implementing these changes, customers will see both deposit and balance amounts in the **Cart Summary**, ensuring clarity and ease of understanding.
