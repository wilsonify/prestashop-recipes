# Deposit Payment for Booking Products and Services

## Problem
When offering booking-based products and services, 
it is often necessary to allow customers to make an initial deposit payment, 
with the remaining balance due upon receiving the service or product. 

However, 
implementing this payment structure in PrestaShop (PS) can be challenging without a built-in feature for deposits.

## Solution
To enable deposit payments, 
we leverage PrestaShop’s price reduction system. 

This method allows us to present two prices within the product box:

1. **Deposit Payment** – The actual amount customers pay when booking online.
2. **Remaining Balance** – The original price (not paid online) displayed as a reference for the total cost.

By using PrestaShop's price reduction system, 
we can effectively create a booking deposit structure without modifying the core payment system. 

While this approach does not visually represent deposits in the most intuitive way, 
it provides all necessary elements for processing split payments.

## Implementation
PrestaShop provides two ways to set up price reductions:

1. **Specific Prices** – Found in the product edit page.
2. **Cart Rules** – Located under **Price Rules → Cart Rules** in the Back Office.

To create a product price reduction:

1. Navigate to **Catalog → Products** in the PrestaShop Back Office.
2. Select the product to edit.
3. Go to the **Prices** tab.
4. Locate the **Specific Prices** section.
5. Set a discounted price that represents the deposit payment.
6. Ensure the original price remains visible to indicate the total cost.

### Example Scenario
- A service originally costs **$100**.
- A **50% deposit ($50)** is required upfront.
- The remaining **$50** is paid when the service is rendered.

In PrestaShop, this setup would display:
- **Current price: $50** (Deposit payment)
- **Old price: $100** (Total cost reference)

## Why This Matters
- **Enables Booking Deposits**: Allows customers to secure their booking with an initial payment.
- **Uses Existing PrestaShop Features**: No need for complex customizations.
- **Improves Customer Transparency**: Shows both the deposit and total cost clearly.
- **Flexible Implementation**: Works for both products and services using price reductions.

For further details, configure price reductions via the **Specific Prices** section in the product edit page or apply **Cart Rules** under **Price Rules → Cart Rules** in the Back Office.
