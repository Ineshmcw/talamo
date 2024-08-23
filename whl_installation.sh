#!/bin/bash

# Check if folder path and .whl file are provided
if [ -z "$1" ]; then
    echo "Usage: $0 <PROJECT_DIR>"
    exit 1
fi

PROJECT_DIR=$1
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
WHL_FILE="${SCRIPT_DIR}/wheel_files/talamo-2.0.0a2-cp310-cp310-linux_x86_64.whl"
FOLDER_NAME=$(basename "$PROJECT_DIR")
VENV_NAME="${FOLDER_NAME}_venv"
VENV_DIR="${PROJECT_DIR}/${VENV_NAME}"
INTERPRETER_PATH="$PROJECT_DIR/$VENV_NAME/bin/python"
VSCODE_SETTINGS_DIR="$PROJECT_DIR/.vscode"
SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"

# Create the folder if it doesn't exist
if [ ! -d "$PROJECT_DIR" ]; then
    mkdir -p "$PROJECT_DIR"
fi

# Create a virtual environment in the specified folder
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    echo "Virtual environment created in $VENV_DIR"
fi

mkdir -p "$VSCODE_SETTINGS_DIR"

echo '{
  "python.pythonPath": "'"$INTERPRETER_PATH"'"
}' > "$SETTINGS_FILE"

echo "VSCode settings updated with Python interpreter: $INTERPRETER_PATH"

chmod +x "${VENV_DIR}/bin/activate"

"${VENV_DIR}/bin/pip" install h5py
echo "Installing h5py."

# Install the .whl file
if [ -f "$WHL_FILE" ]; then
    "${VENV_DIR}/bin/python3.10" -m pip install "$WHL_FILE"
    echo "Installed $WHL_FILE in the virtual environment."
else
    echo "Error: $WHL_FILE not found."
    deactivate
    exit 1
fi

# Check if the function is already present in .bashrc
if ! grep -q "function cd" ~/.bashrc; then
  echo 'function cd() {
  builtin cd "$@"
  if [[ -z "$VIRTUAL_ENV" ]] ; then
      if [[ "$PWD" == "/home/inesh/Innatera/python/test" ]] ; then
        source ./test_venv/bin/activate
      fi
  else
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
      fi
  fi
  }' >> ~/.bashrc

  echo "Activation function added to .bashrc."
else
  echo "Activation function already present in .bashrc."
fi

source ~/.bashrc

echo "Setup complete. The virtual environment will auto-activate when you enter the $FOLDER_NAME directory."
