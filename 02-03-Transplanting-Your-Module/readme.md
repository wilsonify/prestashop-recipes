# Transplanting a Module to Another Hook in PrestaShop

## Problem Statement
You want to move a module from one hook to another, essentially "transplanting" it. This process allows you to change the module’s location on the front end by attaching it to a different hook.

## Solution Overview
Transplanting a module involves two main steps:
1. **Unhooking** the module from its current position.
2. **Attaching** it to the new hook.

These actions are performed through the PrestaShop Back Office under the **Positions** page, where you can manage the hooks for each module.

## Steps to Transplant a Module

### 1. Access the Positions Page
- Log in to your PrestaShop **Back Office**.
- Go to **Modules and Services** > **Positions** from the left-hand menu. This will show you a list of all the hooks and the modules attached to them.

### 2. Find the Module You Want to Transplant
- Use the search bar to find the module you wish to move. For example, if you're moving a module from the **top** hook, search for the hook name (e.g., `top`), or search for the module name directly.

### 3. Unhook the Module
- Once you find the module listed under its current hook, click the **Unhook** button next to the module.
- This will remove the module from the current hook, freeing it to be moved.

### 4. Attach the Module to the New Hook
- After unhooking the module, scroll to the section where you want to move the module.
- Use the **Add a module to a hook** section to select the new hook. From the dropdown, find and select the hook where you want the module to appear (e.g., `displayFooter`).
- Click **Save** to apply the change.

### 5. Verify the Change
- After transplanting the module to the new hook, visit the front end of your store to ensure the module now appears in the desired location.

## Conclusion
Transplanting a module in PrestaShop is a straightforward process that involves unhooking it from its current location and reattaching it to a new hook. By using the **Positions** page in the Back Office, you can easily manage the placement of your modules and customize your store’s layout without needing to modify the module’s code.

---
