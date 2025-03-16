# Problem: Setting PrestaShop in Maintenance Mode

## Overview

When performing updates, troubleshooting, or making significant changes to your PrestaShop store, it's often a good idea to temporarily take your store offline to prevent customers from accessing it during these periods. This is where **maintenance mode** comes in handy. Enabling maintenance mode will hide the storefront from your customers while allowing administrators to continue working on the site.

## Why This Is a Problem

Running a live e-commerce store can be complex, and sometimes updates or changes can result in temporary issues that need to be resolved. For example, updating themes, installing modules, or upgrading PrestaShop itself might require taking the store offline for maintenance. Without maintenance mode, customers may encounter incomplete pages or errors, which could negatively affect their experience.

### Benefits of Maintenance Mode:
- **Prevent Customer Access**: Hides the storefront to avoid confusion or issues for customers while you perform maintenance.
- **Continued Admin Access**: Allows administrators to continue working on the site without disruption.
- **Customizable Access**: You can allow access for specific IPs, such as your own, while blocking others.

## Solution

To enable maintenance mode in PrestaShop, we’ll go to the **Back Office** and access the **Preferences** section. From there, we’ll navigate to the **Maintenance** page, which provides a simple interface for turning maintenance mode on or off and controlling who can access the site.

### Step-by-Step Guide to Enable Maintenance Mode

1. **Access the Maintenance Page**:
   - Log in to your PrestaShop Back Office.
   - Go to **Preferences** → **Maintenance** in the left sidebar menu.

2. **Enable Maintenance Mode**:
   - On the Maintenance page, you’ll see the option **Enable Shop**.
   - Set the **Enable Shop** switch to **No** to take your store offline and activate maintenance mode. This will prevent customers from accessing your site.

3. **Control Access for Specific IPs**:
   - Under **Maintenance IP**, you can enter your IP address to allow your connection to access the store even when it’s in maintenance mode.
   - To add your IP address, click the **Add my IP** button. Alternatively, you can manually enter multiple IP addresses, separated by commas, if other administrators or developers need access as well.

4. **Save Your Changes**:
   - Once you've made these changes, your store will be in maintenance mode, and only the specified IP addresses will be able to access the site.

### Example: Activating Maintenance Mode

Here’s an example of how the page might look after you’ve made the necessary changes:

- **Enable Shop**: Set to **No**.
- **Maintenance IP**: Your IP address is listed here (either added manually or by clicking "Add my IP").
- **Add my IP Button**: This allows you to quickly add your current IP address.

Once maintenance mode is enabled, your visitors will see a "Maintenance" message on the storefront, and only users with the specified IP addresses will have access to the Back Office or the live site.

![Maintenance Mode Example](path/to/screenshot-8-2.jpg) *(Include a screenshot for reference)*

## How It Works

Enabling maintenance mode in PrestaShop prevents the store from being visible to customers by disabling the storefront. However, administrators and specified IPs are allowed to continue working on the site. Here’s a breakdown of the key options available:

- **Enable Shop**: This toggle switch controls whether the store is in maintenance mode. Setting it to **No** disables the store for customers.
- **Maintenance IP**: This field allows you to specify IP addresses that are permitted to view the site while it's in maintenance mode. You can add multiple IPs, separated by commas, to grant access to more than one user.
- **Add my IP**: This button automatically adds your current IP address to the list, ensuring you can access the site even during maintenance.

### Example Scenario:

Imagine you're updating the product catalog or applying a security patch. While you work on the store, customers shouldn’t be able to access it, so you set the **Enable Shop** to **No**. However, since you're working on the store, you add your IP address to the **Maintenance IP** field to ensure you can still access the site while it's in maintenance mode.

## Conclusion

Activating maintenance mode in PrestaShop is a straightforward process that ensures your customers won’t be exposed to an incomplete or malfunctioning website. By using the **Maintenance** settings in the Back Office, you can manage store downtime efficiently while still allowing administrators to work on the site. 

### Key Takeaways:
- **Maintenance Mode** hides the store from customers while you're making updates or fixes.
- **IP Access** allows you to continue working on the site even when the store is offline.
- You can control who has access by entering specific IPs in the **Maintenance IP** field.

By using maintenance mode strategically, you can keep your customers informed and ensure that the site is ready for them when it's back online.

Let me know if you need further clarification or assistance with setting up maintenance mode!
