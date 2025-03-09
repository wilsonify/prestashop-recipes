# Disabling Shipping for Standard Products in PrestaShop

## Problem Statement
You want to disable shipping for certain standard products, such as booking services or digital products, that do not require shipping. PrestaShop typically expects all physical products to have shipping details, but for services or non-shippable items, you need a workaround to bypass this requirement.

## Solution Overview
To disable shipping for a product in PrestaShop, you can create a **Free Shipping** carrier and set it as the only available carrier for that product. This ensures that shipping costs do not apply, while still allowing the product to be processed through the checkout process.

### Why This Works:
By creating a carrier that is marked as "free," PrestaShop will recognize it as a non-shippable product. This prevents shipping options from being shown during checkout, simplifying the experience for customers purchasing non-tangible goods or services.

## Steps to Disable Shipping

1. **Create a Free Shipping Carrier**:
   - Log in to your PrestaShop **Back Office**.
   - Navigate to **Shipping** > **Carriers** in the left-hand menu.
   - In the top right corner, click **Add New Carrier**.

2. **Configure the Carrier**:
   - Create a new carrier called **Free Shipping** or any name that reflects the non-shippable nature of the product.
   - Set this carrier to have **Free Shipping** for all products.

3. **Assign the Carrier to the Product**:
   - Go to the **Products** section in your PrestaShop Back Office.
   - For each product that doesn’t require shipping (e.g., services or bookings), edit the product settings.
   - In the **Shipping** tab of the product page, set the carrier to **Free Shipping** (or the carrier you created).
   
   By doing this, you ensure that no shipping options are presented at checkout for those specific products.

4. **Alternative: Single Free Carrier for All Products**:
   - If none of your products require shipping, you can simplify the process by leaving a single carrier named **Free** and applying it to all your products.

## How It Works
Once you have set the **Free Shipping** carrier for the relevant products, PrestaShop will treat these items as non-shippable during the checkout process. Customers won’t be prompted to select a shipping method for these products, ensuring a smoother and more accurate shopping experience.

### Key Benefits:
- **Simplified Checkout**: Customers buying non-shippable items won’t need to worry about shipping options.
- **Easy Management**: You can control which products have shipping enabled by simply assigning them to the appropriate carrier.

## Conclusion
Disabling shipping for products that don’t require delivery, such as services or bookings, is straightforward in PrestaShop. By creating a **Free Shipping** carrier and assigning it to the relevant products, you can ensure a seamless experience for your customers without unnecessary shipping steps. This method is especially useful for digital products, services, and other non-physical items.

---
