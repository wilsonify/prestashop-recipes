# Problem: Displaying Balance Due in Order Confirmation Emails

## Overview

In many e-commerce systems, it's important to clearly communicate the financial details of an order to the customer. One crucial piece of this information is the **balance due**—the amount the customer still owes after completing their order. Without this information, customers may feel uncertain about their payment status, leading to confusion or potential customer service issues.

This issue arises because the order confirmation emails do not include a detailed breakdown of the balance due. Instead, they might only mention the total cost or payment method, leaving out key details that can affect a customer’s understanding of the transaction.

## Why This Is a Problem

Customers expect transparency when it comes to financial transactions. If the **balance due** isn't clearly indicated, customers may:

- **Misunderstand their payment status**: A customer may think their order has been fully paid, only to realize later that they still owe an amount.
- **Need to contact support for clarification**: This increases the burden on your customer support team and can create delays in processing orders.
- **Have a poor experience**: A lack of clear communication could lead to dissatisfaction, especially if customers are unsure about what they still owe after completing their order.

In order to prevent these issues, it's necessary to update the system to display the **balance due** in the order confirmation email.

## Solution

To solve this problem, we’ll modify the `PaymentModule` class. Specifically, we’ll update the `validateOrder()` method in the `PaymentModule.php` file. By adding a small piece of code to this method, we can ensure that the **balance due** is displayed in the order confirmation emails sent to customers.

### Steps to Implement the Solution

1. **Locate the File**  
   Open the `PaymentModule.php` file, which can be found in the `classes/` directory of your project.

2. **Find the validateOrder() Method**  
   Within the file, locate the `validateOrder()` method. This method is responsible for validating the payment and confirming the order.

3. **Add the Code for Balance Due**  
   Around line 383 of the `validateOrder()` method, add the following code to include the balance due in the order confirmation email. 

   ```php
   // Listing 5-22: Code to add balance due to order confirmation email
   $balanceDue = $order->total_amount - $order->amount_paid;
   $this->context->smarty->assign('balance_due', $balanceDue);
