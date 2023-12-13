generate_commit_message() {
    # Use the gpt-commit-prompter script to process the diff file 
    # (staged_changes.diff) and generate an AI-enhanced commit message.
    # Write the message to tmp_commit_msg.txt.
    # NOTE: The gpt-commit-prompter script must be located in the same directory
    # as this executing script for this function to work correctly.
    if [ -n "$STYLE" ]; then
        python3 "$GCS_ROOT/python/gpt-commit-prompter" "$GIT_ROOT/staged_changes.diff" -i "$INSTRUCTION" -s "$STYLE" > "$GIT_ROOT/tmp_commit_msg.txt"
    elif [ -n "$INSTRUCTION" ]; then
        python3 "$GCS_ROOT/python/gpt-commit-prompter" "$GIT_ROOT/staged_changes.diff" -i "$INSTRUCTION" > "$GIT_ROOT/tmp_commit_msg.txt"
    else
        python3 "$GCS_ROOT/python/gpt-commit-prompter" "$GIT_ROOT/staged_changes.diff" > "$GIT_ROOT/tmp_commit_msg.txt"
    fi
}


handle_preview() {
    # Interactively preview the auto-generated commit message.
    # The user is presented with options to:
    # 1. Proceed with the current commit message.
    # 2. Regenerate commit message without instruction.
    # 3. Regenerate commit message with an instruction.
    # 4. View staged changes
    # 5. Abort the commit process.
    # The loop continues until the user decides to proceed with the commit or
    # aborts.
    regenerate=true

    while $regenerate; do
        # Preview the auto-generated commit message
        echo -e "\nGenerated Commit Message:"
        echo -e "-------------------------\n"
        cat "$GIT_ROOT/tmp_commit_msg.txt"
        echo -e "\n----------------------------------------------------------------\n\n"

        # Ask the user if he wants to proceed or regenerate
        read -p "Options: 
        1. Continue with commit
        2. Regenerate commit message without instruction
        3. Regenerate commit message with an instruction
        4. View staged changes
        5. Abort 

        Choose [1/2/3/4/5]: " choice

        case "$choice" in
            1)
                # Continue to commit logic...
                regenerate=false
                ;;
            2)
                # Regenerate commit message without instruction and preview again
                python3 "$GCS_ROOT/python/gpt-commit-prompter" "$GIT_ROOT/staged_changes.diff" > "$GIT_ROOT/tmp_commit_msg.txt"
                ;;
            3)
                # Regenerate commit message with an instruction
                read -p "Provide a guiding instruction for the AI: " INSTRUCTION
                python3 "$GCS_ROOT/python/gpt-commit-prompter" -i "$INSTRUCTION" "$GIT_ROOT/staged_changes.diff" > "$GIT_ROOT/tmp_commit_msg.txt"
                ;;
			4)
                # View staged changes
                less "$GIT_ROOT/staged_changes.diff"
                ;;
            5)
                # Abort
                echo "Commit aborted."
                rm -f "$GIT_ROOT/staged_changes.diff" "$GIT_ROOT/tmp_commit_msg.txt"
                exit 1
                ;;
            *)
                echo "Invalid choice. Commit aborted."
                rm -f "$GIT_ROOT/staged_changes.diff" "$GIT_ROOT/tmp_commit_msg.txt"
                exit 1
                ;;
        esac
    done
}


