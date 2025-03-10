# Adding Custom Social Links to the PrestaShop Social Networking Module

## Problem

By default, PrestaShop's Social Links module allows you to add links to popular social media platforms in the footer. However, it does not support certain platforms, such as TripAdvisor. If you want to add a TripAdvisor link—or any other social network link—you'll need to modify the Social Networking module.

## Solution

PrestaShop provides a Social Networking module that allows site administrators to configure social media links via the Back Office. While it includes common platforms like Facebook and Twitter, some important networks, like TripAdvisor, are missing. To add a new social network, we will customize this module.

## How It Works

### Step 1: Ensure FontAwesome Supports the Icon

Since the Social Links module uses FontAwesome for icons, first check that your FontAwesome version includes the TripAdvisor icon. If not, update FontAwesome by downloading the latest version and replacing the existing files in:

```
themes/your_theme/fonts/
themes/your_theme/css/font-awesome/
```

For example, FontAwesome 4.7.0 includes the TripAdvisor icon (`fa-tripadvisor`). If your version does not support it, update to a newer version.

### Step 2: Modify the Social Links Module

1. Locate the **Social Links** module files:
   ```
   modules/ps_socialfollow/ps_socialfollow.php
   ```

2. Open `ps_socialfollow.php` and add TripAdvisor to the list of social networks. Locate the section where social networks are defined and add:

   ```php
   'tripadvisor' => array(
       'label' => $this->trans('TripAdvisor', array(), 'Modules.SocialFollow.Admin'),
       'icon' => 'fa-tripadvisor',
   ),
   ```

3. Modify the template file `ps_socialfollow.tpl` to include the new social link:

   ```smarty
   {if isset($social_links.tripadvisor)}
       <li>
           <a href="{$social_links.tripadvisor}" target="_blank" rel="noopener noreferrer">
               <i class="fa fa-tripadvisor"></i>
           </a>
       </li>
   {/if}
   ```

### Step 3: Add the New Link in the Back Office

1. Go to **Modules → Module Manager** in the PrestaShop Back Office.
2. Locate **Social Media Follow Links (ps_socialfollow)** and configure it.
3. A new field for TripAdvisor should now be available—enter your TripAdvisor page URL and save the settings.

### Conclusion

By following these steps, you can successfully add TripAdvisor (or any other social media platform) to the PrestaShop Social Links module. This method can be generalized to include additional social networks, allowing for greater customization and flexibility.

