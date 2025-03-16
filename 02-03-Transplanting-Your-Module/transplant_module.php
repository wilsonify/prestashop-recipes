<?php

// Include PrestaShop's configuration file to access database
include(dirname(__FILE__).'/config/config.inc.php');
include(dirname(__FILE__).'/init.php');

// Function to log errors
function logError($message) {
    // Log errors to a dedicated file or PrestaShop's logger
    // For now, using error_log for simplicity
    error_log($message);
}

// Function to transplant a module to a new hook
function transplantModule($moduleName, $currentHookName, $newHookName) {
    // Sanitize inputs to prevent potential SQL injection or other issues
    $moduleName = pSQL($moduleName);
    $currentHookName = pSQL($currentHookName);
    $newHookName = pSQL($newHookName);

    // Validate inputs
    if (empty($moduleName) || empty($currentHookName) || empty($newHookName)) {
        logError("Invalid inputs: '$moduleName', '$currentHookName', or '$newHookName' are empty.");
        echo "Error: One or more inputs are empty.";
        return;
    }

    // Get the hook IDs by their names
    $currentHookId = (int)Hook::getIdByName($currentHookName);
    $newHookId = (int)Hook::getIdByName($newHookName);

    if ($currentHookId <= 0 || $newHookId <= 0) {
        $message = "Error: One or both hooks ('$currentHookName', '$newHookName') do not exist.";
        logError($message);
        echo $message;
        return;
    }

    // Get the module ID by its name
    $moduleId = (int)Module::getIdByName($moduleName);

    if ($moduleId <= 0) {
        $message = "Error: Module '$moduleName' does not exist.";
        logError($message);
        echo $message;
        return;
    }

    // Unhook the module from the current hook
    $unhookSql = 'DELETE FROM '._DB_PREFIX_.'hook_module
                  WHERE id_module = ? AND id_hook = ?';
    $unhookResult = Db::getInstance()->execute($unhookSql, [$moduleId, $currentHookId]);

    if (!$unhookResult) {
        $message = "Error: Failed to unhook the module '$moduleName' from hook '$currentHookName'.";
        logError($message);
        echo $message;
        return;
    }

    // Attach the module to the new hook
    $hookModuleSql = 'INSERT INTO '._DB_PREFIX_.'hook_module (id_module, id_hook, position)
                      VALUES (?, ?, 0)';
    $hookModuleResult = Db::getInstance()->execute($hookModuleSql, [$moduleId, $newHookId]);

    if ($hookModuleResult) {
        $message = "Module '$moduleName' has been successfully transplanted from '$currentHookName' to '$newHookName'.";
        logError($message);
        echo $message;
    } else {
        $message = "Error: Failed to hook the module '$moduleName' to the new hook '$newHookName'.";
        logError($message);
        echo $message;
    }
}

// Usage example: Transplant "HelloWorld" module from "top" hook to "displayFooter" hook
transplantModule('helloworld', 'top', 'displayFooter');
