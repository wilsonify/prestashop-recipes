<?php

// Include PrestaShop's configuration file to access database
include(dirname(__FILE__).'/config/config.inc.php');
include(dirname(__FILE__).'/init.php');

// Function to change the position of a module
function changeModulePosition($moduleName, $hookName, $newPosition) {
    // Get the hook ID by its name
    $hookId = (int)Hook::getIdByName($hookName);

    if ($hookId <= 0) {
        echo "Error: Hook '$hookName' does not exist.";
        return;
    }

    // Get the module ID by its name
    $moduleId = (int)Module::getIdByName($moduleName);

    if ($moduleId <= 0) {
        echo "Error: Module '$moduleName' does not exist.";
        return;
    }

    // Get the current position of the module in the hook
    $sql = 'SELECT position FROM '._DB_PREFIX_.'hook_module
            WHERE id_module = '.$moduleId.' AND id_hook = '.$hookId.' LIMIT 1';

    $currentPosition = Db::getInstance()->getValue($sql);

    if ($currentPosition === false) {
        echo "Error: Module '$moduleName' is not assigned to hook '$hookName'.";
        return;
    }

    // If the new position is different from the current position, proceed
    if ($newPosition != $currentPosition) {
        // Update the position
        $updateSql = 'UPDATE '._DB_PREFIX_.'hook_module
                      SET position = '.$newPosition.'
                      WHERE id_module = '.$moduleId.' AND id_hook = '.$hookId;
        Db::getInstance()->execute($updateSql);

        echo "Module '$moduleName' has been moved to position $newPosition in hook '$hookName'.";
    } else {
        echo "The module is already in the desired position.";
    }
}

// Usage example: Change position of "HelloWorld" module in "top" hook to position 5
changeModulePosition('helloworld', 'top', 5);
