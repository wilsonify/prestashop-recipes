<?php

// Include PrestaShop's configuration file to access database
include(dirname(__FILE__).'/config/config.inc.php');
include(dirname(__FILE__).'/init.php');

// Function to log errors
function logError($message) {
    // You can log to a file or use PrestaShop's logging system
    // For simplicity, logging to error_log here
    error_log($message);
}

// Function to change the position of a module
function changeModulePosition($moduleName, $hookName, $newPosition) {
    // Sanitize inputs to prevent any security risks
    $moduleName = pSQL($moduleName);
    $hookName = pSQL($hookName);
    $newPosition = (int)$newPosition;

    // Validate inputs
    if (empty($moduleName) || empty($hookName) || $newPosition <= 0) {
        logError("Invalid inputs for changing module position.");
        echo "Error: Invalid input values.";
        return;
    }

    // Get the hook ID by its name
    $hookId = (int)Hook::getIdByName($hookName);
    if ($hookId <= 0) {
        $message = "Error: Hook '$hookName' does not exist.";
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

    // Get the current position of the module in the hook
    $sql = 'SELECT position FROM '._DB_PREFIX_.'hook_module
            WHERE id_module = ? AND id_hook = ? LIMIT 1';

    $currentPosition = Db::getInstance()->getValue($sql, [$moduleId, $hookId]);

    if ($currentPosition === false) {
        $message = "Error: Module '$moduleName' is not assigned to hook '$hookName'.";
        logError($message);
        echo $message;
        return;
    }

    // If the new position is different from the current position, proceed
    if ($newPosition != $currentPosition) {
        // Update the position using a prepared statement
        $updateSql = 'UPDATE '._DB_PREFIX_.'hook_module
                      SET position = ?
                      WHERE id_module = ? AND id_hook = ?';

        $updateSuccess = Db::getInstance()->execute($updateSql, [$newPosition, $moduleId, $hookId]);

        if ($updateSuccess) {
            $message = "Module '$moduleName' has been moved to position $newPosition in hook '$hookName'.";
            logError($message);
            echo $message;
        } else {
            $message = "Error: Failed to update the position of module '$moduleName'.";
            logError($message);
            echo $message;
        }
    } else {
        $message = "The module is already in the desired position.";
        logError($message);
        echo $message;
    }
}

// Usage example: Change position of "HelloWorld" module in "top" hook to position 5
changeModulePosition('helloworld', 'top', 5);

