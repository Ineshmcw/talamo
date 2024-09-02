#!/bin/bash

# Check if folder path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <PROJECT_DIR>"
    exit 1
fi

PROJECT_DIR=$1
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
VSCODE_SETTINGS_DIR="$PROJECT_DIR/.vscode"
SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"

PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
ORIGINAL_VENV_DIR="${SCRIPT_DIR}/talamo${PYTHON_VERSION//./}"
TARGET_VENV_DIR="${PROJECT_DIR}/talamo${PYTHON_VERSION//./}"
INTERPRETER_PATH="$TARGET_VENV_DIR/bin/python"
WHL_FILE="${SCRIPT_DIR}/wheel_files/talamo-2.0.0a2-cp${PYTHON_VERSION//./}-cp${PYTHON_VERSION//./}-linux_x86_64.whl"


if [ ! -d "$ORIGINAL_VENV_DIR" ]; then
    python3 -m venv "$ORIGINAL_VENV_DIR"
    echo "Virtual environment created in $ORIGINAL_VENV_DIR"

    "${ORIGINAL_VENV_DIR}/bin/pip" install h5py
    echo "Installing h5py."

    if [ -f "$WHL_FILE" ]; then
        "${ORIGINAL_VENV_DIR}/bin/python" -m pip install "$WHL_FILE"
        echo "Installed $WHL_FILE in the virtual environment."
    else
        echo "Error: $WHL_FILE not found."
        deactivate
        exit 1
    fi
fi

# Copy the virtual env
cp -r "$ORIGINAL_VENV_DIR" "$TARGET_VENV_DIR"
echo "Virtual environment copied to $TARGET_VENV_DIR."

# Update paths while copying
sed -i "s|$ORIGINAL_VENV_DIR|$TARGET_VENV_DIR|g" "$TARGET_VENV_DIR/bin/activate"
sed -i "s|$ORIGINAL_VENV_DIR|$TARGET_VENV_DIR|g" "$TARGET_VENV_DIR/bin/activate.csh"
sed -i "s|$ORIGINAL_VENV_DIR|$TARGET_VENV_DIR|g" "$TARGET_VENV_DIR/bin/activate.fish"
sed -i "s|$ORIGINAL_VENV_DIR|$TARGET_VENV_DIR|g" "$TARGET_VENV_DIR/pyvenv.cfg"

echo "Paths updated in the copied virtual environment."

mkdir -p "$VSCODE_SETTINGS_DIR"

chmod +x "${TARGET_VENV_DIR}/bin/activate"

echo '{
  "python.pythonPath": "'"$INTERPRETER_PATH"'"
}' > "$SETTINGS_FILE"

echo "VSCode settings updated with Python interpreter: $INTERPRETER_PATH"

echo "Setup complete. Virtual environment is ready at $TARGET_VENV_DIR."
