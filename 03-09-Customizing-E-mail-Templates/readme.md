# Customizing Email Templates in PrestaShop

## Problem

By default, PrestaShop email templates contain standard content that may not fully align with your store's branding or messaging. You may want to customize these emails to include new data, enhance their appearance, or provide a better customer experience.

## Solution

PrestaShop allows you to modify email templates directly from the Back Office. By accessing the translation section, you can edit and personalize email templates for different scenarios, such as order confirmations, account creation, and password resets.

## How It Works

### Step 1: Access the Email Templates

1. Log in to your **PrestaShop Back Office**.
2. Navigate to **Localization → Translations**.
3. In the **Modify Translations** section, select:
   - **Type of translation**: "Email templates translations"
   - **Select your theme**: Choose your active theme
   - **Select your language**: Choose the desired language
4. Click the **Modify** button to proceed.

### Step 2: Locate the Email Template to Edit

Once inside the email templates section:

1. Click on **Core Emails** to see a list of essential email templates.
2. Find the email template you want to modify (e.g., `order_conf.html` for order confirmation emails).
3. Click on the template name to open the editor.

### Step 3: Customize the Email Template

- You can edit the **HTML version** to enhance styling and layout.
- You can modify the **TXT version** for plain-text email compatibility.
- To include additional data, use PrestaShop’s available template variables (e.g., `{customer_firstname}`, `{order_reference}`).
- If you need custom variables, ensure they are assigned in the corresponding **Mail::Send()** function in PrestaShop’s PHP files.

### Step 4: Save and Test

1. Click **Save** after making changes.
2. To test, place a sample order or trigger the corresponding email event in PrestaShop.
3. If needed, review email logs under **Advanced Parameters → Email** to troubleshoot issues.

## Conclusion

By following these steps, you can fully customize PrestaShop email templates to include new data, match your branding, and improve communication with customers.

