# Order Confirmation Email Notification Module

## Problem Statement

You want to create a module that sends an email notification to specific recipients when an order has been confirmed. 

This is useful for store owners who need to be notified about order statuses, 
or for notifying other stakeholders, 
such as managers or customer service teams.

## Solution Overview

To solve this problem, 
we will create an "Order Email Notification" module that allows administrators to configure recipient email addresses. 

The module will be linked to the `displayOrderConfirmation` hook, 
which is triggered whenever an order is confirmed. 

This will allow the module to send email notifications to the configured recipients.

## How It Works

### Step 1: Duplicate the Module Structure
We will begin by duplicating the structure of a basic module, which we’ve previously created in this chapter (e.g., Hello World module). This structure will serve as the foundation for the new Order Email Notification module. 

Ensure that you include the following basic files in your module directory:

- `orderemail.php`: The main PHP file for the module logic.
- `logo.gif` (or `logo.png` depending on your PrestaShop version): The module’s logo for the back office.
- `install.sql` (optional): If your module needs to set up tables or configuration, you can define SQL queries here.

### Step 2: Attach the Module to the `displayOrderConfirmation` Hook
PrestaShop provides several hooks that you can attach modules to. In our case, we need to attach the module to the `displayOrderConfirmation` hook, which is triggered when an order is confirmed.

In the `orderemail.php` file, we will define the `install()` method and use the `registerHook()` method to attach our module to the `displayOrderConfirmation` hook.

```php
public function install()
{
    if (parent::install() && $this->registerHook('displayOrderConfirmation')) {
        return true;
    }
    return false;
}
```

### Step 3: Configure Email Recipients

Next, we will create a configuration page where the store owner can enter email addresses to receive order confirmation notifications. This will be done using PrestaShop’s built-in configuration system.

In the getContent() method of the module, we will provide a form that allows the store administrator to input email addresses:

```php
public function getContent()
{
    if (Tools::isSubmit('submit_orderemail')) {
        // Save the email addresses entered by the admin
        Configuration::updateValue('ORDER_EMAIL_RECIPIENTS', Tools::getValue('order_email_recipients'));
    }

    // Retrieve saved email addresses
    $emailRecipients = Configuration::get('ORDER_EMAIL_RECIPIENTS');

    $output = '
    <form method="post">
        <label for="order_email_recipients">Email Recipients:</label>
        <input type="text" name="order_email_recipients" value="' . htmlentities($emailRecipients) . '" />
        <input type="submit" name="submit_orderemail" value="Save" />
    </form>';

    return $output;
}
```

This form will allow the store owner to specify one or more email addresses, separated by commas. These email addresses will be used to send notifications when an order is confirmed.

### Step 4: Send Email Notification When Order is Confirmed

When an order is confirmed, the module will hook into the displayOrderConfirmation event and send an email notification to the configured recipients. In the hookDisplayOrderConfirmation() method, we will send the email using PrestaShop’s Mail class.

```public function hookDisplayOrderConfirmation($params)
{
    $order = $params['order'];

    // Retrieve the list of email recipients from configuration
    $emailRecipients = Configuration::get('ORDER_EMAIL_RECIPIENTS');
    if (!empty($emailRecipients)) {
        $recipients = explode(',', $emailRecipients);

        // Prepare email content
        $subject = 'Order Confirmation: ' . $order->reference;
        $body = 'Order ' . $order->reference . ' has been confirmed.';

        // Send email to each recipient
        foreach ($recipients as $recipient) {
            Mail::Send(
                (int) $this->context->language->id, // Language ID
                'order_confirmation', // Template name
                $subject, // Email subject
                array('{order_reference}' => $order->reference), // Template variables
                $recipient, // Recipient email address
                null, // Recipient name (optional)
                null, // From email address
                null, // From name
                null, // Attachments (optional)
                null, // BCC (optional)
                dirname(__FILE__) . '/mails' // Mail template directory
            );
        }
    }
}
```

In this method:

    We retrieve the configured recipient email addresses from the ORDER_EMAIL_RECIPIENTS configuration setting.
    We use the Mail::Send() method to send the email. The email content is generated using a PrestaShop email template (order_confirmation), and the order reference is passed as a template variable.

### Step 5: Email Template

PrestaShop uses email templates to send formatted emails. You can create your own email template in the mails folder within your module directory. For example, create a file called order_confirmation.html and order_confirmation.txt in the mails folder. The .html file should contain the HTML structure, and the .txt file should provide a plain-text version of the email.

Here’s an example of the order_confirmation.html template:

```
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
</head>
<body>
    <p>Dear Customer,</p>
    <p>Your order <strong>{order_reference}</strong> has been confirmed.</p>
    <p>Thank you for shopping with us!</p>
</body>
</html>
```

### Step 6: Testing the Module

After installing and configuring your module, place a test order on your PrestaShop store. Once the order is confirmed, the configured email recipients should receive a notification with the order details.

## Conclusion

With this module, you can automatically notify specific recipients whenever an order is confirmed on your PrestaShop store. This feature is useful for store owners, managers, and support teams to stay up-to-date with order statuses. The module is fully configurable, allowing email recipients to be updated through the Back Office.

This module also demonstrates how to use PrestaShop hooks, handle module configuration, and send custom emails, which are useful skills for any module developer.