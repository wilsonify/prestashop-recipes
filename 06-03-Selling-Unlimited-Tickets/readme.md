# Problem: Selling Unlimited Tickets for Your Event

## Overview

When managing events-based products, there may be situations where you want to sell **unlimited tickets** for your event. Unlike physical products, you might not want to manage stock for tickets. Instead, you want to offer tickets without worrying about running out of stock, effectively creating an infinite number of tickets available for each event date.

This can be especially useful for events where the capacity is not constrained by physical space or inventory, such as online webinars or digital events.

## Why This Is a Problem

Without the ability to sell an unlimited number of tickets, you might face issues such as:

- **Stock management**: For events with a theoretically unlimited capacity, keeping track of stock for each date may not make sense. Managing quantities for virtual events or open-access sessions is redundant.
- **Overcomplicated process**: Handling stock for events with unlimited capacity can unnecessarily complicate the purchasing process and lead to confusion for customers.
- **Need for flexibility**: If you want the ability to sell more tickets without limits, you need an efficient solution that doesn’t rely on the traditional stock system.

To solve this, we need to modify the way PrestaShop handles ticket sales for events so that stock management is either disabled or unnecessary.

## Solution

There are a couple of approaches to selling unlimited tickets for your event:

1. **Treat the event as a virtual product**: Virtual products in PrestaShop do not have stock quantities. This allows you to bypass the need to manage stock while still offering event tickets as a product. You will still need combinations (Date attribute) for different event dates.
   
2. **Disable stock management entirely**: If you prefer to continue using combinations for your event dates but don’t want to manage stock levels, you can disable stock management in the PrestaShop back office.

### Steps to Implement the Solution

#### Option 1: Use Virtual Products for Unlimited Tickets

1. **Create a Virtual Product for Your Event**
   - Go to the **Back Office**.
   - Navigate to **Catalog > Products**.
   - Create a new product and choose the **Virtual product** option (this will make the product not require stock management).
   
   > Virtual products are useful for selling digital goods or services, such as tickets, where no physical inventory is required. Since tickets for events can be infinite in number, this solution is ideal for handling unlimited ticket sales.

2. **Add Combinations for Event Dates**
   - Once you’ve set the product as a virtual one, navigate to the **Combinations** tab.
   - Create a **Date attribute** (if not already created) for the event, which will allow customers to choose the date for which they want to buy a ticket.
   
   > You can refer to Chapter 4 for more details on how to enable combinations for virtual products.

3. **Configure the Product for Unlimited Sales**
   - Since this is a virtual product, there will be no quantity limit. The system will not track stock, and customers can purchase as many tickets as they want.

#### Option 2: Disable Stock Management

If you prefer not to use virtual products but still want to offer unlimited tickets, you can disable stock management for the event product.

1. **Go to the Product Settings in the Back Office**
   - In the **Back Office**, navigate to **Preferences > Products**.
   - Here, you can disable **Stock Management** entirely. This will prevent PrestaShop from tracking stock levels for your event products.

   ![Stock management disabled](link_to_image/figure6-9.png)

2. **Configure the Product for Unlimited Sales**
   - Now, you can proceed with setting up combinations for your event, such as available event dates.
   - Since stock management is disabled, customers will be able to buy tickets for any event date without the system limiting the number of tickets based on availability.

### How It Works

Both solutions will allow you to sell unlimited tickets for your event. Here’s a breakdown of how each option works:

- **Option 1 (Virtual Product)**: This option removes the need for stock management by treating the event product as a virtual product. You can still offer event dates as combinations (via the Date attribute), and customers can choose the date they want without worrying about stock. There is no limitation on how many tickets can be sold, making it perfect for events with unlimited capacity.
  
- **Option 2 (Disable Stock Management)**: This option allows you to keep your event product as a regular (non-virtual) product but without stock limitations. By disabling stock management in the PrestaShop settings, the system won’t track quantities for tickets, thus allowing for unlimited sales for each event date.

### Example:

- **Event Product**: "Virtual Cooking Class"
- **Available Dates**: 
  - March 25, 2025 (Unlimited tickets)
  - April 1, 2025 (Unlimited tickets)

By using either of the above solutions, customers can freely select an event date and purchase tickets without the system imposing any quantity limits.

## Conclusion

By following either of these approaches, you can easily configure PrestaShop to sell unlimited tickets for your event. These solutions eliminate the need for stock management, allowing you to focus on managing the event itself rather than worrying about ticket availability.

- **Option 1** (Virtual Product) is ideal if you prefer to keep the event product as a digital good without tracking stock.
- **Option 2** (Disable Stock Management) is suitable if you want to continue using combinations but don’t want to manage ticket quantities.

Both approaches will ensure your event tickets are available for an unlimited number of customers and dates, simplifying your ticket-selling process.

Feel free to reach out if you have any questions or need further guidance on implementing these solutions!
