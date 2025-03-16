<?php

// Include PrestaShop configuration and initialization files
include(dirname(__FILE__).'/config/config.inc.php');
include(dirname(__FILE__).'/init.php');

// Function to log errors
function logError($message) {
    // Log errors to PrestaShop's log system (useful for debugging in production)
    PrestaShopLogger::addLog($message, 3); // 3 represents the 'Error' log level
}

// Function to create and register a custom hook in PrestaShop
function createCustomHook($moduleName, $hookName) {
    // Sanitize inputs to prevent potential issues or vulnerabilities
    $moduleName = pSQL($moduleName);
    $hookName = pSQL($hookName);

    // Validate inputs
    if (empty($moduleName) || empty($hookName)) {
        logError("Invalid inputs: Module or Hook name is empty.");
        echo "Error: Module name or Hook name cannot be empty.";
        return;
    }

    // Step 1: Get the module object
    $module = Module::getInstanceByName($moduleName);

    if (!$module) {
        $message = "Error: Module '$moduleName' does not exist.";
        logError($message);
        echo $message;
        return;
    }

    // Step 2: Check if the hook already exists in the database
    $hookId = Hook::getIdByName($hookName);
    if ($hookId <= 0) {
        $message = "Error: Hook '$hookName' does not exist.";
        logError($message);
        echo $message;
        return;
    }

    // Step 3: Register the custom hook in the module
    $hookRegistered = $module->registerHook($hookName);

    if ($hookRegistered) {
        $message = "Custom hook '$hookName' has been successfully registered for the module '$moduleName'.";
        PrestaShopLogger::addLog($message, 1); // Log the successful registration
        echo $message;
    } else {
        $message = "Error: Failed to register custom hook '$hookName' for the module '$moduleName'.";
        logError($message);
        echo $message;
    }
}

// Usage example: Register custom hook 'displayCustomHook' for the 'helloworld' module
createCustomHook('helloworld', 'displayCustomHook');

