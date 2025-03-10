# Adding a Static List of Links of Interest in the MyAccount Module

## Problem

You want to display a static list of **Links of Interest** in the **MyAccount** section of the footer in PrestaShop. By default, this section provides account-related links, but you may want to include additional links relevant to your business or website.

## Solution

To achieve this, we will modify the **blockmyaccountfooter.tpl** file within the **MyAccount** module. The goal is to place the new list between the **MyAccount** module and the **Contact Info** module in the footer.

## How It Works

### Step 1: Locate and Edit `blockmyaccountfooter.tpl`

1. Navigate to the following directory in your PrestaShop installation:
   ```
   themes/your_theme/modules/blockmyaccountfooter/
   ```

2. Open the file `blockmyaccountfooter.tpl` and locate the section where account-related links are listed.

### Step 2: Add the Links of Interest

Insert the following code **below the existing list of account links**:

```smarty
<ul class="links-of-interest">
    <li><a href="https://example.com/link1" target="_blank">Useful Link 1</a></li>
    <li><a href="https://example.com/link2" target="_blank">Useful Link 2</a></li>
    <li><a href="https://example.com/link3" target="_blank">Useful Link 3</a></li>
</ul>
```

### Step 3: Style the List (Optional)

To ensure the links match the theme's design, you may need to add some custom CSS. Edit the theme’s CSS file, typically found in:

```
themes/your_theme/assets/css/custom.css
```

Add the following styles:

```css
.links-of-interest {
    margin-top: 10px;
    padding-left: 0;
    list-style: none;
}
.links-of-interest li {
    margin-bottom: 5px;
}
.links-of-interest a {
    color: #333;
    text-decoration: none;
    transition: color 0.3s ease;
}
.links-of-interest a:hover {
    color: #007bff;
}
```

### Step 4: Clear Cache and Verify Changes

1. In the PrestaShop Back Office, go to **Advanced Parameters → Performance**.
2. Clear the cache to apply the changes.
3. Visit the footer section of your website and confirm that the **Links of Interest** are correctly displayed.

## Conclusion

By following these steps, you can successfully add a **Links of Interest** section to the MyAccount module in the footer. This allows you to display relevant business or website links for easy customer access.

