#!/bin/bash

# Function to install Azure Data Studio
install_azure_data_studio() {
  echo "Installing Azure Data Studio..."
  wget https://go.microsoft.com/fwlink/?linkid=2215355 -O azuredatastudio-linux.deb
  sudo dpkg -i azuredatastudio-linux.deb || sudo apt-get install -f -y
  rm azuredatastudio-linux.deb
  echo "Azure Data Studio installed successfully."
}

# Function to install sqlcmd
install_sqlcmd() {
  echo "Installing sqlcmd..."
  # Remove conflicting packages if they exist
  sudo apt-get remove -y libodbc1 libodbcinst2 unixodbc unixodbc-dev
  # Import the public repository GPG keys
  curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  # Register the Microsoft SQL Server Ubuntu repository
  curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
  # Update the package list and install sqlcmd and its dependencies
  sudo apt-get update
  sudo apt-get install -y mssql-tools unixodbc-dev
  # Add sqlcmd to the system PATH
  echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
  source ~/.bashrc
  echo "sqlcmd installed successfully."
}

# Function to install DBeaver
install_dbeaver() {
  echo "Installing DBeaver..."
  # Add the DBeaver repository
  wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
  echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
  sudo apt-get update
  sudo apt-get install -y dbeaver-ce
  echo "DBeaver installed successfully."
}

# Function to provide instructions to run the tools
usage_instructions() {
  echo "To use Azure Data Studio:"
  echo "  1. Launch Azure Data Studio by running: azuredatastudio"
  echo "  2. Click on 'New Connection'."
  echo "  3. Enter your server details (e.g., localhost for the server name, SA for the username, and the password you set during installation)."
  echo "  4. Click 'Connect'."
  echo "  5. You can now manage your databases, run queries, and perform other tasks using the graphical interface."

  echo ""
  
  echo "To use sqlcmd:"
  echo "  1. Open a terminal."
  echo "  2. Run the command: sqlcmd -S localhost -U SA -P 'YourPassword'"
  echo "  3. You can now run SQL queries interactively."

  echo ""
  
  echo "To use DBeaver:"
  echo "  1. Launch DBeaver by running: dbeaver"
  echo "  2. Create a new connection and select SQL Server."
  echo "  3. Enter your server details (e.g., localhost for the server name, SA for the username, and the password you set during installation)."
  echo "  4. Click 'Finish'."
  echo "  5. You can now manage your databases using DBeaver's graphical interface."
}

# Main script execution
echo "This script will install tools to manage your SQL Server instance on Ubuntu."
echo "Please choose an option:"
echo "1. Install Azure Data Studio"
echo "2. Install sqlcmd"
echo "3. Install DBeaver"
echo "4. Install all tools"
echo "5. Show usage instructions only"
read -p "Enter your choice [1-5]: " choice

case $choice in
  1)
    install_azure_data_studio
    ;;
  2)
    install_sqlcmd
    ;;
  3)
    install_dbeaver
    ;;
  4)
    install_azure_data_studio
    install_sqlcmd
    install_dbeaver
    ;;
  5)
    usage_instructions
    ;;
  *)
    echo "Invalid choice. Please run the script again and select a valid option."
    ;;
esac

echo "Script execution completed."

