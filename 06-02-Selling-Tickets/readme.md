# Problem: Selling a Limited Number of Tickets for Events

## Overview

When managing events-based products in PrestaShop, it’s essential to provide an option to sell a **limited number of tickets** for each event date. Without this, you may accidentally oversell tickets, causing confusion and dissatisfaction among customers. Additionally, not managing stock for events could lead to logistical problems, like double-booking or overselling a date when the capacity is reached.

To solve this, we need to configure PrestaShop to manage a fixed quantity of tickets per event date and prevent selling more than the available tickets.

## Why This Is a Problem

Without stock management for event tickets, you might run into the following issues:

- **Overselling tickets**: This is a common problem when there is no restriction on how many people can select a specific event date.
- **Customer confusion**: If customers can select dates for which the tickets have already sold out, it may lead to dissatisfaction and a poor user experience.
- **Operational issues**: Managing customer expectations can become difficult without clear stock management for each event date.

By configuring PrestaShop to sell a fixed number of tickets for each event date, you can avoid these issues and provide a smoother experience for your customers.

## Solution

To implement this solution, we will make the following changes:

1. **Allow orders for out-of-stock products**: By enabling this setting, you can still sell event tickets even when a specific date is sold out.
2. **Modify the `product.tpl` file**: We will customize the product page to show "Tickets" instead of "Quantity" and remove irrelevant details like product conditions.
3. **Manage stock for each date**: For each event date (defined by the Date attribute), we will specify a limited number of tickets available for purchase.

### Steps to Implement the Solution

1. **Allow Orders for Out-of-Stock Products**

   First, configure PrestaShop to allow orders even if a product is out of stock:

   - Go to the **Back Office**.
   - Navigate to **Preferences > Products**.
   - Under **Stock management**, enable the option to allow orders when the product is out of stock.
   
   This ensures that customers can still purchase event tickets even if the stock for a particular event date is technically "sold out." PrestaShop will allow customers to place an order but will display an out-of-stock message.

   > **Note**: This step is necessary if you want to sell tickets after an event date has been reached or provide backordering options (if applicable).

2. **Modify the Product Page (product.tpl)**

   To create the illusion of an event-based product, we will make some changes to the product page template:

   - In your theme’s `product.tpl` file, make the following modifications:
     - Hide the "Condition" text, as it's irrelevant for event tickets.
     - Change the text "Quantity" to "Tickets" to make it clear that the user is purchasing tickets, not a regular product.

   Example modification in `product.tpl`:

   ```html
   {if $product->available_for_order}
     <p>{l s='Tickets'}</p>
   {else}
     <p>{l s='Sold out'}</p>
   {/if}

These changes will make the product page feel more like an event product and less like a typical physical product.

    Manage Ticket Quantities in the Back Office

    Now, let’s configure how many tickets you want to sell for each event date:
        Go to Catalog > Products in the PrestaShop Back Office.
        Open the product for which you want to sell tickets.
        Navigate to the Combinations tab.
        For each Date attribute (representing a specific event date), you can set the Quantity field to the number of tickets you want to sell for that particular date.

    Example:
        For March 25, 2025, you may set the available stock to 50 tickets.
        For April 1, 2025, you may set the available stock to 30 tickets.

    This stock management will restrict the number of tickets sold for each event date, ensuring that no more than the specified number of tickets can be purchased for each date.

    Customize Date Attribute Values (Combinations)

    If you have multiple event dates, you will have multiple combinations, each with its own stock. Ensure that the combinations reflect the correct dates, and set the stock accordingly.

    For instance:
        Create a combination for each date with its respective quantity (number of tickets available).
        PrestaShop will treat these combinations like distinct products, with each having its own availability.

How It Works

By allowing orders when products are out of stock, PrestaShop will still process tickets for sold-out dates (with the appropriate stock warning). When customers view the product, they can select an available event date from the combinations and proceed with the purchase.

In the Combinations section, PrestaShop will treat each Date attribute as a separate combination, each with its own stock. For example, if you are selling 50 tickets for March 25, PrestaShop will allow only 50 tickets to be purchased for that date.
Example:

    Event Product: "Art Class - Painting Workshop"
    Available Dates:
        March 25, 2025 (50 tickets available)
        April 1, 2025 (30 tickets available)

The customer will select the date they want, and the product page will show the number of available tickets (if they are still in stock). Once the stock for a particular date is sold out, customers will no longer be able to select that date.
Conclusion

By following these steps, you can easily configure PrestaShop to sell a limited number of tickets for each event date. This solution prevents overselling, provides clarity for customers, and creates an events-based product experience.

These changes transform your PrestaShop store into an effective tool for managing event-based products, making it easy for customers to select their preferred event date while ensuring you don’t exceed ticket availability.

Feel free to further customize the template or stock management process to fit your event needs.

If you have any questions or need additional assistance, don't hesitate to reach out!