# Changing the Font in a PrestaShop Theme

## Problem

By default, PrestaShop themes use predefined fonts, 
but you may want to customize your store’s typography to better match your brand identity. 

Changing the font can enhance the website’s aesthetics, 
readability, and user experience. 

However, modifying fonts in PrestaShop requires proper file placement and CSS configuration.

## Solution

Fonts are typically added to web pages using CSS rules. 

To change the font in a PrestaShop theme, we need to:

1. Copy the desired font files into the appropriate theme directory.
2. Define CSS rules to apply the new font across the site.
3. Use the CSS Editing module (as introduced in Chapter 2) to implement the changes.

## How It Works

### Step 1: Copy Font Files

For this example, we will add the **Corbel** font to the website. Begin by copying the font files into the following directory:

```
themes/your_theme/fonts/
```

Ensure that the font files include different formats (`.woff`, `.woff2`, `.ttf`, `.eot`) to support various browsers.

### Step 2: Define the Font in CSS

Next, we need to declare the font in the theme’s CSS file. Open the **custom.css** file (or create one if it doesn’t exist) in:

```
themes/your_theme/assets/css/custom.css
```

Add the following CSS rule to import and apply the font:

```css
@font-face {
    font-family: 'Corbel';
    src: url('../fonts/Corbel.woff2') format('woff2'),
         url('../fonts/Corbel.woff') format('woff'),
         url('../fonts/Corbel.ttf') format('truetype');
    font-weight: normal;
    font-style: normal;
}

body {
    font-family: 'Corbel', Arial, sans-serif;
}
```

### Step 3: Apply the Font Using the CSS Editing Module

If you are using a PrestaShop module for CSS modifications (such as the **CSS Editing module** from Chapter 2), follow these steps:

1. Navigate to the module settings in the PrestaShop admin panel.
2. Locate the **Custom CSS** section.
3. Copy and paste the CSS code from Step 2.
4. Save changes and refresh your store to see the new font in action.

## Conclusion

By following these steps, you can easily change the font in your PrestaShop theme, improving the visual appeal and consistency of your store’s design. This method ensures that your new font is properly loaded and applied site-wide without affecting performance.

