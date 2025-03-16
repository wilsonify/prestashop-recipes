<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class OrderEmail extends Module
{
    public function __construct()
    {
        $this->name = 'orderemail';
        $this->tab = 'email';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->need_instance = 0;

        parent::__construct();

        $this->displayName = $this->l('Order Email Notifications');
        $this->description = $this->l('Send enhanced order confirmation emails with additional details like customer name and total amount.');
    }

    public function install()
    {
        if (parent::install() && $this->registerHook('displayOrderConfirmation')) {
            return true;
        }
        return false;
    }

    public function getContent()
    {
        if (Tools::isSubmit('submit_orderemail')) {
            Configuration::updateValue('ORDER_EMAIL_RECIPIENTS', Tools::getValue('order_email_recipients'));
        }

        $emailRecipients = Configuration::get('ORDER_EMAIL_RECIPIENTS');

        $output = '
        <form method="post">
            <label for="order_email_recipients">Email Recipients:</label>
            <input type="text" name="order_email_recipients" value="' . htmlentities($emailRecipients) . '" />
            <input type="submit" name="submit_orderemail" value="Save" />
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
        $emailRecipients = Configuration::get('ORDER_EMAIL_RECIPIENTS');
        if (!empty($emailRecipients)) {
            $recipients = explode(',', $emailRecipients);

            // Prepare email content with enhanced information
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
    }
}
s