#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")" || exit
# Set GCS_ROOT to the parent of the current directory (SmartCommit root)
GCS_ROOT=$(cd .. && pwd)
echo "Setting GCS_ROOT to $GCS_ROOT"

# Set up Python environment
echo "Setting up the Python environment..."
if ! python3 -m venv "$GCS_ROOT/python/venv"; then
    echo "Failed to create a Python virtual environment. This could mean that"
	echo "the Python venv module is not installed."
    echo "Please install the Python venv module for your Python version."
    echo "For Python 3.x, you can typically install it on Debian-based systems using:"
    echo "sudo apt-get install python3.x-venv"
    echo "Replace 'x' with your Python 3 version number."
    echo "If you're not using a Debian-based system, please check your"
    echo "distribution's package manager or visit the Python website for"
    echo "installation instructions."
    echo "After installing the venv module, please restart this setup script:"
    echo "$GCS_ROOT/setup/setup_sc.sh"
    exit 1
else
    # shellcheck disable=SC1091
    source "$GCS_ROOT/python/venv/bin/activate"
fi

# Check Python version
python_version=$(python3 --version | cut -d ' ' -f 2)
minimum_version="3.7"

if printf '%s\n' "$python_version" "$minimum_version" | sort -V | head -n 1 | grep -q "$minimum_version"; then
    echo "Python version is $python_version, which is acceptable."
else
    echo "Python 3.7 or higher is required."
    echo "To install Python 3.11, you can typically use the following commands:"
    echo "sudo apt-get update"
    echo "sudo apt-get install python3.11"
    echo "If you're not using a Debian-based system, please check your"
	echo "distribution's package manager or visit the Python website for"
	echo "installation instructions."
    echo "After installing Python 3.11, please rerun this setup script:"
    echo "$GCS_ROOT/setup/setup_sc.sh"
    exit 1
fi

# Install required libraries
echo "Installing required Python libraries..."
pip install -r "$GCS_ROOT/python/requirements.txt"

# Deactivate the virtual environment
deactivate

# Make scripts executable
chmod +x "$GCS_ROOT/gc-smart"
chmod +x "$GCS_ROOT/python/gpt-commit-prompter"

# Check for OpenAI API key
if [ -z "$OPENAI_API_KEY" ]; then
	echo "Settin up the OpenAI API Key:"
	echo "See also: https://help.openai.com/en/articles/4936850-where-do-i-find-my-api-key"
    echo "Please enter your OpenAI API key:"
    read -r OPENAI_API_KEY

    # Check if .bashrc exists and write the key export
    if [ -f "$HOME/.bashrc" ]; then
        echo "export OPENAI_API_KEY='$OPENAI_API_KEY'" >> "$HOME/.bashrc"
        echo "Your OpenAI API key has been added to your .bashrc file."
    fi

    # Check if .zshrc exists and write the key export
    if [ -f "$HOME/.zshrc" ]; then
        echo "export OPENAI_API_KEY='$OPENAI_API_KEY'" >> "$HOME/.zshrc"
        echo "Your OpenAI API key has been added to your .zshrc file."
    fi

    # If neither file exists, return an error
    if [ ! -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
        echo "ERROR: Neither .bashrc nor .zshrc was found."
		echo "Please manually add the OPENAI_API_KEY to your shell's configuration."
        exit 1
    fi

    echo "WARNING: Keep your API key secure and do not share it."
fi

# Add script directory to PATH
echo "Adding SmartCommit directory to PATH..."
script_dir="$GCS_ROOT"
if [ -f "$HOME/.bashrc" ]; then
    echo "export PATH=\"\$PATH:$script_dir\"" >> "$HOME/.bashrc"
    echo "SmartCommit directory added to .bashrc PATH"
fi
if [ -f "$HOME/.zshrc" ]; then
    echo "export PATH=\"\$PATH:$script_dir\"" >> "$HOME/.zshrc"
    echo "SmartCommit directory added to .zshrc PATH"
fi

echo "Setup complete. Please restart your terminal or source your .bashrc/.zshrc file."
