# Full-Width Image Slider on Homepage

## Problem

By default, the image slider module on your homepage is restricted to a certain width. 

This is a common limitation in many PrestaShop themes, 
where elements like the image slider are constrained within a 
specific container to maintain consistent layout proportions.

However, for many websites, this default width is not ideal, 
especially if you want to showcase high-quality images across the full screen. 

The default behavior leads to wasted space on either side of the slider, 
which reduces its visual impact and doesn't make full use of the available screen width.

### Why is this a Problem?

The issue lies in the default layout structure of PrestaShop's theme. 

The slider is wrapped inside a `div` element that has a maximum width set by the theme’s CSS. 

While this design ensures consistent sizing across various screen resolutions, 
it limits the visual potential of the image slider, 
especially on larger screens.

Additionally, many users prefer to have an image slider that spans the entire width of the screen, 
particularly when the images used are high-resolution and are meant to grab attention. 

Restricting the slider to a specific width results in a less engaging user experience, 
and fails to fully capitalize on modern wide-screen displays.

## Solution

To make the image slider span the full width of the screen, 
we need to modify the layout of the theme by adjusting the CSS. 

The slider itself is contained within a `div` that enforces a maximum width. 
This needs to be changed to allow the slider to take up 100% of the width available in the viewport.

### How it works

1. **Inspect the Page Layout**
   First, open the homepage of your site in a browser. Use your browser’s developer tools to inspect the image slider and locate the container that holds it.

   - In most browsers (e.g., Chrome, Firefox), press `F12` or right-click on the slider and select "Inspect" or "Inspect Element."
   - Identify the `div` element wrapping the image slider. You'll notice that it has a CSS rule, likely a `max-width` or `width` property, which is limiting its size.

   ![Inspecting the Image Slider](images/inspect_slider.png)  
   *Inspecting the PrestaShop home page in Mozilla Firefox using the developer tools.*

2. **Remove Width Restrictions**
   In the developer tools, find the CSS rule that's limiting the width of the slider's container (e.g., `max-width: 1200px;`). Modify it to set `width: 100%;` or remove the restriction entirely.

   - If you’re comfortable, you can also modify this directly in the theme’s CSS file to ensure the changes persist across page reloads.

3. **Adjust Theme Settings in the Back Office**
   - Go to your PrestaShop Back Office.
   - Navigate to the **Modules** section and find the **Theme Configurator** module.
   - Click on the **Configure** button to access the theme settings.
   - Here, you can look for layout-related settings for the homepage slider and adjust the settings as necessary to allow it to expand fully.

4. **Test on Multiple Screen Sizes**
   After making these changes, be sure to test how the image slider looks on various devices, including mobile and tablet. You might need to adjust the CSS for different screen sizes to ensure responsiveness. 

   You can use the developer tools' responsive design mode to simulate various devices and screen sizes.

## Conclusion

By modifying the layout and removing the maximum width restriction on the image slider, 
you can make it span the full width of the screen. 

This adjustment is essential for creating a more visually engaging homepage that makes full use of modern screen sizes. 

The solution involves inspecting the layout using your browser’s developer tools, 
removing the width limitations, and updating the theme configuration to reflect the changes.

Remember to test across different devices to ensure that 
the new layout is responsive and doesn’t cause issues on smaller screens.

*Note: 
Always create a backup of your theme before making changes 
to the CSS or layout settings to avoid breaking the layout and causing issues with future updates.*
