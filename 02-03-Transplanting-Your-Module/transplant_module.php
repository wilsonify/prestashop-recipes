<?php

// Include PrestaShop's configuration file to access database
include(dirname(__FILE__).'/config/config.inc.php');
include(dirname(__FILE__).'/init.php');

// Function to transplant a module to a new hook
function transplantModule($moduleName, $currentHookName, $newHookName) {
    // Get the hook ID by its name
    $currentHookId = (int)Hook::getIdByName($currentHookName);
    $newHookId = (int)Hook::getIdByName($newHookName);

    if ($currentHookId <= 0 || $newHookId <= 0) {
        echo "Error: One or both of the hooks ('$currentHookName', '$newHookName') do not exist.";
        return;
    }

    // Get the module ID by its name
    $moduleId = (int)Module::getIdByName($moduleName);

    if ($moduleId <= 0) {
        echo "Error: Module '$moduleName' does not exist.";
        return;
    }

    // Unhook the module from the current hook
    $unhookSql = 'DELETE FROM '._DB_PREFIX_.'hook_module
                  WHERE id_module = '.$moduleId.' AND id_hook = '.$currentHookId;
    $unhookResult = Db::getInstance()->execute($unhookSql);

    if (!$unhookResult) {
        echo "Error: Failed to unhook the module '$moduleName' from hook '$currentHookName'.";
        return;
    }

    // Attach the module to the new hook
    $hookModuleSql = 'INSERT INTO '._DB_PREFIX_.'hook_module (id_module, id_hook, position)
                      VALUES ('.$moduleId.', '.$newHookId.', 0)';
    $hookModuleResult = Db::getInstance()->execute($hookModuleSql);

    if ($hookModuleResult) {
        echo "Module '$moduleName' has been successfully transplanted from '$currentHookName' to '$newHookName'.";
    } else {
        echo "Error: Failed to hook the module '$moduleName' to the new hook '$newHookName'.";
    }
}

// Usage example: Transplant "HelloWorld" module from "top" hook to "displayFooter" hook
transplantModule('helloworld', 'top', 'displayFooter');
