# Enhancing Order Confirmation Email Notifications

## Problem Statement
You want to add more detailed information, such as the total amount to be paid and the customer's name, to the email notifications sent after an order confirmation.

## Solution Overview
In a previous recipe, we created a module that sends email notifications when an order is confirmed. However, you may want to include more detailed information, such as the total amount to be paid and the customer's name, in those email notifications. The solution to this problem involves leveraging the `$params` input variable in the `hookDisplayOrderConfirmation()` method to access the additional details and include them in the email.

## How It Works

### Step 1: Understand the `$params` Input Variable
When creating modules that hook into PrestaShop’s core functions, it’s important to understand the `$params` variable passed into the hook methods. This variable contains all the relevant data associated with the event being triggered.

For example, in the `displayOrderConfirmation` hook, the `$params` variable contains information about the order that has been confirmed, such as the order object, customer details, total amount, and more.

### Step 2: Investigate the `displayOrderConfirmation` Hook
To see exactly what information is available to us in the `$params` variable, we need to review the file where the `displayOrderConfirmation` hook is defined.

The hook `displayOrderConfirmation` is triggered in the `OrderConfirmationController.php` file, located in the `/controllers/front/` directory. Let’s examine the end of the file to understand how the `$params` variable is populated and what data it includes.

Here’s an example of how the `displayOrderConfirmation` hook is defined:

```php
// OrderConfirmationController.php
public function displayOrderConfirmation($order)
{
    $params = [
        'order' => $order, // Order object with all details
        'customer_name' => $order->getCustomer()->firstname . ' ' . $order->getCustomer()->lastname, // Full customer name
        'total_amount' => $order->getTotalPaid() // Total amount to be paid
    ];

    // Trigger the hook and pass the parameters
    Hook::exec('displayOrderConfirmation', $params);
}
```

This shows that the $params array includes:

    The order object, which contains all the order details.
    The customer's name, constructed by concatenating the first and last name.
    The total amount to be paid, retrieved using the getTotalPaid() method.

### Step 3: Modify the Module to Include Additional Information

Now that we know what data is available in the $params variable, we can modify our module to include this additional information in the email notification.

In the hookDisplayOrderConfirmation() method of our module, we will access the details from the $params variable and include them in the email. Here’s how we can do it:

```
public function hookDisplayOrderConfirmation($params)
{
    // Extract information from the $params variable
    $order = $params['order'];
    $customerName = $params['customer_name'];
    $totalAmount = $params['total_amount'];

    // Retrieve the list of email recipients from configuration
    $emailRecipients = Configuration::get('ORDER_EMAIL_RECIPIENTS');
    if (!empty($emailRecipients)) {
        $recipients = explode(',', $emailRecipients);

        // Prepare the subject and email body with additional information
        $subject = 'Order Confirmation: ' . $order->reference;
        $body = 'Hello ' . $customerName . ',<br>';
        $body .= 'Your order <strong>' . $order->reference . '</strong> has been confirmed.<br>';
        $body .= 'Total amount to be paid: ' . $totalAmount . '.<br>';
        $body .= 'Thank you for shopping with us!';

        // Send email to each recipient
        foreach ($recipients as $recipient) {
            Mail::Send(
                (int) $this->context->language->id, // Language ID
                'order_confirmation', // Template name
                $subject, // Email subject
                array(
                    '{order_reference}' => $order->reference,
                    '{customer_name}' => $customerName,
                    '{total_amount}' => $totalAmount
                ), // Template variables
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
}```

In this code:

    We extract the order details, customer name, and total amount from the $params variable.
    We use these values to construct a personalized email body that includes the customer’s name, order reference, and the total amount to be paid.
    The email is sent to the recipients configured in the module, using PrestaShop's Mail::Send() method.

### Step 4: Modify the Email Template

Now that we are passing the additional information (such as customer name and total amount) to the email template, we also need to ensure that the email template is designed to handle and display these new variables.

In the mails folder of your module, ensure that the email template (order_confirmation.html and order_confirmation.txt) includes placeholders for the new variables. For example:

order_confirmation.html:

```
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
</head>
<body>
    <p>Hello {customer_name},</p>
    <p>Your order <strong>{order_reference}</strong> has been confirmed.</p>
    <p>Total amount to be paid: {total_amount}</p>
    <p>Thank you for shopping with us!</p>
</body>
</html>
```
order_confirmation.txt:

Hello {customer_name},

Your order {order_reference} has been confirmed.

Total amount to be paid: {total_amount}

Thank you for shopping with us!

### Step 5: Test the Enhanced Email

After modifying the module and email templates, you can place a test order and confirm it. Once the order is confirmed, the email should include the enhanced information, such as the customer’s name and the total amount to be paid.

## Conclusion

By leveraging the $params input variable in the hookDisplayOrderConfirmation() method, you can include more detailed information in your order confirmation email notifications. This makes the notifications more informative and personalized for both the store owner and the customer.

With this enhancement, you can now provide better insights into the order status directly within the confirmation emails, which is beneficial for store management and customer communication.

