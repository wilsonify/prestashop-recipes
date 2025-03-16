# Problem: Enabling Friendly URLs for Your PrestaShop Site

## Overview

By default, PrestaShop generates URLs with GET parameters that can be long and difficult to read. For example, a product page might have a URL like:

www.havanaclassiccartour.com/index.php?id_product=30&controller=product


These URLs are functional but not user-friendly. To improve the readability of your site’s URLs and enhance SEO, you may want to enable **Friendly URLs**.

Friendly URLs replace these complex GET parameter strings with human-readable, SEO-friendly URLs like:

www.havanaclassiccartour.com/classic-convertibles/30-book-classic-convertible.html


In this guide, we will walk through how to set up **Friendly URLs** in PrestaShop, making your URLs cleaner, easier to remember, and more search-engine optimized.

## Why This Is a Problem

Without friendly URLs, your website’s links are filled with random query strings that make it difficult for users and search engines to understand the content of the page. This can lead to:

- **Poor user experience**: Complex, unmemorable URLs are harder for customers to share and recall.
- **SEO disadvantages**: Search engines prefer clean, keyword-rich URLs that clearly describe the page content.
- **Difficulty in tracking and marketing**: Long URLs can be cumbersome for marketing campaigns and analytics tracking.

Enabling friendly URLs is a simple but effective way to improve your site's usability and search engine optimization.

## Solution

To enable Friendly URLs in PrestaShop, you need to follow these steps:

1. **Go to the Back Office**: Log into your PrestaShop admin panel.
2. **Navigate to SEO & URLs**: Go to **Preferences** > **SEO & URLs**. This is where you will manage all URL settings, including enabling and configuring friendly URLs.
3. **Activate Friendly URLs**: In the **Set Up URLs** section, find the **Friendly URL** option and switch it to **Yes**.
   
   > **Note**: Friendly URLs make the URLs more readable by removing unnecessary parameters and replacing them with meaningful words. For instance:
   > - Non-friendly URL: `www.example.com/index.php?id_product=123&controller=product`
   > - Friendly URL: `www.example.com/beautiful-vintage-table-123.html`

   Activating Friendly URLs will replace these complex URLs with simpler, keyword-rich ones, improving the user experience and SEO.

   ![Activating Friendly URLs](link_to_image/figure7-1.png)  <!-- Replace with actual image path -->

### Additional Configuration for Friendly URLs

Once you enable friendly URLs, PrestaShop provides additional settings in the **SEO & URLs** page that allow you to further customize how URLs are generated.

1. **Define Page Titles and URLs**: On the **SEO & URLs** page, you can define the title and the friendly URL for each page. This is where you can customize product pages, category pages, and other types of content.
2. **Customizing URL Patterns**: You can specify the format for URLs across the site. PrestaShop allows for URL rewriting and customization to ensure that URLs are structured in a way that fits your brand and product categories.

   Example: You can set up product URLs to follow this format:  
   `www.example.com/category-name/product-name-product-id.html`.

3. **Check for URL Conflicts**: After enabling friendly URLs, it’s important to check for any existing conflicts in your URL structure. PrestaShop will attempt to resolve common issues automatically, but it’s always a good idea to manually review your URLs to ensure they reflect your product or category names accurately.

### Advantages of Using Friendly URLs

- **Improved SEO**: Search engines prefer clean, descriptive URLs that include relevant keywords. Friendly URLs help search engines understand the content of the page and rank it accordingly.
- **Better User Experience**: Users are more likely to share and remember simple, descriptive URLs than long ones with query parameters.
- **Cleaner Analytics**: Tracking campaigns and measuring success is easier when URLs are clear and meaningful.

### How It Works

After enabling friendly URLs, PrestaShop generates SEO-friendly URLs for product, category, and CMS pages. Let’s take a closer look at the **SEO & URLs** page in the Back Office:

1. **Set the Page Titles**: In the **SEO & URLs** section, you can assign a **Title** to each page (such as product or category pages). This helps with SEO, as search engines use this title in their ranking algorithm.
2. **Friendly URL Configuration**: You’ll find a **Friendly URL** field where you can configure the format of your URLs. PrestaShop will generate URLs based on the page title and any other relevant information (such as product name or category).
   
   Example: A product titled "Classic Convertible Car" might automatically generate the friendly URL `classic-convertible-car-123.html`, where "123" is the product ID.

3. **Clear URL Structure**: PrestaShop’s friendly URLs remove unnecessary query parameters and allow for clean, readable links.

   Example:
   - Before enabling Friendly URLs: `www.example.com/index.php?id_product=123&controller=product`
   - After enabling Friendly URLs: `www.example.com/classic-convertible-car-123.html`

   This makes URLs more user-friendly and improves SEO by providing more context to the page content.

### Example: Enabling Friendly URLs

1. **Back Office Navigation**: In your PrestaShop Back Office, go to **Preferences > SEO & URLs**.
2. **Set Friendly URLs to Yes**: In the **Set Up URLs** section, find the **Friendly URL** field and switch it to **Yes**.
   
   ![Setting up Friendly URLs](link_to_image/figure7-2.png) <!-- Replace with actual image path -->

3. **Save Changes**: After enabling friendly URLs, save your changes.

   You should now see more readable, SEO-friendly URLs across your site!

## Conclusion

Enabling friendly URLs in PrestaShop is an essential step to improve the user experience, SEO, and overall readability of your website. By following the steps outlined above, you can ensure that your product, category, and CMS page URLs are simple, descriptive, and easy to remember.

- **Friendly URLs** help search engines understand your content and improve page rankings.
- **User-friendly URLs** make your site more shareable and memorable for customers.
- **Simple configuration** allows you to customize the URL structure to match your brand.

Make sure to check your URLs after enabling this feature to ensure they are optimized for both users and search engines.


