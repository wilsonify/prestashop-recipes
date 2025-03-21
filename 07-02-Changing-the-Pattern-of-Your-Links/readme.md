# Problem: Customizing URL Patterns for Friendlier Links

## Overview

In PrestaShop, the URLs generated by default may not always be ideal for SEO or may lack relevant keywords for your business. For instance, a URL like:

www.example.com/index.php?id_product=30&controller=product


Is functional but not optimized for search engines or user experience. To improve SEO and make your URLs more descriptive and relevant, you might want to customize their structure by adding business-related keywords.

This guide will show you how to modify URL patterns for different types of pages—such as products, categories, and CMS pages—in PrestaShop, allowing you to create friendlier, more descriptive, and SEO-friendly URLs.

## Why This Is a Problem

Without custom URL patterns, your site may have:

- **Non-SEO-friendly URLs**: Default URLs often contain generic or technical parameters that do not provide meaningful information for search engines.
- **Missed keyword opportunities**: URLs are a crucial aspect of SEO, and having URLs without business-specific keywords can hurt your chances of ranking for relevant search terms.
- **Hard-to-remember URLs**: If your URLs are not descriptive or include irrelevant parameters, they are more difficult for customers to recall and share.

Customizing your URL structure can address these issues, improve search engine rankings, and enhance the overall user experience.



## Solution

PrestaShop provides an easy way to customize the URL structure through the **SEO & URLs** settings in the Back Office. In this section, you can define URL patterns for various types of pages (e.g., products, categories, CMS pages) and include business-relevant keywords to improve SEO.

### Steps to Customize URL Patterns

1. **Go to the Back Office**: Log into your PrestaShop admin panel.
2. **Navigate to SEO & URLs**: Go to **Preferences** > **SEO & URLs**.
3. **Modify URL Patterns**: In the **Schema of URLs** section, you can define patterns for each type of link (e.g., products, categories, CMS pages).
   
   Here, you’ll find fields that allow you to configure how URLs are generated for the various types of pages on your site. By adjusting these patterns, you can make your URLs more descriptive and aligned with your business.

   For example, you can change a product URL from:


www.example.com/index.php?id_product=30&controller=product


To a more SEO-friendly URL like:

www.example.com/classic-convertibles-30-book-classic-convertible.html



This makes the URL more readable and relevant for both users and search engines.

### Example: Changing Product URL Pattern

In the **Schema of URLs** section, you may see something like this for product pages:
{category:/}{id_product}-{rewrite}.html


Here’s what each part means:

- `{category:/}`: The category of the product.
- `{id_product}`: The product ID.
- `{rewrite}`: The product name or the product's SEO-friendly title.

You can modify this pattern to include additional keywords relevant to your business. For instance, if you’re selling vintage cars, you could customize it to:
{category:/}{rewrite}-vintage-car-{id_product}.html


This pattern would result in URLs like:
www.example.com/classic-convertibles-vintage-car-30.html


### How It Works

To change the URL pattern:

1. **Identify the Page Type**: Decide which type of page you want to customize (e.g., product, category, CMS).
2. **Select the Pattern Variables**: PrestaShop allows you to use a set of variables to build your URLs. These variables represent different elements of the page, such as product name, category name, product ID, and more.
3. **Adjust the Pattern**: Use the available variables to customize the URL structure. Add keywords, remove unnecessary elements, or change the order of variables to suit your needs.
4. **Save Changes**: After adjusting the patterns, save your changes to apply them across your site.

### Example: URL Customization for Different Pages

#### Product Page:
- **Before Customization**: `www.example.com/index.php?id_product=30&controller=product`
- **After Customization**: `www.example.com/classic-convertibles-30-book-classic-convertible.html`

#### Category Page:
- **Before Customization**: `www.example.com/index.php?id_category=10&controller=category`
- **After Customization**: `www.example.com/convertible-cars/`

#### CMS Page:
- **Before Customization**: `www.example.com/index.php?id_cms=5&controller=cms`
- **After Customization**: `www.example.com/about-us/`

### Advantages of Customizing URL Patterns

- **Better SEO**: Custom URLs that include relevant keywords can improve your site's search engine rankings. Search engines use URLs as one of the ranking factors, so having descriptive, keyword-rich URLs is crucial.
- **Improved User Experience**: Clear and readable URLs are easier for users to remember and share.
- **Enhanced Branding**: By including business-specific keywords in your URLs, you reinforce your brand and make your site more recognizable.

### Note on URL Conflicts

When customizing URL patterns, it's important to ensure there are no conflicts with existing URLs. PrestaShop will try to automatically resolve conflicts, but it's always a good idea to manually check your URLs after making changes to ensure they are working as expected.

## Conclusion

Customizing your URL patterns in PrestaShop is a simple yet powerful way to improve your site’s SEO, branding, and user experience. By adjusting the URL structure for product pages, categories, and CMS pages, you can create cleaner, more descriptive URLs that include relevant keywords for your business.

- **SEO Benefits**: By including targeted keywords, you improve the chances of your pages ranking for relevant search terms.
- **User-Friendly URLs**: Make your URLs easier to read, remember, and share by avoiding unnecessary parameters and using descriptive keywords.
- **Customization Flexibility**: PrestaShop provides a flexible system for creating custom URL patterns that can align with your business needs.

Follow these steps to adjust the URL patterns across your site, and you’ll see improvements in SEO, usability, and overall website performance.




