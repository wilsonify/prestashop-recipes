# Displaying a Specific Price as a Deposit Payment

## Problem
You have added a **specific price** to a product in PrestaShop and want to display it as a **deposit payment** instead of a traditional discount. By default, PrestaShop shows percentage reductions (e.g., "-20%"), which does not accurately represent a deposit-based payment structure.

## Solution
To modify the product display and represent the specific price as a deposit payment, you need to edit the `product.tpl` file in your current theme. The goal is to:
- Remove the reduction box that displays the percentage discount.
- Adjust the product price display to reflect a deposit payment.
- Ensure clarity for customers by showing both the deposit amount and the total product price.

## Implementation
### Step 1: Locate the Template File
1. Navigate to your PrestaShop theme directory:
   ```
   themes/your_theme/
   ```
2. Open the `product.tpl` file.

### Step 2: Remove the Discount Percentage Display
1. Around **line 268**, locate the following `<p>` HTML element:
   ```html
   <p id="reduction_percent">-20%</p>
   ```
2. Delete or comment out this element to prevent the discount percentage from being displayed.

### Step 3: Modify Price Display for Deposits
1. Locate the price section in `product.tpl` where the discounted price is displayed.
2. Modify it to clearly label the price as a **deposit payment**.
3. Example adjustment:
   ```html
   <p class="deposit-payment">Pay now: <strong>{$product.price}</strong></p>
   <p class="total-price">Total cost: <strong>{$product.regular_price}</strong></p>
   ```

### Step 4: Apply CSS Styling (Optional)
For better visual clarity, you can add custom CSS in your theme’s stylesheet:
```css
.deposit-payment {
    font-size: 1.2em;
    color: #d9534f;
    font-weight: bold;
}
.total-price {
    font-size: 1em;
    color: #555;
}
```

## Why This Matters
- **Improves User Experience**: Clearly shows customers that they are paying a deposit rather than receiving a discount.
- **Enhances Transparency**: Reduces confusion by displaying both the deposit and total price.
- **Flexible Customization**: Allows for tailored payment structures without modifying PrestaShop’s core logic.

For further adjustments, consider customizing translations or modifying additional template elements to refine the deposit payment display.
