#!/bin/bash

# Variables
REPO_URL="https://github.com/5n00py/SmartCommit.git"
INSTALL_DIR="$HOME/.local/share/SmartCommit"

# Create the installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Clone the repository
echo "Cloning SmartCommit repository into $INSTALL_DIR"
git clone "$REPO_URL" "$INSTALL_DIR"

# Navigate to the SmartCommit setup directory
cd "$INSTALL_DIR/setup" || exit

# Make the setup script executable
chmod +x setup_sc.sh

# Run the setup script
echo "Running setup script..."
./setup_sc.sh

# End of script
echo "Quick setup of SmartCommit is complete."
