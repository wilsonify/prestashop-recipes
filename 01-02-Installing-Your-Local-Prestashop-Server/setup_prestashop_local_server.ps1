# Define Variables
$wamp_url = "https://sourceforge.net/projects/wampserver/files/latest/download"
$prestashop_url = "https://download.prestashop.com/download/old/prestashop_1.7.8.6.zip"
$wamp_installer = "wampserver_installer.exe"
$prestashop_installer = "prestashop.zip"
$wamp_install_dir = "C:\wamp64"
$prestashop_dir = "$wamp_install_dir\www\prestashop"
$mysql_db_name = "prestashop_db"
$mysql_user = "root"
$mysql_password = "root"

# Step 1: Download WAMP Installer
Write-Host "Downloading WAMP server..."
Invoke-WebRequest -Uri $wamp_url -OutFile $wamp_installer

# Step 2: Install WAMP Server
Write-Host "Installing WAMP server..."
Start-Process -FilePath $wamp_installer -ArgumentList "/silent" -Wait

# Step 3: Download PrestaShop Package
Write-Host "Downloading PrestaShop package..."
Invoke-WebRequest -Uri $prestashop_url -OutFile $prestashop_installer

# Step 4: Extract PrestaShop Files
Write-Host "Extracting PrestaShop files..."
Expand-Archive -Path $prestashop_installer -DestinationPath $prestashop_dir

# Step 5: Setup MySQL Database for PrestaShop
Write-Host "Setting up MySQL database for PrestaShop..."
$mysql_command = "CREATE DATABASE IF NOT EXISTS $mysql_db_name; CREATE USER '$mysql_user'@'localhost' IDENTIFIED BY '$mysql_password'; GRANT ALL PRIVILEGES ON $mysql_db_name.* TO '$mysql_user'@'localhost'; FLUSH PRIVILEGES;"
$mysql_path = "C:\wamp64\bin\mysql\mysql5.7.31\bin\mysql.exe"  # Adjust version path accordingly

# Run the MySQL command to set up the database
Start-Process -FilePath $mysql_path -ArgumentList "-u root -e $mysql_command" -Wait

# Step 6: Start WAMP Server
Write-Host "Starting WAMP server..."
Start-Process -FilePath "$wamp_install_dir\wampmanager.exe"

# Step 7: Final Instructions
Write-Host "PrestaShop local server setup is complete!"
Write-Host "You can now access PrestaShop by navigating to http://localhost/prestashop in your web browser."
Write-Host "Go to phpMyAdmin at http://localhost/phpmyadmin to manage your database."
Write-Host "Please complete the installation of PrestaShop by following the on-screen instructions in the browser."
