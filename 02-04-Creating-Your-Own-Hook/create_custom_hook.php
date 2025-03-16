<?php

// Include PrestaShop configuration and initialization files
include(dirname(__FILE__).'/config/config.inc.php');
include(dirname(__FILE__).'/init.php');

// Function to create and register a custom hook in PrestaShop
function createCustomHook($moduleName, $hookName) {
    // Step 1: Get the module object
    $module = Module::getInstanceByName($moduleName);

    if (!$module) {
        echo "Error: Module '$moduleName' does not exist.";
        return;
    }

    // Step 2: Register the custom hook in the module
    $hookRegistered = $module->registerHook($hookName);

    if ($hookRegistered) {
        echo "Custom hook '$hookName' has been successfully registered for the module '$moduleName'.";
    } else {
        echo "Error: Failed to register custom hook '$hookName' for the module '$moduleName'.";
    }
}

// Usage example: Register custom hook 'displayCustomHook' for the 'helloworld' module
createCustomHook('helloworld', 'displayCustomHook');
?>
