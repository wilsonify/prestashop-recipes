# Changing Your PrestaShop Domain in the Database

## Problem
You need to change your PrestaShop shop's domain, but accessing the Back Office is not an option. This situation can arise when migrating your website to a new hosting provider, changing domain names, or recovering from a system issue where the Back Office is inaccessible.

## Solution
When the Back Office is accessible, you can change the shop’s domain by navigating to:

**Preferences → SEO & URLs**

However, if the Back Office is inaccessible, the shop’s URL must be changed directly in the database. This requires modifying specific database entries using a tool like phpMyAdmin.

## How It Works
Let's assume PrestaShop is installed locally and currently runs under:

```
localhost/prestashop
```

We want to change it to:

```
localhost:8181/prestashop
```

To achieve this, we need to update two entries in the **ps_configuration** table within the database.

### Steps to Change the Domain via phpMyAdmin:
1. **Access phpMyAdmin** – Open phpMyAdmin from your hosting control panel or local server (e.g., WAMP, XAMPP).
2. **Select Your Database** – Locate and open the PrestaShop database.
3. **Modify the Configuration Table** – Find the `ps_configuration` table and look for the following entries:
   - `PS_SHOP_DOMAIN`
   - `PS_SHOP_DOMAIN_SSL`
4. **Edit Values** – Update both entries with the new domain (e.g., `localhost:8181/prestashop`).
5. **Save Changes** – Click "Save" or "Go" to apply modifications.
6. **Clear Cache** – Delete the `/var/cache/prod` and `/var/cache/dev` directories in your PrestaShop installation to ensure the changes take effect.

After completing these steps, your PrestaShop store should now be accessible under the new domain.

If you encounter issues, verify that your web server and database are correctly configured and restart your local server if needed.


