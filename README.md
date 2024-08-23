
Installation Guide
==================

To set up the project, follow these steps:

1. **Clone the Repository** (if not already done):
   ```
      git clone https://github.com/Ineshmcw/Python.git
      cd Python
   ```

3. **Run the Installation Script**:
   Execute the bash script with the following command:
```
      ./whl_installation.sh {project_dir}
```

   If you encounter a permission issue, grant execute permissions to the script:
```
      chmod +x whl_installation.sh
```

What the Script Does
====================

The `whl_installation.sh` script performs the following actions:

- **Creates a Virtual Environment**: A virtual environment is created with the name of the folder, using Python version 3.10 as the default.
- **Installs the Talamo Wheel File**: The script installs the Talamo wheel file into the newly created virtual environment.
- **Automates Virtual Environment Activation**: Adds activation and deactivation code to your bash profile (`.bashrc`) to automatically activate the virtual environment when entering the folder and deactivate it when leaving.
- **Updates the vscode settings.json for python Intrepretor**: Adds the Virtual Environment's python path as python intrepretor in the settings.json.

Things to Make Sure Before Running the Script
=============================================

1. **Python 3.10 Installed**:
   Ensure that Python 3.10 is installed on your system. You can check the version with:
```
      python3.10 --version
```
   If not installed, download and install it from `Python's official site <https://www.python.org/downloads/>`_.

2. **Bash or Zsh Shell**:
   Make sure you are using a compatible shell (Bash or Zsh) where the script can modify the profile configuration files. You can check your current shell with:
```
      echo $SHELL
```

3. **Correct Directory Path**:
   Ensure that the `{project_dir}` provided to the script is correct and that you have write permissions to this directory.

4. **Dependencies Installed**:
   Verify that necessary system dependencies are installed, which may include `pip`, `virtualenv`, and other relevant packages.

