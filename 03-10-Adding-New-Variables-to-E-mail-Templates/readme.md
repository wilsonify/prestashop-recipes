# Adding New Variables to PrestaShop Email Templates

## Problem

PrestaShop email templates use predefined variables, but sometimes you need to include additional information, such as custom data about a customer or order details. However, these new variables are not available by default and must be manually added.

## Solution

To customize email templates with new variables, we will:
1. Modify the **AuthController.php** file to add new variables to the customer account creation email.
2. Extend this approach to the **order confirmation email** by modifying the relevant controller.

## How It Works

### Step 1: Adding a New Variable to the Account Email

#### 1. Override `AuthController.php`

To modify the email template for new customer registrations, copy the **AuthController.php** file into the override directory:

```
override/controllers/front/AuthController.php
```

#### 2. Modify `sendConfirmationMail()` Method

Locate the `sendConfirmationMail()` method at the end of the `AuthController.php` file and update it to include a new variable:

```php
protected function sendConfirmationMail(Customer $customer)
{
    if (!Configuration::get('PS_CUSTOMER_CREATION_EMAIL')) {
        return true;
    }
    
    $extra_data = 'Your custom data here'; // Example custom variable
    
    return Mail::Send(
        $this->context->language->id,
        'account',
        Mail::l('Welcome!'),
        array(
            '{firstname}' => $customer->firstname,
            '{lastname}' => $customer->lastname,
            '{email}' => $customer->email,
            '{custom_variable}' => $extra_data, // Adding the new variable
        ),
        $customer->email,
        $customer->firstname . ' ' . $customer->lastname
    );
}
```

#### 3. Update the Email Template

Navigate to **Localization → Translations** in the PrestaShop Back Office, select **Email templates translations**, choose your theme and language, then modify the `account.html` template to include:

```html
<p>Custom data: {custom_variable}</p>
```

### Step 2: Adding a New Variable to the Order Confirmation Email

#### 1. Override `PaymentModule.php`

For order confirmation emails, edit the `PaymentModule.php` file:

```
override/classes/PaymentModule.php
```

#### 2. Modify `validateOrder()` Method

Locate the `validateOrder()` method and add the new variable:

```php
$data = 'Extra order info';

Mail::Send(
    (int)$order->id_lang,
    'order_conf',
    Mail::l('Order confirmation', (int)$order->id_lang),
    array(
        '{order_reference}' => $order->reference,
        '{total_paid}' => Tools::displayPrice($order->total_paid, $this->context->currency),
        '{custom_order_variable}' => $data, // Adding the new variable
    ),
    $customer->email,
    $customer->firstname . ' ' . $customer->lastname
);
```

#### 3. Update the Order Confirmation Email Template

Edit the `order_conf.html` template in **Email templates translations** and insert:

```html
<p>Extra Order Info: {custom_order_variable}</p>
```

## Conclusion

By following these steps, you can successfully add custom variables to PrestaShop email templates. This allows you to display additional information, improving communication with customers and personalizing email content.

