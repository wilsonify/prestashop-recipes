# Selling Services as Virtual Products in PrestaShop

## Problem Statement
You want to sell services instead of tangible products on your PrestaShop store. Unlike physical products, services don’t require a warehouse, specific quantities, or a shipping process. However, PrestaShop treats products as either physical or virtual, and services fall into the virtual product category. 

The challenge is managing these services with flexibility, especially when certain attributes, such as pricing variations, need to be applied based on customer selections.

## Solution Overview
PrestaShop treats services as **virtual products**, which simplifies the process by removing the need for shipping details, inventory tracking, or quantities. To set a product as a virtual one, you simply mark it as a "virtual product" in the product creation page. However, this solution comes with limitations—specifically, the loss of the **Combinations** feature.

The **Combinations** feature is important for services where the price might vary depending on specific attributes selected by the customer, such as booking time, service level, or special conditions. For example, a service like a **Tour of Havana in an American Classic Car** might be priced at $60, but selecting the **Guided Service** attribute could increase the price to $75. In this case, the **Combinations** feature is essential to manage these price variations effectively.

## How It Works
When you set a product as virtual in PrestaShop:
- The **Shipping** tab disappears from the product settings, which makes sense for intangible items like services.
- However, the **Combinations** tab also disappears, which limits your ability to offer dynamic pricing based on attributes like time, place, or extra services (e.g., guided tours, premium services, etc.).

### Problem with the Current Setup
The disappearance of the **Combinations** tab means you lose the ability to create variable pricing based on customer-selected attributes, which is a significant limitation for selling services, bookings, or similar items that depend on various factors. 

## Recommended Solution
A better approach for handling services, bookings, or other non-tangible products in PrestaShop is to:
1. **Create products as standard physical products** (not virtual).
2. **Disable the shipping option** for these products, ensuring that they aren't treated as physical items that require delivery.
3. **Build a custom PrestaShop theme** that hides all traces of shipping, making the shopping experience seamless for customers.
4. **Modify necessary email templates** to reflect the nature of services or bookings instead of physical products.

By using standard products with disabled shipping, you can still leverage the full range of features in PrestaShop, including combinations, and create flexible pricing models for your services.

## Conclusion
While PrestaShop offers a way to treat services as virtual products, using this approach can restrict your ability to offer dynamic pricing based on customer-selected attributes. The recommended solution involves treating services as standard products, disabling shipping, and customizing your theme to reflect the nature of services. In the following chapters, we will walk through this process step by step, offering practical recipes for setting up and customizing services on your PrestaShop store.
