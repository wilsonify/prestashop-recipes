<?php
// Define the module name and folder paths
$moduleName = 'orderemail';
$moduleDir = __DIR__ . '/modules/' . $moduleName;

// 1. Create the Module Folder Structure
$directories = [
    $moduleDir,
    $moduleDir . '/mails',
    $moduleDir . '/views/templates/hook',
];

// Create directories
foreach ($directories as $dir) {
    if (!file_exists($dir)) {
        mkdir($dir, 0777, true);
        echo "Created directory: $dir\n";
    }
}

// 2. Create the Main Module PHP File (orderemail.php)
$modulePhpContent = <<<'PHP'
<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class OrderEmail extends Module
{
    const EMAIL_RECIPIENTS = 'ORDER_EMAIL_RECIPIENTS';

    public function __construct()
    {
        $this->name = 'orderemail';
        $this->tab = 'email';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->displayName = $this->l('Order Confirmation Email Notification');
        $this->description = $this->l('Sends an email notification when an order is confirmed.');

        parent::__construct();
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
            // Save the email addresses entered by the admin
            Configuration::updateValue(self::EMAIL_RECIPIENTS, Tools::getValue('order_email_recipients'));
        }

        // Retrieve saved email addresses
        $emailRecipients = Configuration::get(self::EMAIL_RECIPIENTS);

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
        $order = $params['order'];

        // Retrieve the list of email recipients from configuration
        $emailRecipients = Configuration::get(self::EMAIL_RECIPIENTS);
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
}
PHP;

file_put_contents($moduleDir . '/orderemail.php', $modulePhpContent);
echo "Created orderemail.php file in $moduleDir\n";

// 3. Create the Email Template (order_confirmation.html)
$emailTemplateHtml = <<<'HTML'
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
HTML;

file_put_contents($moduleDir . '/mails/order_confirmation.html', $emailTemplateHtml);
echo "Created order_confirmation.html template in $moduleDir/mails\n";

// 4. Create the Plain Text Email Template (order_confirmation.txt)
$emailTemplateText = <<<'TEXT'
Dear Customer,

Your order {order_reference} has been confirmed.

Thank you for shopping with us!
TEXT;

file_put_contents($moduleDir . '/mails/order_confirmation.txt', $emailTemplateText);
echo "Created order_confirmation.txt template in $moduleDir/mails\n";

// 5. Create the Module Logo (logo.gif or logo.png)
$logoImagePath = $moduleDir . '/logo.gif';
$img = imagecreatetruecolor(100, 100);
$white = imagecolorallocate($img, 255, 255, 255);
imagefilledrectangle($img, 0, 0, 100, 100, $white);
imagegif($img, $logoImagePath);
echo "Created placeholder logo.gif in $moduleDir\n";

// 6. Output success message
echo "Module '$moduleName' has been successfully created and is ready for installation!\n";
?>
