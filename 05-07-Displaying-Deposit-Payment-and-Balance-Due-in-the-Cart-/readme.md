# Displaying Deposit Payment and Balance Due in Cart Summary

## Problem
You need to display both the **deposit payment** and the **balance due** values in the **Cart Summary**.

## Solution
In Recipe 5-6, we linked the deposit payment and balance due values to Smarty variables. Now, we need to update the template files to display these values in the Cart Summary.

## Implementation Steps

### Step 1: Locate the `shopping-cart.tpl` File
1. Navigate to your theme folder:
   ```
   themes/your_theme/templates/shopping-cart.tpl
   ```
2. Open `shopping-cart.tpl`, which is responsible for rendering the Cart Summary table.

### Step 2: Modify the Shopping Cart Template
Locate the first 50 lines of `shopping-cart.tpl` and modify them to display the deposit and balance due in a way that resembles a **reservation summary**. Add the following inside the appropriate `<tr>` in the cart summary:

```html
<tr>
    <td colspan="2">Deposit Paid:</td>
    <td>{$deposit_due|escape:'html':'UTF-8'}</td>
</tr>
<tr>
    <td colspan="2">Balance Due:</td>
    <td>{$balance_due|escape:'html':'UTF-8'}</td>
</tr>
```

### Step 3: Ensure the Values Are Passed to the Template
Make sure `deposit_due` and `balance_due` are assigned properly in `Cart.php` within the `getSummaryDetails()` method:

```php
$summary['deposit_due'] = $deposit_due;
$summary['balance_due'] = $balance_due;
```

## Why This Matters
- **Clear Financial Breakdown**: Users can see how much they've paid and what remains.
- **Better User Experience**: Helps users manage their bookings more effectively.
- **Seamless Checkout**: Works with all major payment modules, including PayPal and Stripe.

Once these updates are made, customers will see a structured reservation summary with their **deposit paid** and **balance due** clearly displayed in the **Cart Summary**.
