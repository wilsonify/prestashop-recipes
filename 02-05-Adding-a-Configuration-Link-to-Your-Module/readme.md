# Adding a Configure Link to Your PrestaShop Module

## Problem Statement
You want to add a **Configure** link to your module, allowing users to customize the module settings directly from the Back Office.

## Solution Overview
In PrestaShop, modules that allow customization typically feature a **Configure** link on the module list page in the Back Office. When clicked, this link directs the user to a settings page where they can modify specific parameters. To add this functionality to your module, you need to implement the `getContent()` method in your module's main class.

In this recipe, we will modify the **Hello World** module to allow users to customize the text it displays from the Back Office.

## How It Works

### 1. Add a Text Variable in the Constructor
To start, we’ll add a text variable in the constructor of the **HelloWorld** module. This variable will be used to store the text in the database, and it will hold the value that the user can modify through the Back Office.

**Example:**

```php
public function __construct()
{
    $this->name = 'helloworld';
    $this->tab = 'front_office_features';
    $this->version = '1.0.0';
    $this->author = 'Your Name';
    
    // Add the text variable for storing the module text
    $this->text = Configuration::get('HELLOWORLD_TEXT'); // Retrieve text from the database

    parent::__construct();
}
```

### 2. Implement the getContent() Method

Next, we’ll implement the getContent() method. This method is responsible for generating the content of the module’s configuration page, which is displayed when the user clicks the Configure link.

Example of getContent() Method:

```php
public function getContent()
{
    if (Tools::isSubmit('submit_helloworld')) {
        // Update the text value in the database when the form is submitted
        $text = Tools::getValue('HELLOWORLD_TEXT');
        Configuration::updateValue('HELLOWORLD_TEXT', $text);
    }

    // Generate the form for the configuration page
    $output = '<form method="post" action="' . $_SERVER['REQUEST_URI'] . '">';
    $output .= '<label for="HELLOWORLD_TEXT">Custom Text: </label>';
    $output .= '<input type="text" name="HELLOWORLD_TEXT" value="' . $this->text . '" />';
    $output .= '<input type="submit" name="submit_helloworld" value="Save" />';
    $output .= '</form>';

    return $output;
}
```

In this example:

    The getContent() method checks if the form is submitted.
    If the form is submitted, it updates the HELLOWORLD_TEXT value in the PrestaShop database using the Configuration::updateValue() method.
    The method then displays a form with a text input field, which allows users to enter custom text. The current text value is retrieved from the database and pre-filled in the input field.

### 3. Save and Retrieve the Custom Text Value

In the getContent() method, the custom text entered by the user is stored in the database under the HELLOWORLD_TEXT key using the Configuration::updateValue() method. To retrieve the saved text, we use Configuration::get('HELLOWORLD_TEXT').

The text value can now be modified by the user in the Back Office when they click the Configure link for your module.

### 4. Display the Custom Text

Finally, to display the custom text on the front end, you will need to modify the hookDisplayTop() method (or another hook method, depending on where you want the content to appear).

Example of Displaying the Custom Text:

public function hookDisplayTop($params)
{
    return '<p>' . $this->text . '</p>'; // Display the custom text in the top section
}

This code will render the custom text wherever the module is hooked to the specified position (e.g., in the top of the page).

## Conclusion

By implementing the getContent() method in your module and using Configuration::get() and Configuration::updateValue(), you can allow users to configure the settings of your module directly from the Back Office. This gives you flexibility to create modules that are customizable and interactive for the users.