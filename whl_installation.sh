#!/bin/bash

# Check if folder path and .whl file are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <PROJECT_DIR> <path_to_whl_file>"
    exit 1
fi

PROJECT_DIR=$1
WHL_FILE="${SCRIPT_DIR}/wheel_files/talamo-2.0.0a2-cp310-cp310-linux_x86_64.whl"
FOLDER_NAME=$(basename "$PROJECT_DIR")
VENV_DIR="${PROJECT_DIR}/${FOLDER_NAME}_venv"

# Create the folder if it doesn't exist
if [ ! -d "$PROJECT_DIR" ]; then
    mkdir -p "$PROJECT_DIR"
fi

# Create a virtual environment in the specified folder
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    echo "Virtual environment created in $VENV_DIR"
fi

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

activation = "
'function ${FOLDER_NAME}_venv() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    if [[ -d ./${FOLDER_NAME}_venv ]] ; then
      source ./${FOLDER_NAME}_venv/bin/activate
    fi
  else
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]] ; then
      deactivate
    fi
  fi
}' >> ~/.bashrc
"


if ! grep -q "function ${FOLDER_NAME}_venv" ~/.bashrc; then
  echo "$activation" >> ~/.bashrc
  echo "Activation function added to .bashrc."
else
  echo "Activation function already present in .bashrc."
fi


echo "Setup complete. The virtual environment will auto-activate when you enter the $FOLDER_NAME directory."
