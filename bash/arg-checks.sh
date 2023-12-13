#!/bin/bash

# This script handles the command-line arguments for the gc-smart script to
# customize the commit process, including message style, preview options, and
# instructions for AI message generation.

# ------------------------------------------------------------------------------
# Global Variables
# ------------------------------------------------------------------------------

GIT_CMD="git" # The command for Git operations, default is 'git'
INSTRUCTION="" # Additional instructions for enhancing the AI commit message
KEEP_FILES=false # Flag to retain intermediate files after the commit process
PREVIEW=true # Flag to preview the AI-generated commit message to the user
STYLE="" # Style for the AI-generated commit message

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

check_for_help() {
    # Check for --help argument and print help message in case
    for arg in "$@"; do
        if [ "$arg" == "--help" ] || [ "$arg" == "-h" ]; then
            print_help
            exit 0
        fi
    done
}

set_keep_files_flag() {
    # Check for --keep-files argument and set flag accordingly
    for arg in "$@"; do
        if [ "$arg" == "--keep-files" ]; then
            KEEP_FILES=true
            break
        fi
    done
}

set_preview_flag() {
    # Check for --quick argument and set preview flag accordingly
    for arg in "$@"; do
        if [ "$arg" == "--quick" ] || [ "$arg" == "-q" ]; then
            PREVIEW=false
            break
        fi
    done
}

set_instruction() {
    # Check for the presence of the "-i" or "--instruction" option. If found,
    # set the INSTRUCTION global variable to the value immediately following
    # the option. This value is later passed to the gpt-commit-prompter script
    # to guide the AI in generating commit messages. If the option is not found
    # or if no value is provided after the option, the function leaves the
    # INSTRUCTION variable empty.
    for idx in "${!ARGS[@]}"; do
        if [ "${ARGS[$idx]}" == "-i" ] || [ "${ARGS[$idx]}" == "--instruction" ]; then
            # Check if a potential instruction follows the flag
            if [ -n "${ARGS[$idx+1]-}" ] && [[ "${ARGS[$idx+1]}" != -* ]]; then
                INSTRUCTION="${ARGS[$idx+1]}"
                break
            else
                echo "Error: The -i or --instruction option requires an argument."
                exit 1
            fi
        fi
    done
}

set_git_cmd() {
    # Parse the cl arguments to detect a possible "--cmd" flag and when
	# detected check if there is a valid command provided after the flag. If a
	# command is found, set the GIT_CMD variable to that value, allowing the
	# script to usa a custom git command. If the flag is present but no command
	# is provided or invalid, print an error message and exit the script.
    local args=("$@")
    for idx in "${!args[@]}"; do
        if [ "${args[$idx]}" == "--cmd" ]; then
            # Check if a potential command follows the flag
            if [ -n "${args[$idx+1]-}" ] && [[ "${args[$idx+1]}" != -* ]]; then
                GIT_CMD="${args[$idx+1]}"
                break
            else
                echo "Error: The --cmd option requires an argument."
                exit 1
            fi
        fi
    done
}

set_style_option() {
    # Parse the command line arguments to detect a possible "-s" or "--style"
    # flag. If detected, set the STYLE variable to the value provided after
    # the flag.
    local args=("$@")
    for idx in "${!args[@]}"; do
        if [ "${args[$idx]}" == "-s" ] || [ "${args[$idx]}" == "--style" ]; then
            # Check if a potential style follows the flag
            if [ -n "${args[$idx+1]-}" ] && [[ "${args[$idx+1]}" != -* ]]; then
                STYLE="${args[$idx+1]}"
                break
            else
                echo "Error: The -s or --style option requires an argument."
                exit 1
            fi
        fi
    done
}

