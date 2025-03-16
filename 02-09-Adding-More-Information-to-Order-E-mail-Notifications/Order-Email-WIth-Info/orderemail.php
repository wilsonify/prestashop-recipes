<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class OrderEmail extends Module
{
    const ORDER_EMAIL_RECIPIENTS = 'ORDER_EMAIL_RECIPIENTS';

    public function __construct()
    {
        $this->name = 'orderemail';
        $this->tab = 'email';
        $this->version = '1.1.0';  // Updated version
        $this->author = 'Your Name';
        $this->need_instance = 0;

        parent::__construct();

        $this->displayName = $this->l('Order Email Notifications');
        $this->description = $this->l('Send enhanced order confirmation emails with additional details like customer name and total amount.');
    }

    public function install()
    {
        return parent::install() && $this->registerHook('displayOrderConfirmation');
    }

    public function getContent()
    {
        // Handle form submission
        if (Tools::isSubmit('submit_orderemail')) {
            $emailRecipients = Tools::getValue('order_email_recipients');
            // Sanitize input to prevent XSS or other vulnerabilities
            $emailRecipients = Tools::sanitize($emailRecipients);
            // Validate email format and store value
            if (filter_var($emailRecipients, FILTER_VALIDATE_EMAIL)) {
                Configuration::updateValue(self::ORDER_EMAIL_RECIPIENTS, $emailRecipients);
                $this->confirmations[] = $this->l('Settings have been updated.');
            } else {
                $this->errors[] = $this->l('Please enter a valid email address.');
            }
        }

        // Retrieve saved email recipients
        $emailRecipients = Configuration::get(self::ORDER_EMAIL_RECIPIENTS);

        // Form for managing email recipients
        $output = '
        <form method="post">
            <label for="order_email_recipients">' . $this->l('Email Recipients') . ':</label>
            <input type="email" name="order_email_recipients" value="' . htmlentities($emailRecipients) . '" />
            <input type="submit" name="submit_orderemail" value="' . $this->l('Save') . '" />
        </form>';

        return $output;
    }

    public function hookDisplayOrderConfirmation($params)
    {
        // Extract order details from the $params variable
        $order = $params['order'];
        $customerName = $params['customer_name'];
        $totalAmount = $params['total_amount'];

        // Retrieve the list of email recipients from configuration
        $emailRecipients = Configuration::get(self::ORDER_EMAIL_RECIPIENTS);
        if (!empty($emailRecipients)) {
            // Multiple recipients support
            $recipients = explode(',', $emailRecipients);
            $subject = 'Order Confirmation: ' . $order->reference;

            // Prepare email content with enhanced information
            $body = 'Hello ' . $customerName . ',<br>';
            $body .= 'Your order <strong>' . $order->reference . '</strong> has been confirmed.<br>';
            $body .= 'Total amount to be paid: ' . $totalAmount . '.<br>';
            $body .= 'Thank you for shopping with us!';

            // Send email to each recipient
            foreach ($recipients as $recipient) {
                $recipient = trim($recipient); // Remove extra spaces
                if (filter_var($recipient, FILTER_VALIDATE_EMAIL)) {
                    $this->sendOrderEmail($recipient, $subject, $body, $order, $customerName, $totalAmount);
                } else {
                    $this->errors[] = $this->l("Invalid email address: $recipient");
                }
            }
        }
    }

    private function sendOrderEmail($recipient, $subject, $body, $order, $customerName, $totalAmount)
    {
        // Send email using the PrestaShop Mail class
        if (!Mail::Send(
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
        )) {
            $this->errors[] = $this->l('Failed to send email to: ' . $recipient);
        }
    }
}
