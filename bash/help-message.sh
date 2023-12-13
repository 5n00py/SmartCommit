#!/bin/bash

print_help() {
	# Print a detailed help message for the gc-smart script
    echo "Usage: gc-smart [OPTION]"
    echo ""
    echo "Automatically generate a commit message for staged changes in a Git repository."
    echo ""
    echo "Options:"
    echo "-h, --help          Display this help message."
    echo "-i, --instruction   Provide an instruction for the AI to guide commit message generation."
    echo "-q, --quick         Skip the preview of the AI generated commit message and commit directly."
    echo "-s, --style         Specify a style for the AI-generated commit message: imperative, detailed, simple, conventional."
    echo "--keep-files        Retain intermediate files after the commit process in the root directory."
    echo "--cmd               Specify a custom command for Git operations. Default is 'git'."
}
