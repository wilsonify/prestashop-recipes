# Adding Customer Testimonials to Your PrestaShop Homepage

## Problem

Displaying customer testimonials on your homepage can help build trust, improve credibility, and increase conversions. However, PrestaShop does not provide a built-in way to manage testimonials dynamically through the admin panel.

## Solution

To address this, we will create a custom PrestaShop module that allows testimonials to be configured easily. This module will enable users to set a testimonial's name, text, and image directly from the back office.

### Quick Start

To speed up development, we will use the existing YouTube module created in Chapter 2 as a template. We will:
1. Copy the YouTube module files and rename the module folder to **testimonials**.
2. Rename the main **.tpl** and **.php** files to match the new module name.
3. Modify the logic to handle testimonial content instead of embedding YouTube videos.

## How It Works

### Step 1: Creating the `testimonials.php` File

We will define the main functionality in `testimonials.php`, which will include:
- Methods to configure testimonial entries (name, text, image).
- A function to retrieve and display testimonials.
- Hook integration to allow testimonials to appear on the homepage.

### Step 2: Defining the Testimonials Hook

In `testimonials.php`, we will register a new hook called **displayTestimonials**. This hook will be assigned to the homepage so that testimonials appear in the designated section.

### Step 3: Implementing the Front-End Display

Using a `.tpl` file, we will create a structured layout to showcase testimonials attractively. The template will include:
- Testimonial text
- Customer name
- Image (if available)

## Conclusion

By following these steps, we will have a fully functional, configurable testimonials module in PrestaShop. This module will enhance the homepage by adding social proof, increasing customer confidence, and providing an easy way for store administrators to manage testimonials dynamically from the back office.

