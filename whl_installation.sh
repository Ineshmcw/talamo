#!/bin/bash

# Check if PROJECT_DIR is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <PROJECT_DIR> [TALAMO_PATH]"
    exit 1
fi

PROJECT_DIR=$1
TALAMO_PATH=$2
PROJECT_NAME=$(basename "$PROJECT_DIR")
VSCODE_SETTINGS_DIR="$PROJECT_DIR/.vscode"
SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"
TARGET_VENV_DIR="${PROJECT_DIR}/${PROJECT_NAME}_venv"
INTERPRETER_PATH=""

# If TALAMO_PATH is provided, verify that Talamo is installed there
if [ -n "$TALAMO_PATH" ]; then
    # Check if Talamo exists in the specified TALAMO_PATH
    if [ ! -f "$TALAMO_PATH/talamo" ]; then
        echo "Error: Talamo executable not found in specified TALAMO_PATH."
        exit 1
    fi
    
    # get python executable
    PYTHON_EXECUTABLE=$(dirname "$TALAMO_PATH")/python

    # Check if Talamo is installed in this environment
    if ! "$PYTHON_EXECUTABLE" -c "import talamo" &> /dev/null; then
        echo "Error: Talamo library is not installed in the specified TALAMO_PATH environment."
        exit 1
    else
        INTERPRETER_PATH="$PYTHON_EXECUTABLE"
        echo "Talamo is installed in the specified TALAMO_PATH. Using its Python interpreter."
    fi
    echo "Talamo path is not provided checking if talamo is available globally"
else
    # Check if Talamo library is installed globally
    if python -c "import talamo" &> /dev/null; then
        echo "Talamo is found globally creating virtual env"
        python -m venv "$TARGET_VENV_DIR" --system-site-packages
        echo "Virtual environment created in $TARGET_VENV_DIR"
        
        # Set INTERPRETER_PATH to the Python executable in the new virtual environment
        INTERPRETER_PATH="$TARGET_VENV_DIR/bin/python"
        echo "Using the globally installed talamo while creating the virtual env"
    else
        echo "Error: Talamo library is not installed globally or in the specified TALAMO_PATH."
        exit 1
    fi
fi

"${TARGET_VENV_DIR}/bin/pip" install h5py
echo "Installing h5py."

mkdir -p "$VSCODE_SETTINGS_DIR"

echo '{
  "python.pythonPath": "'"$INTERPRETER_PATH"'"
}' > "$SETTINGS_FILE"

echo "VSCode settings updated with Python interpreter: $INTERPRETER_PATH"

echo "Setup complete. Virtual environment is ready at $TARGET_VENV_DIR."
