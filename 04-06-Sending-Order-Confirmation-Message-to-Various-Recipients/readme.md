# Sending Order Confirmation Emails to Multiple Recipients

## Problem Overview

You want to send Order Confirmation emails, which customers typically receive after making a purchase on your PrestaShop website, to additional recipients—such as admins, sales teams, or other stakeholders.

## Solution

There are two main approaches for achieving this:

### Option 1: Use the Mail Alerts Module

The Mail Alerts module is a free PrestaShop module that allows you to send email notifications to multiple recipients when specific events occur on your store, such as when a new order is placed. This is a simple way to receive notifications without modifying any core files.

#### Steps to Set Up the Mail Alerts Module:
1. **Install the Mail Alerts Module**:
   - Navigate to **Modules > Module Manager** in the PrestaShop Back Office.
   - Search for the **Mail Alerts** module and click **Install**.
   
2. **Configure Email Notifications**:
   - Once installed, go to **Modules > Mail Alerts**.
   - Configure the email addresses where you want to receive notifications. You can specify multiple email addresses.
   - Set the event trigger for the notifications (for instance, a new order being placed).

**Important Note**:  
The Mail Alerts module uses its own email template, which differs from the default Order Confirmation email template in PrestaShop. If you configure the **Order Confirmation template** in the PrestaShop Back Office, you may find that some information is missing or formatted differently in the emails sent through this module.

![Figure 4-10: Order Confirmation Email Template](#)  
_Example of the Order Confirmation email template in the PrestaShop Back Office._

### Option 2: Modify the `PaymentModule.php` File to Send Notifications

If you prefer to use PrestaShop's default Order Confirmation email template and send it to additional recipients (such as admins or managers), you can directly modify the `PaymentModule.php` file. This approach ensures that the default template is used and that notifications are sent to multiple recipients.

#### Steps to Modify the `PaymentModule.php` File:
1. **Override the `PaymentModule.php` File**:
   - It's recommended to **override** the `PaymentModule.php` file to avoid modifying core files.
   - To do this, copy the original file from the `classes/` folder to the `override/classes/` folder.

2. **Edit the `validateOrder()` Method**:
   The `validateOrder()` method in the `PaymentModule.php` file is responsible for validating orders. You will need to edit this method to send the Order Confirmation email to multiple recipients.

**Example Code for `validateOrder()` Method**:

```php
public function validateOrder($id_cart, $id_currency, $total_paid, $payment_method, $message = null)
{
    // Original order validation logic...

    // Send confirmation email to customer
    $order = new Order($this->currentOrder);
    $customer = new Customer($order->id_customer);

    // Send order confirmation to customer
    Mail::Send(
        (int)$order->id_lang,
        'order_conf',
        Mail::l('Order Confirmation'),
        array(
            '{firstname}' => $customer->firstname,
            '{lastname}' => $customer->lastname,
            '{email}' => $customer->email,
            '{order_name}' => $order->reference
        ),
        $customer->email,
        null,
        null,
        null
    );

    // Send order confirmation to admin (or additional recipients)
    $admin_email = 'admin@example.com'; // Change this to your admin email
    Mail::Send(
        (int)$order->id_lang,
        'order_conf',
        Mail::l('New Order Received'),
        array(
            '{firstname}' => $customer->firstname,
            '{lastname}' => $customer->lastname,
            '{email}' => $customer->email,
            '{order_name}' => $order->reference
        ),
        $admin_email,
        null,
        null,
        null
    );
}
```


In this example:

    The validateOrder() method sends the Order Confirmation email to both the customer and the admin.
    The email to the admin uses the same order_conf template as the customer email, but can be customized with a different subject (e.g., "New Order Received").

Step-by-Step Breakdown:

    Step 1: Copy PaymentModule.php from classes/ to override/classes/.
    Step 2: Modify the validateOrder() method to include additional email recipients (such as the admin).
    Step 3: Customize the Mail::Send() function to send the Order Confirmation email to both the customer and the additional recipients.
    Step 4: Test the functionality by placing a new order to ensure the email is sent to both the customer and the admin.

### Conclusion

To send Order Confirmation emails to multiple recipients in PrestaShop, you have two primary options:

    Mail Alerts Module: This is a quick and easy solution, but it uses a different email template than the default Order Confirmation email template.
    Modify PaymentModule.php: This option allows you to use PrestaShop's default Order Confirmation email template and send it to multiple recipients. It requires modifying the core files but offers more control over the process.

Choose the method that best fits your needs. If you're comfortable making code modifications, Option 2 provides a more flexible solution. If you prefer a simpler approach without modifying any core files, Option 1 is a great choice.