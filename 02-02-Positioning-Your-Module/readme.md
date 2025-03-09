# Changing the Display Order of Modules in PrestaShop

## Problem Statement
You want to change the position or order in which your modules are displayed on your PrestaShop site. This can be useful if you need to reorder modules or move them to different sections of your store.

## Solution Overview
To modify the display order of your modules, you can use the **Positions** page in the PrestaShop Back Office. This page allows you to drag and drop modules to reorder them within their respective hooks.

### Steps to Change Module Position:
In this example, we’ll demonstrate how to move the **Hello World** module (created in the previous recipe) to a different position.

## How It Works

1. **Navigate to the Positions Page**:
   - Log in to your PrestaShop **Back Office**.
   - Go to **Modules and Services** > **Positions** from the left menu.
   
2. **Search for the Hook**:
   - In the **Search for a hook** field on the right, type `top` (or the name of the hook where your module is currently attached). This will help you locate the module in the list.
   
3. **Locate Your Module**:
   - Once you search for the `top` hook, the modules attached to it will appear in a list. Look for the **Hello World** module (or any other module you want to move).

4. **Reorder the Module**:
   - To change the module's position, simply **drag** the module (represented by a row in the list) and drop it in the desired location.
   - For example, if you want the **Hello World** module to appear **under the Cart Block** module, drag it below the Cart Block entry.

5. **Save Changes**:
   - After repositioning the module, the change will be automatically saved. The new order will be reflected on the front end of your store.

### Example:
If your current layout has the **Hello World** module in the **top** hook but you want it to appear below the **Cart Block**, search for the **top** hook, locate both the **Hello World** and **Cart Block** modules, then drag the **Hello World** module under the Cart Block.

## Conclusion
Changing the position of your modules in PrestaShop is simple and can be done via the **Positions** page in the Back Office. By searching for the correct hook and using the drag-and-drop functionality, you can easily reorder modules to customize the layout of your site.
