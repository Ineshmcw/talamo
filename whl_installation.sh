#!/bin/bash

# Check if PROJECT_DIR is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <PROJECT_DIR> [TALAMO_PATH]"
    exit 1
fi

PROJECT_DIR=$1
PROJECT_NAME=$(basename "$PROJECT_DIR")
VSCODE_SETTINGS_DIR="$PROJECT_DIR/.vscode"
SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"
TARGET_VENV_DIR="${PROJECT_DIR}/${PROJECT_NAME}_venv"
INTERPRETER_PATH=""


# Check if Talamo library is installed globally
if python -c "import talamo" &> /dev/null; then
    echo "Talamo is found globally creating virtual env"
    python -m venv "$TARGET_VENV_DIR" --system-site-packages
    echo "Virtual environment created in $TARGET_VENV_DIR"
    
    # Set INTERPRETER_PATH to the Python executable in the new virtual environment
    INTERPRETER_PATH="$TARGET_VENV_DIR/bin/python"
else
    echo "Error: Talamo library is not installed globally or in the specified TALAMO_PATH."
    exit 1
fi


"${TARGET_VENV_DIR}/bin/pip" install h5py
echo "Installing h5py."

mkdir -p "$VSCODE_SETTINGS_DIR"

echo '{
  "python.pythonPath": "'"$INTERPRETER_PATH"'"
}' > "$SETTINGS_FILE"

echo "VSCode settings updated with Python interpreter: $INTERPRETER_PATH"

